# Crea un cluster Kubernetes con Azure Kubernetes Service (AKS) usando Terraform

Basado en el repositorio de AymenSegn `https://github.com/AymenSegni/azure-aks-k8s-tf`
En este artículo hay detalles de como levantar el cluster `http://aymen-segni.com/index.php/2019/12/24/create-a-kubernetes-cluster-with-azure-aks-using-terraform/`
Ajustado por Hugo Aquino para seguir haciendo pruebas

-----

## Configuraciones previas en Azure

* Crea un `storage account` en el portal Azure. Copia el valor de `Storage account name` y `key1`
* Nuevamente desde el portal de Azure crea dentro de `Azure Active Directory` -> `App registrations` una application y guarda el valor de `Application (client) ID`. Una vez creado ve a `Certificates & secrets`, crea un Secreto y almacena el valor `Value`
* Desde la línea de comando ejecuta el siguiente comando:
`az storage container create -n tfstate --account-name <valor_storage_account_name> --account-key <valor_key1`

-----

## Desde la línea de comando donde se encuentra el repositorio

* Clona el repositorio con `git clone https://github.com/HugoAquinoNavarrete/azure-aks-k8s-tf`
* Dentro del directorio `azure-aks-k8s-tf` ve al directorio `src/deployment` y ejecuta el siguiente comando:
`terraform init -backend-config="storage_account_name=<valor_storage_account_name>" -backend-config="container_name=tfstate" -backend-config="access_key=<valor_key1>" -backend-config="key=codelab.microsoft.tfstate"
`

La siguiente salida se mostrará en pantalla

````
Initializing modules...

Initializing the backend...

Successfully configured the backend "azurerm"! Terraform will automatically
use this backend unless the backend configuration changes.

Initializing provider plugins...
- Finding latest version of hashicorp/random...
- Finding hashicorp/azurerm versions matching "~> 2.4, ~> 2.4"...
- Finding latest version of hashicorp/azuread...
- Installing hashicorp/random v3.0.0...
- Installed hashicorp/random v3.0.0 (signed by HashiCorp)
- Installing hashicorp/azurerm v2.41.0...
- Installed hashicorp/azurerm v2.41.0 (signed by HashiCorp)
- Installing hashicorp/azuread v1.1.1...
- Installed hashicorp/azuread v1.1.1 (signed by HashiCorp)

The following providers do not have any version constraints in configuration,
so the latest version was installed.

To prevent automatic upgrades to new major versions that may contain breaking
changes, we recommend adding version constraints in a required_providers block
in your configuration, with the constraint strings suggested below.

* hashicorp/azuread: version = "~> 1.1.1"
* hashicorp/random: version = "~> 3.0.0"

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
````

* Ejecuta `terraform plan -out out.plan`

A la siguiente consulta:

````
var.client_id
  Enter a value:
````

Copia el valor `Application (client) ID`

y a la siguiente consulta:

````
var.client_secret
  Enter a value:
````

Copia el valor del `Client secret` creado

La siguiente salida aparecerá en pantalla con el detalle de la infraestructura a ser creada:

````
Refreshing Terraform state in-memory prior to plan...
The refreshed state will be used to calculate this plan, but will not be
persisted to local or remote state storage.


------------------------------------------------------------------------

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

.
.
.

Plan: 12 to add, 0 to change, 0 to destroy.

------------------------------------------------------------------------

This plan was saved to: out.plan

To perform exactly these actions, run the following command to apply:
    terraform apply "out.plan"

Releasing state lock. This may take a few moments...
````

* Crea la infraestructura `terraform apply out.plan`. El script se ejecutará y tomará unos minutos. Si la primera vez que ejecutas el script te sale el siguiente error:

````
Error: creating Managed Kubernetes Cluster "Test-AKS-Terraform" (Resource Group "test-aks-terraform"): containerservice.ManagedClustersClient#CreateOrUp
date: Failure sending request: StatusCode=400 -- Original Error: Code="BadRequest" Message="The credentials in ServicePrincipalProfile were invalid. Ple
ase see https://aka.ms/aks-sp-help for more details. (Details: adal: Refresh request failed. Status Code = '401'. Response body: {\"error\":\"invalid_cl
ient\",\"error_description\":\"AADSTS7000215: Invalid client secret is provided.\\r\\nTrace ID: ec56ec61-5247-43ed-95f9-6cb1dabd9600\\r\\nCorrelation ID
: 7b87009b-d42e-4a07-8bc1-a231d83936c1\\r\\nTimestamp: 2021-01-04 19:27:06Z\",\"error_codes\":[7000215],\"timestamp\":\"2021-01-04 19:27:06Z\",\"trace_i
d\":\"ec56ec61-5247-43ed-95f9-6cb1dabd9600\",\"correlation_id\":\"7b87009b-d42e-4a07-8bc1-a231d83936c1\",\"error_uri\":\"https://login.microsoftonline.c
om/error?code=7000215\"})"

  on ../modules/aks-cluster/main.tf line 1, in resource "azurerm_kubernetes_cluster" "cluster":
   1: resource "azurerm_kubernetes_cluster" "cluster" {

````

Entonces destruye la infraestructura creada con `terraform destroy` (el script te pedira el `Application (client) ID` y el `Client secret`), a la pregunta del script indica `yes`:

````
An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  - destroy

Terraform will perform the following actions:
 
.
.
.
Plan: 0 to add, 0 to change, 10 to destroy.

Do you really want to destroy all resources?
  Terraform will destroy all your managed infrastructure, as shown above.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value: 
````

La salida de la eliminación de la infraestructura es algo parecida a esto (algunos IDs cambiarán en cada implementación):

````
module.aks_identities.azuread_service_principal_password.cluster_sp_password: Destroying... [id=f58a4585-8a78-42b4-9f73-2ba0e5b9e435/password/d02e34a7-5
d62-9eef-b720-db68001d630c]
module.log_analytics.azurerm_log_analytics_solution.test: Destroying... [id=/subscriptions/6df71756-7203-4f2b-a759-8b5970c6dde5/resourcegroups/test-aks-
terraform/providers/Microsoft.OperationsManagement/solutions/ContainerInsights(testLogAnalyticsWorkspaceName-5038166887844861011)]
module.aks_network.azurerm_subnet.aks_subnet: Destroying... [id=/subscriptions/6df71756-7203-4f2b-a759-8b5970c6dde5/resourceGroups/test-aks-terraform/pr
oviders/Microsoft.Network/virtualNetworks/test-aks-terraform-vnet/subnets/runitoncloud-subnet]
module.aks_identities.azuread_service_principal_password.cluster_sp_password: Still destroying... [id=f58a4585-8a78-42b4-9f73-2ba0e5b9e435/pa...d/d02e34
a7-5d62-9eef-b720-db68001d630c, 10s elapsed]
module.log_analytics.azurerm_log_analytics_solution.test: Destruction complete after 7s
module.log_analytics.azurerm_log_analytics_workspace.test: Destroying... [id=/subscriptions/6df71756-7203-4f2b-a759-8b5970c6dde5/resourceGroups/test-aks
-terraform/providers/Microsoft.OperationalInsights/workspaces/testLogAnalyticsWorkspaceName-5038166887844861011]
module.aks_network.azurerm_subnet.aks_subnet: Still destroying... [id=/subscriptions/6df71756-7203-4f2b-a759-...aform-vnet/subnets/runitoncloud-subnet,
10s elapsed]
module.log_analytics.azurerm_log_analytics_workspace.test: Destruction complete after 4s
module.log_analytics.random_id.log_analytics_workspace_name_suffix: Destroying... [id=ResqF1Ug1FM]
module.log_analytics.random_id.log_analytics_workspace_name_suffix: Destruction complete after 0s
module.aks_network.azurerm_subnet.aks_subnet: Destruction complete after 10s
module.aks_network.azurerm_virtual_network.aks_vnet: Destroying... [id=/subscriptions/6df71756-7203-4f2b-a759-8b5970c6dde5/resourceGroups/test-aks-terra
form/providers/Microsoft.Network/virtualNetworks/test-aks-terraform-vnet]
module.aks_identities.azuread_service_principal_password.cluster_sp_password: Still destroying... [id=f58a4585-8a78-42b4-9f73-2ba0e5b9e435/pa...d/d02e34
a7-5d62-9eef-b720-db68001d630c, 20s elapsed]
module.aks_network.azurerm_virtual_network.aks_vnet: Still destroying... [id=/subscriptions/6df71756-7203-4f2b-a759-...irtualNetworks/test-aks-terraform
-vnet, 10s elapsed]
module.aks_identities.azuread_service_principal_password.cluster_sp_password: Still destroying... [id=f58a4585-8a78-42b4-9f73-2ba0e5b9e435/pa...d/d02e34
a7-5d62-9eef-b720-db68001d630c, 30s elapsed]
module.aks_network.azurerm_virtual_network.aks_vnet: Destruction complete after 12s
azurerm_resource_group.aks: Destroying... [id=/subscriptions/6df71756-7203-4f2b-a759-8b5970c6dde5/resourceGroups/test-aks-terraform]
module.aks_identities.azuread_service_principal_password.cluster_sp_password: Destruction complete after 39s
module.aks_identities.random_string.cluster_sp_password: Destroying... [id=UCgPDgezh{[hnJgNC]iLiD)iwIyyMh]v]
module.aks_identities.random_string.cluster_sp_password: Destruction complete after 0s
module.aks_identities.azuread_service_principal.cluster_sp: Destroying... [id=f58a4585-8a78-42b4-9f73-2ba0e5b9e435]
module.aks_identities.azuread_service_principal.cluster_sp: Destruction complete after 0s
module.aks_identities.azuread_application.cluster_aks: Destroying... [id=4f6f58c1-4475-4f6b-90b9-24586d734065]
module.aks_identities.azuread_application.cluster_aks: Destruction complete after 1s
azurerm_resource_group.aks: Still destroying... [id=/subscriptions/6df71756-7203-4f2b-a759-...dde5/resourceGroups/test-aks-terraform, 10s elapsed]
azurerm_resource_group.aks: Still destroying... [id=/subscriptions/6df71756-7203-4f2b-a759-...dde5/resourceGroups/test-aks-terraform, 20s elapsed]
azurerm_resource_group.aks: Still destroying... [id=/subscriptions/6df71756-7203-4f2b-a759-...dde5/resourceGroups/test-aks-terraform, 30s elapsed]
azurerm_resource_group.aks: Still destroying... [id=/subscriptions/6df71756-7203-4f2b-a759-...dde5/resourceGroups/test-aks-terraform, 40s elapsed]
azurerm_resource_group.aks: Destruction complete after 47s

Destroy complete! Resources: 10 destroyed.
````

Nuevamente ejecuta `terraform plan -out out.plan` (la salida ya vimos más arriba como es) y `terraform apply out.plan`. La ejecución puede demorar unos minutos, la salida será parecida a:

````
Acquiring state lock. This may take a few moments...
module.log_analytics.random_id.log_analytics_workspace_name_suffix: Creating...
module.log_analytics.random_id.log_analytics_workspace_name_suffix: Creation complete after 0s [id=TcP0dP4f0XE]
module.aks_identities.azuread_application.cluster_aks: Creating...
azurerm_resource_group.aks: Creating...
module.aks_identities.azuread_application.cluster_aks: Still creating... [10s elapsed]
azurerm_resource_group.aks: Creation complete after 2s [id=/subscriptions/6df71756-7203-4f2b-a759-8b5970c6dde5/resourceGroups/test-aks-terraform]
module.log_analytics.azurerm_log_analytics_workspace.test: Creating...
module.aks_network.azurerm_virtual_network.aks_vnet: Creating...
module.aks_identities.azuread_application.cluster_aks: Creation complete after 12s [id=df408fb1-a8c6-4340-b08b-895df1895fcc]
module.aks_identities.azuread_service_principal.cluster_sp: Creating...
module.aks_network.azurerm_virtual_network.aks_vnet: Creation complete after 7s [id=/subscriptions/6df71756-7203-4f2b-a759-8b5970c6dde5/resourceGroups/t
est-aks-terraform/providers/Microsoft.Network/virtualNetworks/test-aks-terraform-vnet]
module.aks_network.azurerm_subnet.aks_subnet: Creating...
module.log_analytics.azurerm_log_analytics_workspace.test: Still creating... [10s elapsed]
module.aks_identities.azuread_service_principal.cluster_sp: Still creating... [10s elapsed]
module.aks_network.azurerm_subnet.aks_subnet: Creation complete after 5s [id=/subscriptions/6df71756-7203-4f2b-a759-8b5970c6dde5/resourceGroups/test-aks
-terraform/providers/Microsoft.Network/virtualNetworks/test-aks-terraform-vnet/subnets/runitoncloud-subnet]
module.aks_identities.azuread_service_principal.cluster_sp: Creation complete after 11s [id=c1fa85e8-a510-45e9-83a4-271f63b2d427]
module.aks_identities.random_string.cluster_sp_password: Creating...
module.aks_identities.random_string.cluster_sp_password: Creation complete after 0s [id=M#gMQHLl3QJxYipRnYfH$_h#AHb}{quw]
module.aks_identities.azuread_service_principal_password.cluster_sp_password: Creating...
module.aks_cluster.azurerm_kubernetes_cluster.cluster: Creating...
module.log_analytics.azurerm_log_analytics_workspace.test: Still creating... [20s elapsed]
module.aks_identities.azuread_service_principal_password.cluster_sp_password: Still creating... [10s elapsed]
module.aks_cluster.azurerm_kubernetes_cluster.cluster: Still creating... [10s elapsed]
module.aks_identities.azuread_service_principal_password.cluster_sp_password: Creation complete after 11s [id=c1fa85e8-a510-45e9-83a4-271f63b2d427/passw
ord/20863aab-dd0a-dcd7-b5db-b6e20972aa90]
module.log_analytics.azurerm_log_analytics_workspace.test: Still creating... [30s elapsed]
module.aks_cluster.azurerm_kubernetes_cluster.cluster: Still creating... [20s elapsed]
module.log_analytics.azurerm_log_analytics_workspace.test: Still creating... [40s elapsed]
module.aks_cluster.azurerm_kubernetes_cluster.cluster: Still creating... [30s elapsed]
module.log_analytics.azurerm_log_analytics_workspace.test: Still creating... [50s elapsed]
module.aks_cluster.azurerm_kubernetes_cluster.cluster: Still creating... [40s elapsed]
module.log_analytics.azurerm_log_analytics_workspace.test: Still creating... [1m0s elapsed]
module.aks_cluster.azurerm_kubernetes_cluster.cluster: Still creating... [50s elapsed]
module.log_analytics.azurerm_log_analytics_workspace.test: Creation complete after 1m6s [id=/subscriptions/6df71756-7203-4f2b-a759-8b5970c6dde5/resource
Groups/test-aks-terraform/providers/Microsoft.OperationalInsights/workspaces/testLogAnalyticsWorkspaceName-5603591144695910769]
module.log_analytics.azurerm_log_analytics_solution.test: Creating...
module.log_analytics.azurerm_log_analytics_solution.test: Creation complete after 4s [id=/subscriptions/6df71756-7203-4f2b-a759-8b5970c6dde5/resourcegro
ups/test-aks-terraform/providers/Microsoft.OperationsManagement/solutions/ContainerInsights(testLogAnalyticsWorkspaceName-5603591144695910769)]
module.aks_cluster.azurerm_kubernetes_cluster.cluster: Still creating... [1m0s elapsed]
module.aks_cluster.azurerm_kubernetes_cluster.cluster: Still creating... [1m10s elapsed]
module.aks_cluster.azurerm_kubernetes_cluster.cluster: Still creating... [1m20s elapsed]
module.aks_cluster.azurerm_kubernetes_cluster.cluster: Still creating... [1m30s elapsed]
module.aks_cluster.azurerm_kubernetes_cluster.cluster: Still creating... [1m40s elapsed]
module.aks_cluster.azurerm_kubernetes_cluster.cluster: Still creating... [1m50s elapsed]
module.aks_cluster.azurerm_kubernetes_cluster.cluster: Still creating... [2m0s elapsed]
module.aks_cluster.azurerm_kubernetes_cluster.cluster: Still creating... [2m10s elapsed]
module.aks_cluster.azurerm_kubernetes_cluster.cluster: Still creating... [2m20s elapsed]
module.aks_cluster.azurerm_kubernetes_cluster.cluster: Still creating... [2m30s elapsed]
module.aks_cluster.azurerm_kubernetes_cluster.cluster: Still creating... [2m40s elapsed]
module.aks_cluster.azurerm_kubernetes_cluster.cluster: Still creating... [2m50s elapsed]
module.aks_cluster.azurerm_kubernetes_cluster.cluster: Still creating... [3m0s elapsed]
module.aks_cluster.azurerm_kubernetes_cluster.cluster: Still creating... [3m10s elapsed]
module.aks_cluster.azurerm_kubernetes_cluster.cluster: Still creating... [3m20s elapsed]
module.aks_cluster.azurerm_kubernetes_cluster.cluster: Still creating... [3m30s elapsed]
module.aks_cluster.azurerm_kubernetes_cluster.cluster: Still creating... [3m40s elapsed]
module.aks_cluster.azurerm_kubernetes_cluster.cluster: Still creating... [3m50s elapsed]
module.aks_cluster.azurerm_kubernetes_cluster.cluster: Still creating... [4m0s elapsed]
module.aks_cluster.azurerm_kubernetes_cluster.cluster: Still creating... [4m10s elapsed]
module.aks_cluster.azurerm_kubernetes_cluster.cluster: Creation complete after 4m12s [id=/subscriptions/6df71756-7203-4f2b-a759-8b5970c6dde5/resourcegro
ups/test-aks-terraform/providers/Microsoft.ContainerService/managedClusters/Test-AKS-Terraform]
module.aks_cluster.azurerm_monitor_diagnostic_setting.aks_cluster: Creating...
module.aks_cluster.azurerm_monitor_diagnostic_setting.aks_cluster: Creation complete after 5s [id=/subscriptions/6df71756-7203-4f2b-a759-8b5970c6dde5/re
sourcegroups/test-aks-terraform/providers/Microsoft.ContainerService/managedClusters/Test-AKS-Terraform|Test-AKS-Terraform-audit]

Apply complete! Resources: 12 added, 0 changed, 0 destroyed.
Releasing state lock. This may take a few moments...
````

-----

* Valida en el portal de Azure que el cluster este creado y ejecuta algunos comando desde la línea de comando para validar que este funcionando correctamente

````
az aks install-cli
az aks get-credentials --resource-group test-aks-terraform --name Test-AKS-Terraform
kubectl get nodes
kubectl get deployments --all-namespaces=true
````

-----

* Para eliminar la infraestructura ejecuta `terraform destroy` (el script te pedira el `Application (client) ID` y el `Client secret`), a la pregunta del script indica `yes`:

````
Acquiring state lock. This may take a few moments...
module.log_analytics.random_id.log_analytics_workspace_name_suffix: Refreshing state... [id=TcP0dP4f0XE]
module.aks_identities.azuread_application.cluster_aks: Refreshing state... [id=df408fb1-a8c6-4340-b08b-895df1895fcc]
module.aks_identities.azuread_service_principal.cluster_sp: Refreshing state... [id=c1fa85e8-a510-45e9-83a4-271f63b2d427]
module.aks_identities.random_string.cluster_sp_password: Refreshing state... [id=M#gMQHLl3QJxYipRnYfH$_h#AHb}{quw]
module.aks_identities.azuread_service_principal_password.cluster_sp_password: Refreshing state... [id=c1fa85e8-a510-45e9-83a4-271f63b2d427/password/2086
3aab-dd0a-dcd7-b5db-b6e20972aa90]
azurerm_resource_group.aks: Refreshing state... [id=/subscriptions/6df71756-7203-4f2b-a759-8b5970c6dde5/resourceGroups/test-aks-terraform]
module.log_analytics.azurerm_log_analytics_workspace.test: Refreshing state... [id=/subscriptions/6df71756-7203-4f2b-a759-8b5970c6dde5/resourceGroups/te
st-aks-terraform/providers/Microsoft.OperationalInsights/workspaces/testLogAnalyticsWorkspaceName-5603591144695910769]
module.aks_network.azurerm_virtual_network.aks_vnet: Refreshing state... [id=/subscriptions/6df71756-7203-4f2b-a759-8b5970c6dde5/resourceGroups/test-aks
-terraform/providers/Microsoft.Network/virtualNetworks/test-aks-terraform-vnet]
module.aks_network.azurerm_subnet.aks_subnet: Refreshing state... [id=/subscriptions/6df71756-7203-4f2b-a759-8b5970c6dde5/resourceGroups/test-aks-terraf
orm/providers/Microsoft.Network/virtualNetworks/test-aks-terraform-vnet/subnets/runitoncloud-subnet]
module.log_analytics.azurerm_log_analytics_solution.test: Refreshing state... [id=/subscriptions/6df71756-7203-4f2b-a759-8b5970c6dde5/resourcegroups/tes
t-aks-terraform/providers/Microsoft.OperationsManagement/solutions/ContainerInsights(testLogAnalyticsWorkspaceName-5603591144695910769)]
module.aks_cluster.azurerm_kubernetes_cluster.cluster: Refreshing state... [id=/subscriptions/6df71756-7203-4f2b-a759-8b5970c6dde5/resourcegroups/test-a
ks-terraform/providers/Microsoft.ContainerService/managedClusters/Test-AKS-Terraform]
module.aks_cluster.azurerm_monitor_diagnostic_setting.aks_cluster: Refreshing state... [id=/subscriptions/6df71756-7203-4f2b-a759-8b5970c6dde5/resourceg
roups/test-aks-terraform/providers/Microsoft.ContainerService/managedClusters/Test-AKS-Terraform|Test-AKS-Terraform-audit]

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  - destroy

Terraform will perform the following actions:
.
.
.
Plan: 0 to add, 0 to change, 12 to destroy.

Do you really want to destroy all resources?
  Terraform will destroy all your managed infrastructure, as shown above.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value:
````

La ejecución demorará unos minutos, la salida será parecida a esta:

````
module.aks_identities.azuread_service_principal_password.cluster_sp_password: Destroying... [id=c1fa85e8-a510-45e9-83a4-271f63b2d427/password/20863aab-d
d0a-dcd7-b5db-b6e20972aa90]
module.aks_identities.azuread_service_principal_password.cluster_sp_password: Destruction complete after 1s
module.aks_cluster.azurerm_monitor_diagnostic_setting.aks_cluster: Destroying... [id=/subscriptions/6df71756-7203-4f2b-a759-8b5970c6dde5/resourcegroups/
test-aks-terraform/providers/Microsoft.ContainerService/managedClusters/Test-AKS-Terraform|Test-AKS-Terraform-audit]
module.log_analytics.azurerm_log_analytics_solution.test: Destroying... [id=/subscriptions/6df71756-7203-4f2b-a759-8b5970c6dde5/resourcegroups/test-aks-
terraform/providers/Microsoft.OperationsManagement/solutions/ContainerInsights(testLogAnalyticsWorkspaceName-5603591144695910769)]
module.log_analytics.azurerm_log_analytics_solution.test: Destruction complete after 2s
module.aks_cluster.azurerm_monitor_diagnostic_setting.aks_cluster: Still destroying... [id=/subscriptions/6df71756-7203-4f2b-a759-...AKS-Terraform|Test-
AKS-Terraform-audit, 10s elapsed]
module.aks_cluster.azurerm_monitor_diagnostic_setting.aks_cluster: Still destroying... [id=/subscriptions/6df71756-7203-4f2b-a759-...AKS-Terraform|Test-AKS-Terraform-audit, 20s elaps
ed]
module.aks_cluster.azurerm_monitor_diagnostic_setting.aks_cluster: Still destroying... [id=/subscriptions/6df71756-7203-4f2b-a759-...AKS-Terraform|Test-AKS-Terraform-audit, 30s elaps
ed]
module.aks_cluster.azurerm_monitor_diagnostic_setting.aks_cluster: Still destroying... [id=/subscriptions/6df71756-7203-4f2b-a759-...AKS-Terraform|Test-AKS-Terraform-audit, 40s elaps
ed]
module.aks_cluster.azurerm_monitor_diagnostic_setting.aks_cluster: Still destroying... [id=/subscriptions/6df71756-7203-4f2b-a759-...AKS-Terraform|Test-AKS-Terraform-audit, 50s elaps
ed]
module.aks_cluster.azurerm_monitor_diagnostic_setting.aks_cluster: Destruction complete after 56s
module.aks_cluster.azurerm_kubernetes_cluster.cluster: Destroying... [id=/subscriptions/6df71756-7203-4f2b-a759-8b5970c6dde5/resourcegroups/test-aks-terraform/providers/Microsoft.Con
tainerService/managedClusters/Test-AKS-Terraform]
module.log_analytics.azurerm_log_analytics_workspace.test: Destroying... [id=/subscriptions/6df71756-7203-4f2b-a759-8b5970c6dde5/resourceGroups/test-aks-terraform/providers/Microsoft
.OperationalInsights/workspaces/testLogAnalyticsWorkspaceName-5603591144695910769]
module.log_analytics.azurerm_log_analytics_workspace.test: Destruction complete after 4s
module.log_analytics.random_id.log_analytics_workspace_name_suffix: Destroying... [id=TcP0dP4f0XE]
module.log_analytics.random_id.log_analytics_workspace_name_suffix: Destruction complete after 0s
module.aks_cluster.azurerm_kubernetes_cluster.cluster: Still destroying... [id=/subscriptions/6df71756-7203-4f2b-a759-...ice/managedClusters/Test-AKS-Terraform, 10s elapsed]
module.aks_cluster.azurerm_kubernetes_cluster.cluster: Still destroying... [id=/subscriptions/6df71756-7203-4f2b-a759-...ice/managedClusters/Test-AKS-Terraform, 20s elapsed]
module.aks_cluster.azurerm_kubernetes_cluster.cluster: Still destroying... [id=/subscriptions/6df71756-7203-4f2b-a759-...ice/managedClusters/Test-AKS-Terraform, 30s elapsed]
module.aks_cluster.azurerm_kubernetes_cluster.cluster: Still destroying... [id=/subscriptions/6df71756-7203-4f2b-a759-...ice/managedClusters/Test-AKS-Terraform, 40s elapsed]
module.aks_cluster.azurerm_kubernetes_cluster.cluster: Still destroying... [id=/subscriptions/6df71756-7203-4f2b-a759-...ice/managedClusters/Test-AKS-Terraform, 50s elapsed]
module.aks_cluster.azurerm_kubernetes_cluster.cluster: Still destroying... [id=/subscriptions/6df71756-7203-4f2b-a759-...ice/managedClusters/Test-AKS-Terraform, 1m0s elapsed]
module.aks_cluster.azurerm_kubernetes_cluster.cluster: Still destroying... [id=/subscriptions/6df71756-7203-4f2b-a759-...ice/managedClusters/Test-AKS-Terraform, 1m10s elapsed]
module.aks_cluster.azurerm_kubernetes_cluster.cluster: Still destroying... [id=/subscriptions/6df71756-7203-4f2b-a759-...ice/managedClusters/Test-AKS-Terraform, 1m20s elapsed]
module.aks_cluster.azurerm_kubernetes_cluster.cluster: Still destroying... [id=/subscriptions/6df71756-7203-4f2b-a759-...ice/managedClusters/Test-AKS-Terraform, 1m30s elapsed]
module.aks_cluster.azurerm_kubernetes_cluster.cluster: Still destroying... [id=/subscriptions/6df71756-7203-4f2b-a759-...ice/managedClusters/Test-AKS-Terraform, 1m40s elapsed]
module.aks_cluster.azurerm_kubernetes_cluster.cluster: Still destroying... [id=/subscriptions/6df71756-7203-4f2b-a759-...ice/managedClusters/Test-AKS-Terraform, 1m50s elapsed]
module.aks_cluster.azurerm_kubernetes_cluster.cluster: Still destroying... [id=/subscriptions/6df71756-7203-4f2b-a759-...ice/managedClusters/Test-AKS-Terraform, 2m0s elapsed]
module.aks_cluster.azurerm_kubernetes_cluster.cluster: Still destroying... [id=/subscriptions/6df71756-7203-4f2b-a759-...ice/managedClusters/Test-AKS-Terraform, 2m10s elapsed]
module.aks_cluster.azurerm_kubernetes_cluster.cluster: Still destroying... [id=/subscriptions/6df71756-7203-4f2b-a759-...ice/managedClusters/Test-AKS-Terraform, 2m20s elapsed]
module.aks_cluster.azurerm_kubernetes_cluster.cluster: Still destroying... [id=/subscriptions/6df71756-7203-4f2b-a759-...ice/managedClusters/Test-AKS-Terraform, 2m30s elapsed]
module.aks_cluster.azurerm_kubernetes_cluster.cluster: Still destroying... [id=/subscriptions/6df71756-7203-4f2b-a759-...ice/managedClusters/Test-AKS-Terraform, 2m40s elapsed]
module.aks_cluster.azurerm_kubernetes_cluster.cluster: Still destroying... [id=/subscriptions/6df71756-7203-4f2b-a759-...ice/managedClusters/Test-AKS-Terraform, 2m50s elapsed]
module.aks_cluster.azurerm_kubernetes_cluster.cluster: Still destroying... [id=/subscriptions/6df71756-7203-4f2b-a759-...ice/managedClusters/Test-AKS-Terraform, 3m0s elapsed]
module.aks_cluster.azurerm_kubernetes_cluster.cluster: Still destroying... [id=/subscriptions/6df71756-7203-4f2b-a759-...ice/managedClusters/Test-AKS-Terraform, 3m10s elapsed]
module.aks_cluster.azurerm_kubernetes_cluster.cluster: Still destroying... [id=/subscriptions/6df71756-7203-4f2b-a759-...ice/managedClusters/Test-AKS-Terraform, 3m20s elapsed]
module.aks_cluster.azurerm_kubernetes_cluster.cluster: Still destroying... [id=/subscriptions/6df71756-7203-4f2b-a759-...ice/managedClusters/Test-AKS-Terraform, 3m30s elapsed]
module.aks_cluster.azurerm_kubernetes_cluster.cluster: Still destroying... [id=/subscriptions/6df71756-7203-4f2b-a759-...ice/managedClusters/Test-AKS-Terraform, 3m40s elapsed]
module.aks_cluster.azurerm_kubernetes_cluster.cluster: Still destroying... [id=/subscriptions/6df71756-7203-4f2b-a759-...ice/managedClusters/Test-AKS-Terraform, 3m50s elapsed]
module.aks_cluster.azurerm_kubernetes_cluster.cluster: Still destroying... [id=/subscriptions/6df71756-7203-4f2b-a759-...ice/managedClusters/Test-AKS-Terraform, 4m0s elapsed]
module.aks_cluster.azurerm_kubernetes_cluster.cluster: Still destroying... [id=/subscriptions/6df71756-7203-4f2b-a759-...ice/managedClusters/Test-AKS-Terraform, 4m10s elapsed]
module.aks_cluster.azurerm_kubernetes_cluster.cluster: Still destroying... [id=/subscriptions/6df71756-7203-4f2b-a759-...ice/managedClusters/Test-AKS-Terraform, 4m20s elapsed]
module.aks_cluster.azurerm_kubernetes_cluster.cluster: Still destroying... [id=/subscriptions/6df71756-7203-4f2b-a759-...ice/managedClusters/Test-AKS-Terraform, 4m30s elapsed]
module.aks_cluster.azurerm_kubernetes_cluster.cluster: Still destroying... [id=/subscriptions/6df71756-7203-4f2b-a759-...ice/managedClusters/Test-AKS-Terraform, 4m40s elapsed]
module.aks_cluster.azurerm_kubernetes_cluster.cluster: Still destroying... [id=/subscriptions/6df71756-7203-4f2b-a759-...ice/managedClusters/Test-AKS-Terraform, 4m50s elapsed]
module.aks_cluster.azurerm_kubernetes_cluster.cluster: Still destroying... [id=/subscriptions/6df71756-7203-4f2b-a759-...ice/managedClusters/Test-AKS-Terraform, 5m0s elapsed]
module.aks_cluster.azurerm_kubernetes_cluster.cluster: Still destroying... [id=/subscriptions/6df71756-7203-4f2b-a759-...ice/managedClusters/Test-AKS-Terraform, 5m10s elapsed]
module.aks_cluster.azurerm_kubernetes_cluster.cluster: Still destroying... [id=/subscriptions/6df71756-7203-4f2b-a759-...ice/managedClusters/Test-AKS-Terraform, 5m20s elapsed]
module.aks_cluster.azurerm_kubernetes_cluster.cluster: Still destroying... [id=/subscriptions/6df71756-7203-4f2b-a759-...ice/managedClusters/Test-AKS-Terraform, 5m30s elapsed]
module.aks_cluster.azurerm_kubernetes_cluster.cluster: Still destroying... [id=/subscriptions/6df71756-7203-4f2b-a759-...ice/managedClusters/Test-AKS-Terraform, 5m40s elapsed]
module.aks_cluster.azurerm_kubernetes_cluster.cluster: Still destroying... [id=/subscriptions/6df71756-7203-4f2b-a759-...ice/managedClusters/Test-AKS-Terraform, 5m50s elapsed]
module.aks_cluster.azurerm_kubernetes_cluster.cluster: Still destroying... [id=/subscriptions/6df71756-7203-4f2b-a759-...ice/managedClusters/Test-AKS-Terraform, 6m0s elapsed]
module.aks_cluster.azurerm_kubernetes_cluster.cluster: Destruction complete after 6m3s
module.aks_identities.random_string.cluster_sp_password: Destroying... [id=M#gMQHLl3QJxYipRnYfH$_h#AHb}{quw]
module.aks_identities.random_string.cluster_sp_password: Destruction complete after 0s
module.aks_identities.azuread_service_principal.cluster_sp: Destroying... [id=c1fa85e8-a510-45e9-83a4-271f63b2d427]
module.aks_network.azurerm_subnet.aks_subnet: Destroying... [id=/subscriptions/6df71756-7203-4f2b-a759-8b5970c6dde5/resourceGroups/test-aks-terraform/providers/Microsoft.Network/virt
ualNetworks/test-aks-terraform-vnet/subnets/runitoncloud-subnet]
module.aks_identities.azuread_service_principal.cluster_sp: Destruction complete after 2s
module.aks_identities.azuread_application.cluster_aks: Destroying... [id=df408fb1-a8c6-4340-b08b-895df1895fcc]
module.aks_identities.azuread_application.cluster_aks: Destruction complete after 1s
module.aks_network.azurerm_subnet.aks_subnet: Still destroying... [id=/subscriptions/6df71756-7203-4f2b-a759-...aform-vnet/subnets/runitoncloud-subnet, 10s elapsed]
module.aks_network.azurerm_subnet.aks_subnet: Destruction complete after 11s
module.aks_network.azurerm_virtual_network.aks_vnet: Destroying... [id=/subscriptions/6df71756-7203-4f2b-a759-8b5970c6dde5/resourceGroups/test-aks-terraform/providers/Microsoft.Netwo
rk/virtualNetworks/test-aks-terraform-vnet]
module.aks_network.azurerm_virtual_network.aks_vnet: Still destroying... [id=/subscriptions/6df71756-7203-4f2b-a759-...irtualNetworks/test-aks-terraform-vnet, 10s elapsed]
module.aks_network.azurerm_virtual_network.aks_vnet: Destruction complete after 11s
azurerm_resource_group.aks: Destroying... [id=/subscriptions/6df71756-7203-4f2b-a759-8b5970c6dde5/resourceGroups/test-aks-terraform]
azurerm_resource_group.aks: Still destroying... [id=/subscriptions/6df71756-7203-4f2b-a759-...dde5/resourceGroups/test-aks-terraform, 10s elapsed]
azurerm_resource_group.aks: Still destroying... [id=/subscriptions/6df71756-7203-4f2b-a759-...dde5/resourceGroups/test-aks-terraform, 20s elapsed]
azurerm_resource_group.aks: Still destroying... [id=/subscriptions/6df71756-7203-4f2b-a759-...dde5/resourceGroups/test-aks-terraform, 30s elapsed]
azurerm_resource_group.aks: Still destroying... [id=/subscriptions/6df71756-7203-4f2b-a759-...dde5/resourceGroups/test-aks-terraform, 40s elapsed]
azurerm_resource_group.aks: Destruction complete after 47s

Destroy complete! Resources: 12 destroyed.
````

Valida en el portal de Azure que el cluster se haya eliminado, lo único que aun tendrás activo el Storage Account.

