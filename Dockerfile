FROM roborio:tmp

# Fixes issues with the original RoboRIO image
RUN mkdir -p /var/volatile/tmp && \
    mkdir -p /var/volatile/cache && \
    mkdir -p /var/volatile/log && \
    mkdir -p /var/run/sshd

RUN opkg update && \
    opkg install binutils-symlinks gcc-symlinks g++-symlinks libgcc-s-dev make libstdc++-dev

# Overwrite auth
COPY system/common_auth /etc/pam.d/common-auth
RUN useradd admin -ou 0 -g 0 -s /bin/bash -m
RUN usermod -aG sudo admin

# Fixes for WPILib
RUN mkdir -p /usr/local/frc/third-party/lib
RUN chmod 777 /usr/local/frc/third-party/lib

# This forces uname to report armv7l
COPY system/libfakearmv7l.so /usr/local/lib/libfakearmv7l.so
RUN chmod +x /usr/local/lib/libfakearmv7l.so && \
    mkdir -p /home/admin/.ssh && \
    echo "LD_PRELOAD=/usr/local/lib/libfakearmv7l.so" >> /home/admin/.ssh/environment && \
    echo "PermitUserEnvironment yes" >> /etc/ssh/sshd_config && \
    echo "PasswordAuthentication no">> /etc/ssh/sshd_config

COPY startup.sh startup.sh

# Put the CPU into 32bit mode, and start an SSH server
ENTRYPOINT [ "sh", "startup.sh" ]
