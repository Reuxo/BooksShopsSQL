create database BookShop;

use BookShop;

create table Authors 
( 
Id int auto_increment not null primary key,
Name varchar(100) not null check (Name <> N''),
Surname varchar(100) not null check(Surname <> N''),
CountryId int not null 
);
select * from Authors;

insert into Authors values 
(1, "Стивен", "Кинг", 1),
(2, "Сергей", "Лукьяненко", 2),
(3, "Кристи", "Агата", 3),
(4, "Джек", "Лондон", 1),
(5, "Энн", "Райс", 1);

create table Books
(
Id int auto_increment not null primary key,
Name varchar(100) not null check (Name <> N''),
Pages int not null check (Pages > 0),
Price int not null check (Price >= 0),
PublishDate date not null check(PublishDate <= sysdate()),
AuthorId int not null,
ThemeId int not null
);
select * from Books;

insert into Books values
(1, "Мгла", 250, 1250, '1980.02.03', 1, 1),
(2, "Оно", 275, 1300, '1986.04.20', 1, 1),
(3, "Ночной Дозор", 320, 1400, '1998.05.12', 2, 2 ),
(4, "Сумеречный Дозор", 315, 1400, '2004.05.22', 2, 2),
(5, "Убийство в Восточном экспрессе", 400, 2000, '1934.03.01', 3, 3),
(6, "Смерть на Ниле", 560, 2500, '1937.10.13', 3, 3),
(7, "Зов предков", 470, 1750, '1903.07.08', 4, 4),
(8, "Путешествие на Снарке", 450, 1850, '1911.06.08', 4, 4),
(9, "Интервью с вампиром", 377, 1550, '1976.05.01', 5, 5),
(10, "Песнь серафимов", 380, 1250, '2009.05.01', 5, 5),
(11, "Дар Волка", 255, 1150, '2012.09.02', 5, 5);


create table Countries
(
Id int auto_increment not null primary key,
Name varchar(50) not null unique check (Name <> N'')
);
select * from Countries;

insert into Countries values
(1, "Америка"),
(2, "Россия"),
(3, "Англия");

create table Sales 
(
Id int auto_increment not null primary key,
Price int not null check (Price >= 0),
Quantity int not null check(Quantity > 0),
SaleDate date not null check(SaleDate <= sysdate()) default (sysdate()),
BookId int not null,
ShopId int not null
);
select * from Sales;

insert into Sales values
(1, 1250, 10, '2021.08.19', 1, 1),
(2, 1300, 17, '2021.08.17', 2, 1),
(3, 1400, 7, '2021.08.15', 3, 2),
(4, 1400, 10, '2021.08.15', 4, 2),
(5, 2000, 18, '2021.08.27', 5, 3),
(6, 2500, 8, '2021.08.13', 6, 3),
(7, 2500, 10, '2021.08.19', 6, 1),
(8, 2500, 7, '2021.08.07', 6, 2),
(9, 1750, 12, '2021.08.01', 7, 2),
(10, 1850, 8, '2021.08.05', 8, 1),
(11, 1550, 22, '2021.08.16', 9, 2),
(12, 1250, 10, '2021.08.12', 10, 3);

create table Shops
(
Id int auto_increment not null primary key,
Name varchar(100) not null check (Name <> N''),
CountryId int not null
);
select * from Shops;

insert into Shops values 
(1, "Книжная история", 1),
(2, "Книжный мир", 2),
(3, "Зал книг", 3);

create table Themes
(
Id int auto_increment not null primary key,
Name varchar(100) not null unique check (Name <> N'')
);
select * from Themes;

insert into Themes values
(1, "Ужасы"),
(2, "Фантастика"),
(3, "Детектив"),
(4, "Приключение"),
(5, "Мистика");

alter table Shops 
add foreign key (CountryId) references Countries(Id);

alter table Sales
add foreign key (ShopId) references Shops(Id);

alter table Sales
add foreign key (BookId) references Books(Id);

alter table Books 
add foreign key (ThemeId) references Themes(Id);

alter table Books 
add foreign key (AuthorId) references Authors(Id);

alter table Authors
add foreign key (CountryId) references Countries(Id);


/* 1. Показать все книги, количество страниц в которых больше 500, но меньше 650. */ 
select Books.name from Books where Pages between 200 and 400;

/* 2. Показать все книги, в которых первая буква названия либо «А», либо «З».*/
select Books.name from Books where Name like 'С%' or Name like 'П%';

/* 3. Показать все книги жанра «Детектив», количество про данных книг более 30 экземпляров. */ 
select Books.name, Quantity, Themes.name from Books 
join Sales on Sales.BookId = Books.Id
join Themes on Themes.Id = Books.ThemeId
where Quantity > 10 and Themes.name = "Детектив";

/* 4. Показать все книги, в названии которых есть слово «Mic ro soft», но нет слова «Windows». */
select Books.name from Books 
where Name like '%Дозор%' and not Name like '%Ночной%';

/* 5. Показать все книги (название, тематика, полное имя автора в одной ячейке), цена одной страницы которых меньше 65 копеек.*/
select concat( Books.name, Themes.name , Authors.name , Authors.surname ) as "Описание" from Books 
join Themes on Themes.Id = Books.ThemeId
join Authors on Authors.Id = Books.AuthorId
where Price < 4 * Books.pages;

/* 6. Показать все книги, название которых состоит из 4 слов. */
select * from Books 
where Name like '% % % %' and not Name like '% % % % %';

/* 7. Показать информацию о продажах в следующем виде:
 ▷ Название книги, но, чтобы оно не содержало букву «А».
 ▷ Тематика, но, чтобы не «Программирование».
 ▷ Автор, но, чтобы не «Герберт Шилдт».
 ▷ Цена, но, чтобы в диапазоне от 10 до 20 гривен.
 ▷ Количество продаж, но не менее 8 книг.
 ▷ Название магазина, который продал книгу, но он не должен быть в Украине или России. */
 
select * from Books 
join Themes on Themes.Id = Books.ThemeId
join Authors on Authors.Id = Books.AuthorId
join Sales on Sales.BookId = Books.Id
join Shops on Shops.Id = Sales.ShopId
join Countries on Countries.Id = Authors.CountryId
where not Books.name like '%М%' 
and not Themes.name = "Детектив" 
and not Authors.name = "Стивен" 
and Books.price between 1700 and 1800
and Quantity >= 8 
and not Countries.name = "Россия" ;

/* 8. Показать следующую информацию в два столбца (числа в правом столбце приведены в качестве примера): 
▷ Количество авторов: 14 
▷ Количество книг: 47 
▷ Средняя цена продажи: 85.43 грн. 
▷ Среднее количество страниц: 650.6. */
SELECT 'Количество авторов:' as "Наименование" ,COUNT(*) as "Количество" FROM Authors
UNION
(SELECT 'Количество книг:',COUNT(*) FROM Books)
UNION
(SELECT 'Средняя цена продажи:', AVG(Sales.Quantity) FROM Sales)
UNION
(SELECT 'Среднее количество страниц:', AVG(Books.Pages) FROM Books);




/* 9. Показать тематики книг и сумму страниц всех книг по каждой из них. */
select Themes.name, sum(pages) from Books 
join Themes on Themes.Id = Books.ThemeId 
group by Themes.name;


/* 10. Показать количество всех книг и сумму страниц этих книг по каждому из авторов. */
select Authors.name, count(Books.id), sum(pages) from Books 
join Authors on Authors.Id = Books.AuthorId
group by Authors.name;

/* 11. Показать книгу тематики «Программирование» с наиболь шим количеством страниц. */
select Books.name , MAX(Pages) from books 
join Themes on Themes.Id = Books.ThemeId 
where Themes.name = "Мистика"  ;

/* 12. Показать среднее количество страниц по каждой тематике, которое не превышает 400. */ 
select themes.name, avg(Pages) from Books 
join Themes on Themes.Id = Books.ThemeId
group by Themes.name
having avg(Pages) <= 400;

/* 13. Показать сумму страниц по каждой тематике, учитывая только книги с количеством страниц более 400,
 и чтобы тематики были «Программирование», «Администриро вание» и «Дизайн». */
 select Themes.name, sum(Pages) from Books 
 join Themes on Themes.Id = Books.ThemeId
 where Books.pages < 400
 group by Themes.name
 having (Themes.name = "Детектив" or Themes.name = "Мистика" or Themes.name = "Фантастика");
 
 /* 14. Показать информацию о работе магазинов: что, где, кем, когда и в каком количестве было продано. */
 select Books.name, Countries.name , Shops.name, Saledate, Sales.Quantity  from Books 
 join Sales on Sales.BookId = Books.Id
join Shops on Shops.Id = Sales.ShopId
join Countries on Countries.Id = Shops.CountryId;
 
 /* 15. Показать самый прибыльный магазин. */
  select Shops.name, SUM(Price * Quantity) as "Прибыль" from Shops 
 join Sales on Sales.ShopId = Shops.Id;
 
