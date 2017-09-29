#!/bin/bash

grep -r  LIBNOVA_EXPORT|awk '{print $3}'|grep ln_|awk -F\( '{print $1}'
