#!/bin/bash

# Set the default GPU name for D3D12
# By default, it use the integrated GPU
export MESA_D3D12_DEFAULT_ADAPTER_NAME="NVIDIA"

if [ -z "$XDG_RUNTIME_DIR" ]; then
    ln -sf /mnt/wslg/runtime-dir/wayland-* "$XDG_RUNTIME_DIR/"
fi
