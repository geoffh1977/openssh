# OpenSSH Jumpbox Container #

![OpenSSH picture](https://raw.githubusercontent.com/geoffh1977/openssh/master/assets/openssh.gif)

## Description ##
This docker image provides an OpenSSH  daemon which can be used as a Jumpbox into other systems or a docker bridged network. A Username/Password combination is configuration at runtime as is a Banner message and Message of the Day.

## Running The Container ##

In order to run the container, the USERNAME and PASSWORD variables must be speicifed. Other variables are optional.

`docker run -it --rm -e USERNAME=username -e PASSWORD=password -p {PORT}:22/tcp geoffh1977/openssh`

**Command Options:**

> -e USERNAME -> The username that will be used to login
> -e PASSWORD -> The password that will be used to login
> -e BANNER - A banner message to display before the login prompt
> -e MOTD - Message of the day. Displayed after the login prompt
> -v {PATH}:/etc/ssh - A custom config and files for the service to use

You can place the container in detached mode by replacing the "-it" switch with "-d". The BANNER and MOTD can also be placed in files in the /etc/ssh path and will be picked up and used by the startup script.

### Getting In Contact ###
So why do I provide images like this one? Mainly because I need to use them myself, and figure other people may want them without the hassle of having to build them from scratch.

If you find any issues with this container or want to recommend some improvements, fell free to get in contact with me or submit pull requests on github.
