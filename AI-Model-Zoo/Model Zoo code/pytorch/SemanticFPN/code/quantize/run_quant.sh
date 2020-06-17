# Copyright 2019 Xilinx Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

export PYTHONPATH=${PWD}:${PYTHONPATH}
CUDA_VISIBLE_DEVICES=0 python code/quantize/quant.py \
                      --quant_mode 1 \
                      --eval --dataset citys \
                      --model fpn \
                      --backbone resnet18 \
                      --crop-size 256 \
                      --data-folder ./data/cityscapes/ \
                      --weight ./float/fpn_res18/final_best.pth.tar \

CUDA_VISIBLE_DEVICES=0 python code/quantize/quant.py \
                      --quant_mode 2 \
                      --eval --dataset citys \
                      --model fpn \
                      --backbone resnet18 \
                      --crop-size 256 \
                      --data-folder ./data/cityscapes/ \
                      --weight ./float/fpn_res18/final_best.pth.tar \



