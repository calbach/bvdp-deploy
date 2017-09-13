#!/bin/bash
#
# This script pulls upstream changes from the Data Explorer API definition and
# modifies them for this environment. With YAML, there is no standard way to
# override/extend one file with another, otherwise this script would not be
# necessary. This environment-specific swagger file is needed as the
# configuration for cloud endpoints, and so it may also include GCP specific
# extensions (which do not belong in the upstream data explorer repository).

hash yaml
if [[ $? -ne 0 ]]; then
  echo "Please install the 'yaml' CLI: go get github.com/mikefarah/yaml" >&2
  exit 1
fi

readonly git_root="$(git rev-parse --show-toplevel)"
readonly out="${git_root}/verily/data-explorer/dev.swagger.yaml"
readonly project=bvdp-verily-dev
readonly host="explorer-api-dot-${project}.appspot.com"

cp "${git_root}/data-explorer-service/api/index.swagger.yaml" "${out}"
yaml w -i ${out} host "${host}"
yaml w -i ${out} x-google-allow all

# Configure/require oauth for Cloud Endpoints.
yaml w -i ${out} securityDefinitions.google_id_token.authorizationUrl ""
yaml w -i ${out} securityDefinitions.google_id_token.flow "implicit"
yaml w -i ${out} securityDefinitions.google_id_token.type "oauth2"
yaml w -i ${out} securityDefinitions.google_id_token.x-google-issuer "https://accounts.google.com"

# For both values, audiences are a single comma-delimited string. Copy it over
# to avoid having to duplicate this verbose list.
readonly aud=$(yaml r "${git_root}/verily/data-explorer/dev.app.yaml" env_variables.OAUTH2_AUDIENCES)
yaml w -i ${out} "securityDefinitions.google_id_token.x-google-audiences" "${aud}"

# Manual for now: https://github.com/mikefarah/yaml/issues/21
cat >> ${out} << EOF

security:
  - google_id_token: []
EOF
