FROM alpine:3.21 AS build

RUN set -eux; \
	apk add --no-cache \
		bash \
		gcc \
		linux-headers \
		make \
		musl-dev \
# https://github.com/landley/toybox/issues/493#issuecomment-2050906703 (why the GNU tools *and* why Alpine / musl)
		findutils cpio \
	;

WORKDIR /toybox

ENV TOYBOX_VERSION 0.8.12

RUN set -eux; \
	wget -O toybox.tgz "https://landley.net/toybox/downloads/toybox-$TOYBOX_VERSION.tar.gz"; \
	tar -xf toybox.tgz --strip-components=1; \
	rm toybox.tgz

# pre-build toybox for the build to use 👀
RUN sh -eux scripts/prereq/build.sh

RUN make root

# smoke-test/verify the result
RUN chroot root/host/fs sh -c 'PS4="++ " && set -ux && echo hi from toybox'

FROM scratch
COPY --from=build /toybox/root/host/fs/ /
CMD ["sh"]
