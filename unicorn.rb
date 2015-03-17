# Set the working application directory
# working_directory "/path/to/your/app"
working_directory "/var/www/jeff"

# Unicorn PID file location
# pid "/path/to/pids/unicorn.pid"
pid "/var/www/jeff/pids/unicorn.pid"

# Path to logs
# stderr_path "/path/to/logs/unicorn.log"
# stdout_path "/path/to/logs/unicorn.log"
stderr_path "/var/www/jeff/logs/unicorn.log"
stdout_path "/var/www/jeff/logs/unicorn.log"

# Unicorn socket
# listen "/tmp/unicorn.[app name].sock"
listen "/tmp/unicorn.jeff.sock"

# Number of processes
# worker_processes 4
worker_processes 2

# Time-out
timeout 30