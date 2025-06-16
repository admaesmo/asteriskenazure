¡Perfecto! Aquí tienes un nuevo README.md completamente adaptado al despliegue que realizamos juntos, con Asterisk 20 sobre una VM Ubuntu en Azure usando PJSIP, Terraform y SSH.

⸻

📄 README.md – Asterisk en Azure con Terraform

# Asterisk en Azure – Laboratorio de Voz IP

Este proyecto implementa un servidor **Asterisk 20** sobre **Ubuntu 20.04 LTS** en **Microsoft Azure**, utilizando **Terraform** para la provisión de infraestructura y **PJSIP** para la configuración de extensiones.

---

## ⚙️ Tecnologías utilizadas

- [Terraform](https://www.terraform.io/) para Infraestructura como Código (IaC)
- [Microsoft Azure](https://azure.microsoft.com/) como plataforma de nube
- [Asterisk 20](https://www.asterisk.org/) para PBX VoIP
- [PJSIP](https://wiki.asterisk.org/wiki/display/AST/PJSIP+Configuration) como canal SIP moderno
- SSH para administración remota
- Linphone / Zoiper como softphones para pruebas de llamadas

---

## 📦 Estructura del proyecto

terraform_azure_asterisk/
├── main.tf               # Define la infraestructura en Azure
├── variables.tf          # Variables de configuración
├── outputs.tf            # IP pública como salida
├── scripts/
│   └── install_asterisk.sh  # Script automatizado para instalar Asterisk y configurar PJSIP
├── README.md             # Esta documentación

---

## 🧱 Requisitos

- Cuenta de Azure con créditos gratuitos
- [Terraform](https://www.terraform.io/downloads) instalado
- [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli) instalado
- Par de claves SSH (`id_rsa`, `id_rsa.pub`) generadas
- `public_key = file("C:/Users/tu_usuario/.ssh/id_rsa.pub")` en `main.tf`

---

## 🚀 Despliegue

### 1. Autenticarse en Azure

```bash
az login

2. Inicializar y aplicar Terraform

terraform init
terraform plan -out=tfplan
terraform apply tfplan

Obtendrás una IP pública, por ejemplo:

Outputs:
vm_public_ip = "52.179.91.129"


⸻

🔧 Acceso y configuración

1. Conexión por SSH

ssh -i ~/.ssh/id_rsa azureuser@52.179.91.129

2. Instalar Asterisk

chmod +x install_asterisk.sh
sudo ./install_asterisk.sh


⸻

📁 Configuración de PJSIP

Los archivos de configuración están en:
	•	/etc/asterisk/pjsip.conf
	•	/etc/asterisk/extensions.conf

Extensiones definidas: 1001, 1002.

⸻

📲 Registro en softphones (Linphone / Zoiper)
	•	Usuario SIP: 1001 o 1002
	•	Contraseña: clave1001 / clave1002
	•	Dominio / servidor: 52.179.91.129
	•	Puerto: 5060
	•	Transporte: UDP

⸻

🧪 Pruebas de llamada
	•	Desde 1001 marca 1002
	•	Desde 1002 marca 1001
	•	Verifica en Asterisk con:

sudo asterisk -rvvv
pjsip show endpoints


⸻

💸 Detener servicios para evitar facturación

Para detener la VM (sin destruirla):

az vm deallocate --resource-group asterisk-rg --name asterisk-vm

Para destruir toda la infraestructura:

terraform destroy


⸻

✨ Créditos

Proyecto realizado como laboratorio de Voz IP - Universidad de Antioquia
Autores: Adrian Espinosa, Dina Reales, Carlos Orrego

---

¿Te gustaría que te entregue este `README.md` como archivo descargable listo para subirlo a tu repositorio?