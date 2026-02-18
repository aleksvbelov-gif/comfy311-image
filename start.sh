#!/usr/bin/env bash
set -e

cd /workspace/ComfyUI

sed -i 's/dtype=dtype/torch_dtype=dtype/g' custom_nodes/ComfyUI-Florence2/nodes.py || true

exec python main.py --listen 0.0.0.0 --port 3000
