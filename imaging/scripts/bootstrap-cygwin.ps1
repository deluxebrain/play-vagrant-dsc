# Cygwin and Cygwin packages
choco install cygwin -y

# Reload environment
refreshenv

# theoretically choco supports installing packages in cygwin as follows:
# $ choco install <package> --source cygwin
# ... does't seem to work though ( complains that package can't be found )
# choco install bash --source cygwin -y

