# kubekite
**kubekite** is a manager for buildkite-agent jobs in Kubernetes.  It watches the [Buildkite](https://buildkite.com) API for new build jobs and when one is detected, it launches a Kubernetes job resource to run a single-user pod of [buildkite-agent](https://github.com/buildkite/agent).  When the agent is finished, kubekite cleans up the job and the associated pod.

## Usage

### How to build a new version of the container
- To build and push to GCR in one go run `VERSION=[YOUR VERSION] ./build_all.sh`
- Alternatively
  - Build the full docker image, and tag it with the GCR resource: `docker build . -t us.gcr.io/sigma-1330/kubekite:$VERSION`
  - Push the kubekite image to GCR: `docker push us.gcr.io/sigma-1330/kubekite:$VERSION`
- To build a specific job: `docker build . --build-arg JOB_TEMPLATE=job-templates/[job].yaml -t us.gcr.io/sigma-1330/kubekite:$VERSION-[job]`

Kubekite is designed to be run within Kubernetes as a single-replica deployment.  An example deployment spec [can be found here](https://github.com/ProjectSigma/kubekite/blob/master/kube-deploy/sigma-1330/deployment.yaml).  You can build and deploy kubekite from within Buildkite using the [included pipeline](https://github.com/ProjectSigma/kubekite/tree/master/.buildkite).

**Note that you will have to modify the deployment spec, these scripts, and the `pipeline.yml` to suit your infrastructure and preferred Docker registry.**

