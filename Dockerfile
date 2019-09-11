FROM 	tomcat:8
EXPOSE 	8081
ADD 	dummy /tmp/
ADD 	/root/data/jenkins/workspace/jenkins_demo/hello-world/target/hello-world.war /usr/local/tomcat/webapps/
CMD 	["catalina.sh","run"]
