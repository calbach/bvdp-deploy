# Job Monitor

Config/docs for Verily's internal BVDP job monitor usage.

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

The GAE service names are ["jobs-ui"](https://console.cloud.google.com/appengine/versions?project=bvdp-verily-dev&serviceId=jobs-ui) and ["jobs-api"](https://console.cloud.google.com/appengine/versions?project=bvdp-verily-dev&serviceId=jobs-api).

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
    cp "$(git rev-parse --show-toplevel)/verily/job-monitor/environment.dev.ts" "$(git rev-parse --show-toplevel)/job-monitor/ui/src/environments/environment.prod.ts"
    # Build the container
    gcloud container builds submit --project bvdp-verily-dev --tag gcr.io/bvdp-verily-dev/jm-dsub-ui "$(git rev-parse --show-toplevel)/job-monitor/ui"
    # Reset submodule state
    pushd $(git rev-parse --show-toplevel)/job-monitor
    git reset --hard HEAD
    popd
    ```

1. **API**: Build container for the `dsub` server:

    ```
    gcloud container builds submit --project bvdp-verily-dev --tag gcr.io/bvdp-verily-dev/jm-dsub-api "$(git rev-parse --show-toplevel)/job-monitor/servers/dsub"
    ```

#### TODO:
- [ ] [#7](https://github.com/bvprivate/bvdp-deploy/issues/7) Add continuous deployment.
- [ ] [#8](https://github.com/bvprivate/bvdp-deploy/issues/8) Reduce hackiness around environment file injection.

### Deployment

Push flags and new images:
```
gcloud app deploy $(git rev-parse --show-toplevel)/verily/job-monitor/ui-dev.app.yaml --image-url gcr.io/bvdp-verily-dev/jm-dsub-ui --project bvdp-verily-dev
gcloud app deploy $(git rev-parse --show-toplevel)/verily/job-monitor/api-dev.app.yaml --image-url gcr.io/bvdp-verily-dev/jm-dsub-api --project bvdp-verily-dev
```

Note: it may be faster to specify an existing --version. Retrieve the active
version as follows:
```
gcloud app services describe jobs-ui --project bvdp-verily-dev
gcloud app services describe jobs-api --project bvdp-verily-dev
```

## prod
No production deployments yet
