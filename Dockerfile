FROM tomcat:8
LABEL "organization"="QT"
COPY openmrs.war /usr/local/tomcat/webapps/openmrs.war
EXPOSE 8080
CMD ["catalina.sh", "run"]

