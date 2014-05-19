pseudodistributed-hadoop-docker
===============================

A dockerfile for building a self-contained pseudodistributed hadoop instance
image.

Docker images built with this dockerfile will run an HDFS instance with a single
datanode running in the same container and a YARN instance with a single
nodemanager running in the same container also.

There is also an SSH server ready to login as root (with password "pass").

All controlled by supervisord.
