# Chapter 6 Lab: Identity, RBAC, PSA Restricted, and Workload Hardening

This directory contains runnable manifests for bringing the `OrderFlow`
platform to 100% Pod Security Admission (PSA) `restricted` compliance,
least-privilege ServiceAccounts and RBAC, and read-only root filesystems.

## Files

- `01-namespaces.yaml` — Creates `orderflow-prod` (`enforce: restricted`,
  `audit: restricted`, `warn: restricted`) and `orderflow-staging`
  (`enforce: baseline`, `warn: restricted`).
- `02-rejected-root-pod.yaml` — Non-compliant root Pod used to verify API
  server PSA `restricted` rejection.
- `03-rbac-and-serviceaccounts.yaml` — Dedicated ServiceAccounts with
  `automountServiceAccountToken: false` and namespace-scoped RBAC.
- `04-orderflow-hardened-workloads.yaml` — Full hardened `OrderFlow`
  stack (`order-gateway`, `order-service`, `payment-worker`,
  `orderflow-db`, `orderflow-cache`).
- `05-etcd-encryption-config.yaml` — Reference control-plane
  `EncryptionConfiguration` (do NOT apply with `kubectl apply`).

## Quick Run

```bash
kubectl apply -f 01-namespaces.yaml
kubectl apply -f 02-rejected-root-pod.yaml || true
kubectl apply -f 03-rbac-and-serviceaccounts.yaml
kubectl apply -f 04-orderflow-hardened-workloads.yaml
```

## Verification

```bash
kubectl get pods -n orderflow-prod -o wide
kubectl auth can-i --list \
  --as=system:serviceaccount:orderflow-prod:order-service-sa \
  -n orderflow-prod
```
