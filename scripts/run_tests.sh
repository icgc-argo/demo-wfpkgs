#!/bin/bash

for f in test*.nf.json; do
  echo $f;
  ./checker.nf -params-file $f;
done
