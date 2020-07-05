# Домашнее задание №32
## Условие

базу развернуть на мастере и настроить чтобы реплицировались таблицы  
| bookmaker |  
| competition |  
| market |  
| odds |  
| outcome |  

варианты которые принимаются к сдаче  
- рабочий вагрантафайл  
- скрины или логи SHOW TABLES  
* конфиги  
* пример в логе изменения строки и появления строки на реплике  

Для проверки необходимо скачать из данного репозитория GitHub каталог Lesson_32 и перейти в него.  
Далее необходимо выполнить в терминале  

	vagrant up

Далее подключаемся к ВМ master

    vagrant ssh master
    mysql -u root -p
    пароль: mEd+(C}DTf+qCajO;!w5
    USE bet;
    INSERT INTO bookmaker (id,bookmaker_name) VALUES(1,'1xbet');
    SELECT * FROM bookmaker;

Для проверки репликации проверяем на ВМ slave

    vagrant ssh slave
    mysql -u root -p
    пароль: mEd+(C}DTf+qCajO;!w5
    USE bet;
    SELECT * FROM bookmaker;