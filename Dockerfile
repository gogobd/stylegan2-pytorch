FROM nvidia/cuda:latest

# Install system dependencies
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y \
        build-essential \
        curl \
        wget \
        git \
        unzip \
        screen \
        vim \
    && apt-get clean

# Install python miniconda3 + requirements
ENV MINICONDA_HOME="/opt/miniconda"
ENV PATH="${MINICONDA_HOME}/bin:${PATH}"
RUN curl -o Miniconda3-latest-Linux-x86_64.sh https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && chmod +x Miniconda3-latest-Linux-x86_64.sh \
    && ./Miniconda3-latest-Linux-x86_64.sh -b -p "${MINICONDA_HOME}" \
    && rm Miniconda3-latest-Linux-x86_64.sh

# COPY environment.yml environment.yml
# RUN conda env update -n=root --file=environment.yml
# RUN conda clean -y -i -l -p -t && \
#    rm environment.yml

# COPY requirements.txt requirements.txt
# RUN pip install requirements.txt

RUN conda install -c anaconda jupyter && \
    conda install -c conda-forge jupyterlab && \
    conda install -c anaconda nb_conda && \
    conda install -c conda-forge fire && \
    conda install numpy && \
    conda install -c conda-forge tqdm && \
    conda install pytorch torchvision -c soumith && \
    conda install pillow=6.1
RUN pip install torch-optimizer

RUN wget https://github.com/cdr/code-server/releases/download/2.1698/code-server2.1698-vsc1.41.1-linux-x86_64.tar.gz && \
    tar -xzvf code-server2.1698-vsc1.41.1-linux-x86_64.tar.gz && \
    chmod +x code-server2.1698-vsc1.41.1-linux-x86_64/code-server && \
    rm code-server2.1698-vsc1.41.1-linux-x86_64.tar.gz
 
# Copy
COPY . /stylegan2-pytorch
WORKDIR /stylegan2-pytorch

# Start container in notebook mode
CMD /code-server2.1698-vsc1.41.1-linux-x86_64/code-server --allow-http --no-auth --data-dir / & \
    jupyter-lab --ip="*" --no-browser --allow-root

