# Operators

A collection of custom kubernetes operators. The operators are written in Go and use the Operator SDK. A basic guide on how to create operators can be found [here](https://sdk.operatorframework.io/docs/building-operators/golang/). Note: I only implemented go based operators though ansible and helm are also supported.

## Commands

```bash
mkdir -p homelab-operator
cd homelab-operator

operator-sdk init --domain=server.home --repo github.com/kallepan/operators

# plugins=go/v4 is required for Apple Silicon
operator-sdk create api --group homelab --version v1alpha1 --kind ResourceQuotaConfig --resource --controller --plugins=go/v4 --namespaced=false

# Webhook
operator-sdk create webhook --group homelab --version v1alpha1 --kind ResourceQuotaConfig --defaulting
```

## Implementations

### ResourceQuotaConfig

This operator creates a ResourceQuotaConfig CRD which can be used to set default resource quotas for all namespaces. The operator watches for changes to the ResourceQuotaConfig CRD, namespace and resource quota objects and updates the resource quotas accordingly.
