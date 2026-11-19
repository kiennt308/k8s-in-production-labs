# Chapter 9 Lab: Autoscaling & FinOps in Kubernetes v1.35-v1.37

This directory contains runnable manifests for Chapter 9 of
*Kubernetes in Production* (Practical Engineering Series, Vol. 01).

## Prerequisites

- A Kubernetes `v1.35+` cluster (In-Place Pod Vertical Scaling / KEP-1287
  is GA and enabled by default in `v1.35`; pod-level `.spec.resources`
  in-place scaling is Beta in `v1.36+`).
- `orderflow-prod` namespace configured with PSA `restricted` labels
  and `orderflow-cache` Redis StatefulSet running (from Chapters 3 & 6).
- `metrics-server` installed for HPA v2 (`autoscaling/v2`).
- KEDA `v2.21.0` installed for `ScaledObject` exercises.
- Helm `v4.3.x` for OpenCost `v1.121.4` (chart `opencost-2.5.34`).

## Verification Scope & Cloud Boundary

- **Cluster-Runnable:** `01-order-service-resizable.yaml`,
  `02-order-service-hpa.yaml`, and `03-payment-worker-keda.yaml` execute
  live on any Kubernetes `v1.35+` cluster (including `kind` or `k3s`).
- **Cloud-Managed Boundary:** `04-karpenter-nodepool.yaml` uses the
  Karpenter `v1.15` (`karpenter.sh/v1`) schema alongside an AWS
  `EC2NodeClass` reference stub. Validate schema locally with
  `kubeconform` or `kubectl apply --dry-run=client`; live EC2 instance
  provisioning requires an AWS EKS cluster with Karpenter controllers
  (covered deeply in Volume 04).

## Quick Execution Sequence

```bash
kubectl apply -f 01-order-service-resizable.yaml
kubectl apply -f 02-order-service-hpa.yaml
kubectl apply -f 03-payment-worker-keda.yaml
```

Watch live resize status without container restarts:

```bash
POD=$(kubectl -n orderflow-prod get pod \
  -l app.kubernetes.io/name=order-service \
  -o jsonpath='{.items[0].metadata.name}')

kubectl -n orderflow-prod patch pod "${POD}" \
  --subresource resize \
  --patch '{"spec":{"containers":[{"name":"order-service",
  "resources":{"requests":{"cpu":"250m","memory":"192Mi"},
  "limits":{"cpu":"500m","memory":"256Mi"}}}]}}'
```
