FROM ubuntu:24.04
LABEL maintainer="BNLCyber"

ARG DEBIAN_FRONTEND=noninteractive

ENV uv_packages="ansible"

# Install uv from the official image.
COPY --from=ghcr.io/astral-sh/uv:latest /uv /bin/uv

# Install dependencies.
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       apt-utils \
       build-essential \
       locales \
       libffi-dev \
       libssl-dev \
       libyaml-dev \
       python3-dev \
       python3-setuptools \
       python3-yaml \
       software-properties-common \
       rsyslog systemd systemd-cron sudo iproute2 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /usr/share/doc /usr/share/man

RUN sed -i 's/^\($ModLoad imklog\)/#\1/' /etc/rsyslog.conf

# Fix potential UTF-8 errors with ansible-test.
RUN locale-gen en_US.UTF-8

# Install Ansible via uv.
RUN uv pip install --system --break-system-packages $uv_packages

COPY initctl_faker .
RUN chmod +x initctl_faker && rm -f /sbin/initctl && ln -s /initctl_faker /sbin/initctl

# Install Ansible inventory file.
RUN mkdir -p /etc/ansible \
    && echo "[local]\nlocalhost ansible_connection=local" > /etc/ansible/hosts

# Remove unnecessary getty and udev targets that result in high CPU usage when using
# multiple containers with Molecule (https://github.com/ansible/molecule/issues/1104)
RUN rm -f /lib/systemd/system/systemd*udev* \
    && rm -f /lib/systemd/system/getty.target

VOLUME ["/sys/fs/cgroup", "/tmp", "/run"]
CMD ["/lib/systemd/systemd"]
