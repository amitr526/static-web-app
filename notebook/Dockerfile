FROM quay.io/jupyter/minimal-notebook
USER root

# RUN apt-get install --yes --no-install-recommends npm nodejs
RUN curl -LsS https://aka.ms/InstallAzureCLIDeb | bash \
    && rm -rf /var/lib/apt/lists/*

USER ${NB_UID}
RUN pip install --no-cache-dir pyspark