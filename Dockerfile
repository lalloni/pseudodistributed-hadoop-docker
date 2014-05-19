FROM ubuntu:14.04

MAINTAINER Pablo Lalloni <plalloni@gmail.com>

WORKDIR /opt

# Tools #################

RUN \
  apt-get update && \
  apt-get dist-upgrade -y && \
  apt-get install -y software-properties-common wget

# JDK 7 #################

RUN \
  echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections && \
  add-apt-repository -y ppa:webupd8team/java && \
  apt-get update && \
  apt-get install -y oracle-java7-installer && \
  rm -rf /var/cache/oracle-jdk7-installer
ENV JAVA_HOME /usr/lib/jvm/java-7-oracle

# Hadoop ################

RUN \
  wget http://archive.cloudera.com/cdh5/cdh/5/hadoop-2.3.0-cdh5.0.1.tar.gz && \
  tar -xzf hadoop-2.3.0-cdh5.0.1.tar.gz && \
  ln -s hadoop-2.3.0-cdh5.0.1 hadoop && \
  rm hadoop-2.3.0-cdh5.0.1.tar.gz && \
  rm -rf hadoop/share/doc hadoop/src hadoop/examples hadoop/examples-mapreduce1 hadoop/cloudera
ADD core-site.xml /opt/hadoop/etc/hadoop/
ADD hdfs-site.xml /opt/hadoop/etc/hadoop/
ADD mapred-site.xml /opt/hadoop/etc/hadoop/
RUN hadoop/bin/hdfs namenode -format

# HDFS ports
EXPOSE 8020 50010 50020 50070 50075

# MR2/YARN ports
EXPOSE 8030 8032 8088 8042 19888

# SSH ###################

RUN \
  apt-get install -y ssh && \
  mkdir -vp /var/run/sshd && \
  echo 'root:pass' | chpasswd && \
EXPOSE 22

# Supervisor ############

RUN \
  apt-get install -y supervisor && \
  mkdir -vp /var/log/supervisor
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD wrap /usr/bin/wrap
ADD ifaddr /usr/bin/ifaddr
CMD /usr/bin/supervisord
EXPOSE 80
