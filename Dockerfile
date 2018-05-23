FROM ubuntu:16.04

RUN apt-get update && \
           apt-get upgrade -y

WORKDIR \

RUN mkdir -p /tensorflow/models

RUN apt-get install -y \
           git \
           python-pip \
           #python-pil
           #protobuf-compiler
           wget \
           unzip
           

RUN pip install -U pip \
           tensorflow \
           pillow \
           lxml \
           matplotlib \
           jupyter

RUN git clone https://github.com/tensorflow/models.git /tensorflow/models

WORKDIR /tensorflow/models/research

RUN wget https://github.com/google/protobuf/releases/download/v3.3.0/protoc-3.3.0-linux-x86_64.zip && \
           chmod 775 protoc-3.3.0-linux-x86_64.zip && \
           unzip protoc-3.3.0-linux-x86_64.zip && \
           bin/protoc object_detection/protos/*.proto --python_out=.

RUN export PYTHONPATH=$PYTHONPATH:`pwd`:`pwd`/slim

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY jupyter_notebook_config.py /root/.jupyter/
COPY run_jupyter.sh /

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

# jupyter
EXPOSE 8888

CMD ["/run_jupyter.sh", "--allow-root"]

CMD ["/bin/bash"]

# CMD ["jupyter", "notebook", "--allow-root", "--notebook-dir=/tensorflow/models/research/object_detection", "--port=8888"]