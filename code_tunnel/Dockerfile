FROM ubuntu:22.04

# for sshd install
ARG USERNAME=root


# Accept dynamic user and group IDs at build time
ARG USER_ID=${USER_ID}
ARG GROUP_ID=${GROUP_ID}
ARG DOCKER_GROUP_ID=${DOCKER_GROUP_ID}


# Accept Python version as a build argument
ARG PYTHON_VERSION=${PYTHON_VERSION:-3.11}

# Create non-root user and Docker group dynamically
RUN groupadd -g ${GROUP_ID} mosgarage && \
    useradd -u ${USER_ID} -g mosgarage -m mosgarage && \
    groupadd -g ${DOCKER_GROUP_ID} docker && \
    usermod -aG docker mosgarage



# sets up repo for python
RUN apt-get update \
    && apt-get install -y software-properties-common curl \
    apt-transport-https ca-certificates gnupg \
    && add-apt-repository ppa:deadsnakes/ppa

# sets up timezone so apt wont freeze on build
RUN apt-get install -y tzdata && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone && \
    dpkg-reconfigure --frontend noninteractive tzdata

# install gcloud CLI
RUN curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg \
    | gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" \
    > /etc/apt/sources.list.d/google-cloud-sdk.list && \
    apt-get update && apt-get install -y google-cloud-cli

# install Docker CLI and utils
RUN apt-get update && apt-get install -y \
    sudo \
    docker.io git bash \
    python${PYTHON_VERSION} python3-pip python${PYTHON_VERSION}-venv \
    && apt-get clean


# Set mosgarage's default shell to bash
RUN chsh -s /bin/bash mosgarage

# Set the PYTHONPATH dynamically based on the Python version argument
ARG PYTHONPATH=/usr/bin/python${PYTHON_VERSION}

# Allow mosgarage to run sudo without password
RUN echo "mosgarage ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/mosgarage && \
    chmod 0440 /etc/sudoers.d/mosgarage    

# Create a symbolic link to ensure `python` refers to the correct Python version
RUN ln -s /usr/bin/python${PYTHON_VERSION} /usr/bin/python

# enable SSH server
EXPOSE ${SSHD_PORT}
ARG SSHD_PORT=${SSHD_PORT}
ARG START_SSHD=${START_SSHD}
COPY container_sshd.sh /usr/local/bin/container_sshd.sh
RUN chmod +x /usr/local/bin/container_sshd.sh && \
    /usr/local/bin/container_sshd.sh
ARG mosgarage_PASSWORD
ENV mosgarage_PASSWORD=${mosgarage_PASSWORD}
RUN echo "mosgarage:${mosgarage_PASSWORD}" | chpasswd

# Switch to non-root user
USER mosgarage

# Set the default workspace directory
ENV REMOTE_WORKSPACE=/workspaces

WORKDIR /app
# Download VS Code CLI
RUN curl -L -o code.tar.gz "https://code.visualstudio.com/sha/download?build=stable&os=cli-alpine-x64" && \
    tar -xzf "code.tar.gz" && \
    rm -f code.tar.gz

WORKDIR /workspaces

# Copy the entrypoint script into the container
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

# Set the script as the entry point
ENTRYPOINT ["docker-entrypoint.sh"]
