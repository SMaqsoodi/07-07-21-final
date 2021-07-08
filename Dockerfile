FROM tomcat:8.0
MAINTAINER Sefvatullah.Maqsoodi
COPY target/easypay-final-0.0.1-SNAPSHOT.war /usr/local/tomcat/webapps/

EXPOSE 8080

# CMD [“catalina.sh”, “run”]