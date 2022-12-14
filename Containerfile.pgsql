ARG IMAGE
FROM ${IMAGE}

RUN dnf -q -y install bc \
                   bison \
                   cmake \
                   flex \
                   gcc \
                   glibc-devel \
                   glibc-langpack-en \
                   hostname \
                   iproute \
                   libev-devel \
                   make \
                   openssh-clients \
                   openssh-server \
                   openssl-devel \
                   pandoc \
                   patch \
                   perf \
                   perl \
                   python3-docutils \
                   R \
                   readline-devel \
                   rsync \
                   sysstat \
                   tar \
                   which \
                   zlib-devel && \
    dnf -q clean all

# Install DBT Tools.

ARG DBTTOOLSVER=0.3.0
RUN curl -o /tmp/v${DBTTOOLSVER}.tar.gz -sOL \
    https://github.com/osdldbt/dbttools/archive/refs/tags/v${DBTTOOLSVER}.tar.gz && \
    tar -C /usr/local/src -xf /tmp/v${DBTTOOLSVER}.tar.gz
WORKDIR /usr/local/src/dbttools-${DBTTOOLSVER}
RUN cmake . && cmake --install .

# Install DBT-3 for PostgreSQL.

ENV DBT3PATH=/usr/local/src/dbt3
COPY . ${DBT3PATH}

WORKDIR ${DBT3PATH}
RUN cmake . && cmake --install .

ARG TPCFILE
COPY ${TPCFILE} ${DBT3PATH}
RUN unzip -q ${TPCFILE}
# Work around the space in the directory name.
RUN mv "TPC-H V3.0.1" tpchtools
WORKDIR ${DBT3PATH}/tpchtools
RUN patch -s -p2 < ../patches/dbt3-TPC-H_v3.0.1-postgresql.diff && \
    patch -s -p2 < ../patches/dbt3-TPC-H_v3.0.1-stdout.diff && \
    patch -s -p2 < ../patches/dbt3-TPC-H_v3.0.1-mysql.diff && \
    patch -s -p2 < ../patches/dbt3-TPC-H_v3.0.1-virtuoso.diff && \
    patch -s -p2 < ../patches/dbt3-TPC-H_v3.0.1-monetdb.diff
WORKDIR ${DBT3PATH}/tpchtools/dbgen
RUN make -s -f Makefile.postgresql

RUN chmod 777 /opt

RUN groupadd postgres && \
    useradd -g postgres postgres

# Install PostgreSQL from source.

ARG PGVER
RUN curl -o /tmp/postgresql-${PGVER}.tar.gz -sOL \
    https://ftp.postgresql.org/pub/source/v${PGVER}/postgresql-${PGVER}.tar.gz
RUN tar -C /usr/local/src -xf /tmp/postgresql-${PGVER}.tar.gz
WORKDIR /usr/local/src/postgresql-${PGVER}
RUN ./configure -q --prefix /usr && \
    make -s -j$(nproc) install && \
    rm -f /tmp/postgresql-${PGVER}.tar.gz
WORKDIR /usr/local/src/postgresql-${PGVER}/contrib/auto_explain
RUN make -s -j$(nproc) install

RUN echo "/usr/lib" > /etc/ld.so.conf.d/postgresql.conf && \
    ldconfig

USER postgres
RUN /usr/bin/initdb -D /opt/pgdata -A trust --auth=trust --auth-host=trust \
           --auth-local=trust -E UTF8 --locale=en_US.utf8 \
           --lc-collate=en_US.utf8 --lc-ctype=en_US.utf8
RUN echo "host all all 0.0.0.0/0 trust" >> /opt/pgdata/pg_hba.conf && \
    echo "host all all ::/0 trust" >> /opt/pgdata/pg_hba.conf && \
    echo "max_connections = 1000" >> /opt/pgdata/postgresql.auto.conf && \
    echo "shared_buffers = 1024MB" >> /opt/pgdata/postgresql.auto.conf && \
    echo "checkpoint_timeout = 30min" >> /opt/pgdata/postgresql.auto.conf && \
    echo "max_wal_size = 100GB" >> /opt/pgdata/postgresql.auto.conf && \
    echo "listen_addresses = '*'" >> /opt/pgdata/postgresql.auto.conf

ENV DSS_PATH=/tmp/dss
ENV DSS_CONFIG=${DBT3PATH}/tpchtools/dbgen
ENV DSS_QUERY=${DBT3PATH}/queries/pgsql
ENV DBGEN=${DBT3PATH}/tpchtools/dbgen/dbgen
ENV QGEN=${DBT3PATH}/tpchtools/dbgen/qgen

ENV PGDATA=/opt/pgdata
ENV PGUSER=postgres
ENV PGDATABASE=dbt3

user root
RUN systemctl enable sshd
CMD [ "/usr/sbin/init" ]
