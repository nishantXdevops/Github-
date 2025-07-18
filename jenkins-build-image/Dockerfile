FROM jenkins/jenkins:lts

# Disable setup wizard
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=true

# Add plugin list
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt

# Install plugins
RUN jenkins-plugin-cli --plugin-file /usr/share/jenkins/ref/plugins.txt

# Setup default admin user
COPY basic-security.groovy /usr/share/jenkins/ref/init.groovy.d/basic-security.groovy
