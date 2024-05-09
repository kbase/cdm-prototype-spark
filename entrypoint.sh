#!/bin/bash

# Haven't been able to get the workers to use a different version of python any other way
# Only want to do this in this shell so it doesn't screw up everything by changing the system
# python
export PATH=/opt/py:$PATH

# run spark in the foreground so the container doesn't immediately exit
export SPARK_NO_DAEMONIZE=true
# these two env vars don't seem to work
export PYSPARK_PYTHON=$PYTHON_VER
export PYSPARK_DRIVER_PYTHON=$PYTHON_VER
export SPARK_MASTER_HOST=0.0.0.0
export SPARK_MASTER_PORT=$PORT
export SPARK_MASTER_WEBUI_PORT=$WEBPORT
export SPARK_WORKER_WEBUI_PORT=$WEBPORT

if [ "$MODE" == "master" ] ; then
    echo "starting spark master"
    /opt/spark/sbin/start-master.sh
elif [ "$MODE" == "worker" ] ; then
    echo "starting spark worker"
    /opt/spark/sbin/start-worker.sh --cores "$CORES" --memory "$MEM" "$SPARK_MASTER_URL"
elif [ "$MODE" == "bash" ] ; then
    bash
else
    echo "Unrecognized MODE env var: [$MODE]"
fi
