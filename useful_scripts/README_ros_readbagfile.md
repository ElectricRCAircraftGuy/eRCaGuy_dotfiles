# Read messages on certain topics from within a ROS bag file

## Installation

First, see the Installation Instructions at the top of the file: [ros_readbagfile.py](ros_readbagfile.py).

## Help and usage

See help menu:

    ros_readbagfile -h

Basic usage:

    ros_readbagfile <mybagfile.bag> [topic1] [topic2] [topic3] [...topicN]

## Tutorial

For a tutorial demonstration, see my ROS tutorial I wrote here: [Reading messages from a bag file](http://wiki.ros.org/ROS/Tutorials/reading%20msgs%20from%20a%20bag%20file).

In short:

1. Download a 730 MB `demo.bag` file: 
   ```bash
    wget https://open-source-webviz-ui.s3.amazonaws.com/demo.bag
    ```
1. Now, read a couple topics from this file and store them into a `topics.yaml` file:
   ```bash
   time ros_readbagfile demo.bag /obs1/gps/fix /diagnostics_agg | tee topics.yaml
   ```

Done.
