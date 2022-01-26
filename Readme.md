**Terraform и AWS**

*Для управлением AWS инстансов требуется созданная учетная запись с правами администратора*
В настройках пользователя AWS нужно скопировать AWS_ACCESS_KEY и AWS_SECRET_ACCESS_KEY

*Для работы с terraform рекомендуется создать отдельную директорию, в которой будут хранится файлы состояния terraform.*


**Применение изменений с помощью terraform:**
- Выполняем инициализацию провайдера: `terraform init`
*Инициализация провайдера выполняется один раз, в следующих изменениях её выполнять не надо*
- Проверяем изменения в инфраструктуре: `terraform plan`
- Если изменения нас устраивают, то вводим команду `terraform apply` 
После ввода данной команды terraform снова покажет нам все изменения, которые будут внесены, для внесения изменений нужно ввести `yes`


Сохранение изменений, без уточнений: `terraform apply --auto-approve`



**Особенности terraform:**
- Вся информация об инфраструктуре будет храниться в файле **terraform.tfstate** 
- Если удалить файл terraform.tfstate, то terraform потеряет информацию о созданных ресурсах. В облаке ресурсы останутся.
- Если поменять параметры в инстансе (например размер ОЗУ), то после команды `terraform apply` AWS:
 1) остановит инстанс, 
 2) изменит параметры, 
 3) снова запустит инстанс
 
- Если в созданном терраформом инстансе внести изменения со стороны AWS и не внести их в терраформ, то при следующем `terraform apply` **изменения будут удалены**



**Удаление ресурсов**

Для удаления ресурсов просто удалите ту часть кода, которая отвечает за ресурс.

Удаление всей инфраструктуры: `terraform destroy`