import psutil
import argparse
import json
import sys





def run(command):
    
    #if command["cmd"] == CMD_SYS_VERSION:


   # else:
     
    processes_dict = {}

    
    for proc in psutil.process_iter():
        try:
           
            process_name = proc.name()
            process_pid = proc.pid
           
            processes_dict[process_name] = process_pid
        except (psutil.NoSuchProcess, psutil.AccessDenied, psutil.ZombieProcess):
          
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