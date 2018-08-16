#!/bin/bash

mkdir -p ~/performance
if [ ! -e ~/performance/benchmark_baseline.json ]; then
    mix benchmark --json --update-json
    mv benchmark_baseline.json ~/performance
fi
ln -s ~/performance/benchmark_baseline.json
