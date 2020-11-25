IMAGE=sgtsquiggs/caddy-auth-portal
BUILDER=qemubuilder

.PHONY: build
build:
	sh build.sh "$(IMAGE)" "$(BUILDER)"

.PHONY: push
push:
	sh push.sh "$(IMAGE)" "$(BUILDER)"
