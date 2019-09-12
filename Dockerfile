FROM 	tomcat:8
EXPOSE 	8080
ADD 	dummy /tmp/
COPY 	./hello-world/target/hello-world.war /usr/local/tomcat/webapps/
CMD 	["catalina.sh","run"]
