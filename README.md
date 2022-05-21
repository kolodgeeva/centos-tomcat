Docker container: CentOS 7 + Java 17 + Tomcat 9

## Build the image

```sh
git clone https://github.com/kolodgeeva/centos-tomcat.git
cd centos-tomcat
docker build -t kolodgeeva/centos-tomcat .
```

## How to use
Put your war under the `/opt/tomcat/webapps` directory and run the following command.

```sh
docker run -v /opt/tomcat/webapps:/opt/tomcat/webapps -v /opt/tomcat/logs:/opt/tomcat/logs -p 8080:8080 -i -t --name centos-tomcat kirillf/centos-tomcat
```

Once you run it, you can start the container with `docker start centos-tomcat` in next time and log file will be under the `/opt/tomcat/logs` directory.

Also, if you got some error, you can remove the container with `docker rm centos-tomcat`. Your current container list will be show with `docker ps -a`.

For Mac user, you must share the directory `/opt/tomcat/webapps` and `/opt/tomcat/logs` on Docker > Preferences > File Sharing.

## Versions
If you got error while build the docker image, please check the latest version of Java and Tomcat.

|Software|Version|Note|
|:-----------|:------------|:------------|
|CentOS|7||
|Java|17 [Java Release Note](https://jdk.java.net/17/release-notes)|
|Apache Tomcat|9.0.62|[Tomcat Download Page](https://tomcat.apache.org/download-90.cgi)|

[Docker Official Image for Tomcat](https://github.com/docker-library/tomcat) is also available.
