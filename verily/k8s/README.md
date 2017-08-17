# k8s

Config/docs for Verily's internal BVDP GKE usage. For now we expect a k8s
cluster to correspond 1:1 to a full deployment of the BVDP, e.g. one per
environment.

# Environments

## Dev

Project: [bvdp-verily-dev](
https://console.cloud.google.com/home/dashboard?project=bvdp-verily-dev)
GKE cluster: [bvdp-dev](
https://console.cloud.google.com/kubernetes/clusters/details/us-central1-b/bvdp-dev?project=bvdp-verily-dev)

# Setup and new environments

For new Cloud Projects, follow the GKE [quick-start](
https://cloud.google.com/container-engine/docs/quickstart), without creating the
example cluster. Must have installed:

- [gcloud](https://cloud.google.com/sdk/docs/quickstart-linux)
- kubectl: `gcloud components install kubectl`

## Create a new k8s cluster

```
gcloud container clusters create ${CLUSTER_NAME}
```

# Configuring kubectl

```
gcloud container clusters list

# Select the appropriate cluster from above.
CLUSTER_NAME=
CLUSTER_ZONE=

gcloud container clusters get-credentials ${CLUSTER_NAME} --zone ${CLUSTER_ZONE}
```

Note that this will persist a k8s context to your home directory. Subsequent
kubectl usage will target this cluster.
