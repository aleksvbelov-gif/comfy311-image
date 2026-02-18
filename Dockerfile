FROM nvidia/cuda:12.1.1-cudnn8-runtime-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV PIP_DISABLE_PIP_VERSION_CHECK=1
ENV PYTHONUNBUFFERED=1

RUN apt-get update && apt-get install -y --no-install-recommends \
    git curl ca-certificates \
    python3.11 python3.11-venv python3-pip \
    && rm -rf /var/lib/apt/lists/*

RUN ln -sf /usr/bin/python3.11 /usr/bin/python3 && ln -sf /usr/bin/python3.11 /usr/bin/python

WORKDIR /workspace

RUN git clone https://github.com/comfyanonymous/ComfyUI.git /workspace/ComfyUI

WORKDIR /workspace/ComfyUI
RUN python -m pip install --upgrade pip wheel setuptools \
 && pip install -r requirements.txt \
 && pip install \
    "transformers==4.41.2" "tokenizers==0.19.1" \
    timm einops sentencepiece protobuf accelerate safetensors

WORKDIR /workspace/ComfyUI/custom_nodes
RUN git clone https://github.com/kijai/ComfyUI-Florence2.git

RUN sed -i 's/dtype=dtype/torch_dtype=dtype/g' /workspace/ComfyUI/custom_nodes/ComfyUI-Florence2/nodes.py

WORKDIR /workspace
COPY start.sh /workspace/start.sh
RUN chmod +x /workspace/start.sh

EXPOSE 3000
CMD ["/workspace/start.sh"]
