FROM twobombs/cudacluster:vulkan

# we wants it, we needs it
RUN apt install -y unzip

# conda
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-py38_4.12.0-Linux-x86_64.sh && chmod 744 Miniconda3-py38_4.12.0-Linux-x86_64.sh && ./Miniconda3-py38_4.12.0-Linux-x86_64.sh -b

# create an environment for stable diffusion
RUN git clone https://github.com/CompVis/stable-diffusion.git
RUN export PATH="/root/miniconda3/bin:$PATH" && cd stable-diffusion && /root/miniconda3/bin/conda env create -f environment.yaml && /root/miniconda3/bin/conda init bash && echo $SHELL

# fetch prrrecious model
RUN cd stable-diffusion && mkdir -p models/ldm/stable-diffusion-v1/ && curl "https://www.googleapis.com/storage/v1/b/aai-blog-files/o/sd-v1-4.ckpt?alt=media" > sd-v1-4.ckpt
# HD addon
RUN wget https://github.com/xinntao/Real-ESRGAN/releases/download/v0.2.5.0/realesrgan-ncnn-vulkan-20220424-ubuntu.zip && unzip realesrgan-ncnn-vulkan-20220424-ubuntu.zip -p /stable-diffusion
RUN git clone https://github.com/jquesnelle/txt2imghd.git && cd txt2imghd && cp txt2imghd.py /stable-diffusion/scripts/txt2imghd.py
# runscripts
COPY run-instance /root/run-instance
COPY run-stable-diffusion /root/run-stable-diffusion
RUN chmod 744 /root/run-*

EXPOSE 5900 3389
ENTRYPOINT /root/run-stable-diffusion
