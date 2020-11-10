FROM rocker/shiny:3.6.3

#ARG nginx_port
#ENV nginx_port=${nginx_port}

RUN apt-get update -qq && apt-get -y --no-install-recommends install \
  libudunits2-dev \
  libgdal-dev \
  libbz2-dev \
  liblzma-dev \
  libmagick++-dev \
  lsof \
  libpython3.7-dev \
  python3-pip \
  git-all \
  vim \
  nginx \
  ufw \
  libssl-dev \
  libharfbuzz-dev \
  libfribidi-dev \
 
 && pip3 install numpy \
 && pip3 install Cython \
 && pip3 install setuptools \
# && pip3 install biom-format==2.1.7 \
 && pip3 install biom-format \
 && pip3 install h5py \
# && R -e 'install.packages("devtools")' \
# && R -e 'devtools::install_github("r-lib/pkgdown")' \
 && install2.r --error \
  --deps TRUE \
#  plotly \
  shiny \
  DT \
  devtools \
  shinythemes \ 
  shinyFiles \
  pingr \ 
  shinycssloaders \
  shinyjs \
  shinyWidgets \
  shinyBS \
  kableExtra \
  dunn.test \
  vegan \
  egg \
  ggrepel \
  usedist \
  tidyverse \
  htmltools \
  remotes \
  fossil \
  tippy \
       
 && R -e 'devtools::install_github("ropensci/plotly")' \
 && R -e 'devtools::install_github("gregce/ipify")' \
 && R -e 'install.packages("plyr")' \
 && R -e 'remotes::install_github("dreamRs/shinybusy")' \
 && R -e 'remotes::install_github("jbisanz/qiime2R")' \ 
 && R -e 'remotes::install_github("hrbrmstr/myip")' \
 && R -e 'install.packages("Rcpp")' \
 && R -e 'install.packages("BiocManager")' \
 && R -e 'BiocManager::install(version = "3.10")' \
 && R -e 'BiocManager::install("dada2", version = "3.10")' \
 
 && cd /home/ \
 && mkdir imuser \
 && cd imuser \

RUN apt-get -qq update && apt-get -qq -y install curl bzip2 \
    && curl -sSL https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -o /tmp/miniconda.sh  \
    && bash /tmp/miniconda.sh -bfp /usr/local  \
    && rm -rf /tmp/miniconda.sh  \
    && conda install -y python=3  \
    && conda update conda  \
    && apt-get -qq -y remove curl bzip2  \
    && apt-get -qq -y autoremove \
    && apt-get autoclean \
    && rm -rf /var/lib/apt/lists/* /var/log/dpkg.log \
    && conda clean --all --yes \
    && wget https://data.qiime2.org/distro/core/qiime2-2020.8-py36-linux-conda.yml \
    && conda env create -n qiime2-2020.8 --file qiime2-2020.8-py36-linux-conda.yml \
    && rm qiime2-2020.8-py36-linux-conda.yml \

 && sed -i 's/run_dada_single.R/\/usr\/local\/envs\/qiime2-2020.8\/bin\/run_dada_single.R/g' /usr/local/envs/qiime2-2020.8/lib/python3.6/site-packages/q2_dada2/_denoise.py \
 && sed -i 's/run_dada_paired.R/\/usr\/local\/envs\/qiime2-2020.8\/bin\/run_dada_paired.R/g' /usr/local/envs/qiime2-2020.8/lib/python3.6/site-packages/q2_dada2/_denoise.py \

 && cd /home/imuser \
 && git clone https://github.com/v0369012/mochi_imuser.git \
 && cp -r mochi_imuser/* ./ \
 && rm -r mochi_imuser \
 && mkdir qiime_output \
 && mkdir FAPROTAX_output \

# && service nginx start \

# && cd /var/www/html \
 && cd /home/imuser \
 && git clone https://github.com/v0369012/mochi_var_www_html.git \

# && mkdir nginx_share \
 
 && cp -r mochi_var_www_html/* /var/www/html \
 && rm -r mochi_var_www_html  \

 && rm -r /srv/shiny-server/* \
# && sed -i 's/\/var\/www\/html/\/home\/imuser\/nginx_share/g' /home/imuser/server.R \
 && cp /home/imuser/ui.R /srv/shiny-server/ \
 && cp /home/imuser/server.R /srv/shiny-server/ \

 && sed -i 's/\/home\/imuser\/miniconda3\/envs\/qiime2-2019.10\/bin\/qiime/\/usr\/local\/envs\/qiime2-2020.8\/bin\/qiime/g' /srv/shiny-server/server.R \
 && chmod -R 777 /home/imuser \
# && chmod -R 777 /home/imuser/nginx_share \
# && chown -R shiny:shiny /home/imuser/ \

 && chmod -R 777 /var/www/html \
 && sed -i 's/8099/8011/g' /srv/shiny-server/server.R \
 && sed -i 's/8099/8011/g' /srv/shiny-server/ui.R \

# && echo shiny:shiny | chpasswd
 && sed -i "21i shiny ALL=NOPASSWD: ALL" /etc/sudoers \
 && sed -i 's/\/home\/imuser\/miniconda3\/envs\/qiime2-2019.10\/bin/\/usr\/local\/envs\/qiime2-2020.8\/bin/g' /srv/shiny-server/server.R \ 
 && sed -i 's/\/home\/imuser\/miniconda3\/envs\/python-2.7\/bin\/python2.7/\/usr\/local\/envs\/python-2.7\/bin\/python2.7/g' /srv/shiny-server/server.R \

 && conda create -n python-2.7 python=2.7 -y \
 && /usr/local/envs/python-2.7/bin/python2.7 -m pip install numpy \
 && /usr/local/envs/python-2.7/bin/python2.7 -m pip install h5py  \
 && /usr/local/envs/python-2.7/bin/python2.7 -m pip install biom-format==2.1.7 \
 #&& apt-get install -y python-numpy \
 #&& apt-get install -y python-biom-format=2.1.7 \
 #&& apt-get install -y python-h5py \

