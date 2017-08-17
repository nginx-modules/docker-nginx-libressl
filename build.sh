#!/bin/bash
set -e

for i in stable mainline
 do
	docker build -t nginx-testbuild-$i $i/alpine && docker rmi nginx-testbuild-$i
done
