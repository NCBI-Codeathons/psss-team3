FROM ncbi/blast AS blast

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

COPY preprocess.sh /bin/prepare_data
COPY wrapper.sh /bin/run_tool
