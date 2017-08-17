#!/bin/bash

hash yaml
if [[ $? -ne 0 ]]; then
  echo "Please install the 'yaml' CLI: go get github.com/mikefarah/yaml" >&2
  exit 1
fi

# The Helm release name.
readonly release=de-dev

readonly git_root="$(git rev-parse --show-toplevel)"
readonly out="${git_root}/verily/data-explorer/endpoints/dev.swagger.yaml"
readonly project=bvdp-verily-dev
readonly host="data-explorer.endpoints.${project}.cloud.goog"

readonly esp_ip=$(kubectl get svc \
  --namespace default \
  "${release}-data-explorer-esp" \
  -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
if [[ -z "${esp_ip}" ]]; then
  cat >&2 << EOF
  Failed to find the k8s ESP data explorer service for release "${release}",
  please ensure that the release name is up to date, and that you are in the
  correct kubernetes context.
EOF
  exit 1
fi

cp "${git_root}/data-explorer-service/api/index.swagger.yaml" "${out}"
yaml w -i ${out} host "${host}"
yaml w -i ${out} x-google-allow all
yaml w -i ${out} x-google-endpoints[0].name "${host}"
yaml w -i ${out} x-google-endpoints[0].target "${esp_ip}"
