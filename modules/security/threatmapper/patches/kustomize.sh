#!/bin/bash

cat <&0 > patches/all.yaml

kustomize build patches && rm patches/all.yaml