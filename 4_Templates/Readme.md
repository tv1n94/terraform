**Templates**

*Динамический файл — файл, который генерируется автоматически на основе переменных, которые мы в него отправили*

Проверка template перед применением:

`terraform console`

Вывод файла без изменений: `file(“user_data.sh.tpl”)`

Вывод файла с изменениями: `templatefile("user_data.sh.tpl", {f_name = "Alexey", names = [""Vasya", "John", "Kate", "Sasha""] })`