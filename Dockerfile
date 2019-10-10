FROM openjdk:7
MAINTAINER donglei "donglei@qutoutiao.net"

EXPOSE 8080

ENV TOMCAT_VERSION 8.0.38
ENV ACTIVITI_VERSION 6.0.0
ENV MYSQL_CONNECTOR_JAVA_VERSION 8.0.16

ADD . /tmp


# Tomcat
RUN mv  /tmp/apache-tomcat-${TOMCAT_VERSION}.tar.gz  /tmp/catalina.tar.gz && \
	tar xzf /tmp/catalina.tar.gz -C /opt && \
	ln -s /opt/apache-tomcat-${TOMCAT_VERSION} /opt/tomcat && \
	rm /tmp/catalina.tar.gz && \
	rm -rf /opt/tomcat/webapps/examples && \
	rm -rf /opt/tomcat/webapps/docs

# To install jar files first we need to deploy war files manually
RUN mv /tmp/activiti-${ACTIVITI_VERSION}.zip  /tmp/activiti.zip && \
 	unzip /tmp/activiti.zip -d /opt/activiti && \
	unzip /opt/activiti/activiti-${ACTIVITI_VERSION}/wars/activiti-app.war -d /opt/tomcat/webapps/activiti-app && \
	unzip /opt/activiti/activiti-${ACTIVITI_VERSION}/wars/activiti-rest.war -d /opt/tomcat/webapps/activiti-rest && \
	rm -f /tmp/activiti.zip

# Add mysql connector to application
RUN mv /tmp/mysql-connector-java-${MYSQL_CONNECTOR_JAVA_VERSION}.zip  /tmp/mysql-connector-java.zip && \
	unzip /tmp/mysql-connector-java.zip -d /tmp && \
	cp /tmp/mysql-connector-java-${MYSQL_CONNECTOR_JAVA_VERSION}/mysql-connector-java-${MYSQL_CONNECTOR_JAVA_VERSION}.jar /opt/tomcat/webapps/activiti-rest/WEB-INF/lib/ && \
	cp /tmp/mysql-connector-java-${MYSQL_CONNECTOR_JAVA_VERSION}/mysql-connector-java-${MYSQL_CONNECTOR_JAVA_VERSION}.jar /opt/tomcat/webapps/activiti-app/WEB-INF/lib/ && \
	rm -rf /tmp/mysql-connector-java.zip /tmp/mysql-connector-java-${MYSQL_CONNECTOR_JAVA_VERSION}

# Add roles
ADD assets /assets
RUN cp /assets/config/tomcat/tomcat-users.xml /opt/apache-tomcat-${TOMCAT_VERSION}/conf/

CMD ["/assets/init"]
