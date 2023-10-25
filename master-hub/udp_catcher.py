import atexit
import datetime
import queue
import socket
import sqlite3
import subprocess
import threading
import time
from dataclasses import dataclass

# UDP server configuration
server_ip: str = "0.0.0.0"  # listen on all interfaces
server_port: int = 7321
# db file
db_file: str = 'slave_db.sqlite'

# message queue
mq: queue.Queue = queue.Queue()

@dataclass
class Message:
    """Dataclass for storing message object"""
    host_name: str
    ip_address: str
    os: str
    gma_state: str


def at_exit_cleanup():
    """cleanup function"""
    exit_flag.set()


def slave_db_update_thread():
    """worker thread used for file writing"""
    while True:
        if not mq.empty():
            db_connection = sqlite3.connect(db_file)
            while not mq.empty():
                message: Message = mq.get()
                cursor: sqlite3.Cursor = db_connection.cursor()
                res = cursor.execute(f"""
                    INSERT OR REPLACE INTO hosts (host_name, ip_address, os, gma_state) 
                    VALUES (
                    '{message.host_name}', '{message.ip_address}', '{message.os}', '{message.gma_state}'
                    );
                """)
                if exit_flag.is_set():
                    db_connection.commit()
                    db_connection.close()
                    return
            db_connection.commit()
            db_connection.close()
        time.sleep(1)


def udp_server_thread():
    with socket.socket(socket.AF_INET, socket.SOCK_DGRAM) as udp_socket:
        udp_socket.bind((server_ip, server_port))
        while True:
            # get data
            data, address = udp_socket.recvfrom(1024)
            remote_ip, remote_port = address
            decoded_message: str = data.decode('utf-8')
            hostname, os, gma_state, *other = decoded_message.split()
            message: Message = Message(hostname, remote_ip, os, gma_state)
            mq.put(message)
            if exit_flag.is_set():
                udp_socket.shutdown(socket.SHUT_RDWR)
                udp_socket.close()
                return


if __name__ == "__main__":
    # flag for termination of child thread
    exit_flag = threading.Event()

    # binding exit cleanup function
    atexit.register(at_exit_cleanup)

    file_update_thread: threading.Thread = threading.Thread(target=slave_db_update_thread)
    file_update_thread.start()

    server_thread: threading.Thread = threading.Thread(target=udp_server_thread)
    server_thread.start()
    server_thread.join()
