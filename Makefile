MAKEFILES_VERSION=10.1.1

.DEFAULT_GOAL:=help

include build/make/variables.mk
include build/make/self-update.mk
include build/make/clean.mk
include build/make/release.mk
include build/make/prerelease.mk
include build/make/k8s-dogu.mk
