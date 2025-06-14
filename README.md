# inspec-httprb

![GitHub release](https://img.shields.io/github/v/release/memes/inspec-httprb?sort=semver)
![Maintenance](https://img.shields.io/maintenance/yes/2025)
[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-2.1-4baaaa.svg)](CODE_OF_CONDUCT.md)

This repo contains a drop-in replacement for Inspec [http] resource. The intent
is to preserve the simplicity of use of [http], but use [HTTPrb] in preference
to Faraday as it seems to handle HTTP/2 responses better which I encounter working
with GCP load balancers.

[http]: https://docs.chef.io/inspec/resources/http/
[httprb]: https://github.com/httprb/http
