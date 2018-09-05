# Job Manager

Config/docs for Verily's internal BVDP job manager usage.

The deployment contains two app engine services, the UI and API. The API is a
light-weight flask server which wraps the dsub library and implements the common
job monitoring interface.

# Environments

## dev

Requires access to [bvdp-verily-dev](
https://console.cloud.google.com/home/dashboard?project=bvdp-verily-dev).
File a GitHub issue to request access.

UI: https://jobs-ui-dot-bvdp-verily-dev.appspot.com

API: https://jobs-api-dot-bvdp-verily-dev.appspot.com

The GAE service names are
["jobs-ui"](https://console.cloud.google.com/appengine/versions?project=bvdp-verily-dev&serviceId=jobs-ui), ["jobs-api"](https://console.cloud.google.com/appengine/versions?project=bvdp-verily-dev&serviceId=jobs-api),
["jobs-ui-v2"](https://console.cloud.google.com/appengine/versions?project=bvdp-verily-dev&serviceId=jobs-ui-v2) and ["jobs-api-v2"](https://console.cloud.google.com/appengine/versions?project=bvdp-verily-dev&serviceId=jobs-api-v2).
See [deployment](#deployment) for information on v1 vs. v2 instances.

### Rebuild

For now, this is rebuilt manually as-needed. Continuous deployment is coming
soon.

1. Pull the latest code via gitsubmodule:

    ```
    git submodule update --recursive --remote
    ```

1. **UI**: Build container with injected environment:

    ```
    # Copy environment.dev.ts into the submodule
    cp "$(git rev-parse --show-toplevel)/verily/job-manager/environment.dev.ts" "$(git rev-parse --show-toplevel)/job-manager/ui/src/environments/environment.prod.ts"
    # Build the container
    gcloud container builds submit --project bvdp-verily-dev --config "$(git rev-parse --show-toplevel)/verily/job-manager/ui-config.yaml" "$(git rev-parse --show-toplevel)/job-manager/ui"
    # Reset submodule state
    pushd $(git rev-parse --show-toplevel)/job-manager
    git reset --hard HEAD
    popd
    ```

1. **API**: Build container for the `dsub` server:

    ```
    gcloud container builds submit --project bvdp-verily-dev --config "$(git rev-parse --show-toplevel)/verily/job-manager/api-config.yaml" "$(git rev-parse --show-toplevel)/job-manager/servers"
    ```

#### TODO:
- [ ] [#7](https://github.com/bvprivate/bvdp-deploy/issues/7) Add continuous deployment.
- [ ] [#8](https://github.com/bvprivate/bvdp-deploy/issues/8) Reduce hackiness around environment file injection.

### Deployment
dsub now has [preliminary support](https://github.com/DataBiosphere/dsub/issues/114)
for the Google Genomics Pipelines v2 API, and v1 has now been deprecated. Since
the APIs are completely distinct, there are two separate Job Manager instances
for dsub with v1 and dsub with v2. The following commands pushes flags and
new images for both instances:
```
# Job Manager for dsub (pipelines API v1)
gcloud app deploy $(git rev-parse --show-toplevel)/verily/job-manager/ui-dev.app.yaml --image-url gcr.io/bvdp-verily-dev/jm-dsub-ui --project bvdp-verily-dev
gcloud app deploy $(git rev-parse --show-toplevel)/verily/job-manager/api-dev.app.yaml --image-url gcr.io/bvdp-verily-dev/jm-dsub-api --project bvdp-verily-dev
# Job Manager fopr dsub (pipelines API v2)
gcloud app deploy $(git rev-parse --show-toplevel)/verily/job-manager/ui-dev-v2.app.yaml --image-url gcr.io/bvdp-verily-dev/jm-dsub-ui --project bvdp-verily-dev
gcloud app deploy $(git rev-parse --show-toplevel)/verily/job-manager/api-dev-v2.app.yaml --image-url gcr.io/bvdp-verily-dev/jm-dsub-api --project bvdp-verily-dev
```

Note: it may be faster to specify an existing --version. Retrieve the active
version as follows:
```
gcloud app services describe jobs-ui --project bvdp-verily-dev
gcloud app services describe jobs-api --project bvdp-verily-dev
gcloud app services describe jobs-ui-v2 --project bvdp-verily-dev
gcloud app services describe jobs-api-v2 --project bvdp-verily-dev
```

## prod
No production deployments yet
