# Chapter 10 Lab: Production Observability with OTel & Prometheus 3

This directory contains runnable manifests and PromQL queries for
Chapter 10 of *Kubernetes in Production* (Practical Engineering Series,
Vol. 01).

## Prerequisites

- Kubernetes `v1.35+` cluster (`v1.37` includes component Native
  Histograms Beta enabled by default).
- `platform-observability` and `orderflow-prod` namespaces created.
- OpenTelemetry Operator `v0.163.0` installed (CRDs
  `opentelemetry.io/v1beta1`) for `03-otel-collector-ta.yaml`.

## Quick Execution Sequence

```bash
kubectl apply -f 00-allow-observability-scrape.yaml
kubectl apply -f 01-prometheus3-config.yaml
kubectl apply -f 02-prometheus3-deploy.yaml
kubectl apply -f 03-otel-collector-ta.yaml
kubectl apply -f 04-order-service-otel.yaml
```

## Live Verification

Port-forward Prometheus 3 and generate traffic against `order-service`:

```bash
kubectl -n platform-observability port-forward \
  svc/prom 9090:9090

kubectl -n orderflow-prod port-forward \
  svc/order-service 9898:9898
```

Run queries from `05-promql-lab-queries.promql` in the Prometheus UI or
via `/api/v1/query`. Apply `06-apiserver-audit-policy.yaml` on control
plane nodes using `--audit-policy-file`.
