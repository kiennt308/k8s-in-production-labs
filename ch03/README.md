# Chapter 3 Lab: Stateful Workloads, Storage & Packaging

This directory contains runnable manifests for Chapter 3 of
*Kubernetes in Production* by Kien Nguyen.

## Contents

- `storageclass.yaml` — Topology-aware `StorageClass` using
  `WaitForFirstConsumer` and `Retain` reclaim policy.
- `orderflow-db.yaml` — PSA-`restricted` PostgreSQL `StatefulSet`
  (`postgres:16-alpine`, UID `70`) with `emptyDir` socket mounts.
- `orderflow-cache.yaml` — PSA-`restricted` Redis `StatefulSet`
  (`redis:7-alpine`, UID `999`, `fsGroup: 1000`).
- `kustomize/` — Kustomize v5.7+ base and `staging`/`prod` overlays
  with `configMapGenerator` hash suffixing.
- `helm-chart/orderflow/` — Helm v4.3+ chart with checksum rollout
  triggers, immutable ConfigMaps, and PSA-`restricted` workloads.

## Quick Verification

```bash
kubectl apply -f storageclass.yaml
kubectl apply -f orderflow-db.yaml
kubectl apply -f orderflow-cache.yaml
kubectl -n orderflow-prod get statefulset,pvc,pod
kubectl kustomize kustomize/overlays/prod
helm lint helm-chart/orderflow
helm template orderflow helm-chart/orderflow \
  -f helm-chart/orderflow/values-prod.yaml
```
