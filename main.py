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
    cpu_percent = psutil.cpu_percent(interval=1)  # Get CPU usage as a percentage
    memory_info = psutil.virtual_memory()  # Get memory usage information
    disk_usage = psutil.disk_usage('/')  # Get disk usage information for the root directory

    return {
        'cpu_percent': cpu_percent,
        'memory_percent': memory_info.percent,
        'memory_total': memory_info.total,
        'memory_used': memory_info.used,
        'disk_total': disk_usage.total,
        'disk_used': disk_usage.used,
    }
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






