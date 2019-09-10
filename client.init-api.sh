#!/bin/bash
curl -H "Content-Type: application/json" -X POST -d '{"colour":"red", "size":"small"}'  "http://rp/API"
curl -H "Content-Type: application/json" -X POST -d '{"colour":"green", "size":"medium"}'  "http://rp/API"
curl -H "Content-Type: application/json" -X POST -d '{"colour":"blue", "size":"large"}'  "http://rp/API"
curl rp/accounts;echo
