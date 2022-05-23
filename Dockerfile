# Centos based container with Java and Tomcat
FROM centos:centos7
MAINTAINER kolodgeeva

# Install prepare infrastructure
RUN yum -y update && yum -y install wget && \
  yum -y install tar && \
  wget https://download-ib01.fedoraproject.org/pub/epel/7/x86_64/Packages/e/epel-release-7-14.noarch.rpm && \
  wget https://download-ib01.fedoraproject.org/pub/epel/8/Everything/x86_64/Packages/h/haveged-1.9.14-1.el8.x86_64.rpm && \
  rpm -Uvh epel-release-7-14.noarch.rpm && \
  yum -y install haveged && \
  chkconfig haveged on

# Prepare environment 
ENV JAVA_HOME /usr/java/latest
ENV CATALINA_HOME /opt/tomcat 
ENV PATH $PATH:$JAVA_HOME/bin:$CATALINA_HOME/bin:$CATALINA_HOME/scripts

# Install Oracle Java17
ENV JAVA_VERSION 17

RUN wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" \
 https://download.oracle.com/java/${JAVA_VERSION}/latest/jdk-17_linux-x64_bin.rpm && \
 yum -y localinstall jdk*

# Install Tomcat
ENV TOMCAT_MAJOR 9
ENV TOMCAT_VERSION 9.0.62

RUN wget http://mirror.linux-ia64.org/apache/tomcat/tomcat-${TOMCAT_MAJOR}/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz && \
 tar -xvf apache-tomcat-${TOMCAT_VERSION}.tar.gz && \
 rm apache-tomcat*.tar.gz && \
 mv apache-tomcat* ${CATALINA_HOME}

RUN chmod +x ${CATALINA_HOME}/bin/*sh

# Create Tomcat admin user
ADD create_admin_user.sh $CATALINA_HOME/scripts/create_admin_user.sh
ADD tomcat.sh $CATALINA_HOME/scripts/tomcat.sh
RUN chmod +x $CATALINA_HOME/scripts/*.sh

# Create tomcat user
RUN groupadd -r tomcat && \
 useradd -g tomcat -d ${CATALINA_HOME} -s /sbin/nologin  -c "Tomcat user" tomcat && \
 chown -R tomcat:tomcat ${CATALINA_HOME}

WORKDIR /opt/tomcat

EXPOSE 8080
EXPOSE 8009

USER tomcat
CMD ["tomcat.sh"]
