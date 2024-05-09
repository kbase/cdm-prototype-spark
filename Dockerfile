# Would much prefer to use an official image, but it looks like they're just for submitting jobs
# rather than running a cluster?
# https://github.com/apache/spark-docker/blob/master/3.5.1/scala2.12-java17-ubuntu/entrypoint.sh
# Can't seem to find any usage documentation, so've just been reading the code to figure out how
# they work

FROM ubuntu:22.04 as build

RUN apt update -y
RUN apt install -y wget

ENV SPARK_VER=spark-3.5.1-bin-hadoop3-scala2.13

WORKDIR /opt
# TODO should at least check the sha, or copy the pgp check from the official dockerfile
RUN wget -q https://dlcdn.apache.org/spark/spark-3.5.1/$SPARK_VER.tgz && \
    tar -xf $SPARK_VER.tgz


FROM eclipse-temurin:17.0.11_9-jre-jammy

ENV SPARK_VER=spark-3.5.1-bin-hadoop3-scala2.13
ENV PYTHON_VER=python3.11

# install from deadsnakes so it's not an rc version
RUN apt update && \
	apt-get install -y software-properties-common && \
	add-apt-repository ppa:deadsnakes/ppa && \
	apt install -y $PYTHON_VER python3-pip && \
	apt install -y r-base r-base-dev && \
	rm -rf /var/lib/apt/lists/*

RUN $PYTHON_VER --version

RUN mkdir /opt/py && ln -s /usr/bin/$PYTHON_VER /opt/py/python3

RUN echo '#!/usr/bin/bash' > /usr/bin/pip && \
	echo "$PYTHON_VER -m pip \$@" >> /usr/bin/pip

ENV R_HOME /usr/lib/R

RUN mkdir /opt/spark
COPY --from=build /opt/$SPARK_VER/ /opt/spark/
# this doesn't seem to actually work
RUN echo "spark.pyspark.python /usr/bin/$PYTHON_VER" > /opt/spark/conf/spark-defaults.conf

COPY entrypoint.sh /opt/
RUN chmod a+x /opt/entrypoint.sh

ENTRYPOINT ["/opt/entrypoint.sh"]
