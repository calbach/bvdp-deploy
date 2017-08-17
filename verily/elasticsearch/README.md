# Elastic Search

Config/docs for the Elastic Search backend component. Uses Helm to push [Elastic
Search](https://github.com/elastic/elasticsearch) to [GKE](../k8s/README.md).
values.yaml files are used to to override parameters in the [base Helm Chart](
https://github.com/kubernetes/charts/tree/master/incubator/elasticsearch).

Requirements:
- [gcloud](https://cloud.google.com/sdk/docs/quickstart-linux)
- kubectl: `gcloud components install kubectl`
- [Helm](https://github.com/kubernetes/helm#install)

Helm is used primarily as a templated definition for the k8s resources. For now,
we are also using the standard chart for Elastic Search (though we may later
decide to fork this chart entirely).

Elastic Search access is restricted to the k8s cluster.

# Environments

## Dev

For internal Verily use with loose ACL restrictions. Data may be wiped at any
time. Cloud project is [bvdp-verily-dev](
https://console.cloud.google.com/home/dashboard?project=bvdp-verily-dev).

The Helm release name is "es-dev".

### Upgrade

```
gcloud container clusters get-credential bvdp-dev --zone us-east1-b --project bvdp-verily-dev
helm upgrade es-dev incubator/elasticsearch --version 0.1.8 --values dev.values.yaml --kube-context $(kubectl config current-context)
```

# Setup and new environments

See [initial k8s setup](../k8s/README.md), including kubectl configuration.

## Starting the initial deployment

Create a new values yaml file, see [dev.values.yaml](./dev.values.yaml)

```
helm init
helm install incubator/elasticsearch --version 0.1.8 --name RELEASE_NAME --values VALUES_FILE --kube-context $(kubectl config current-context)
```
