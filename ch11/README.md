# Chapter 11 Lab: Zero-Downtime Upgrades, Backup & Disaster Recovery

This directory contains runnable manifests for Chapter 11 of *Kubernetes
in Production* (Practical Engineering Series, Vol. 01) by Kien Nguyen.

## Prerequisites

- Kubernetes `v1.35+` cluster (`v1.37` includes `StorageVersionMigration`
  `storagemigration.k8s.io/v1` GA enabled by default).
- Velero `v1.18.4` or `v1.19.0` installed with CSI support enabled
  (`--features=EnableCSI`) and an S3 or local MinIO `BackupStorageLocation`.
- Existing `orderflow-prod` stack (`orderflow-db` running PostgreSQL 16).

## Execution Order

```bash
kubectl apply -f 00-namespaces.yaml
kubectl apply -f 01-storage-version-migration.yaml
kubectl get storageversionmigrations

kubectl apply -f 02-velero-bsl-vsl.yaml
kubectl apply -f 03-velero-schedule-orderflow.yaml
kubectl apply -f 04-velero-backup-ondemand.yaml
velero backup wait orderflow-prod-pre-v137
```

## Isolated DR Restore Drill & Verification

```bash
kubectl apply -f 05-velero-restore-drill.yaml
velero restore wait orderflow-dr-drill-01
kubectl apply -f 06-verify-db-restore-job.yaml
kubectl wait --for=condition=complete job/verify-orderflow-db-restore \
  -n orderflow-dr-drill --timeout=120s
kubectl logs job/verify-orderflow-db-restore -n orderflow-dr-drill
```

## Cleanup

```bash
kubectl delete -f 06-verify-db-restore-job.yaml
kubectl delete -f 05-velero-restore-drill.yaml
kubectl delete namespace orderflow-dr-drill
```
