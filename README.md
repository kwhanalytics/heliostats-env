# heliostats-env
**Description:** The `heliostats-env` Docker image includes requirements necessary for HelioStats development, integration testing, and HelioStats display in the browser. It inherits from the [data-env](https://github.com/kwhanalytics/data-env) Docker image for [marvin](https://bitbucket.org/kwh/marvin/src/develop/) development.

[Dockerhub](https://hub.docker.com/repository/docker/kwhadocker/heliostats-env) builds a `heliostats-env` Docker image from the code in the `heliostats-env` Github repo. We use code in the separate [devops](https://bitbucket.org/kwh/devops/src/master/) repo to pull down Docker images and make local `heliostats_env` Docker containers from them. 

## Table of Contents
1. [Using the heliostats-env Docker image](#1-using-the-heliostats-env-docker-image)
2. [Updating the helisotats-env Docker image](#2-updating-the-heliostats-env-docker-image)

## 1. Using the heliostats-env Docker image
Please refer to the Confluence documentation on [Using Docker for HelioStats](https://kwhanalytics.atlassian.net/wiki/spaces/KTD/pages/1121255455/Using+Docker+for+HelioStats). (Documentation-ception)

## 2. Updating the heliostats-env Docker image
**Note:** These instructions are adapted from the document regarding [Updating the data-env Docker Image](https://kwhanalytics.atlassian.net/wiki/spaces/KTD/pages/908394665/Updating+the+Data+Env+Docker+Image).
### Update Github repo
**Note:** These instructions are a work in progress. Especially because concourse tests are not yet using the `heliostats-env` image.

1) Create a new branch off github/kwhanalytics/data-env and name it “v[N+1]” where vN is the most recent branch name in the GitHub repo (Check the list of open and merged branches in GitHub to find this). For example, if the most recent branch is v1 you will name your branch v2.
    * It is very important that you name this branch exactly as formatted, otherwise DockerHub won’t automatically create a new build with the correct tag.  
2) Push your branch to github, open a PR, and add reviewers.  
3) Check DockerHub to ensure your new tag was built successfully. You can check https://hub.docker.com/repository/docker/kwhadocker/heliostats-env/builds to see the status of your build. If your build fails, check the logs and debug appropriately.

### Test the new Docker image
**Note:** This section is a **work in progress**.We still need to set up docker on heliostats concourse tests and define the testing process for new docker images.

### Merge Changes and Tell the Team
**Note:** This section is a **work in progress**. We still need to set up docker on heliostats concourse tests and define the testing process for new docker images.  
* Once testing is complete, get approval for your open PR's.
* Merge the Github branch into `master`. This will trigger a new build on DockerHub for the `latest` tag which will be an identical copy of your newest tag.