#!/usr/bin/env bash

# This startup script is not used currenly. It was part of try and error during
# the webapp use case. Although, it's still here for documentation purposes.
#
# This commented scirpt aat the bottom is what Azure is setting up on its own.
# I'm wodering where the value for APP_PATH is coming from as it is hardcoded here.
#
python3 -m venv .venv
source venv/bin/activate
pip3 install -r requirements.txt
gunicorn --bind=0.0.0.0 --timeout 600 --chdir snappass main:app

exit

#!/bin/sh
#
# echo 'export APP_PATH="/tmp/8dc90314aeff6e8"' >> ~/.bashrc
# echo 'cd $APP_PATH' >> ~/.bashrc
#
# # Enter the source directory to make sure the script runs where the user expects
# cd /tmp/8dc90314aeff6e8
#
# export APP_PATH="/tmp/8dc90314aeff6e8"
# if [ -z "$HOST" ]; then
#                 export HOST=0.0.0.0
# fi
#
# if [ -z "$PORT" ]; then
#                 export PORT=80
# fi
#
# export PATH="/opt/python/3.11.8/bin:${PATH}"
# echo 'export VIRTUALENVIRONMENT_PATH="/tmp/8dc90314aeff6e8/antenv"' >> ~/.bashrc
# echo '. antenv/bin/activate' >> ~/.bashrc
# PYTHON_VERSION=$(python -c "import sys; print(str(sys.version_info.major) + '.' + str(sys.version_info.minor))")
# echo Using packages from virtual environment 'antenv' located at '/tmp/8dc90314aeff6e8/antenv'.
# export PYTHONPATH=$PYTHONPATH:"/tmp/8dc90314aeff6e8/antenv/lib/python$PYTHON_VERSION/site-packages"
# echo "Updated PYTHONPATH to '$PYTHONPATH'"
# . antenv/bin/activate
# GUNICORN_CMD_ARGS="--timeout 600 --access-logfile '-' --error-logfile '-' -c /opt/startup/gunicorn.conf.py --chdir=/tmp/8dc90314aeff6e8" gunicorn app:app
# (antenv) root@867605dd5052:/srv#
#
