#!/bin/bash

NAME=$1

if [[ ! -f ~/.kaggle/kaggle.json ]]; then
  echo -n "Kaggle username: "
  read USERNAME
  echo
  echo -n "Kaggle API key: "
  read APIKEY

  mkdir -p ~/.kaggle
  echo "{\"username\":\"$USERNAME\",\"key\":\"$APIKEY\"}" > ~/.kaggle/kaggle.json
  chmod 600 ~/.kaggle/kaggle.json
fi

pip install kaggle --upgrade

echo $NAME

case $NAME in
  "carvana")
    kaggle competitions download -c carvana-image-masking-challenge -f train_hq.zip
    mkdir -p data/carvana/imgs
    unzip train_hq.zip
    mv train_hq/* data/carvana/imgs/
    rm -r train_hq
    rm train_hq.zip

    kaggle competitions download -c carvana-image-masking-challenge -f train_masks.zip
    mkdir -p data/carvana/masks
    unzip train_masks.zip
    mv train_masks/* data/carvana/masks/
    rm -r train_masks
    rm train_masks.zip
    ;;
  "mnist_csv")
    kaggle competitions download -c digit-recognizer
    mkdir -p data/mnist_csv
    unzip digit-recognizer.zip
    mv train.csv data/mnist_csv
    mv test.csv data/mnist_csv
    rm sample_submission.csv
    rm digit-recognizer.zip
    ;;
  "mnist")
    mkdir -p data/mnist/raw
    wget -c -P data/mnist/raw https://ossci-datasets.s3.amazonaws.com/mnist/train-images-idx3-ubyte.gz
    wget -c -P data/mnist/raw https://ossci-datasets.s3.amazonaws.com/mnist/train-labels-idx1-ubyte.gz
    wget -c -P data/mnist/raw https://ossci-datasets.s3.amazonaws.com/mnist/t10k-images-idx3-ubyte.gz
    wget -c -P data/mnist/raw https://ossci-datasets.s3.amazonaws.com/mnist/t10k-labels-idx1-ubyte.gz
    gunzip -k data/mnist/raw/*.gz
    ;;
  "cifar10")
    wget -c https://www.cs.toronto.edu/~kriz/cifar-10-python.tar.gz
    mkdir -p data/cifar10
    tar -xvf cifar-10-python.tar.gz
    mv cifar-10-batches-py/* data/cifar10
    rm cifar-10-python.tar.gz
    rm -r cifar-10-batches-py
    ;;
  "tiny-imagenet")
    wget -c https://www.image-net.org/data/tiny-imagenet-200.zip
    mkdir -p data/tiny-imagenet
    unzip tiny-imagenet-200.zip
    mv tiny-imagenet-200/* data/tiny-imagenet
    rm tiny-imagenet-200.zip
    rm -r tiny-imagenet-200
    ;;
  "cub200")
    kaggle datasets download veeralakrishna/200-bird-species-with-11788-images --unzip
    mkdir -p data/CUB_200_2011
    tar -xvzf CUB_200_2011.tgz -C ./data
    tar -xvzf segmentations.tgz -C ./data/CUB_200_2011
    rm CUB_200_2011.tgz
    rm segmentations.tgz
    ;;
  *)
    echo "Invalid dataset name"
    ;;
esac
