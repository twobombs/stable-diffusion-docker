# Stable Diffusion in a Docker container
### - contains WebUI with Integrated SD app & pre-fetched data
### - will fetch ~ 1.5+ GB of data at first start 
### - All their code has all rights reserved to Stability AI
### - https://stability.ai/blog/stable-diffusion-announcement


docker run --gpus all -p 6080:6080 --device=/dev/dri:/dev/dri -d twobombs/stable-diffusion-docker
- go with your favorite browser to localhost:6080 and login with 00000000 
- working environment pre setup with defaults in /stable-diffusion
- python scripts/txt2img.py --prompt 'a digital Illustration of the new jerusalem, 4k, detailed futuristic' --plms --ckpt sd-v1-4.ckpt --skip_grid --n_samples 1

![Screenshot from 2022-09-04 12-31-27](https://user-images.githubusercontent.com/12692227/188309043-7a83928f-860c-475a-bb99-bf037a613af8.png)

*example made on an M40 24GB
