# Dockerfile for OpenClinica
FROM tomcat:7.0-jre8
ENV  OC_HOME              $CATALINA_HOME/webapps/OpenClinica
ENV  OC_WS_HOME           $CATALINA_HOME/webapps/OpenClinica-ws
ENV  OC_VERSION           3.17
COPY run.sh               /run.sh
RUN  mkdir /tmp/oc 
# copy zip from src to container
ADD  'OpenClinica-3.17.zip' /tmp/oc/openclinica.zip
ADD  'OpenClinica-ws-3.17.zip' /tmp/oc/openclinica-ws.zip
# unzip and remove zip
RUN  cd /tmp/oc && \
     unzip openclinica.zip && \
     unzip openclinica-ws.zip && \
     rm openclinica.zip && \
     rm openclinica-ws.zip
# 
RUN  rm -rf $CATALINA_HOME/webapps/* && \
     mkdir $OC_HOME && cd $OC_HOME && \
     cp /tmp/oc/OpenClinica-$OC_VERSION/distribution/OpenClinica.war . && \
     unzip OpenClinica.war 
RUN  cd .. 
RUN  mkdir $OC_WS_HOME && cd $OC_WS_HOME && \
     cp /tmp/oc/OpenClinica-ws-$OC_VERSION/distribution/OpenClinica-ws.war . && \
     unzip OpenClinica-ws.war && cd ..
RUN  rm -rf /tmp/oc
RUN  mkdir $CATALINA_HOME/openclinica.data/xslt -p
# servlet-api.jar deleted from war file
# https://jira.openclinica.com/browse/OC-6074
RUN  chmod +x /*.sh
ENV  JAVA_OPTS -Xmx1280m -XX:+UseParallelGC -XX:+CMSClassUnloadingEnabled
CMD  ["/run.sh"]