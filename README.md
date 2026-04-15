# Terraform Azure Lab

Projeto de laboratório para provisionamento de infraestrutura na Microsoft Azure utilizando Terraform (IaC).

## Recursos criados

- Resource Group
- Virtual Network com Subnet
- Network Interface
- VM Windows Server 2019

## Tecnologias

- Terraform v1.14.8
- Azure Provider v3.117.1
- Azure CLI 2.85.0

## Como usar

```bash
terraform init
terraform plan
terraform apply
terraform destroy
```

## Aprendizados

- Infraestrutura como Código (IaC)
- Provisionamento automatizado na Azure
- Gerenciamento de state do Terraform
- Troubleshooting de SKU e disponibilidade por região