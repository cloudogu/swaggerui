# Swagger UI Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [v4.9.0-3] - 2024-06-27
### Changed
- Update base image to Version 3.20.1-2 (#24)

## [v4.9.0-2] - 2023-04-21
### Changed
- Update base image to Version 3.15.8-1 (#22)

### Removed
- curl, wget (#22)

## [v4.9.0-1] - 2022-04-13
### Fixed
- Upgrade zlib to fix [CVE-2018-25032](https://security.alpinelinux.org/vuln/CVE-2018-25032); #13
- Upgrade ssl libraries to 1.1.1n-r0 and fix [CVE-2022-0778](https://security.alpinelinux.org/vuln/CVE-2022-0778)

### Changed
- Update swagger-ui to 4.9.0-1 (#12)
  - This also includes the change that the google fonts are added to repository (#12) 
- Add update-test to jenkinsfile (#12)
- Upgrade base image to 3.15.3-1
- Changes in the CI process
   - Update dogu-build-lib to `v1.6.0`
   - Update zalenium-build-lib to `v2.1.0`
   - Upgrade ces-build-lib to v1.52.0
   - toggle video recording with build parameter (#4)

### Added
- make targets
- configurable swap and memory

## [v3.25.0-2] - 2020-05-26
### Added
- added template for the index page
- added etcd key to set the SwaggerValidator

## [v3.25.0-1] - 2020-04-08
### Added
* add Swagger UI in version 3.25.0
