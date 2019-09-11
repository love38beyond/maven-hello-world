FROM 	tomcat:8
EXPOSE 	8081
ADD 	dummy /tmp/
ADD 	mymaven:/usr/src/maven-hello-world/hello-world/target/hello-world.war /usr/local/tomcat/webapps/
CMD 	["catalina.sh","run"]
