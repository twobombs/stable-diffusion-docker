FROM twobombs/cudacluster:vulkan

SHELL ["/bin/bash", "-c"]

# we wants it, we needs it
RUN apt update && apt install -y unzip git-lfs
RUN pip3 install -f torch torchvision opencv-python omegaconf invisible-watermark einops pytorch-lightning ldm

# conda
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-py38_4.12.0-Linux-x86_64.sh && chmod 744 Miniconda3-py38_4.12.0-Linux-x86_64.sh && ./Miniconda3-py38_4.12.0-Linux-x86_64.sh -b

# create an environment for stable diffusion
RUN git clone --depth=1 https://github.com/CompVis/stable-diffusion.git && cd stable-diffusion/scripts && sed -i 's/x_checked_image, has_nsfw_concept = check_safety(x_samples_ddim)/x_checked_image = x_samples_ddim/g' txt2img.py
RUN export PATH="/root/miniconda3/bin:$PATH" && cd stable-diffusion && /root/miniconda3/bin/conda env create -f environment.yaml && /root/miniconda3/bin/conda init bash && echo $SHELL
RUN git clone --depth=1 https://github.com/Stability-AI/stablediffusion.git

# create an enviroment for generative models
RUN git clone --depth=1 https://github.com/Stability-AI/generative-models.git
RUN apt install -y python3.10-venv && apt clean all
RUN cd generative-models && python3 -m venv .pt2 && source .pt2/bin/activate && pip3 install -r requirements/pt2.txt && pip3 install .

# fetch prrrecious models
RUN cd stable-diffusion && mkdir -p models/ldm/stable-diffusion-v1/ && curl "https://www.googleapis.com/storage/v1/b/aai-blog-files/o/sd-v1-4.ckpt?alt=media" > sd-v1-4.ckpt 
# RUN cd stablediffusion && wget https://huggingface.co/stabilityai/stable-diffusion-2-1-base/resolve/main/v2-1_512-ema-pruned.ckpt

# HD addon
RUN wget https://github.com/xinntao/Real-ESRGAN/releases/download/v0.2.5.0/realesrgan-ncnn-vulkan-20220424-ubuntu.zip && unzip realesrgan-ncnn-vulkan-20220424-ubuntu.zip -d stable-diffusion && chmod 755 /stable-diffusion/realesrgan-ncnn-vulkan
RUN git clone --depth=1 https://github.com/jquesnelle/txt2imghd.git && cd txt2imghd && cp txt2imghd.py /stable-diffusion/scripts/txt2imghd.py && cp txt2imghd.py /stablediffusion/scripts/txt2imghd.py

# runscripts
RUN mkdir /stable-diffusion/outputs /stable-diffusion/outputs/txt2img-samples /stable-diffusion/outputs/txt2img-samples/samples

COPY run-instance /root/run-instance
COPY run-stable-diffusion /root/run-stable-diffusion
RUN chmod 744 /root/run-*

EXPOSE 5900 3389
ENTRYPOINT /root/run-stable-diffusion
