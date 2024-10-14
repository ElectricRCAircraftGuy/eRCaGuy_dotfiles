This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles


# Bitbucket runners, pipelines, CI/CD, etc.


# References

1. https://support.atlassian.com/bitbucket-cloud/docs/set-up-runners-for-windows/
1. https://support.atlassian.com/bitbucket-cloud/docs/configure-your-first-pipeline/
1. https://support.atlassian.com/bitbucket-cloud/docs/configure-your-runner-in-bitbucket-pipelines-yml/

1. https://support.atlassian.com/bitbucket-cloud/docs/git-clone-behavior/

    Example `bitbucket-pipelines.yml` file to disable cloning:
    ```yaml
    clone: 
        enabled: false
    ```
1. https://support.atlassian.com/bitbucket-cloud/docs/global-options/

1. https://support.atlassian.com/bitbucket-cloud/docs/docker-image-options/

    Example `bitbucket-pipelines.yml` file to use a custom Docker image:
    ```yaml
    image: my-custom-image:latest
    ```

1. https://support.atlassian.com/bitbucket-cloud/docs/runners/ - runners: using your own build machine hardware to build: ex: Linux Ubuntu, Windows, macOS, etc.

1. https://bitbucket.org/blog/predefine-values-of-custom-pipeline-variables

1. https://support.atlassian.com/bitbucket-cloud/docs/step-options/
    1. https://support.atlassian.com/bitbucket-cloud/docs/step-options/#Runs-on
        
        > To run a pipeline step on a self-hosted runner, add the `runs-on` option to the step. When the pipeline is run, the step will run on the next available runner that has all the listed labels. If all matching runners are busy, your step will wait until one becomes available again. If you don't have any online runners in your repository that match all labels, the step will fail.

1. https://support.atlassian.com/bitbucket-cloud/docs/variables-and-secrets/


# Notes


# TODO

_Newest on BOTTOM._

1. [ ] Read the following:
    1. [ ] https://support.atlassian.com/bitbucket-cloud/docs/docker-image-options/
    1. [ ] https://support.atlassian.com/bitbucket-cloud/docs/runners/
    1. [ ] https://support.atlassian.com/bitbucket-cloud/docs/configure-your-runner-in-bitbucket-pipelines-yml/
    1. [x] \*\*\*\*\*https://support.atlassian.com/bitbucket-cloud/docs/set-up-runners-for-windows/
    1. [ ] https://support.atlassian.com/bitbucket-cloud/docs/git-clone-behavior/
1. [ ] More advanced topics:
    1. [ ] https://support.atlassian.com/bitbucket-cloud/docs/use-docker-images-as-build-environments/
