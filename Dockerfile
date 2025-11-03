FROM --platform="linux/amd64" ubuntu:22.04

# Install gdb-multiarch, Python, and dependencies
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    gdb-multiarch \
    python3 \
    python3-pip \
    curl \
    wget \
    file \
    locales \
    && rm -rf /var/lib/apt/lists/*

# GEB UTF-8

RUN locale-gen en_US.UTF-8
ENV LC_CTYPE=C.UTF-8

# Install fastmcp library
RUN pip3 install 'fastmcp>=2.0'

# Create workspace directory
WORKDIR /workspace

# Copy the gdb-mcp script
COPY gdb-mcp /usr/local/share/gdb-mcp


# Create .gdbinit that sources the MCP server and starts it
RUN echo 'source /usr/local/share/gdb-mcp' > /root/.gdbinit && \
    echo 'python' >> /root/.gdbinit && \
    echo 'import gdb' >> /root/.gdbinit && \
    echo 'gdb.execute("mcp-server 0.0.0.0 3333")' >> /root/.gdbinit && \
    echo 'end' >> /root/.gdbinit

RUN bash -c "$(curl -fsSL https://gef.blah.cat/sh)"

# Expose the MCP server port
EXPOSE 3333

# Start gdb-multiarch
CMD ["gdb-multiarch", "-q"]
