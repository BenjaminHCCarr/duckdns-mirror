## Intent
This is a mirror of the [DuckDNS](https://www.duckdns.org/) server code. This source was provided on 20180513 by Steven of duckdns.org and is availble from http://bit.ly/DuckSource_GDrive.

DuckDNS is an excellent service, and I am very happy with what they provide! I was extremely excited when they decided to release the entire server stack code as GPL3!


## INTRO
This is a servlet project
In Eclipse you can run it on Tomcat for easy development (see below)
Updates are cached in each server to reduce DB lookups.
Sessions are held in DynamoDB
Updates cause a push to each DNS server with an event that flushes the cache in the DNS
Events are passed to Google ANALYTICS for real time monitoring

In product this runs in jetty 9
When packaged, all dependent libs are not included, to make it lighter to publish.
All jars are placed in jetty_base/libs/ext
All Config is placed in jetty_base/resources

## CREATE WAR
To create the duckdns.war
Add an ANT view into Eclipse (Window | Show View | Other - ANT)
Drag the build.xml into the ant window
Double click on the "Duck Website" ant file
The war will be built at : dist/duckdns.war
This task also copies your Secrets from the secrets project - see the ../samplesecrets project
../secrets/aws/AwsCredentials.properties
../secrets/jetty/secrets.properties

## CONFIGURATION
You will need to choose a domain to do your OAUTH on, each provider needs setting up.
Put a host file in your local machine to test if it works, the providers will be redirecting your browser to this domain

You will need the correct OAUTH config in secrets.properties
You will need a SALT config in secrets.properties
You will need a GOOGLE ANALYTICS config in secrets.properties
You will need the INTERNAL and EXTERNAL IPS setting config in secrets.properties (can be 127.0.0.1 for now)

## RUN IN ECLIPSE TOMCAT
extract tomcat to a location e.g. /apps
localsetup/resources/apache-tomcat-7.0.57.tar.gz

Then add a new tomcat 7 server - use /apps as the file location - also select JDK 8
Set the domain as localdev.duckdns.org (I have this set to 127.0.0.1)

Now right click on the duckdns project and choose RUN : RUN ON SERVER
Select the new tomcat 7 server
localhost:8080 should be working

## Preparing Jetty
We run Jetty using an JETTY_BASE
Copy the folder : conf/jetty_config -> jetty_base

In the base are all the files we add to jetty to make it work - copy these in 
WebContent/WEB-INF/lib/*.jar -> /jetty_base/lib/ext/
resources/* -> /jetty_base/resources/
secrets/* -> /jetty_base/resources/

## RUNNING JETTY IN A SHELL
export PATH=/apps/java/jdk_current/bin:${PATH};export JAVA_HOME=/apps/java/jdk_current;export JETTY_USER=jetty;export JETTY_HOME=/apps/jetty/jetty_current;export JAVA_OPTIONS="-d64 -server -Xms200m -Xmx200m";export JETTY_PORT=8080;export JETTY_RUN=${JETTY_HOME}/run;export LANG=en_GB.ISO8859-1;export JETTY_BASE=/apps/jetty/jetty_config; ${JETTY_HOME}/bin/jetty.sh run

## RUNNING JETTY AS A SERVICE
Scripts for this are in scripts/*

## RELEASING 
To release we copy the WAR to /var/tmp/duckdns.war
Then we execute
scripts/do_release.sh

## NGINX WEBSERVER
Nginx is a lightweight webserver that provides a wrapper to jetty
Jetty server all non dyanmic requests
Requests pass through nginx to jetty when needed
There is a sample Nginx config at : conf/nginx/default
