#!/usr/bin/env bash

./pre-build-scripts/pre_build_automation.sh && flutter drive -t test_driver/app_$1.dart --flavor automation