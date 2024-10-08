FROM artifactory.wikia-inc.com/dockerhub/eclipse-temurin:17.0.9_9-jdk-jammy

# Shared indexing works best
# when you use the IDE
# corresponding to the language
# your project is in
ARG IDE=ideaIU
ARG IDE_SHORT=idea
ARG IDE_CODE=idea
ARG IDE_VERSION=2024.1.6

# persist build args for runtime
# see https://www.saltycrane.com/blog/2021/04/buildtime-vs-runtime-environment-variables-nextjs-docker/#setting-dynamic-buildtime-environment-variables-that-are-available-at-runtime-also
ENV IDE=$IDE
ENV IDE_SHORT=$IDE_SHORT
ENV IDE_CODE=$IDE_CODE
ENV IDE_VERSION=$IDE_VERSION

ARG IDE_TAR=${IDE}-${IDE_VERSION}.tar.gz
ARG IJ_SHARED_INDEXES_TOOL_VERSION=0.9.9

# Runtime variables
ENV INDEXES_CDN_URL=http://localhost:3000/project
ENV COMMIT_ID=''
ENV PROJECT_ID=''
ENV IDEA_PROJECT_DIR="/var/project"
ENV SHARED_INDEX_BASE="/shared-index"

USER root
WORKDIR /opt

RUN apt-get update && \
    apt-get install -y zip git && \
    rm -rf /var/lib/apt/lists/*

# Set up folders
RUN mkdir -p /etc/idea && \
    mkdir -p /etc/idea/config && \
    mkdir -p /etc/idea/log && \
    mkdir -p /etc/idea/system && \
    mkdir ${SHARED_INDEX_BASE}

# Install IntelliJ IDEA Ultimate
RUN wget -nv https://download-cf.jetbrains.com/${IDE_CODE}/${IDE_TAR} && \
    tar xzf ${IDE_TAR} && \
    tar tzf ${IDE_TAR} | head -1 | sed -e 's/\/.*//' | xargs -I{} ln -s {} idea && \
    rm ${IDE_TAR} && \
    echo idea.config.path=/etc/idea/config >> /opt/idea/bin/idea.properties && \
    echo idea.log.path=/etc/idea/log >> /opt/idea/bin/idea.properties && \
    echo idea.system.path=/etc/idea/system >> /opt/idea/bin/idea.properties && \
    chmod -R 777 /opt/idea && \
    chmod -R 777 ${SHARED_INDEX_BASE} && \
    chmod -R 777 /etc/idea

# Install ij-shared-indexes-tool
RUN wget https://packages.jetbrains.team/maven/p/ij/intellij-shared-indexes/com/jetbrains/intellij/indexing/shared/ij-shared-indexes-tool-cli/${IJ_SHARED_INDEXES_TOOL_VERSION}/ij-shared-indexes-tool-cli-${IJ_SHARED_INDEXES_TOOL_VERSION}.zip -O ij-shared-indexes-tool-cli.zip && \
    unzip ij-shared-indexes-tool-cli.zip && \
    rm ij-shared-indexes-tool-cli.zip && \
    mv ij-shared-indexes-tool-cli-${IJ_SHARED_INDEXES_TOOL_VERSION} ij-shared-indexes-tool-cli


COPY entrypoint.sh entrypoint.sh

RUN useradd -u 955 -ms /bin/bash app
USER app

CMD ./entrypoint.sh

# Comment out the CMD line and uncomment the following for testing
# ENTRYPOINT ["tail", "-f", "/dev/null"]
