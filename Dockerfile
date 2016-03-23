FROM rhel
RUN ln -s /var/run/secrets/rhel7.repo /etc/yum.repos.d \
  && yum -y install java-1.8.0-openjdk-headless tar \
  && mkdir -p /opt/kafka \
  && cd /opt/kafka \
  && curl -s http://www.mirrorservice.org/sites/ftp.apache.org/kafka/0.9.0.1/kafka_2.11-0.9.0.1.tgz | tar -xz --strip-components=1 \
  && yum -y remove tar \
  && yum clean all \
  && chmod -R a=u /opt/kafka
COPY zookeeper-server-start-multiple.sh /opt/kafka/bin/
WORKDIR /opt/kafka
VOLUME /tmp/kafka-logs /tmp/zookeeper
EXPOSE 2181 2888 3888 9092
