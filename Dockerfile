FROM continuumio/miniconda3:4.8.2

LABEL container.base.image="continuumio/miniconda3:4.8.2" \
      software.name="IGM Churchill Ancestry" \
      software.version="3.0.2"

# install system requirements so these can potentially be cached
ENV NUMBA_VERSION="0.48" PATH="/opt/conda/bin:$PATH"
RUN conda install -y \
      -c conda-forge \
      matplotlib=3.2.1 xgboost=1.0.2  \
      pandas=1.0.1 numpy=1.18.1 \
      scipy=1.4.1 umap-learn=0.4.2 \
      scikit-learn=0.24.1 \
      bokeh=2.4.3 && \
      # clean up
      conda clean --all

# install the application requirements to cache
WORKDIR /tmp/
# download at tag v1.1-buster
RUN git clone --branch v1.1-buster https://github.com/genome/snvstory.git 
WORKDIR /tmp/snvstory/
RUN pip install -r requirements.txt
ARG SERVICE_NAME=Ancestry
WORKDIR /opt/${SERVICE_NAME}
RUN cp -r /tmp/snvstory/igm_churchill_ancestry ./
RUN chmod -R ugo+rw .

RUN rm -rf /tmp/snvstory/
ENV PYTHONPATH=/opt/${SERVICE_NAME}
ENV PATH="/opt/conda/bin:$PATH"
