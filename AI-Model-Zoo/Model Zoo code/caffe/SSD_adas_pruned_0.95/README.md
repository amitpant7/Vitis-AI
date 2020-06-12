### Contents
1. [Installation](#installation)
2. [Demo](#Demo)
3. [Preparation](#Preparation)
4. [Train/Eval](#traineval)
5. [Performance](#Performance)
6. [Model info](#Model info)

### Installation
1. Get the code. We will call the directory that you cloned Caffe into `$CAFFE_ROOT`
  **Note:** To download caffe-xilinx
  
  ```shell
  unzip caffe-xilinx.zip
  cd caffe-xilinx
  ```

2. Build the code. Please follow [Caffe instruction](http://caffe.berkeleyvision.org/installation.html) to install all necessary packages and build it.
  ```shell
  # Modify Makefile.config according to your Caffe installation.
  cp Makefile.config.example Makefile.config
  make -j8
  # Make sure to include $CAFFE_ROOT/python to your PYTHONPATH.
  # python version(python2)
  make py
  ```
### Demo
 run demo
  ```shell
  # modify the "caffe_xilinx_dir" in code/test/demo.sh
  sh code/test/demo.sh
  ```
### Preparation
1. Dataset Diretory Structure like:
   ```shell
   + train
     + images
        + image_id1.jpg
        + image_id2.jpg
     + label_txt
        + image_id1.txt
        + image_id2.txt
      
     label.txt: please refer code/train/label_txt/*.txt
        image_name label_1 xmin1 ymin1 xmax1 ymax1
        image_name label_2 xmin2 ymin2 xmax2 ymax2
        ...
     ```

2. Create the LMDB 
   ```shell
    Because the data is private so you should copy your data to 'code/train/images/' and modify the 'train.txt' and 'test.txt' information. You can use the 'create_data.sh.' convert the data to IMDB.
   ./code/train/create_data.sh
   ```

### Train/Eval
1. train your model, modify the LMDB path in the '%.prototxt'
   ```shell
   sh ./code/train/trainval.sh
   ```
2. Evaluate the most recent snapshot.
  if you have the lmdb file ,you can do :
   ```shell
   ### you would modify the 'phase_type' from "train " to "test"
   sh ./code/train/trainval.sh
   ```
  You can also test the images 
  ```shell
  # If you would like to test a model you trained, you can do:
  # 1. add the all images path to  images.txt and  run 
  # 2. modify the threshlod 0.3 to 0.005 
  sh code/test/demo.sh
  ```
  Evaluate mIou and mAP.
  ```shell
  # Evaluate mAP
   python code/test/evaluation.py -gt_file code/test/gt_labels.txt -result_file code/test/result.txt
  ```
### Performance
  ```shell
   Test images: private data 1000
   Model: ssd-vgg-pruned
   Classes: 4
   mAP: 42.07% 
   ```
### MOdel info
1. data preprocess
```
1. data channel order: BGR(0~255)                  
2. resize: 360 * 480(H * W) 
3. mean_value: 104, 117, 123
4. scale: 1
```
2.For quantization with calibration mode:
  ```
  Modify datalayer of test.prototxt for model quantization:
  a. Replace the "Input" data layer of test.prototxt with the "ImageData" data layer.
  b. Modify the "ImageData" layer parameters according to the date preprocess information.
  c. Provide a "quant.txt" file, including image path and label information with fake value(like 1).
  d. Give examples of data layer and "quant.txt":
  # data layer example
    layer {
    name: "data"
    type: "ImageData"
    top: "data"
    top: "label"
    include {
      phase: TRAIN
    }
    transform_param {
      mirror: false
      mean_value: 104
      mean_value: 117
      mean_value: 123
     }

    image_data_param {
      source: "quant.txt"
      new_width: 480  
      new_height: 360
      batch_size: 16
    }
  }
  # quant.txt: image path label
    images/000001.jpg 1
    images/000002.jpg 1
    images/000003.jpg 1

  ```
3.For quantization with finetuning mode: 
  ```
  use trainval.prototxt for model quantization.
  ```