# Swagger UI Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [v5.29.1-1] - 2025-09-30
### Changed
- [#73] Update swagger-ui to 5.29.1

## [v5.29.0-1] - 2025-09-10
### Changed
- [#71] Update swagger-ui to 5.29.0

## [v5.28.1-1] - 2025-09-03
### Changed
- [#66] Update swagger-ui to 5.28.1

## [v5.27.1-1] - 2025-08-04
### Changed
- [#64] Update swagger-ui to 5.27.1
- [#64] Update base image to 3.22.0-4

## [v5.26.2-1] - 2025-07-08
### Changed
- [#60] Update swagger-ui to 5.26.2

## [v5.26.0-1] - 2025-07-03
### Changed
- [#58] Update swagger-ui to 5.26.0

## [v5.25.2-1] - 2025-06-18
### Changed
- [#56] Update swagger-ui to 5.25.2
- [#56] Update cypress to 13.17.0
- [#56] Update Base Image to v3.22.0-2
 
## [v5.24.1-1] - 2025-06-16
### Changed
- [#54] Update swagger-ui to 5.24.1

## [v5.22.0-1] - 2025-05-28
### Changed
- [#52] Update swagger-ui to 5.22.0

## [v5.21.0-2] - 2025-04-29
- [#50] Set sensible resource requests and limits

## [v5.21.0-1] - 2025-04-14
- [#48] Update swagger-ui to 5.21.0

## [v5.20.8-1] - 2025-04-11
### Changed
- [#46] Update Makefiles to 9.9.1
- [#46] Update swagger-ui to 5.20.8
- [#46] Update dogu-build-lib to 3.2.0 and ces-build-lib to 4.2.0

## [v5.19.0-1] - 2025-02-26
### Changed
- [#44] Update Makefiles to 9.5.3
- [#44] Update swagger-ui to 5.19.0
- [#44] Update dogu-build-lib to 3.1.0 and ces-build-lib to 4.1.0

## [v5.18.2-4] - 2025-02-12
### Added
- Add missing container config keys to dogu.json

## [v5.18.2-3] - 2025-01-22
### Fixed
- Add Pre-Release Build-Stage

## [v5.18.2-2] - 2025-01-22
### Changed
- [#33] Update Makefiles to 9.5.2
- [#35] Update base image to 3.21.0-1
- [#37] use new Trivy-Class from ces-build-lib instead of dogu-build-lib

## [v5.18.2-1] - 2024-11-19
- Update cypress/included:13.15.2
- Update github.com/cloudogu/ces-build-lib@3.0.0
- Update base image to version 3.20.3-3
- Update swagger-ui to 5.18.2 

## [v5.17.14-1] - 2024-10-18
- dismiss special fork from swagger-ui (#31)
- Update swagger-ui to 5.17.14 (#31)

### Changed
- Update base image to alpine 3.20.3 (#31)

## [v4.9.0-5] - 2024-09-18
### Changed
- Relicense to AGPL-3.0-only (#29)

## [v4.9.0-4] - 2024-08-07
### Changed
- Update base image to version 3.20.2-1 (#27)

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
