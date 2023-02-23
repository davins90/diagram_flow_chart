FROM python:3.9-slim-buster

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    graphviz \
    xdg-utils \
 && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
RUN pip install --no-cache-dir \
    diagrams \
    jupyterlab

# Set up JupyterLab
RUN useradd -m jovyan && \
    echo "jovyan ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    mkdir -p /home/jovyan/.jupyter && \
    echo c.ServerApp.ip = \"0.0.0.0\" > /home/jovyan/.jupyter/jupyter_server_config.py && \
    echo c.ServerApp.token = \"\" >> /home/jovyan/.jupyter/jupyter_server_config.py && \
    echo c.ServerApp.allow_origin = \"*\" >> /home/jovyan/.jupyter/jupyter_server_config.py && \
    chown -R jovyan /home/jovyan/.jupyter

USER jovyan

WORKDIR /home/jovyan

# Expose JupyterLab port
EXPOSE 8888

# Start JupyterLab
CMD ["jupyter", "lab"]
