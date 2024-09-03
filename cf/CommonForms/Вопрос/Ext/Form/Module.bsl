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
	
	// Размещение заголовка.
	Если Не ПустаяСтрока(Параметры.Заголовок) Тогда
		Заголовок = Параметры.Заголовок;
		ШиринаЗаголовка = 1.3 * СтрДлина(Заголовок);
		Если ШиринаЗаголовка > 40 И ШиринаЗаголовка < 80 Тогда
			Ширина = ШиринаЗаголовка;
		ИначеЕсли ШиринаЗаголовка >= 80 Тогда
			Ширина = 80;
		КонецЕсли;
	КонецЕсли;
	
	Если Параметры.БлокироватьВесьИнтерфейс Тогда
		РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс;
	КонецЕсли;
	
	// Картинка.
	Если Параметры.Картинка.Вид <> ВидКартинки.Пустая Тогда
		Элементы.Предупреждение.Картинка = Параметры.Картинка;
	Иначе
		// В этом случае можно скрыть картинку.
		// Но для обратной совместимости реализован параметр ПоказыватьКартинку.
		// Например, кто-то из потребителей мог открывать форму напрямую со своими параметрами,
		// в обход API БФ, в частности СтандартныеПодсистемыКлиент.ПоказатьВопросПользователю.
		ПоказыватьКартинку = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(Параметры, "ПоказыватьКартинку", Истина);
		Если Не ПоказыватьКартинку Тогда
			Элементы.Предупреждение.Видимость = Ложь;
		КонецЕсли;
	КонецЕсли;
	
	// Размещение текста.
	Если ТипЗнч(Параметры.ТекстСообщения) = Тип("Строка") Тогда 
		ТекстСообщения = Параметры.ТекстСообщения;
		Элементы.МногострочныйТекстСообщения.Видимость = Истина;
		Элементы.ТекстСообщенияФорматированнаяСтрока.Видимость = Ложь;
	ИначеЕсли ТипЗнч(Параметры.ТекстСообщения) = Тип("ФорматированнаяСтрока") Тогда
		Элементы.ТекстСообщенияФорматированнаяСтрока.Заголовок = Параметры.ТекстСообщения;
		Элементы.МногострочныйТекстСообщения.Видимость = Ложь;
		Элементы.ТекстСообщенияФорматированнаяСтрока.Видимость = Истина;
	ИначеЕсли ТипЗнч(Параметры.ТекстСообщения) = Тип("Неопределено") Тогда
		// Поддерживаем тип Неопределено для обратной совместимости.
		ТекстСообщения = "";
	Иначе
		ОбщегоНазначенияКлиентСервер.ПроверитьПараметр(
			Метаданные.ОбщиеФормы.Вопрос.ПолноеИмя(), 
			"ТекстСообщения", 
			Параметры.ТекстСообщения, 
			Новый ОписаниеТипов("Строка, ФорматированнаяСтрока"));
	КонецЕсли;

	МинимальнаяШиринаПоля = 50;
	ПримернаяВысотаПоля = ЧислоСтрок(Параметры.ТекстСообщения, МинимальнаяШиринаПоля);
	Элементы.МногострочныйТекстСообщения.Ширина = МинимальнаяШиринаПоля;
	Элементы.МногострочныйТекстСообщения.Высота = Мин(ПримернаяВысотаПоля, 10);
	
	// Размещение флажка.
	Если ЗначениеЗаполнено(Параметры.ТекстФлажка) Тогда
		Элементы.БольшеНеЗадаватьЭтотВопрос.Заголовок = Параметры.ТекстФлажка;
	ИначеЕсли НЕ ПравоДоступа("СохранениеДанныхПользователя", Метаданные) ИЛИ НЕ Параметры.ПредлагатьБольшеНеЗадаватьЭтотВопрос Тогда
		Элементы.БольшеНеЗадаватьЭтотВопрос.Видимость = Ложь;
	КонецЕсли;
	
	// Размещение кнопок.
	ДобавитьКомандыИКнопкиНаФорму(Параметры.Кнопки);
	
	// Установка кнопки по умолчанию.
	ВыделятьКнопкуПоУмолчанию = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(Параметры, "ВыделятьКнопкуПоУмолчанию", Истина);
	УстановитьКнопкуПоУмолчанию(Параметры.КнопкаПоУмолчанию, ВыделятьКнопкуПоУмолчанию);
	
	// Установка кнопки для обратного отсчета.
	УстановитьКнопкуОжидания(Параметры.КнопкаТаймаута);
	
	// Установка таймера обратного отсчета.
	ОжиданиеСчетчик = Параметры.Таймаут;
	
	// Сброс размеров и положения окна этой формы.
	СтандартныеПодсистемыСервер.СброситьРазмерыИПоложениеОкна(ЭтотОбъект);
	
	Если ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		Элементы.Переместить(Элементы.БольшеНеЗадаватьЭтотВопрос, ЭтотОбъект);
		ПоложениеКоманднойПанели = ПоложениеКоманднойПанелиФормы.Верх;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	// Запуск обратного отсчета.
	Если ОжиданиеСчетчик >= 1 Тогда
		ОжиданиеСчетчик = ОжиданиеСчетчик + 1;
		ПродолжитьОбратныйОтсчет();
	КонецЕсли;
	
	ТекущийЭлемент = Элементы.Колонки;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

// Параметры:
//  Команда - КомандаФормы
//
&НаКлиенте
Процедура Подключаемый_ОбработчикКоманды(Команда)
	ВыбранноеЗначение = СоответствиеКнопокИВозвращаемыхЗначений.Получить(Команда.Имя);
	
	РезультатВыбора = Новый Структура;
	РезультатВыбора.Вставить("БольшеНеЗадаватьЭтотВопрос", БольшеНеЗадаватьЭтотВопрос);
	РезультатВыбора.Вставить("Значение", КодВозвратаДиалогаПоЗначению(ВыбранноеЗначение));
	
	Закрыть(РезультатВыбора);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Клиент

&НаКлиенте
Процедура ПродолжитьОбратныйОтсчет()
	ОжиданиеСчетчик = ОжиданиеСчетчик - 1;
	Если ОжиданиеСчетчик <= 0 Тогда
		Закрыть(Новый Структура("БольшеНеЗадаватьЭтотВопрос, Значение", Ложь, КодВозвратаДиалога.Таймаут));
	Иначе
		Если ОжиданиеИмяКнопки <> "" Тогда
			НовыйЗаголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = '%1 (осталось %2 сек.)'"),
				ОжиданиеЗаголовокКнопки,
				Строка(ОжиданиеСчетчик));
				
			ЭлементФормы = Элементы[ОжиданиеИмяКнопки]; // ВсеЭлементыФормы
			ЭлементФормы.Заголовок = НовыйЗаголовок;
		КонецЕсли;
		ПодключитьОбработчикОжидания("ПродолжитьОбратныйОтсчет", 1, Истина);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Функция КодВозвратаДиалогаПоЗначению(Значение)
	Если ТипЗнч(Значение) <> Тип("Строка") Тогда
		Возврат Значение;
	КонецЕсли;
	
	Если Значение = "КодВозвратаДиалога.Да" Тогда
		Результат = КодВозвратаДиалога.Да;
	ИначеЕсли Значение = "КодВозвратаДиалога.Нет" Тогда
		Результат = КодВозвратаДиалога.Нет;
	ИначеЕсли Значение = "КодВозвратаДиалога.ОК" Тогда
		Результат = КодВозвратаДиалога.ОК;
	ИначеЕсли Значение = "КодВозвратаДиалога.Отмена" Тогда
		Результат = КодВозвратаДиалога.Отмена;
	ИначеЕсли Значение = "КодВозвратаДиалога.Повторить" Тогда
		Результат = КодВозвратаДиалога.Повторить;
	ИначеЕсли Значение = "КодВозвратаДиалога.Прервать" Тогда
		Результат = КодВозвратаДиалога.Прервать;
	ИначеЕсли Значение = "КодВозвратаДиалога.Пропустить" Тогда
		Результат = КодВозвратаДиалога.Пропустить;
	Иначе
		Результат = Значение;
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Сервер

&НаСервере
Процедура ДобавитьКомандыИКнопкиНаФорму(Кнопки)
	// Добавляет команды и соответствующие им кнопки на форму.
	//
	// Параметры:
	//  Кнопки - Строка / СписокЗначений - набор кнопок
	//		   если строка - строковый идентификатор в формате "РежимДиалогаВопрос.<одно из значений РежимДиалогаВопрос>",
	//		   например "РежимДиалогаВопрос.ДаНет"
	//		   если СписокЗначений - для каждой записи,
	//		   Значение - значение возвращаемое формой при нажатии кнопки.
	//		   Представление - заголовок кнопки.
	
	Если ТипЗнч(Кнопки) = Тип("Строка") Тогда
		КнопкиСписокЗначений = СтандартныйНабор(Кнопки);
	Иначе
		КнопкиСписокЗначений = Кнопки;
	КонецЕсли;
	
	СоответствиеКнопокЗначениям = Новый Соответствие;
	
	Индекс = 0;
	
	Для Каждого ЭлементОписаниеКнопки Из КнопкиСписокЗначений Цикл
		Индекс = Индекс + 1;
		ИмяКоманды = "Команда" + XMLСтрока(Индекс);
		Команда = Команды.Добавить(ИмяКоманды);
		Команда.Действие  = "Подключаемый_ОбработчикКоманды";
		Команда.Заголовок = ЭлементОписаниеКнопки.Представление;
		Команда.ИзменяетСохраняемыеДанные = Ложь;
		
		Кнопка= Элементы.Добавить(ИмяКоманды, Тип("КнопкаФормы"), КоманднаяПанель);
		Кнопка.ПоложениеВКоманднойПанели = ПоложениеКнопкиВКоманднойПанели.ВКоманднойПанели;
		Кнопка.ИмяКоманды = ИмяКоманды;
		
		СоответствиеКнопокЗначениям.Вставить(ИмяКоманды, ЭлементОписаниеКнопки.Значение);
	КонецЦикла;
	
	СоответствиеКнопокИВозвращаемыхЗначений = Новый ФиксированноеСоответствие(СоответствиеКнопокЗначениям);
КонецПроцедуры

&НаСервере
Процедура УстановитьКнопкуПоУмолчанию(КнопкаПоУмолчанию, ВыделятьКнопкуПоУмолчанию)
	Если СоответствиеКнопокИВозвращаемыхЗначений.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Кнопка = Неопределено;
	Для Каждого Элемент Из СоответствиеКнопокИВозвращаемыхЗначений Цикл
		Если Элемент.Значение = КнопкаПоУмолчанию Тогда
			Кнопка = Элементы[Элемент.Ключ];
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если Кнопка = Неопределено Тогда
		Кнопка = КоманднаяПанель.ПодчиненныеЭлементы[0];
	КонецЕсли;
	
	Если ВыделятьКнопкуПоУмолчанию Тогда
		Кнопка.КнопкаПоУмолчанию = Истина;
	КонецЕсли;
	ТекущийЭлемент = Кнопка;
КонецПроцедуры

&НаСервере
Процедура УстановитьКнопкуОжидания(ЗначениеКнопкиОжидания)
	Если СоответствиеКнопокИВозвращаемыхЗначений.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого Элемент Из СоответствиеКнопокИВозвращаемыхЗначений Цикл
		Если Элемент.Значение = ЗначениеКнопкиОжидания Тогда
			ОжиданиеИмяКнопки = Элемент.Ключ;
			КомандаФормы = Команды[ОжиданиеИмяКнопки]; // КомандаФормы
			ОжиданиеЗаголовокКнопки = КомандаФормы.Заголовок;
			Возврат;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаСервереБезКонтекста
Функция СтандартныйНабор(Кнопки)
	Результат = Новый СписокЗначений;
	
	Если Кнопки = "РежимДиалогаВопрос.ДаНет" Тогда
		Результат.Добавить("КодВозвратаДиалога.Да",  НСтр("ru = 'Да'"));
		Результат.Добавить("КодВозвратаДиалога.Нет", НСтр("ru = 'Нет'"));
	ИначеЕсли Кнопки = "РежимДиалогаВопрос.ДаНетОтмена" Тогда
		Результат.Добавить("КодВозвратаДиалога.Да",     НСтр("ru = 'Да'"));
		Результат.Добавить("КодВозвратаДиалога.Нет",    НСтр("ru = 'Нет'"));
		Результат.Добавить("КодВозвратаДиалога.Отмена", НСтр("ru = 'Отмена'"));
	ИначеЕсли Кнопки = "РежимДиалогаВопрос.ОК" Тогда
		Результат.Добавить("КодВозвратаДиалога.ОК", НСтр("ru = 'ОК'"));
	ИначеЕсли Кнопки = "РежимДиалогаВопрос.ОКОтмена" Тогда
		Результат.Добавить("КодВозвратаДиалога.ОК",     НСтр("ru = 'ОК'"));
		Результат.Добавить("КодВозвратаДиалога.Отмена", НСтр("ru = 'Отмена'"));
	ИначеЕсли Кнопки = "РежимДиалогаВопрос.ПовторитьОтмена" Тогда
		Результат.Добавить("КодВозвратаДиалога.Повторить", НСтр("ru = 'Повторить'"));
		Результат.Добавить("КодВозвратаДиалога.Отмена",    НСтр("ru = 'Отмена'"));
	ИначеЕсли Кнопки = "РежимДиалогаВопрос.ПрерватьПовторитьПропустить" Тогда
		Результат.Добавить("КодВозвратаДиалога.Прервать",   НСтр("ru = 'Прервать'"));
		Результат.Добавить("КодВозвратаДиалога.Повторить",  НСтр("ru = 'Повторить'"));
		Результат.Добавить("КодВозвратаДиалога.Пропустить", НСтр("ru = 'Пропустить'"));
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

// Определяет примерное число строк с учетом переносов.
&НаСервереБезКонтекста
Функция ЧислоСтрок(Текст, ОтсечкаПоШирине, ПриводитьКРазмерамЭлементовФормы = Истина)
	ЧислоСтрок = СтрЧислоСтрок(Текст);
	ЧислоПереносов = 0;
	Для НомерСтроки = 1 По ЧислоСтрок Цикл
		Строка = СтрПолучитьСтроку(Текст, НомерСтроки);
		ЧислоПереносов = ЧислоПереносов + Цел(СтрДлина(Строка)/ОтсечкаПоШирине);
	КонецЦикла;
	ПримерноеЧислоСтрок = ЧислоСтрок + ЧислоПереносов;
	Если ПриводитьКРазмерамЭлементовФормы Тогда
		Коэффициент = 2/3; // В такси в высоту 2 вмещается примерно 3 строки текста.
		ПримерноеЧислоСтрок = Цел((ПримерноеЧислоСтрок+1)*Коэффициент);
	КонецЕсли;
	Если ПримерноеЧислоСтрок = 2 Тогда
		ПримерноеЧислоСтрок = 3;
	КонецЕсли;
	Возврат ПримерноеЧислоСтрок;
КонецФункции

#КонецОбласти
