﻿

// Получает результат запроса с необходимыми полями из произвольной таблицы БД
//
// Параметры:
//  Таблица - Строка - Имя таблицы для запроса
//  Первые - Число - Задает ограничение на выборку первых записей. Если 0, то ограничения не будет
//				Значение по умолчанию: 0 
//  Разрешенные - Булево - Устанавливает или отменяет выборку разрешенных записей
//				Значение по умолчанию: Ложь 
//  Различные - Булево - Устанавливает или отменяет выборку различных записей	 записей
//				Значение по умолчанию: Ложь 
//  Реквизиты - Строка - имена реквизитов, перечисленные через запятую, в формате
//              требований к свойствам структуры. Можно передать 1 или "*".
//              Например, "Код, Наименование, Родитель". 
//            - Структура, ФиксированнаяСтруктура - в качестве ключа передается
//              псевдоним поля для возвращаемой структуры с результатом, а в качестве
//              значения (опционально) фактическое имя поля в таблице.
//              Если значение не определено, то имя поля берется из ключа.
//            - Массив, ФиксированныйМассив - имена реквизитов в формате требований
//              к свойствам структуры.
//				Значение по умолчанию: "Ссылка" 
//  Отборы 	  - Строка, Строка отборов, например, "Ссылка = &Ссылка"
//  	 	  - Структура, ФиксированнаяСтруктура - в качестве ключа передается
//              значение отбора без символа "&", а в качестве значения фактическое имя поля в таблице.
//				В этот случае в отбор устанавливается на равенство 
//              Например, Новый Структура("Ссылка", "Ссылка"), что значит "Ссылка = &Ссылка".
//				Необязательно
//  Параметры  - Структура, ФиксированнаяСтруктура - для задания параметров запроса. В качестве ключа передается
//				имя реквизита, а в качестве значения - его значение
//              Например, Новый Структура("Ссылка", Ссылка).
//  Сортировка - Строка - представление сортировки без слова "УПОРЯДОЧИТЬ", 
//              Например, "Код Возр, Наименование Убыв".
//			   - Структура - Задает сортировку запроса, где ключ - поле, а значение - строка "Возр" и "Убыв". 
//				Если значение не задано, то считается, что это "Возр".
//              Например, Новый Структура("Код, Наименование",,  "Убыв").
//				Необязательно
//  Итоги - Строка - итоги запроса 
//              Например, "ИТОГИ СУММА(Количество) ПО ОБЩИЕ".
//	Автоупорядочивание - автоупорядочивание выборки.
//				Значение по умолчанию: Ложь. 
//  Отборы 	  - Строка, Строка Соединения с основной таблицей, например 
//					ЛЕВОЕ СОЕДИНЕНИЕ
//						Документ.ЗаказКлиента КАК ЗаказКлиента
//					ПО
//						Таблица.ДокументОснование = ЗаказКлиента.Ссылка
//
// Возвращаемое значение:
//  РезультатЗапроса.
Функция ПолучитьРезультатЗапросаПоТаблице(	Таблица, 
											Первые = 0,
											Разрешенные = Ложь,
											Различные = Ложь,
											Знач Реквизиты = "Ссылка", 
											Знач Отборы = "", 
											Знач Параметры = Неопределено, 
											Знач Сортировка = "", 
											Знач Итоги = "", 
											Автоупорядочивание = Ложь,
											Знач Соединения = "") Экспорт
	
	Если Реквизиты = "1" Или Реквизиты = 1 Тогда
		ТекстПолей = "1 КАК Поле";
	ИначеЕсли Реквизиты = "*" Тогда
		ТекстПолей = "*";
	Иначе	
		Если ТипЗнч(Реквизиты) = Тип("Строка") Тогда
			Реквизиты = СтрРазделить(Реквизиты, ",", Ложь);
		КонецЕсли;
		
		СтруктураРеквизитов = Новый Структура;
		Если ТипЗнч(Реквизиты) = Тип("Структура") Или ТипЗнч(Реквизиты) = Тип("ФиксированнаяСтруктура") Тогда
			СтруктураРеквизитов = Реквизиты;
		ИначеЕсли ТипЗнч(Реквизиты) = Тип("Массив") Или ТипЗнч(Реквизиты) = Тип("ФиксированныйМассив") Тогда
			Для Каждого Реквизит Из Реквизиты Цикл
				СтруктураРеквизитов.Вставить(СтрЗаменить(Реквизит, ".", ""), Реквизит);
			КонецЦикла;
		Иначе
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Неверный тип второго параметра Реквизиты: %3'"), Строка(ТипЗнч(Реквизиты)));
		КонецЕсли;
		
		ТекстПолей = "";
		Для Каждого КлючИЗначение Из СтруктураРеквизитов Цикл
			ИмяПоля   = ?(ЗначениеЗаполнено(КлючИЗначение.Значение),
			              СокрЛП(КлючИЗначение.Значение),
			              СокрЛП(КлючИЗначение.Ключ));
			
			Псевдоним = СокрЛП(КлючИЗначение.Ключ);
			
			ТекстПолей  = ТекстПолей + ?(ПустаяСтрока(ТекстПолей), "", ",") + "
			|	" + ИмяПоля + " КАК " + Псевдоним;
		КонецЦикла;
	КонецЕсли;
	
	ТекстОтбора = "";
	Если ТипЗнч(Отборы) = Тип("Строка") Тогда
		ТекстОтбора = Отборы;
	Иначе
		Для каждого КлючИЗначение Из Отборы Цикл
			ТекстОтбора = КлючИЗначение.Ключ + " = &" + ?(ЗначениеЗаполнено(КлючИЗначение.Значение), КлючИЗначение.Значение, КлючИЗначение.Ключ)  + " И ";
		КонецЦикла;
		ТекстОтбора = Лев(ТекстОтбора, СтрДлина(ТекстОтбора) - 3);
	КонецЕсли;
	Если Не ПустаяСтрока(ТекстОтбора) Тогда
		ТекстОтбора	= "ГДЕ " + Символы.ПС + ТекстОтбора
	КонецЕсли;
	
	ТекстСортировки = "";
	Если ТипЗнч(Сортировка) = Тип("Строка") Тогда
		ТекстСортировки = Сортировка;
	Иначе
		Для каждого КлючИЗначение Из Отборы Цикл
			ТекстСортировки = КлючИЗначение.Ключ + ?(ЗначениеЗаполнено(КлючИЗначение.Значение), " " + КлючИЗначение.Значение, "") + ", ";
		КонецЦикла;
		ТекстСортировки = Лев(ТекстСортировки, СтрДлина(ТекстСортировки) - 2);
	КонецЕсли;
	Если Не ПустаяСтрока(ТекстСортировки) Тогда
		ТекстСортировки	= "УПОРЯДОЧИТЬ ПО " + Символы.ПС + ТекстСортировки;
	КонецЕсли;
	
	ТекстАвтоупорядочивания = ?(Автоупорядочивание, "АВТОУПОРЯДОЧИВАНИЕ", "");
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ " + ?(Первые = 0, "", "ПЕРВЫЕ " + Формат(Первые, "ЧЦ=10; ЧГ=0")) + ?(Разрешенные, " РАЗРЕШЕННЫЕ ", "") + ?(Различные, " РАЗЛИЧНЫЕ ", "") + "
	|	" + ТекстПолей + "
	|ИЗ
	|	" + Таблица + " КАК Таблица
	|" + Соединения + "
	|" + ТекстОтбора + "
	|" + ТекстСортировки + "
	|" + Итоги + "
	|" + ТекстАвтоупорядочивания + "
	|";
	
	Если Не Параметры = Неопределено Тогда
		Для каждого КлючИЗначение Из Параметры Цикл
			Запрос.УстановитьПараметр(КлючИЗначение.Ключ, КлючИЗначение.Значение);
		КонецЦикла;
	КонецЕсли;
	Возврат Запрос.Выполнить();
	
КонецФункции
