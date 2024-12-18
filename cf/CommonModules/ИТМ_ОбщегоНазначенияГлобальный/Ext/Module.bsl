﻿
Функция ОтладитьНаСервере(ДанныеОтладки) Экспорт

	Если ТипЗнч(ДанныеОтладки) = Тип("Запрос") Тогда

		лСтруктура = Новый Структура("Параметры,Текст");
		ЗаполнитьЗначенияСвойств(лСтруктура, ДанныеОтладки);

		ТекстМВТ = "";

		Если ДанныеОтладки.МенеджерВременныхТаблиц <> Неопределено Тогда
			МВТ = ДанныеОтладки.МенеджерВременныхТаблиц;
			Для Каждого ТаблицаМВТ Из МВТ.Таблицы Цикл 
				ДанныеМВТ = ТаблицаМВТ.ПолучитьДанные().Выгрузить();
				лСтруктура.Параметры.Вставить("МВТ_" + ТаблицаМВТ.ПолноеИмя, ДанныеМВТ);
				
				Поля = "";
				Для Каждого Колонка Из ДанныеМВТ.Колонки Цикл
					
					ТипыКолонки = Колонка.ТипЗначения.Типы();
					// Удалим Тип NULL
					ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ТипыКолонки, Тип("Null"));
					// Если тип 1, то все просто
					Если ТипыКолонки.Количество() = 1 Тогда
						Тип = ТипыКолонки[0];
					// Если типов много, но есть данные в ВТ, но если в первых 100 строках один тип, то назначаем его
					ИначеЕсли ЗначениеЗаполнено(ДанныеМВТ) И ЗначениеЗаполнено(ДанныеМВТ[0][Колонка.Имя]) Тогда
						Тип = ТипЗнч(ДанныеМВТ[0][Колонка.Имя]);
						Для Сч = 1 По Мин(100, ДанныеМВТ.Количество()) Цикл
							Если Тип <> ТипЗнч(ДанныеМВТ[Сч - 1][Колонка.Имя]) Тогда
								Тип = Неопределено;
								Прервать;	
							КонецЕсли;	
						КонецЦикла;
					// Иначе не типизируем
					Иначе
						Тип = Неопределено;
					КонецЕсли;             
					Если Тип = Неопределено Тогда
						Поля = Поля + "ТЗ." + Колонка.Имя + ",";
					Иначе	
						МТ = Метаданные.НайтиПоТипу(Тип);
						Если МТ <> Неопределено Тогда
							Поля = Поля + "ВЫРАЗИТЬ(ТЗ." + Колонка.Имя + " КАК " + МТ.ПолноеИмя() + ") КАК " + Колонка.Имя + ",";
						Иначе
							Поля = Поля + "ТЗ." + Колонка.Имя + ",";
						КонецЕсли;
					КонецЕсли;
					
				КонецЦикла;
				Если Не ПустаяСтрока(Поля) Тогда
					Поля = Лев(Поля, СтрДлина(Поля) - 1);
				Иначе
					Поля = "*";
				КонецЕсли;
				
				ТекстМВТ = ТекстМВТ + "
					|ВЫБРАТЬ " + Поля + " ПОМЕСТИТЬ " + ТаблицаМВТ.ПолноеИмя + " ИЗ &МВТ_" + ТаблицаМВТ.ПолноеИмя + " КАК ТЗ;";
			КонецЦикла;

			Если НЕ ПустаяСтрока(ТекстМВТ) Тогда
			ТекстМВТ = ТекстМВТ + "
			|
			|////////ОСНОВНОЙ ЗАПРОС/////////////
			|";
			КонецЕсли;
		
		КонецЕсли;

		лСтруктура.Текст = ТекстМВТ + лСтруктура.Текст;

	Иначе
		лСтруктура = ДанныеОтладки;
	КонецЕсли;

	Возврат ПоместитьВоВременноеХранилище(лСтруктура, Новый УникальныйИдентификатор);
	                
КонецФункции

Функция Отладить(ДанныеОтладки) Экспорт

	Возврат ОтладитьНаСервере(ДанныеОтладки);
	                
КонецФункции

Процедура ПоказатьСтруктуру(Структура, ТекущийУровень = 0) Экспорт
	
	Для каждого Элемент Из Структура Цикл
		Сообщить(ПолучитьОтступ(ТекущийУровень) + Элемент.Ключ + " - " + ТипЗнч(Элемент.Значение));
		Если ТипЗнч(Элемент.Значение) = Тип("Структура") Тогда
			ПоказатьСтруктуру(Элемент.Значение, ТекущийУровень+1);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура ПоказатьТаблицу(ТаблицаЗначений) Экспорт
	
	Шаблон = "";
	КодЗаполнения = "Сообщить(СтрШаблон(Шаблон";
	Сч = 1;
	Для Каждого Колонка Из ТаблицаЗначений.Колонки Цикл
		
		Шаблон = Шаблон + Колонка.Имя + ": %" + Сч + "; ";
		КодЗаполнения = КодЗаполнения + ", Стр." + Колонка.Имя;
		
		Сч = Сч + 1;
		
	КонецЦикла;
	
	КодЗаполнения = КодЗаполнения + "));";
	
	Для Каждого Стр Из ТаблицаЗначений Цикл
		Выполнить КодЗаполнения;
	КонецЦикла;
		
КонецПроцедуры

Функция ПолучитьОтступ(ТекущийУровень)
	
	Отступ = "";
	Для Сч = 0 По ТекущийУровень Цикл
		Отступ = Отступ + Символы.Таб;
	КонецЦикла;
	
	Возврат Отступ;
	
КонецФункции