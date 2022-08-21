FROM twobombs/cudacluster:vulkan

# RUN wget https://repo.anaconda.com/archive/Anaconda3-2021.11-Linux-x86_64.sh && chmod 744 Anaconda3-2021.11-Linux-x86_64.sh && bash ./Anaconda3-2021.11-Linux-x86_64.sh -b -p $HOME/anaconda3 && rm Anaconda3-2021.11-Linux-x86_64.sh

RUN wget https://repo.anaconda.com/miniconda/Miniconda3-py38_4.12.0-Linux-x86_64.sh && chmod 744 Miniconda3-py38_4.12.0-Linux-x86_64.sh && ./Miniconda3-py38_4.12.0-Linux-x86_64.sh -b
RUN export PATH="/root/miniconda3/bin:$PATH"

RUN git clone https://github.com/CompVis/stable-diffusion.git
RUN cd stable-diffusion && conda env create -f environment.yaml && conda init bash && echo $SHELL
# RUN cd stable-diffusion && conda activate ld

EXPOSE 5900 3389
ENTRYPOINT /root/run
