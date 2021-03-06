FROM ubuntu:trusty

COPY *.list *.key /etc/apt/sources.list.d/
COPY tcwg-buildslave/.ssh /home/tcwg-buildslave/.ssh

RUN dpkg --add-architecture i386 \
 && apt-key add /etc/apt/sources.list.d/*.key \
 && apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -y \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y devscripts \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
 alien \
 autoconf \
 autogen \
 automake \
 bc \
 bison \
 build-essential \
 ccache \
 ccrypt \
 byacc \
 debhelper \
 dejagnu \
 dh-autoreconf \
 dh-translations \
 distro-info-data \
 emacs \
 fakeroot \
 flex \
 g++-multilib \
 gawk \
 gdb \
 gdbserver \
 git \
 libexpat1-dev \
 liblzma-dev \
 libncurses5-dev \
 libpython2.7-dev \
 libreadline-dev \
 libssl-dev \
 libtool \
 make \
 mingw-w64 \
 mingw32 \
 net-tools \
 netcat \
 openjdk-7-jdk \
 openssh-server \
 python-dev \
 qemu-user \
 rsync \
 sudo \
 texinfo \
 texlive-fonts-recommended \
 texlive-latex-recommended \
 time \
 vim \
 wget \
 wine \
 xz-utils \
 zlib1g-dev \
 && apt-get clean \
 && rm -rf \
 /etc/apt/sources.list.d/*.key \
 /var/lib/apt/lists/* \
 /tmp/* \
 /var/tmp/*

RUN groupadd -g 9000 tcwg-infra \
 && useradd -m -g tcwg-infra -u 11827 tcwg-buildslave \
 && echo 'tcwg-buildslave ALL = NOPASSWD: ALL' > /etc/sudoers.d/jenkins \
 && chmod 440 /etc/sudoers.d/jenkins \
 && chown -R tcwg-buildslave:tcwg-infra /home/tcwg-buildslave/.ssh/ \
 && install -D -p -m0755 /usr/share/doc/git/contrib/workdir/git-new-workdir /usr/local/bin/git-new-workdir \
 && sed -i -e 's:^session *required *pam_loginuid.so:# session required pam_loginuid.so:' /etc/pam.d/sshd \
 && mkdir -p /var/run/sshd

# Unfortunately, VOLUME doesn't support bind-mounts for portability reasons.
# Therefore, the bind-mounts for the following paths are configured in
# the ci.linaro.org's docker plugin.
# Sources caches (read-only):
# /home/tcwg-buildslave/snapshots-ref:/home/tcwg-buildslave/snapshots-ref:ro
# Workspace (read-write):
# /home/tcwg-buildslave/workspace:/home/tcwg-buildslave/workspace:rw

# We use ssh multiplexing, which creates sockets in /tmp.  Overlayfs,
# which docker is using can't host sockets, so we use a scratch mount
# for /tmp.  This requires that we add --rm option to "docker run"
# invocations (e.g., mark "Remove volumes" checkbox in docker plugin) to
# cleanup host directories used for the scratch mounts.
VOLUME /tmp

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
