FROM debian:7.8
MAINTAINER Ryne Okimoto <ryneo@livekodawari.com>

# Define commonly used JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

# Install dependencies
RUN apt-get update && \
    apt-get install -y git build-essential curl wget zip unzip software-properties-common

# Create editor userspace
RUN groupadd play && \
    useradd play -m -g play -s /bin/bash && \
    passwd -d -u play && \
    mkdir -p /etc/sudoers.d && touch /etc/sudoers.d/play && \
    echo "play ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/play && \
    chmod 0440 /etc/sudoers.d/play && \
    mkdir /home/play/Code && \
    chown play:play /home/play/Code

WORKDIR /tmp
RUN wget --quiet http://downloads.typesafe.com/typesafe-activator/1.3.2/typesafe-activator-1.3.2.zip

# Install play
RUN unzip typesafe-activator-1.3.2.zip
RUN mv activator-1.3.2 /opt/activator
RUN chown -R play:play /opt/activator

# Install Java and dependencies
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \
    echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee /etc/apt/sources.list.d/webupd8team-java.list && \
    echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886 && \
    apt-get update && \
    apt-get install -y oracle-java8-installer

RUN echo "export PATH=$PATH:/opt/activator" >> /home/play/.bashrc
# Define user home. Activator will store ivy2 and sbt caches on /home/play/Code volume
RUN echo "export _JAVA_OPTIONS='-Duser.home=/home/play/Code'" >> /home/play/.bashrc

# Change user, launch bash
USER play
WORKDIR /home/play
CMD ["/bin/bash"]

# Expose Code volume and play ports 9000 default 9999 debug 8888 activator ui
VOLUME "/home/play/Code"
EXPOSE 9000
EXPOSE 9999
EXPOSE 8888
WORKDIR /home/play/Code
