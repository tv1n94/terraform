#Любой манифест начинается с описания провайдера
#Колличество пробелов тут не важно
provider "aws" {
    #Access_key и Secret_key можно взять в AWS в настройках пользователя
    #В AWS Secret key показывается только один раз
    access_key = "<ACCESS_KEY>"
    secret_key = "<SECRET_KEY>"
    #Указываем в каком регионе будем создавать наши инстансы
    region = "eu-central-1"
}

#Создаём первый ресурс
#В ресурсе сначала указывается наименование ресурса как у провайдера, потом наше наименование
resource "aws_instance" "my_ubuntu" {
    #Image ID. Можно посмотреть в AWS.
    ami = "ami-0d527b8c289b4af7f"
    #Тип виртуальной машины. С заданными параметрами RAM,HDD,SSD and CPU count. 
    instance_type = "t3.micro"
    
    #Provisioning this VM after my_amazon_linux1 and aws_instance.my_amazon_linux
    depends_on = [aws_instance.my_amazon_linux1, aws_instance.my_amazon_linux]
}

#Добавление ещё одного ресурса
resource "aws_instance" "my_amazon_linux" {
    ami = "ami-05d34d340fb1d89e5"
    instance_type = "t3.micro"
     
    #укажем имя инстанса в AWS
    tags = {
      name = "My Amazon Server"
      Owner = "Alexey"
      Project = "Terraform Lessons"
    }
    
}

#Создание нескольких инстансов одновременно
resource "aws_instance" "my_amazon_linux1" {
    #Указываем количество созданных инстансов
    count = 3
    ami = "ami-05d34d340fb1d89e5"
    instance_type = "t3.small"

    tags = {
      name = "My Amazon Server"
      Owner = "Alexey"
      Project = "Terraform Lessons"
    }

    #Provisioning this VM after my_amazon_linux
    depends_on = [aws_instance.my_amazon_linux]
}


