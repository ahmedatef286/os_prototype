import psutil
import argparse
import json
import sys
def set_process_priority(pid, priority):
    try:
        process = psutil.Process(pid)
        process.nice(priority)
        return True, f"Priority set successfully for PID {pid}."
    except psutil.NoSuchProcess:
        return False, f"No such process with PID {pid}."
    except psutil.AccessDenied:
        return False, "Access denied. Unable to set priority."
    except ValueError:
        return False, "Invalid priority value. Priority should be an integer."
def list_process():
    processes_dict = {}

    for proc in psutil.process_iter():
        try:

            process_name = proc.name()
            process_pid = proc.pid

            processes_dict[process_name] = process_pid
        except (psutil.NoSuchProcess, psutil.AccessDenied, psutil.ZombieProcess):

            pass

    return processes_dict

def end_process(pid):
    try:
        process = psutil.Process(pid)
        process.terminate()
        return True, f"Process with PID {pid} terminated successfully."
    except psutil.NoSuchProcess:
        return False, f"No such process with PID {pid}."
    except psutil.AccessDenied:
        return False, "Access denied. Unable to terminate the process."



def get_system_resource_utilization():
    cpu_percent = psutil.cpu_percent(interval=1)
    memory_info = psutil.virtual_memory()
    disk_usage = psutil.disk_usage('/')

    return {
        'cpu_percent': cpu_percent,
        'memory_percent': memory_info.percent,
        'memory_total': memory_info.total,
        'memory_used': memory_info.used,
        'disk_total': disk_usage.total,
        'disk_used': disk_usage.used,
    }


import psutil

def get_system_resource_utilization_for_each_process():
    cpu_percent = psutil.cpu_percent(interval=1)
    memory_info = psutil.virtual_memory()
    disk_usage = psutil.disk_usage('/')

    system_info = {
        'cpu_percent': cpu_percent,
        'memory_percent': memory_info.percent,
        'memory_total': memory_info.total,
        'memory_used': memory_info.used,
        'disk_total': disk_usage.total,
        'disk_used': disk_usage.used,
    }

    # Get individual process resource utilization
    processes_info = []
    for proc in psutil.process_iter(['pid', 'name', 'cpu_percent', 'memory_percent']):
        try:
            process_info = proc.info
            processes_info.append(process_info)
        except (psutil.NoSuchProcess, psutil.AccessDenied, psutil.ZombieProcess):
            pass

    return {
        'system': system_info,
        'processes': processes_info,
    }

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

# Example usage:
success, message = terminate_process_tree_by_name("msedge.exe")
if success:
    print(message)
else:
    print("Error:", message)

print(list_process())

print(terminate_process_tree(16744))

print(get_system_resource_utilization())


def main(command,pid=None, other_var=None):
    if command==1:
        list_process()
    elif command==2:
        set_process_priority(pid,other_var)
    elif command==3:
        end_process(pid)
    elif command==4:
        get_system_resource_utilization()
    elif command==5:
        get_system_resource_utilization_for_each_process()




def set_process_priority(pid, priority):
    priority_classes = {
        'low': psutil.IDLE_PRIORITY_CLASS,
        'below_normal': psutil.BELOW_NORMAL_PRIORITY_CLASS,
        'normal': psutil.NORMAL_PRIORITY_CLASS,
        'above_normal': psutil.ABOVE_NORMAL_PRIORITY_CLASS,
        'high': psutil.HIGH_PRIORITY_CLASS,
        'realtime': psutil.REALTIME_PRIORITY_CLASS
    }

    if isinstance(priority, str):
        priority = priority_classes.get(priority.lower())

    try:
        process = psutil.Process(pid)
        process.nice(priority)
        return True, f"Priority set successfully for PID {pid}."
    except psutil.NoSuchProcess:
        return False, f"No such process with PID {pid}."
    except psutil.AccessDenied:
        return False, "Access denied. Unable to set priority."
    except ValueError:
        return False, "Invalid priority value."
