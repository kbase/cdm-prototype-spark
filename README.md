# CDM prototype Spark dockerfiles

This is an extremely naive Dockerfile allowing deployment of a Spark master and workers in
Rancher.

## Submit example

Open a shell in a container in rancher with spark installed in `/opt/spark` (as of this writing,
the `ci-core-cdm-prototype-spark-bash` container is appropriate and has environment variables set up
for the necessary host and port configurations).

The container will need 2 ports mapped - one for the driver and one for the block manager.
Then:

```
root@f058c872158d:/# cd /opt/spark/
root@f058c872158d:/opt/spark# echo $SPARK_DRIVER_HOST
10.58.1.108
root@f058c872158d:/opt/spark# echo $SPARK_DRIVER_PORT
7075
root@f058c872158d:/opt/spark# echo $SPARK_BLOCKMANAGER_PORT
7076
root@f058c872158d:/opt/spark# bin/spark-submit --master spark://10.58.1.104:7077 --conf spark.driver.bindAddress=0.0.0.0 --conf spark.driver.host=$SPARK_DRIVER_HOST --conf spark.driver.port=$SPARK_DRIVER_PORT --conf spark.blockManager.port=$SPARK_BLOCKMANAGER_PORT examples/src/main/python/pi.py 10 2>/dev/null
Pi is roughly 3.144080
```

## Notes

* When we switch to Rancher 2 should probably switch from the standalone scheduler to the k8s
  scheduler.  Haven't looked into this at all.
* The dockerfile uses mostly default values, which is almost certainly bad.
* Do we need to install and configure Hadoop? Jobs run without it... should we use Minio instead?
