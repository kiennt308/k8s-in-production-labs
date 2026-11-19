# Chapter 4 Lab: eBPF Data Planes & Zero-Trust Network Policies

This directory contains runnable manifests for Chapter 4 of
*Kubernetes in Production* by Kien Nguyen.

## Contents

- `00-default-deny-all.yaml` — Namespace-wide Ingress + Egress deny
  baseline for `orderflow-prod`.
- `01-allow-dns-egress.yaml` — Explicit UDP/TCP port 53 egress to
  CoreDNS pods in `kube-system`.
- `02-allow-order-gateway.yaml` — Ingress to `order-gateway:8080` and
  egress to `order-service:9898`.
- `03-allow-order-service.yaml` — Ingress from `order-gateway` to
  `9898` and egress to `orderflow-db:5432` and `orderflow-cache:6379`.
- `04-allow-payment-worker.yaml` — Egress from `payment-worker` to
  `orderflow-db:5432` and `orderflow-cache:6379`.
- `05-allow-data-stores.yaml` — Strict database and cache ingress
  restricted to `order-service` and `payment-worker`.
- `06-cilium-l7-order-service.yaml` — `CiliumNetworkPolicy` enforcing
  L7 HTTP method and path allowlists on `order-service:9898`.
- `07-ndots-tuned-pod-patch.yaml` — Pod `dnsConfig` patch lowering
  `ndots` from `5` to `2`.

## Quick Verification

```bash
kubectl apply -f 00-default-deny-all.yaml
kubectl apply -f 01-allow-dns-egress.yaml
kubectl apply -f 02-allow-order-gateway.yaml
kubectl apply -f 03-allow-order-service.yaml
kubectl apply -f 04-allow-payment-worker.yaml
kubectl apply -f 05-allow-data-stores.yaml
kubectl -n orderflow-prod get networkpolicy
```
