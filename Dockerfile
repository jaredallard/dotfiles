# syntax=docker/dockerfile:experimental
# VSCode tunnel image for the dotfiles.
FROM ubuntu:24.04
# Username of the custom user.
ARG CUSTOM_USER=gitpod
ENV SHELL /bin/zsh
SHELL [ "/usr/bin/env", "bash", "-c" ]
ENTRYPOINT ["code"]
CMD ["tunnel", "--accept-server-license-terms"]

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
RUN groupadd -g 33333 ${CUSTOM_USER} \
  && useradd -u 33333 -g ${CUSTOM_USER} -m -s /bin/bash ${CUSTOM_USER} \
  && echo "${CUSTOM_USER} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers \
  && chown -R ${CUSTOM_USER}:${CUSTOM_USER} /home/${CUSTOM_USER}

COPY setup.sh /tmp/setup.sh
USER ${CUSTOM_USER}
WORKDIR /home/user
RUN DEBIAN_FRONTEND=noninteractive /tmp/setup.sh \
  && sudo chsh -s /bin/zsh $(whoami) \
  && sudo apt-get clean \
  && sudo rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*