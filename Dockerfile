FROM jenkins/inbound-agent:4.11-1
ARG user=jenkins

USER root

RUN mkdir -p /etc/pip/
COPY pip.conf /etc/

#RUN apt update && apt install -y  less ca-certificates curl tar bash procps tzdata

RUN apt update && apt  install -y   python3 \   
        python3-dev \
        python3-pip \
        jq \
        make \
        git \
        zip \
        gcc \
        less \
        curl \
        tar \
        bash \
        procps \
        tzdata \
        g++ \
        musl-dev \
        libffi-dev \   
        unixodbc-dev 
      
 # RUN   rm -rf /var/cache/apk/*

ARG MAVEN_VERSION=3.6.3
ARG USER_HOME_DIR="/root"
#ARG BASE_URL=http://apache.mirror.digionline.de/maven/maven-3/${MAVEN_VERSION}/binaries
ARG BASE_URL=http://mirrors.ocf.berkeley.edu/apache/maven/maven-3/${MAVEN_VERSION}/binaries/
RUN mkdir -p /usr/share/maven /usr/share/maven/ref \
  && curl -fsSL -o /tmp/apache-maven.tar.gz ${BASE_URL}/apache-maven-${MAVEN_VERSION}-bin.tar.gz \ 
  && tar -xzf /tmp/apache-maven.tar.gz -C /usr/share/maven --strip-components=1 \
  && rm -f /tmp/apache-maven.tar.gz \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

ENV MAVEN_HOME /usr/share/maven
ENV MAVEN_CONFIG "$USER_HOME_DIR/.m2"
ENV LOG4J_FORMAT_MSG_NO_LOOKUPS=true

USER ${user}

COPY settings-docker.xml "$USER_HOME_DIR/.m2/settings.xml"
CMD ["/usr/local/bin/jenkins-agent"]


