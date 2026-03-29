@echo off
echo Starting Jenkins with Java 17...
cd /d "C:\Program Files\Eclipse Adoptium\jdk-17.0.17.10-hotspot\bin"
java -jar "d:\New_automation_\kfic-automation-framework\jenkins.war" --httpPort=8080
pause