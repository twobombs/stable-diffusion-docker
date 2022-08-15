FROM twobombs/cudacluster:vulkan

RUN apt update && apt install anaconda && apt clean all
RUN git clone https://github.com/CompVis/stable-diffusion.git
RUN cd stable-diffusion && conda env create -f environment.yaml && conda activate ld

EXPOSE 5900 3389
ENTRYPOINT /root/run
