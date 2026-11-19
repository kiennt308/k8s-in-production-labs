# Chapter 7 Lab: Policy-as-Code & Supply-Chain Security

This directory contains runnable manifests for native Kubernetes CEL
`ValidatingAdmissionPolicy`, Sigstore Cosign v3.1.4 bundle verification,
and Kyverno v1.20 `ImageValidatingPolicy` (`policies.kyverno.io/v1`).

## Files

- `01-cel-vap-orderflow-guardrails.yaml` — Native CEL
  `ValidatingAdmissionPolicy` blocking `:latest` or untagged images,
  requiring `app.kubernetes.io/part-of`, checking
  `readOnlyRootFilesystem`, and enforcing allowed registry prefixes.
- `02-cel-vap-binding.yaml` — `ConfigMap` policy parameters plus
  `ValidatingAdmissionPolicyBinding` (`Deny` on `orderflow-prod`,
  `Warn` + `Audit` on `orderflow-staging`).
- `03-rejected-latest-pod.yaml` — Non-compliant Pod used to prove
  native API server CEL rejection.
- `04-kyverno-image-validating-policy.yaml` — Kyverno v1.20
  `ImageValidatingPolicy` enforcing Cosign key-based signature and
  immutable digest verification (`verifyImageSignatures`).
- `05-kyverno-keyless-and-trustedroot.yaml` — Kyverno v1.20
  `ImageValidatingPolicy` for keyless OIDC + Fulcio + Rekor and
  offline `trustedRoot` verification.
- `06-trivy-slsa-attestation-ivp.yaml` — Kyverno v1.20
  `ImageValidatingPolicy` enforcing SLSA provenance / Trivy scan
  attestations (`verifyAttestationSignatures` + `extractPayload`).
- `07-legacy-clusterpolicy-migration-ref.yaml` — Pre-v1.20
  `ClusterPolicy` `verifyImages` reference for migration context only
  (do NOT enforce on Kyverno v1.20 clusters).
- `08-unsigned-test-pod.yaml` — Test Pod referencing an unsigned
  internal image to prove `ImageValidatingPolicy` rejection.

## Quick Run (Native CEL Guardrails)

```bash
kubectl apply -f 01-cel-vap-orderflow-guardrails.yaml
kubectl apply -f 02-cel-vap-binding.yaml
kubectl apply -f 03-rejected-latest-pod.yaml || true
```

## Quick Run (Cosign v3.1.4 + Kyverno v1.20)

```bash
cosign generate-key-pair
cosign verify-blob --help | head -n 5
kubectl apply -f 04-kyverno-image-validating-policy.yaml
```
