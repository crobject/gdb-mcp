FROM --platform="linux/amd64" ubuntu:22.04

# Install gdb-multiarch, Python, and dependencies
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    gdb-multiarch \
    python3 \
    python3-pip \
    curl \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Install fastmcp library
RUN pip3 install 'fastmcp>=2.0'

# Create workspace directory
WORKDIR /workspace

# Copy the gdb-mcp script
COPY gdb-mcp /usr/local/share/gdb-mcp

RUN curl -qsL 'https://install.pwndbg.re' | sh -s -- -t pwndbg-gdb

# Create .gdbinit that sources the MCP server and starts it
RUN echo 'source /usr/local/share/gdb-mcp' > /root/.gdbinit && \
    echo 'python' >> /root/.gdbinit && \
    echo 'import gdb' >> /root/.gdbinit && \
    echo 'gdb.execute("mcp-server 0.0.0.0 3333")' >> /root/.gdbinit && \
    echo 'end' >> /root/.gdbinit

# Expose the MCP server port
EXPOSE 3333

# Start gdb-multiarch
CMD ["gdb-multiarch", "-q"]
