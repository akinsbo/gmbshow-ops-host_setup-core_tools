#!/bin/sh
until kubectl get nodes;
do sleep 1;
echo 'Waiting for aws to provision nodes';
done