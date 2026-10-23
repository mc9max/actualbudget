# Actual Budget on Railway — one-click deploy wrapper (single service)
#
# Base is the official prebuilt image (actualbudget/actual-server), pinned to
# v26.10.0: the Node sync-server bundles the budget sync API and serves the
# React frontend — the wrapper only adapts it to Railway, never rebuilds it.
#
# Why each non-default setting exists:
#   USER root ................. The stock image has no USER directive (runs as
#                               root); kept explicit so the Railway
#                               root-owned volume at /data is always writable.
#   ENV ACTUAL_DATA_DIR ....... Pins all state (account.sqlite + budget files)
#                               onto the /data volume mount. Upstream only
#                               defaults to /data when the dir exists, so set
#                               it explicitly — it is also the single place to
#                               move state if the mount path ever changes.
#   PORT ...................... Honored natively by upstream: load-config.js
#                               uses `process.env.PORT` with a 5006 fallback
#                               (verified in upstream source). Railway injects
#                               PORT; nothing to remap.
#   HOSTNAME .................. Upstream default `::` already binds every
#                               interface, so the Railway proxy can reach it.
#   No ENTRYPOINT/CMD override — the stock image's own
#                               `/usr/bin/tini -g -- node app.js` is the
#                               correct start (the repo-root `bin/docker-start`
#                               is a dev-only script, absent from the published
#                               image; overriding CMD with it crash-loops).
#   HEALTHCHECK NONE .......... The stock image has no healthcheck; Railway's
#                               external healthcheckPath ("/") in railway.json
#                               is the readiness gate.
#
# Upstream: https://github.com/actualbudget/actual (MIT)
# Base image: actualbudget/actual-server v26.10.0 (amd64)
# Digest: sha256:bdfbb624d5fe9df05481d8eb6791a00a4a78ab8152bce31e79c6f18917e6933e

FROM actualbudget/actual-server@sha256:bdfbb624d5fe9df05481d8eb6791a00a4a78ab8152bce31e79c6f18917e6933e

USER root

HEALTHCHECK NONE

# Baked literal defaults — kept off the one-click deploy form.
ENV ACTUAL_DATA_DIR=/data

EXPOSE 5006

LABEL org.opencontainers.image.source="https://github.com/mc9max/actualbudget"
