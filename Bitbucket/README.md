This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles


# Bitbucket runners, pipelines, CI/CD, etc.


### Update Feb. 2025: see my answer here!: `bitbucket-pipelines.yml` file example: [Advanced Bitbucket Pipelines configuration file example...](https://stackoverflow.com/a/79476795/4561887)

> ...for Windows, relying extensively on [YAML anchors and aliases](https://support.atlassian.com/bitbucket-cloud/docs/yaml-anchors/), custom key:value entries, and common commands to be shared across many `script` entries in many `step`s. 
> 
> This also demonstrates how to run Bash scripts inside Windows PowerShell, how to run Linux-compatible Bash scripts on Windows build servers, and how to run many steps _in parallel_ if your self-hosted build server has multiple pipeline runners that can operate in parallel, or _in series_ if you have only one pipeline runner.
> 
> This would be good to use as a template for all future `bitbucket-pipelines.yml` files you create, for both Windows and Linux build servers and Bitbucket runners.


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
