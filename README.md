# 🚀 Flipkart DevSecOps Multi-Environment CI/CD Pipeline

A complete enterprise-grade DevSecOps pipeline with GitOps, multi-environment deployment, and comprehensive security scanning.

## 🏗️ Architecture Overview

Developer Push → GitHub Actions CI → Amazon ECR → Git Manifests → ArgoCD GitOps → Amazon EKS

## 🌍 Environment Structure

| Environment | Branch | Namespace | URL | Replicas |
|-------------|--------|-----------|-----|----------|
| **Development** | dev | flipkart-dev | https://dev-flipstore.elsondevops.cloud | 1 |
| **Staging** | staging | flipkart-staging | https://stage-flipstore.elsondevops.cloud | 2 |
| **Production** | main | flipkart-prod | https://flipstore.elsondevops.cloud | 3 |

## 🔄 CI/CD Workflow

### Development Flow
Push to dev branch → Auto Build → Auto Deploy to Dev Environment

### Staging Flow  
Push to staging branch → Build → Manual Approval → Deploy to Staging

### Production Flow
Push to main branch → Build → Manual Approval → Deploy to Production

## 🛡️ Security Pipeline

### Static Analysis Security Testing (SAST)
- **Semgrep**: Code vulnerability scanning
- **ESLint**: Code quality and security linting  
- **npm audit**: Dependency vulnerability checking

### Container Security
- **Trivy**: Filesystem and container image scanning
- **Docker Scout**: CVE detection and analysis

### Dynamic Application Security Testing (DAST)
- **OWASP ZAP**: Web application security testing
- **Nuclei**: Vulnerability scanner with templates

## 📁 Repository Structure

```
├── .github/workflows/
│   └── multi-env-devsecops.yaml     # Main CI/CD pipeline
├── environments/
│   ├── dev/                         # Dev environment configs
│   ├── staging/                     # Staging environment configs  
│   └── prod/                        # Production environment configs
├── argocd/applications/             # ArgoCD application definitions
├── k8s-80/                          # Base Kubernetes manifests
├── src/                             # React application source
├── Dockerfile                       # Container build instructions
└── package.json                     # Node.js dependencies
```

## 🚀 Getting Started

### Prerequisites
- AWS Account with EKS cluster: **flipkart-eks-cluster**
- GitHub repository with Actions enabled
- Self-hosted GitHub Actions runner
- ArgoCD installed on EKS cluster

### 1. Clone Repository
```bash
git clone https://github.com/elsonpulikkan96/Flipkart-DevSecops-EKS-Scout-OWASP-ZAP-Gitops-project.git
cd Flipkart-DevSecops-EKS-Scout-OWASP-ZAP-Gitops-project
```

### 2. Environment Setup
```bash
# Namespaces are auto-created by ArgoCD
kubectl apply -f argocd/applications/
```

## 🔧 Pipeline Configuration

### Environment Variables
```yaml
env:
  ECR_REGISTRY: 739275449845.dkr.ecr.us-east-1.amazonaws.com
  ECR_REPOSITORY: flipkartimg
  AWS_REGION: us-east-1
  EKS_CLUSTER: flipkart-eks-cluster
```

### Pipeline Jobs
1. **code-quality**: ESLint, npm audit
2. **security-scan**: Trivy, Semgrep  
3. **build-push**: Docker build and ECR push
4. **container-security**: Image vulnerability scanning
5. **dast**: Dynamic security testing
6. **deploy-{env}**: Environment-specific deployment

## 🎯 ArgoCD GitOps

### Access ArgoCD Dashboard
- **URL**: https://argocd.elsondevops.cloud
- **Username**: admin
- **Password**: tsB2sA7WwV4BH9g1

### Applications
- **flipkart-dev**: Manages dev environment
- **flipkart-staging**: Manages staging environment  
- **flipkart-prod**: Manages production environment

## 🔍 Monitoring & Observability

### Application URLs
- **Development**: https://dev-flipstore.elsondevops.cloud
- **Staging**: https://stage-flipstore.elsondevops.cloud
- **Production**: https://flipstore.elsondevops.cloud

### Health Checks
```bash
# Check pod status
kubectl get pods -n flipkart-dev
kubectl get pods -n flipkart-staging  
kubectl get pods -n flipkart-prod

# Check ArgoCD sync status
kubectl get applications -n argocd
```

## 🚦 Deployment Process

### Development Deployment
```bash
git checkout dev
git add .
git commit -m feature:
