import psutil
import argparse
import json
import sys


def terminate_process_tree_by_name(process_name):
    terminated_pids = []
    for proc in psutil.process_iter(['pid', 'name']):
        if proc.info['name'] == process_name:
            terminated, message = terminate_process_tree(proc.info['pid'])
            if terminated:
                terminated_pids.append(proc.info['pid'])
            else:
                return False, message
    if terminated_pids:
        return True, f"Process tree(s) with name '{process_name}' terminated successfully. PIDs: {terminated_pids}"
    else:
        return False, f"No process with name '{process_name}' found."


def terminate_process_tree(pid):
    try:
        parent = psutil.Process(pid)
        children = parent.children(recursive=True)
        for child in children:
            child.terminate()
        _, alive = psutil.wait_procs(children, timeout=5)
        for p in alive:
            p.kill()
        parent.terminate()
        parent.wait(5)
        return True, f"Process tree with PID {pid} terminated successfully."
    except psutil.NoSuchProcess:
        return False, f"No such process with PID {pid}."
    except psutil.AccessDenied:
        return False, "Access denied. Unable to terminate the process."
    except psutil.TimeoutExpired:
        return False, f"Timeout expired. Process with PID {pid} could not be terminated in time."


def set_process_priority(pid, nice_value):
    priority_classes = {
        'low': psutil.IDLE_PRIORITY_CLASS,
        'below_normal': psutil.BELOW_NORMAL_PRIORITY_CLASS,
        'normal': psutil.NORMAL_PRIORITY_CLASS,
        'above_normal': psutil.ABOVE_NORMAL_PRIORITY_CLASS,
        'high': psutil.HIGH_PRIORITY_CLASS,
        'realtime': psutil.REALTIME_PRIORITY_CLASS
    }

    if isinstance(nice_value, str):
        nice_value = priority_classes.get(nice_value.lower())
    try:
        process = psutil.Process(pid)
        process.nice(nice_value)
        return True, f"Priority (nice value) set successfully for PID {pid}."
    except psutil.NoSuchProcess:
        return False, f"No such process with PID {pid}."
    except psutil.AccessDenied:
        return False, "Access denied. Unable to set priority."
    except ValueError:
        return False, "Invalid nice value. Must be between -20 and 19."


def run(command):

    if command["type"] == "kill":
        terminate_process_tree_by_name(command['name'])

    elif command["type"] == "setPriority":
        set_process_priority(command['pid'], command['priority'])
    elif command["type"] == "system":
        # Get CPU usage as a percentage
        cpu_percent = psutil.cpu_percent(interval=1)
        memory_info = psutil.virtual_memory()  # Get memory usage information
        # Get disk usage information for the root directory
        disk_usage = psutil.disk_usage('/')
        dic = {
            'cpu_percent': cpu_percent,
            'logical_cores': psutil.cpu_count(),
            'physical_cores': psutil.cpu_count(logical=False),
            'cpu_frequency': psutil.cpu_freq(),
            'memory_percent': memory_info.percent,
            'memory_total': memory_info.total,
            'memory_used': memory_info.used,
            'disk_total': disk_usage.total,
            'disk_used': disk_usage.used,
        }
        return dic
    elif command["type"] == "listRunningProcessess":

        processes_dict = {}

        for proc in psutil.process_iter():
            try:

                process_name = proc.name()
                process_pid = proc.pid
                process_status = proc.status()
                process_cpu = proc.cpu_percent()
                process_memory = proc.memory_percent(memtype='rss')
                process_priority = proc.nice()

                processes_dict[process_name] = [
                    process_pid, process_status, process_cpu, process_memory, process_priority]
            except (psutil.NoSuchProcess, psutil.AccessDenied, psutil.ZombieProcess):
                print('error')
                pass

        return processes_dict


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--uuid")
    args = parser.parse_args()
    stream_start = f"`S`T`R`E`A`M`{args.uuid}`S`T`A`R`T`"
    stream_end = f"`S`T`R`E`A`M`{args.uuid}`E`N`D`"
    while True:
        cmd = input()
        cmd = json.loads(cmd)
        try:
            result = run(cmd)
        except Exception as e:
            result = {"exception": e.__str__()}
        result = json.dumps(result)
        print(stream_start + result + stream_end)
        