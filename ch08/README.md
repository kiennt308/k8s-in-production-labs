# Chapter 8 Lab: Multi-Tenancy, Isolation & Resource Governance

This directory contains runnable manifests for isolating
`orderflow-prod` and `orderflow-staging` using PriorityClasses,
ResourceQuotas, LimitRanges, QoS tiers, and RuntimeClass sandboxing.

## Files

- `01-priority-classes.yaml` — Defines `orderflow-critical`,
  `orderflow-standard`, and `orderflow-batch` PriorityClasses.
- `02-prod-quota-and-limitrange.yaml` — Enforces namespace
  `ResourceQuota` and `LimitRange` guardrails on `orderflow-prod`.
- `03-staging-quota-and-limitrange.yaml` — Enforces tighter staging
  quotas plus a `PriorityClass`-scoped `orderflow-batch` cap.
- `04-orderflow-prod-qos-deployments.yaml` — Configures `order-service`
  with `Guaranteed` QoS + `orderflow-critical`, and `payment-worker`
  with `Burstable` QoS + `orderflow-standard`.
- `05-noisy-neighbor-quota-test.yaml` — Oversized staging Pod to prove
  immediate `QuotaExceeded` admission rejection.
- `06-oom-cgroup-containment-test.yaml` — Bounded staging Pod proving
  container cgroup OOMKill (`ExitCode: 137`) containment.
- `07-runtimeclass-gvisor.yaml` — Reference `RuntimeClass` (`gvisor`)
  and sandboxed Pod manifest (`requires runsc runtime on node`).

## Quick Run

```bash
kubectl apply -f 01-priority-classes.yaml
kubectl apply -f 02-prod-quota-and-limitrange.yaml
kubectl apply -f 03-staging-quota-and-limitrange.yaml
kubectl apply -f 04-orderflow-prod-qos-deployments.yaml
kubectl apply -f 05-noisy-neighbor-quota-test.yaml || true
kubectl apply -f 06-oom-cgroup-containment-test.yaml
```
