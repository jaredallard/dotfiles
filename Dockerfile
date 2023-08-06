# syntax=docker/dockerfile:experimental
# VSCode tunnel image for the dotfiles.
FROM ubuntu:23.04
SHELL [ "/usr/bin/env", "bash", "-c" ]
ENTRYPOINT ["code"]
CMD ["tunnel", "--accept-server-license-terms"]

# Update the apt sources to use our package mirror.
RUN sed -i.bak 's/archive.ubuntu.com/100.69.242.81:9124/g' /etc/apt/sources.list \
  &&  sed -i.bak 's/security.ubuntu.com/100.69.242.81:9124/g' /etc/apt/sources.list \
  &&  cat /etc/apt/sources.list

# Install the vscode cli and other required dependencies.
RUN set -euo pipefail \
  && apt-get update \
  && apt-get install -y git curl \
  && curl -sL \
  "https://code.visualstudio.com/sha/download?build=stable&os=cli-alpine-x64" \
  --output /tmp/vscode-cli.tar.gz \
  && tar -xf /tmp/vscode-cli.tar.gz -C /usr/bin \
  && rm /tmp/vscode-cli.tar.gz \
  && apt-get install -y sudo gpg \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Run the setup script under a non-root user.
RUN useradd -m -s /bin/bash user \
  && echo "user ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers \
  && chown -R user:user /home/user

COPY setup.sh /tmp/setup.sh
USER user
WORKDIR /home/user
RUN /tmp/setup.sh \
  && sudo chsh -s /bin/zsh $(whoami) \
  && sudo apt-get clean \
  && sudo rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*