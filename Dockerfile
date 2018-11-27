FROM jenkins/jenkins:lts
USER root

# BEGIN: SSH installation and configuration for Azure Web App SSH Login

RUN apt-get update -y
RUN apt-get install openssh-server -y
RUN echo "root:Docker!" | chpasswd \
    && echo "cd /home" >> /etc/bash.bashrc

COPY sshd_config /etc/ssh/
# END: SSH installation #


# Make directory for Jenkins in /home so that the installation
# can be persisted to the Web App /home directory mounted to
# Azure Storage.
RUN mkdir -p /home/jenkins_home

# Define Jenkins root directory environment variable
ENV JENKINS_HOME /home/jenkins_home

# For Jenkins UI web interface port
EXPOSE 8080

# For SSH port
EXPOSE 2222

# For Jenkins slave agents port
EXPOSE 50000

COPY jenkins.sh /usr/local/bin/jenkins.sh
RUN chmod 755 /usr/local/bin/jenkins.sh
ENTRYPOINT ["/usr/local/bin/jenkins.sh"]