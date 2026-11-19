# Chapter 12 Lab: Production Troubleshooting & Go-Live Readiness

This directory contains runnable manifests for the timed three-fault
troubleshooting drill in Chapter 12 of *Kubernetes in Production*
(Practical Engineering Series, Vol. 01) by Kien Nguyen.

## Prerequisites

- Kubernetes `v1.35 – v1.37` cluster with CNI `NetworkPolicy` enforcement
  (Cilium `v1.20.4` recommended).
- Isolated `orderflow-staging` namespace (`enforce: baseline`,
  `warn: restricted`). Never run fault injection against `orderflow-prod`.

## Execution Sequence

1. Deploy the healthy baseline and verify `/api/version`:

```bash
kubectl apply -f 00-staging-baseline.yaml
kubectl wait --for=condition=Ready pod \
  -l app.kubernetes.io/part-of=orderflow \
  -n orderflow-staging --timeout=120s
```

2. Inject all three simultaneous faults:

```bash
kubectl apply -f 01-inject-fault-netpol-dns.yaml
kubectl apply -f 02-inject-fault-oom-probe.yaml
kubectl apply -f 03-inject-fault-pending-quota.yaml
```

3. Diagnose via `kubectl events`, `kubectl describe`, and `kubectl debug`
   (follow Section 12.5 in Chapter 12), then apply the remediated state:

```bash
kubectl apply -f 04-remediated-staging.yaml
kubectl rollout status deployment/order-service \
  -n orderflow-staging --timeout=120s
kubectl rollout status deployment/payment-worker \
  -n orderflow-staging --timeout=120s
```

## Cleanup

```bash
kubectl delete -f 00-staging-baseline.yaml
```
