#!/bin/bash

if [[ "$TRAVIS_PULL_REQUEST" != "false" ]]; then
    echo "This is a pull request. Code coverage will only be uploaded on merge."
    exit 0
fi

# run the XcodeCoverage scripts to generate a code coverage report
"${XCODE_COVERAGE_DIR}/getcov"

# where XcodeCoverage puts its results
source ${XCODE_COVERAGE_DIR}/envcov.sh
LCOV_OUTPUT_DIR="${BUILT_PRODUCTS_DIR}/lcov"

# zip up the output directory for easier S3 uploading
zip --quiet --recurse-paths "${TRAVIS_BUILD_DIR}/lcov" "${LCOV_OUTPUT_DIR}"
