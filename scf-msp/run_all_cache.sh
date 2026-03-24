#!/bin/bash

JSON=()

JSON+=(bsl.balanced.json)
JSON+=(bsl.json)
JSON+=(bsl.linear.json)
JSON+=(mulhi3.balanced.json)
JSON+=(mulhi3.json)
JSON+=(mulhi3.linear.json)
JSON+=(mulmod8.balanced.json)
JSON+=(mulmod8.json)
JSON+=(mulmod8.linear.json)
JSON+=(sharevalue.balanced.json)
JSON+=(sharevalue.json)
JSON+=(sharevalue.linear.json)
JSON+=(switch16.balanced.json)
JSON+=(switch16.json)
JSON+=(switch16.linear.json)
JSON+=(switch8.balanced.json)
JSON+=(switch8.json)
JSON+=(switch8.linear.json)

for j in "${JSON[@]}"; do
    ./main.py ipe_tests/$j $@
done
