# Relatos de Papel - Arquitectura AWS de 3 capas con Terraform

Este proyecto crea una arquitectura de 3 capas en alta disponibilidad para **Relatos de Papel** usando Terraform y AWS.

## Arquitectura

Diagrama textual:

```text
Usuario → ALB público → ASG frontend/backend privado → RDS privado Multi-AZ
```

Componentes creados:

- VPC nueva `relatos-papel-vpc` con CIDR `10.0.0.0/16`.
- Dos subredes públicas para el Application Load Balancer en `us-east-1a` y `us-east-1b`.
- Dos subredes privadas para aplicación en `us-east-1a` y `us-east-1b`.
- Dos subredes privadas para base de datos en `us-east-1a` y `us-east-1b`.
- Internet Gateway para las subredes públicas.
- NAT Gateway en una subred pública para que las instancias privadas descarguen paquetes y artefactos.
- Tablas de rutas separadas para ALB público, capa de aplicación privada y capa de base de datos privada.
- Security Groups por capa:
  - `relatos-papel-alb-sg`: HTTP 80 desde internet.
  - `relatos-papel-frontend-sg`: HTTP 80 solo desde `relatos-papel-alb-sg`.
  - `relatos-papel-backend-sg`: TCP 8080 desde `relatos-papel-alb-sg` y `relatos-papel-frontend-sg`.
  - `relatos-papel-rds-sg`: PostgreSQL 5432 solo desde `relatos-papel-backend-sg`.
- Application Load Balancer público.
- Target Group frontend en puerto 80 con health check `/health`.
- Target Group backend en puerto 8080 con health check `/health`.
- Listener HTTP 80 con frontend por defecto y regla `/api`/`/api/*` hacia backend.
- Launch Templates con Amazon Linux 2023 para frontend y backend.
- Auto Scaling Groups privados para frontend y backend, distribuidos en dos zonas de disponibilidad.
- RDS PostgreSQL privado, cifrado y Multi-AZ.

Todos los recursos usan tags comunes:

```text
Project     = relatos-papel
Environment = academy
ManagedBy   = terraform
```

## Estructura del proyecto

El root module funciona como orquestador: define provider, variables, tags comunes, outputs y la composición de módulos. Cada módulo interno tiene una responsabilidad principal:

```text
.
├── main.tf                      # Composición de módulos
├── versions.tf                  # Versión de Terraform y providers
├── providers.tf                 # Configuración del provider AWS
├── locals.tf                    # Tags comunes
├── variables.tf                 # Variables públicas del proyecto
├── outputs.tf                   # Outputs públicos del proyecto
└── modules/
    ├── network/                 # VPC, subnets, gateways y rutas
    ├── security/                # Security Groups por capa
    ├── load_balancer/           # ALB, Target Groups, listener y reglas
    ├── compute/                 # AMI, Launch Templates, ASG y user data
    └── database/                # DB subnet group y RDS PostgreSQL
```

## Requisitos

- Terraform `>= 1.6.0`
- Credenciales AWS configuradas localmente
- Permisos para crear VPC, EC2, ALB, Auto Scaling, NAT Gateway, Elastic IP y RDS

## Variables sensibles

La contraseña de RDS no está quemada en el código. La variable `db_password` está marcada como `sensitive` y debe definirse fuera de `main.tf`.

Para crear tu archivo local de variables:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Luego edita `terraform.tfvars` y reemplaza:

```hcl
db_password = "CAMBIA_ESTA_CONTRASENA_SEGURA"
```

No subas `terraform.tfvars` a Git.

## Comandos

Inicializar Terraform:

```bash
terraform init
```

Validar la configuración:

```bash
terraform validate
```

Revisar el plan de cambios:

```bash
terraform plan
```

Crear la infraestructura:

```bash
terraform apply
```

Destruir la infraestructura cuando termines:

```bash
terraform destroy
```

## Pruebas

Al terminar `terraform apply`, revisa los outputs.

Probar frontend:

```bash
http://<alb_dns>
```

Probar backend:

```bash
http://<alb_dns>/api
```

También puedes revisar el health check:

```bash
http://<alb_dns>/health
```

## User Data

### Frontend

`modules/compute/templates/user_data_frontend.sh` instala Nginx, `wget` y `unzip`, descarga el ZIP del frontend desde Google Drive usando `frontend_google_drive_file_id`, busca automáticamente una carpeta `dist`, copia su contenido a `/usr/share/nginx/html`, crea `/usr/share/nginx/html/health` y configura Nginx para servir una React SPA.

Logs:

```bash
/var/log/user-data-frontend.log
```

### Backend

`modules/compute/templates/user_data_backend.sh` instala Python 3, crea una API HTTP simple escuchando en `0.0.0.0:8080` y registra el servicio systemd `relatos-backend.service`.

Endpoints:

- `/health`: responde `{"status":"UP","service":"backend"}`.
- `/api` y rutas `/api/*`: responden un JSON de prueba.

Logs:

```bash
/var/log/user-data-backend.log
```

## Troubleshooting

Si los targets aparecen como `Unhealthy` en el Target Group:

- Revisa que los Security Groups permitan el tráfico correcto entre ALB, frontend, backend y RDS.
- Revisa que el puerto del Target Group coincida con el servicio: frontend `80`, backend `8080`.
- Revisa que el health check `/health` responda HTTP `200`.
- Revisa que el NAT Gateway exista y que las subredes privadas de aplicación tengan ruta `0.0.0.0/0` hacia el NAT Gateway.
- Revisa los logs de User Data:

```bash
sudo tail -n 200 /var/log/user-data-frontend.log
sudo tail -n 200 /var/log/user-data-backend.log
```

También puedes inspeccionar servicios:

```bash
sudo systemctl status nginx
sudo systemctl status relatos-backend.service
```
