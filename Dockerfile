FROM ubuntu:16.04

RUN apt-get update && \
           apt-get upgrade -y

WORKDIR /

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
           jupyter \
           pandas

RUN git clone https://github.com/tensorflow/models.git /tensorflow/models

WORKDIR /tensorflow/models/research

RUN wget https://github.com/google/protobuf/releases/download/v3.0.0/protoc-3.0.0-linux-x86_64.zip && \
    chmod 775 protoc-3.0.0-linux-x86_64.zip && \
    unzip protoc-3.0.0-linux-x86_64.zip -d protoc3 && \
    mv protoc3/bin/* /usr/local/bin/ && \
    mv protoc3/include/* /usr/local/include/ && \
    rm protoc-3.0.0-linux-x86_64.zip && \
    # chown $USER /usr/local/bin/protoc && \
    # chown -R $USER /usr/local/include/google && \
    protoc object_detection/protos/*.proto --python_out=.

ENV PYTHONPATH=$PYTHONPATH:/tensorflow/models/research:/tensorflow/models/research/slim

    # this seems to be the fabled lost page of installation instructions
RUN python setup.py build && \
    python setup.py install

WORKDIR /

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY jupyter_notebook_config.py /root/.jupyter/
COPY run_jupyter.sh /

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

# jupyter
EXPOSE 8888

# tensorboard
EXPOSE 6006

CMD ["/run_jupyter.sh", "--allow-root"]

# CMD ["/bin/bash"]

# CMD ["jupyter", "notebook", "--allow-root", "--notebook-dir=/tensorflow/models/research/object_detection", "--port=8888"]
