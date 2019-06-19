.. SPDX-License-Identifier: GPL-2.0+

GitLab CI / U-Boot runner container
===================================

This image is based on the Ubuntu images and adds what is required for U-Boot
to be able to be built and run its test suite.

## Usage

- Build this image on your docker host.

```
docker build -t your-namespace:your-tag .
```
