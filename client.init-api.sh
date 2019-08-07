#!/bin/bash -x
curl -H "Content-Type: application/json" -X POST -d '{"colour":"red", "size":"small"}'  "http://rp/accounts"
curl -H "Content-Type: application/json" -X POST -d '{"colour":"green", "size":"medium"}'  "http://rp/accounts"
curl -H "Content-Type: application/json" -X POST -d '{"colour":"blue", "size":"large"}'  "http://rp/accounts"
