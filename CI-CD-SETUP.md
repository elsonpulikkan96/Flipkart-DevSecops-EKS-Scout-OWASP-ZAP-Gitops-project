# 🚀 CI/CD Pipeline Documentation

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

## 🎯 ArgoCD GitOps

### Access ArgoCD Dashboard
- **URL**: https://argocd.elsondevops.cloud
- **Username**: admin
- **Password**: tsB2sA7WwV4BH9g1

### Applications
- **flipkart-dev**: Manages dev environment
- **flipkart-staging**: Manages staging environment  
- **flipkart-prod**: Manages production environment

## 🚦 Deployment Process

### Development Deployment
```bash
git checkout dev
git add .
git commit -m "feature: new functionality"
git push origin dev
# → Automatic deployment to dev environment
```

### Staging Deployment  
```bash
git checkout staging
git merge dev
git push origin staging
# → Manual approval required → Deploy to staging
```

### Production Deployment
```bash
git checkout main
git merge staging  
git push origin main
# → Manual approval required → Deploy to production
```

## 🛠️ Troubleshooting

### Common Issues

**ArgoCD Sync Issues**
```bash
kubectl get applications -n argocd
kubectl describe application flipkart-dev -n argocd
```

**Pod Not Starting**
```bash
kubectl logs -n flipkart-dev deployment/dev-flipkart-app-deployment
```

## 🔧 Infrastructure Components

### AWS Resources
- **EKS Cluster**: flipkart-eks-cluster
- **ECR Repository**: 739275449845.dkr.ecr.us-east-1.amazonaws.com/flipkartimg
- **SSL Certificate**: f5be8959-2f51-44b4-a827-6ca97cc45a98

### Pipeline Jobs
1. **code-quality**: ESLint, npm audit
2. **security-scan**: Trivy, Semgrep  
3. **build-push**: Docker build and ECR push
4. **container-security**: Image vulnerability scanning
5. **dast**: Dynamic security testing
6. **deploy-{env}**: Environment-specific deployment

## 📊 Security Reports

Access security reports in GitHub Actions artifacts:
- Trivy filesystem and image scans
- Semgrep code analysis
- OWASP ZAP security testing
- Docker Scout CVE reports

Built with ❤️ using DevSecOps best practices
