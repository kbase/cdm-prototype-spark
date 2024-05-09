# CDM prototype Spark dockerfiles

This is an extremely naive Dockerfile allowing deployment of a Spark master and workers in
Rancher.

## Notes

* When we switch to Rancher 2 should probably switch from the standalone scheduler to the k8s
  scheduler.  Haven't looked into this at all.
* The dockerfile uses mostly default values, which is almost certainly bad.
* Do we need to install and configure Hadoop? Jobs run without it... should we use Minio instead?
