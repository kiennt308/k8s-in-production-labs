# Chapter 5 Lab: Gateway API v1.6 & Ingress Migration

This directory contains runnable manifests for Chapter 5 of
*Kubernetes in Production* by Kien Nguyen.

## Contents

- `gatewayclass-cilium.yaml` — `GatewayClass` bound to Cilium's
  `io.cilium/gateway-controller`.
- `gateway-orderflow.yaml` — Platform-owned `Gateway` in
  `platform-gateway` with HTTP/HTTPS listeners and cert-manager TLS.
- `referencegrant-orderflow.yaml` — Cross-namespace `ReferenceGrant`
  allowing platform routes to target `orderflow-prod` Services.
- `httproute-orderflow.yaml` — Production `HTTPRoute` (`orderflow-routes`)
  and HTTP-to-HTTPS `RequestRedirect` route.
- `httproute-canary.yaml` — Weighted `90/10` canary split and
  `X-Canary: always` header matching without annotations.
- `tcproute-v1-example.yaml` — Standard `TCPRoute` (`v1` in Gateway
  API v1.6) example for non-HTTP TCP routing.
- `legacy-ingress.yaml` — Legacy `ingress-nginx` manifest for testing
  `ingress2gateway` translation.

## Quick Verification

```bash
kubectl apply -f gatewayclass-cilium.yaml
kubectl apply -f gateway-orderflow.yaml
kubectl apply -f referencegrant-orderflow.yaml
kubectl apply -f httproute-orderflow.yaml
kubectl -n platform-gateway get gateway orderflow-public-gw
kubectl -n orderflow-prod get httproute,referencegrant
ingress2gateway print --providers=ingress-nginx \
  --input-file legacy-ingress.yaml
```
