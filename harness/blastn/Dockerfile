FROM ncbi/blast

RUN apt-get update && apt-get install -y \
    git \
    python-pip \
    python3.5 \
    build-essential \
    autoconf

RUN git clone -b develop https://github.com/TravisWheelerLab/hmmer.git

WORKDIR hmmer

RUN git clone -b develop https://github.com/TravisWheelerLab/easel.git
RUN autoconf
RUN ./configure
RUN make && make install

WORKDIR easel
RUN make install

COPY prepare_data.sh /bin/prepare_data
COPY run_tool.sh /bin/run_tool
