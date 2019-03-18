#!/bin/bash
set -e
set -uxo pipefail

# Decrypt and import signing key
openssl aes-256-cbc -K $encrypted_ec79e61fc360_key -iv $encrypted_ec79e61fc360_iv -in ci/dropwizard.asc.enc -out ci/dropwizard.asc -d
gpg2 --import ci/dropwizard.asc

./mvnw -B deploy --settings 'ci/settings.xml' -DperformRelease=true -Dmaven.test.skip=true

# Documentation
./mvnw -B site site:stage --settings 'ci/settings.xml' -Dmaven.test.skip=true

DOCS_VERSION=$(./mvnw help:evaluate -Dexpression=project.version -q -DforceStdout)
mkdir gh-pages
mv target/staging gh-pages/"${DOCS_VERSION}"