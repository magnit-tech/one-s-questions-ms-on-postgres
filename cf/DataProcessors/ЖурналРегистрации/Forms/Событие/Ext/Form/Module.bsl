﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Дата                        = Параметры.Дата;
	ИмяПользователя             = Параметры.ИмяПользователя;
	ПредставлениеПриложения     = Параметры.ПредставлениеПриложения;
	Компьютер                   = Параметры.Компьютер;
	Событие                     = Параметры.Событие;
	ПредставлениеСобытия        = Параметры.ПредставлениеСобытия;
	Комментарий                 = Параметры.Комментарий;
	ПредставлениеМетаданных     = Параметры.ПредставлениеМетаданных;
	Данные                      = Параметры.Данные;
	ПредставлениеДанных         = Параметры.ПредставлениеДанных;
	Транзакция                  = Параметры.Транзакция;
	СтатусТранзакции            = Параметры.СтатусТранзакции;
	Сеанс                       = Параметры.Сеанс;
	РабочийСервер               = Параметры.РабочийСервер;
	ОсновнойIPПорт              = Параметры.ОсновнойIPПорт;
	ВспомогательныйIPПорт       = Параметры.ВспомогательныйIPПорт;
	
	Если Параметры.Свойство("РазделениеДанныхСеанса") Тогда
		РазделениеДанныхСеанса = Параметры.РазделениеДанныхСеанса;
	КонецЕсли;
	
	Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1 от %2'"), 
		Параметры.Уровень, Дата);
	
	// Для списка метаданных включается кнопка открытия.
	Если ТипЗнч(ПредставлениеМетаданных) = Тип("СписокЗначений") Тогда
		Элементы.ПредставлениеМетаданных.КнопкаОткрытия = Истина;
		Элементы.ПредставлениеМетаданныхДоступа.КнопкаОткрытия = Истина;
		Элементы.ПредставлениеМетаданныхОтказаПраваДоступа.КнопкаОткрытия = Истина;
		Элементы.ПредставлениеМетаданныхОтказаДействияДоступа.КнопкаОткрытия = Истина;
	КонецЕсли;
	
	// Обработка данных специальных событий.
	Элементы.ДанныеДоступа.Видимость = Ложь;
	Элементы.ДанныеОтказаПраваДоступа.Видимость = Ложь;
	Элементы.ДанныеОтказаДействияДоступа.Видимость = Ложь;
	Элементы.ДанныеАутентификации.Видимость = Ложь;
	Элементы.ДанныеПользователяИБ.Видимость = Ложь;
	Элементы.ПростыеДанные.Видимость = Ложь;
	Элементы.ПредставленияДанных.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;
	
	Если Не ЗначениеЗаполнено(Параметры.ХранилищеДанных) Тогда
		ДанныеСобытий = Новый Соответствие;
	Иначе
		ДанныеСобытий = ПолучитьИзВременногоХранилища(Параметры.ХранилищеДанных);
	КонецЕсли;
	
	Если Событие = "_$Access$_.Access" Тогда
		Элементы.ПредставленияДанных.ТекущаяСтраница = Элементы.ДанныеДоступа;
		Элементы.ДанныеДоступа.Видимость = Истина;
		ДанныеСобытия = ДанныеСобытий[Параметры.АдресДанных]; // Структура
		Если ДанныеСобытия <> Неопределено Тогда
			СоздатьТаблицуФормы("ТаблицаДанныхДоступа", "ТаблицаДанных", ДанныеСобытия.Данные);
		КонецЕсли;
		Элементы.Комментарий.РастягиватьПоВертикали = Ложь;
		Элементы.Комментарий.Высота = 1;
		
	ИначеЕсли Событие = "_$Access$_.AccessDenied" Тогда
		ДанныеСобытия = ДанныеСобытий[Параметры.АдресДанных]; // Структура
		
		Если ДанныеСобытия <> Неопределено Тогда
			Если ДанныеСобытия.Свойство("Право") Тогда
				Элементы.ПредставленияДанных.ТекущаяСтраница = Элементы.ДанныеОтказаПраваДоступа;
				Элементы.ДанныеОтказаПраваДоступа.Видимость = Истина;
				ОтказПраваДоступа = ДанныеСобытия.Право;
			Иначе
				Элементы.ПредставленияДанных.ТекущаяСтраница = Элементы.ДанныеОтказаДействияДоступа;
				Элементы.ДанныеОтказаДействияДоступа.Видимость = Истина;
				ОтказДействияДоступа = ДанныеСобытия.Действие;
				ТаблицаДанные = Неопределено;
				Если ДанныеСобытия.Свойство("Данные") Тогда
					ТаблицаДанные = ДанныеСобытия.Данные;
				КонецЕсли;
				СоздатьТаблицуФормы("ТаблицаДанныхОтказаДействияДоступа", "ТаблицаДанных", ТаблицаДанные);
				Элементы.Комментарий.РастягиватьПоВертикали = Ложь;
				Элементы.Комментарий.Высота = 1;
			КонецЕсли;
		КонецЕсли;
		
	ИначеЕсли Событие = "_$Session$_.Authentication"
		  ИЛИ Событие = "_$Session$_.AuthenticationError" Тогда
		ДанныеСобытия = ДанныеСобытий[Параметры.АдресДанных];
		Элементы.ПредставленияДанных.ТекущаяСтраница = Элементы.ДанныеАутентификации;
		Элементы.ДанныеАутентификации.Видимость = Истина;
		Если ДанныеСобытия <> Неопределено Тогда
			ДанныеСобытия.Свойство("Имя",                   АутентификацияИмяПользователя);
			ДанныеСобытия.Свойство("ПользовательОС",        АутентификацияПользовательОС);
			ДанныеСобытия.Свойство("ТекущийПользовательОС", АутентификацияТекущийПользовательОС);
		КонецЕсли;
		
	ИначеЕсли Событие = "_$User$_.Delete"
		  ИЛИ Событие = "_$User$_.New"
		  ИЛИ Событие = "_$User$_.Update" Тогда
		ДанныеСобытия = ДанныеСобытий[Параметры.АдресДанных];
		Элементы.ПредставленияДанных.ТекущаяСтраница = Элементы.ДанныеПользователяИБ;
		Элементы.ДанныеПользователяИБ.Видимость = Истина;
		СвойстваПользователяИБ = Новый ТаблицаЗначений;
		СвойстваПользователяИБ.Колонки.Добавить("Имя");
		СвойстваПользователяИБ.Колонки.Добавить("Значение");
		МассивРолей = Неопределено;
		Если ДанныеСобытия <> Неопределено Тогда
			Для каждого КлючИЗначение Из ДанныеСобытия Цикл
				Если КлючИЗначение.Ключ = "Роли" Тогда
					МассивРолей = КлючИЗначение.Значение;
					Продолжить;
				КонецЕсли;
				НоваяСтрока = СвойстваПользователяИБ.Добавить();
				НоваяСтрока.Имя      = КлючИЗначение.Ключ;
				НоваяСтрока.Значение = КлючИЗначение.Значение;
			КонецЦикла;
		КонецЕсли;
		СвойстваПользователяИБ.Сортировать("Имя Возр");
		СоздатьТаблицуФормы("ТаблицаСвойствПользователяИБ", "ТаблицаДанных", СвойстваПользователяИБ);
		Если МассивРолей <> Неопределено Тогда
			РолиПользователяИБ = Новый ТаблицаЗначений;
			РолиПользователяИБ.Колонки.Добавить("Роль",, НСтр("ru = 'Роль'"));
			Для каждого ТекущаяРоль Из МассивРолей Цикл
				РолиПользователяИБ.Добавить().Роль = ТекущаяРоль;
			КонецЦикла;
			СоздатьТаблицуФормы("ТаблицаРолейПользователяИБ", "Роли", РолиПользователяИБ);
		КонецЕсли;
		Элементы.Комментарий.РастягиватьПоВертикали = Ложь;
		Элементы.Комментарий.Высота = 1;
		
	Иначе
		Элементы.ПредставленияДанных.ТекущаяСтраница = Элементы.ПростыеДанные;
		Элементы.ПростыеДанные.Видимость = Истина;
	КонецЕсли;
	
	Элементы.РазделениеДанныхСеанса.Видимость = Не ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПредставлениеМетаданныхОткрытие(Элемент, СтандартнаяОбработка)
	
	ПоказатьЗначение(, ПредставлениеМетаданных);
	
КонецПроцедуры

&НаКлиенте
Процедура РазделениеДанныхСеансаОткрытие(Элемент, СтандартнаяОбработка)
	
	ПоказатьЗначение(, РазделениеДанныхСеанса);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТаблицаДанныхОтказаДействияДоступа

&НаКлиенте
Процедура ТаблицаДанныхВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ПоказатьЗначение(, Элемент.ТекущиеДанные[Сред(Поле.Имя, СтрДлина(Элемент.Имя)+1)]);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура СоздатьТаблицуФормы(Знач ИмяПоляТаблицыФормы, Знач ИмяРеквизитаДанныеФормыКоллекция, Знач ТаблицаЗначений)
	
	Если ТипЗнч(ТаблицаЗначений) <> Тип("ТаблицаЗначений") Тогда
		ТаблицаЗначений = Новый ТаблицаЗначений;
		ТаблицаЗначений.Колонки.Добавить("Неопределено", , " ");
	КонецЕсли;
	
	// Добавление реквизитов в таблицу формы.
	ДобавляемыеРеквизиты = Новый Массив;
	Для каждого Колонка Из ТаблицаЗначений.Колонки Цикл
		ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы(Колонка.Имя, Колонка.ТипЗначения, ИмяРеквизитаДанныеФормыКоллекция, Колонка.Заголовок));
	КонецЦикла;
	ИзменитьРеквизиты(ДобавляемыеРеквизиты);
	
	// Добавление элементов форму
	Для каждого Колонка Из ТаблицаЗначений.Колонки Цикл
		ЭлементРеквизита = Элементы.Добавить(ИмяПоляТаблицыФормы + Колонка.Имя, Тип("ПолеФормы"), Элементы[ИмяПоляТаблицыФормы]);
		ЭлементРеквизита.ПутьКДанным = ИмяРеквизитаДанныеФормыКоллекция + "." + Колонка.Имя;
	КонецЦикла;
	
	ЗначениеВРеквизитФормы(ТаблицаЗначений, ИмяРеквизитаДанныеФормыКоллекция);
	
КонецПроцедуры

#КонецОбласти
