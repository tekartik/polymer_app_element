#!/bin/bash

# Fast fail the script on failures.
set -e

# Check dart2js warning: using dart2js example/demo_idb.dart --show-package-warnings -o /tmp/out.js

dartanalyzer --fatal-warnings \
  lib/app_page.dart \
  lib/app_page_container.dart \
  lib/app_prefs.dart \
  lib/dom_ready_mixin.dart \
  lib/element_utils.dart \
  lib/gapi_flow.dart \

pub run test -p vm
pub run test -p chrome
# pub run test -p content-shell -j 1
# pub run test -p firefox -j 1 --reporter expanded