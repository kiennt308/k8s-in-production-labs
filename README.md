# Kubernetes in Production — Companion Code Labs (`OrderFlow`)

Welcome to the official companion repository for *Kubernetes in Production: A Practical Guide to Modern Architecture, Security, Networking, and Day-2 Operations* (*Practical Engineering Series, Volume 01*) by **Kien Nguyen**.

Every manifest, Helm/Kustomize configuration, policy rule, and troubleshooting drill in this directory powers the running **OrderFlow Commerce Platform** case study across Chapters 1 through 12.

---

## Verified Software Baseline (`Nov. 18, 2026`)

| Component | Book Baseline Version | Notes |
|---|---|---|
| **Kubernetes** | `v1.35 – v1.37` (`v1.37` Garhwal) | In-Place Resize GA (`v1.35`), `StorageVersionMigration` GA (`v1.37`) |
| **Cilium** | `v1.20.4` | eBPF `kube-proxy` replacement, `NetworkPolicy`, Hubble |
| **Gateway API** | `v1.6.3` | Standard `Gateway`, `HTTPRoute`, `GRPCRoute`, `TCPRoute` |
| **Helm / Kustomize** | `v4.3.2` / `v5.7+` | Server-Side Apply and `kstatus` readiness |
| **Kyverno / Cosign** | `v1.20.x` / `v3.1.4` | CEL parity and unified `.sigstore.json` bundles |
| **Karpenter / KEDA / OpenCost** | `v1.15.x` / `v2.21.0` / `v1.121.4` | `Balanced` consolidation, Redis queue scaling, FinOps |
| **OpenTelemetry / Prometheus** | `v0.163.0` / `v3.16.0` | Native Histograms and UTF-8 telemetry |
| **Velero** | `v1.18.4` / `v1.19.0` | CSI snapshot block data mover (`velero-block`) |

> **Deprecation Notice:** `kubernetes/ingress-nginx` reached End-of-Life in March 2026 and is not used anywhere in these labs. See Chapter 5 and Appendix B for Gateway API `v1.6` migration steps.

---

## OrderFlow Architecture Map

```text
[ Client / Internet ]
         │  HTTPS (TLS 1.3)
         ▼
┌──────────────────────────────────────────────────────────┐
│  Gateway API (Cilium / Envoy Data Plane, port 443)       │
└────────┬──────────────────────────────┬──────────────────┘
         │ /api/v1/orders               │ / (Edge)
         ▼                              ▼
┌─────────────────────┐      ┌─────────────────────────────┐
│   order-service     │─────▶│       order-gateway         │
│  (podinfo:6.7.1)    │      │  (nginx-unprivileged:1.27)  │
└──┬───────────────┬──┘      └─────────────────────────────┘
   │ TCP:5432      │ TCP:6379
   ▼               ▼
┌──────────┐  ┌──────────┐   ┌─────────────────────────────┐
│PostgreSQL│  │  Redis   │◀──│       payment-worker        │
│(postgres)│  │ (redis)  │   │   (KEDA Queue Consumer)     │
└──────────┘  └──────────┘   └─────────────────────────────┘
```

All production workloads in `orderflow-prod` run as non-root users with `readOnlyRootFilesystem: true`, `allowPrivilegeEscalation: false`, `capabilities.drop: ["ALL"]`, and `RuntimeDefault` seccomp profiles to satisfy Pod Security Admission (`restricted`).

---

## Safety & Prerequisites

1. **Never target an active production `kubectl` context.** Always switch to an isolated local cluster (`kind`, `k3s`, or a dedicated sandbox cluster) before running `kubectl apply`:

```bash
kind create cluster --config kind-orderflow.yaml
kubectl config current-context
```

2. Install `kubectl` (`v1.35+`), `helm` (`v4.3+`), `cilium` CLI, and `velero` CLI locally depending on the chapter lab you are running.
3. Cloud-managed hardware APIs (such as Karpenter `EC2NodeClass` or AWS EBS CSI snapshot drivers) follow cloud-specific provider plugins; core Kubernetes manifests work cleanly on local `kind` or managed clusters alike.

---

## Chapter-by-Chapter Lab Directory Map

| Directory | Chapter Title | Key Hands-On Focus |
|---|---|---|
| **`ch01/`** | *Production Cluster Architecture & Failure Domains* | `OrderFlow` namespaces, zone topology, PriorityClasses, API Priority & Fairness |
| **`ch02/`** | *Engineering Resilient Stateless Workloads* | `order-gateway` & `order-service` probes, `preStop` drains, PDBs, native sidecars |
| **`ch03/`** | *Stateful Workloads, Storage & Configuration Hygiene* | `orderflow-db` & `orderflow-cache` StatefulSets, `StorageClass`, Helm 4 + Kustomize |
| **`ch04/`** | *eBPF Data Planes, Services & Zero-Trust Network Policies* | Default-deny `NetworkPolicy`, explicit DNS egress, Cilium L7 & Hubble verification |
| **`ch05/`** | *North-South & East-West Traffic with Gateway API* | `Gateway`, `ReferenceGrant`, `HTTPRoute`, `GRPCRoute`, canary weights, `ingress2gateway` |
| **`ch06/`** | *Identity, RBAC & Workload Hardening* | PSA `restricted` enforcement, least-privilege RBAC, `readOnlyRootFilesystem` patterns |
| **`ch07/`** | *Policy-as-Code & Supply-Chain Security* | Native CEL `ValidatingAdmissionPolicy`, Kyverno `v1.20`, Cosign `v3.1` verification |
| **`ch08/`** | *Multi-Tenancy, Isolation & Resource Governance* | `ResourceQuota`, `LimitRange`, `PriorityClass` tiers, QoS eviction behavior |
| **`ch09/`** | *Autoscaling & FinOps in Kubernetes v1.35–v1.37* | Live `--subresource resize` GA, HPA v2, KEDA `v2.21` Redis scaling, Karpenter, OpenCost |
| **`ch10/`** | *Production Observability with OpenTelemetry & Prometheus 3* | OTel Operator `v0.163`, Prometheus `v3.16` Native Histograms, audit policy |
| **`ch11/`** | *Zero-Downtime Cluster Upgrades, Backup & Disaster Recovery* | `v1.37` `StorageVersionMigration`, Velero `velero-block` backups, isolated DR restore drill |
| **`ch12/`** | *Production Troubleshooting & Go-Live Readiness* | Live 3-fault `orderflow-staging` incident lab (DNS block, `OOMKilled`, `Pending` quota) |

---

## License & Attribution

* **Source Code & Manifests:** Licensed under the **Apache License, Version 2.0**.
* **Book Prose & Architectural Diagrams:** Copyright © 2026 **Kien Nguyen**. All rights reserved.
* **Companion Repository:** `https://github.com/kiennt308/k8s-in-production-labs`
