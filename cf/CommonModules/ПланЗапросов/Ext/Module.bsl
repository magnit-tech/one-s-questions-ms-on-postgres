﻿// Основной метод разбора

Функция ПолучитьОбъектЗапроса(Знач Запрос, СтроковыеПараметры) Экспорт
	
	Запрос = НормализованныйТекстЗапроса(Запрос);
	ПронумероватьВыборкиВЗапросе(Запрос);
	
	МассивПодзапросов = ОбъектПакетЗапросов(Запрос, СтроковыеПараметры);
	
	Возврат МассивПодзапросов;
	
КонецФункции

Функция ОбъектПакетЗапросов(Запрос, СтроковыеПараметры)
	
	Результат = Новый Структура("ЗапросИсточник,Приемник,ПоляПриемника,Значения");
	РезультатМассивЗапросов = Новый Массив;
	
	Результат.Приемник = Приемник(Запрос);
	ПоследняяПозиция = 1;
	Результат.ПоляПриемника = ПоляПриемника(Запрос, Результат.Приемник, ПоследняяПозиция);
	Результат.Значения = МассивЗначений(Запрос, СтроковыеПараметры);
	
	Если ЗначениеЗаполнено(Результат.Значения) Тогда
		Возврат Результат;	
	КонецЕсли;
	
	МассивПодзапросов = МассивПодзапросов(Запрос,ПоследняяПозиция+1);
	
	// Дедаем запрос плоским
	ЗаменитьСтроковыеЗначенияНаПараметры(Запрос, МассивПодзапросов, КлючПодзапросов());
	
	// Разделить запрос по объединению
	МассивЗапросов = МассивЗапросов(Запрос);
	Для Каждого ОдиночныйЗапрос Из МассивЗапросов Цикл
		ОбъектЗапроса = ОбъектЗапроса(ОдиночныйЗапрос, МассивПодзапросов, СтроковыеПараметры);
		РезультатМассивЗапросов.Добавить(ОбъектЗапроса);
	КонецЦикла;
	
	Результат.ЗапросИсточник = РезультатМассивЗапросов;
	Возврат Результат;
	
КонецФункции

Функция МассивЗапросов(Знач Запрос)
	
	Результат = Новый Массив;
	
	МассивЗапросовОбъединитьВсе = РазложитьСтрокуВМассивПодстрок(Запрос, КомандаUNIONALL());
	
	Для Каждого ЗапросовОбъединитьВсе Из МассивЗапросовОбъединитьВсе Цикл
		
		МассивЗапросовОбъединить = РазложитьСтрокуВМассивПодстрок(ЗапросовОбъединитьВсе, КомандаUNION());
		
		Для Каждого ЗапросовОбъединить Из МассивЗапросовОбъединить Цикл
			Результат.Добавить(ЗапросовОбъединить);
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция ОбъектЗапроса(Запрос, МассивПодзапросов, СтроковыеПараметры)
	
	Результат = СтруктураЗапроса();
	
	
	ЗаполнитьПервыеИРазличные(Запрос, Результат);
	//Результат.Первые = Первые(Запрос);
	Результат.МассивПолей = МассивПолей(Запрос, Результат, СтроковыеПараметры);
	
	Результат.ОсновнаяТаблица = ОсновнаяТаблица(Запрос, МассивПодзапросов, СтроковыеПараметры);
	
	Результат.МассивСоединений = МассивСоединений(Запрос, МассивПодзапросов, СтроковыеПараметры);
	Результат.Условия = Условия(Запрос, МассивПодзапросов);
	Результат.ПоляСортировки = ПоляСортировки(Запрос);
	Результат.ПоляГруппировки = ПоляГруппировки(Запрос); 
	
	Возврат Результат;
	
КонецФункции


// Получение хеша запроса

Функция ПолучитьХэшЗапроса(Знач Запрос) Экспорт
	
	ОкончаниеЗапроса = Найти(Запрос,"',N'@P1");
	Если ОкончаниеЗапроса > 0 Тогда
		Запрос = Лев(Запрос,ОкончаниеЗапроса);
	КонецЕсли;
	
	ОбъектЗапроса = ПланЗапросов.ПолучитьОбъектЗапроса(НРег(Запрос),"");
	Профиль = ПрофильЗапроса(ОбъектЗапроса);
	
	Возврат ХэшТекста(Профиль);	
КонецФункции

Функция ХэшТекста(Текст)
	Хеш = Новый ХешированиеДанных(ХешФункция.MD5);
	Хеш.Добавить(Текст);
	Возврат Хеш.ХешСумма
КонецФункции

Функция ПрофильЗапроса(ОбъектЗапроса)

	ПрофильЗапросов = "";
	Для Каждого ЗапросИсточник Из ОбъектЗапроса.ЗапросИсточник Цикл
		
		Если ПрофильЗапросов <> "" Тогда
			ПрофильЗапросов = ПрофильЗапросов + Символы.ПС + " UNION ";
		КонецЕсли;
		
		Профиль =  "SELECT 1 FROM ";
		
		ОсновнаяТаблица = ОсновнаяТаблицаИсточника(ЗапросИсточник.ОсновнаяТаблица);
				
		Профиль = Профиль + ОсновнаяТаблица;
		
		Для Каждого Соединение из ЗапросИсточник.МассивСоединений Цикл
			  ТаблицаСоединения = ОсновнаяТаблицаИсточника(Соединение.Источник);
			  
			  Профиль = Профиль + Символы.ПС + СтрШаблон("JOIN %1 ON %2", ТаблицаСоединения, Соединение.Условия); 
				
		КонецЦикла;
		
		Профиль = Профиль + Символы.ПС + ЗапросИсточник.Условия;
		  
		ПрофильЗапросов = ПрофильЗапросов + Символы.ПС + Профиль;
		
	КонецЦикла;
		
	Возврат ПрофильЗапросов;	
	
	
КонецФункции 

Функция ОсновнаяТаблицаИсточника(Источник) 
	Если Источник.Запрос <> Неопределено Тогда
		 ОсновнаяТаблица = "(" + ПрофильЗапроса(Источник.Запрос) + ")";
	Иначе
		Если Найти(Источник.Таблица,"#") > 0 Тогда
			ОсновнаяТаблица = "ВТ";
		Иначе
			ОсновнаяТаблица = Источник.Таблица;
		КонецЕсли;			 
	КонецЕсли;

	Возврат ОсновнаяТаблица;
КонецФункции



// Методы разбора элементов запроса

Функция Приемник(Запрос)

	Результат = "";
	ПозицияINSERINTO = СтрНайти(Запрос, КомандаINSERINTO());
	Если ПозицияINSERINTO > 0 Тогда
		Результат = СледующееСлово(Запрос, ПозицияINSERINTO + СтрДлина(КомандаINSERINTO()));
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ПоляПриемника(Запрос, Приемник, ПоследняяПозиция)
	
	Результат = Новый Массив();
	
	Если Не ЗначениеЗаполнено(Приемник) Тогда
		Возврат Результат;
	КонецЕсли;
	
	ПозицияПриемника = СтрНайти(Запрос, Приемник);
	
	СловоПослеПриемника = СледующееСловоПослеСлова(Запрос, Приемник);
	Если СтрНайти(СловоПослеПриемника, КомандаWITH()) > 0 Тогда
		ПозицияПриемника = СтрНайти(Запрос, СловоПослеПриемника) + СтрДлина(СловоПослеПриемника)+1;
	КонецЕсли;
	
	НачалоПолейПриемника = СтрНайти(Запрос, "(",, ПозицияПриемника);
	КонецПолейПриемника = СтрНайти(Запрос, ")",, ПозицияПриемника);
	
	ТекстПолейПриемника = Сред(Запрос, НачалоПолейПриемника+1, КонецПолейПриемника-НачалоПолейПриемника-1);
	
	Результат = СтрРазделить(ТекстПолейПриемника, ",", Истина);
	
	ПоследняяПозиция = КонецПолейПриемника;
	Возврат Результат;
	
КонецФункции

Функция МассивЗначений(Запрос, СтроковыеПараметры)
    Результат = Новый Массив;
	
	ПозицияVALUES = СтрНайти(Запрос, КомандаVALUES());
	Если ПозицияVALUES = 0 Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	НачалоТекстаЗначений = ПозицияVALUES + СтрДлина(КомандаVALUES()) + 2; 
	
	//ТекстЗначений = Сред(Запрос, НачалоТекстаЗначений, СтрДлина(Запрос) - НачалоТекстаЗначений);
	ТекстЗначений = Сред(Запрос, НачалоТекстаЗначений, СтрДлина(Запрос) - НачалоТекстаЗначений - 1); // 19.02.2024 Берлизов Сергей. CE-Добавил еще один символ
	
	Результат = МассивПолейПоТексту(ТекстЗначений, СтроковыеПараметры);
	
	Возврат Результат;
	
КонецФункции

Функция МассивПолей(Запрос,ОбъектЗапроса, СтроковыеПараметры)
     Результат = Новый Массив;
		 
	 ТекстНачалаПолей = КомандаSELECT()
	 		+ " " + КлючНомераВыборки() + ОбъектЗапроса.НомерВыборки + КлючНомераВыборки()
	 		+ ?(ОбъектЗапроса.РазличныеДоПервых = Истина, " " + КомандаDISTINCT(), "") 
			+ ?(ЗначениеЗаполнено(ОбъектЗапроса.Первые), " " + КомандаTOP() + " " + ОбъектЗапроса.Первые, "")
			+ ?(ОбъектЗапроса.РазличныеДоПервых = Ложь И ОбъектЗапроса.Различные = Истина, " " + КомандаDISTINCT(), "")
			+ " ";
	 
	 ПозицияНачалаПолей = СтрНайти((Запрос), ТекстНачалаПолей) + СтрДлина(ТекстНачалаПолей);
	 
	 ПозицияОкончанияПолей = СтрНайти((Запрос)," " + КомандаFROM() + " ");
	 Если ПозицияОкончанияПолей = 0 Тогда
		 ПозицияОкончанияПолей = СтрДлина(Запрос);
	 КонецЕсли;
	 
	 ТекстПолей = Сред(Запрос, ПозицияНачалаПолей, ПозицияОкончанияПолей-ПозицияНачалаПолей);
	 
	 Результат = МассивПолейПоТексту(ТекстПолей, СтроковыеПараметры);
	 	 
	 Возврат Результат;
	 
 КонецФункции
 
Функция МассивПолейПоТексту(ТекстПолей, СтроковыеПараметры)
	
	Результат = Новый Массив;
	
	// Экранирую значения в скобках
	МассивВыраженийВСкобках = МассивВыраженийВСкобках(ТекстПолей);
	ЗаменитьСтроковыеЗначенияНаПараметры(ТекстПолей, МассивВыраженийВСкобках, "##pole##");
	
	МассивСтрокПолей = СтрРазделить(ТекстПолей, ",",Истина);
	Для Каждого СтрокаПоля Из МассивСтрокПолей Цикл
		//ЗаменитьПараметрыНаСтроковыеЗначения(СтрокаПоля, МассивВыраженийВСкобках, "##pole##");
		ЗаменитьИмеющиесяПараметрыНаСтроковыеЗначения(СтрокаПоля, МассивВыраженийВСкобках, "##pole##");
		ЗаменитьИмеющиесяПараметрыНаСтроковыеЗначения(СтрокаПоля, СтроковыеПараметры, "##str##"); // 20.02.2024 Берлизов Сергей. CE-Возвращаем на место строковые параметры
		//СтрокаПоля = НастройкаТестовКлиентСервер.ЗаменаНачалаКавычек(СтрокаПоля);
		Результат.Добавить(СокрЛП(СтрокаПоля));
	КонецЦикла;
	
	Возврат Результат;
	 
КонецФункции

Процедура ЗаполнитьПервыеИРазличные(Запрос, ОбъектЗапроса)

	ПервоеСловоПослеSELECT = СледующееСловоПослеСлова(Запрос, КомандаSELECT());
	
	ОбъектЗапроса.НомерВыборки = ДанныеВКлюче(ПервоеСловоПослеSELECT,КлючНомераВыборки());
	
	ПервоеСловоПослеSELECT = СледующееСловоПослеСлова(Запрос, ПервоеСловоПослеSELECT);
	
	Если ПервоеСловоПослеSELECT = КомандаDISTINCT() Тогда
		ОбъектЗапроса.Различные = Истина;
		ОбъектЗапроса.РазличныеДоПервых = Истина;
		ПервоеСловоПослеSELECT = СледующееСловоПослеСлова(Запрос, КомандаDISTINCT());
	КонецЕсли;
	
	Если ПервоеСловоПослеSELECT <> КомандаTOP() Тогда
		Возврат;
	КонецЕсли;
	
	ЧислоПервых = СледующееСловоПослеСлова(Запрос, КомандаTOP());
	ОбъектЗапроса.Первые = ЧислоПервых;
	
	ПервоеСловоПослеЧислаПервых = СледующееСловоПослеСлова(Запрос, ЧислоПервых);
	Если ПервоеСловоПослеЧислаПервых = КомандаDISTINCT() Тогда
		ОбъектЗапроса.Различные = Истина;
		ОбъектЗапроса.РазличныеДоПервых = Ложь;
	КонецЕсли;
	
КонецПроцедуры

Функция ОсновнаяТаблица(Запрос, МассивПодзапросов, СтроковыеПараметры)
	
	Результат = СтруктураИсточника();
	ПозицияНачалаИсточника = СтрНайти((Запрос)," " + КомандаFROM() + " ");
	Если ПозицияНачалаИсточника = 0 Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ТекстИсточника = СледующееСлово(Запрос,ПозицияНачалаИсточника+6); 
	СледующееСловоПослеИсточника = СледующееСловоПослеСлова(Запрос, ТекстИсточника, ПозицияНачалаИсточника);
	
	Если СледующееСловоПослеИсточника = КомандаAS() Тогда
		Псевдоним = СледующееСловоПослеСлова(Запрос, КомандаAS(), ПозицияНачалаИсточника);
	Иначе
		Псевдоним = СледующееСловоПослеИсточника;
	КонецЕсли;
	
	Результат = ПолучитьИсточник(ТекстИсточника, МассивПодзапросов, СтроковыеПараметры);
	Результат.Псевдоним = Псевдоним;
	
	Возврат Результат;
	
КонецФункции

Функция МассивСоединений(Запрос, МассивПодзапросов, СтроковыеПараметры)
	
	Результат = Новый Массив;
	БлокиЗапросаССоединениями = РазложитьСтрокуВМассивПодстрок(Запрос, " " + КомандаJOIN() + " ");
	
	Если БлокиЗапросаССоединениями.Количество() = 1 Тогда
		Возврат Результат;
	КонецЕсли;
	
	Сч = 1;
	Для Сч = 1 По БлокиЗапросаССоединениями.ВГраница() Цикл
		ТекстТекущегоСоединения = БлокиЗапросаССоединениями[Сч];
		Соединение = СтруктураСоединения();
		Таблица = СледующееСлово(ТекстТекущегоСоединения,1);
		Соединение.Источник = ПолучитьИсточник(Таблица, МассивПодзапросов, СтроковыеПараметры);
		
		СледующееСловоПослеИсточника = СледующееСловоПослеСлова(ТекстТекущегоСоединения, Таблица);
	
		Если СледующееСловоПослеИсточника = КомандаAS() Тогда
			Псевдоним = СледующееСловоПослеСлова(ТекстТекущегоСоединения, КомандаAS());
		Иначе
			Псевдоним = СледующееСловоПослеИсточника;
		КонецЕсли;				
		Соединение.Источник.Псевдоним = Псевдоним;
		
		ПозицияНачалаУсловий = СтрНайти(ТекстТекущегоСоединения, " " + КомандаON() + " ");
		Если ПозицияНачалаУсловий <> 0 Тогда
			
			ПозицияОкончанияУсловий = ПозицияБлижайшегоЗарезервированногоСлова(ТекстТекущегоСоединения);
			Соединение.Условия = Сред(ТекстТекущегоСоединения, ПозицияНачалаУсловий+4, ПозицияОкончанияУсловий-ПозицияНачалаУсловий+4);
		КонецЕсли;
		
		Результат.Добавить(Соединение);
	КонецЦикла;
	
	Возврат Результат;
КонецФункции

Функция Условия(Запрос, МассивПодзапросов);
	
КонецФункции

Функция ПоляСортировки(Запрос)
	
КонецФункции

Функция ПоляГруппировки(Запрос)
	
КонецФункции


//Доп методы разбора запроса

Функция ПолучитьИсточник(ТекстИсточника, МассивПодзапросов, СтроковыеПараметры)
	
	Результат = СтруктураИсточника();
	Если СтрНайти(ТекстИсточника, КлючПодзапросов()) > 0 Тогда
		ТекстПодзапроса = ПолучитьТекстЗаменыПоКлючу(ТекстИсточника, КлючПодзапросов(), МассивПодзапросов);
		ТекстПодзапроса = СокрЛП(ТекстПодзапроса);
		ТекстПодзапросаБезСкобок = Сред(ТекстПодзапроса,2,СтрДлина(ТекстПодзапроса)-2);
		Результат.Запрос = ОбъектПакетЗапросов(ТекстПодзапросаБезСкобок, СтроковыеПараметры);		
	Иначе
		Результат.Таблица = ТекстИсточника;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция СледующееСлово(Текст, ПозицияНачала)
	
	Пока Сред(Текст, ПозицияНачала,1) = " " Цикл
		ПозицияНачала = ПозицияНачала + 1;
	КонецЦикла;
	
	ПозицияПробелаПослеСледующегоСлова = СтрНайти(Текст, " ",,ПозицияНачала);
	Результат = Сред(Текст, ПозицияНачала, ПозицияПробелаПослеСледующегоСлова - ПозицияНачала);
	Возврат Результат;
КонецФункции

Функция СледующееСловоПослеСлова(Текст, ПервоеСлово, НачалоПоиска = 1)
	
	Результат = "";
	ПозицияПервогоСлова = СтрНайти(Текст, ПервоеСлово,,НачалоПоиска);
	Если ПозицияПервогоСлова > 0 Тогда
		Результат = СледующееСлово(Текст, ПозицияПервогоСлова + СтрДлина(ПервоеСлово));
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция МассивВыраженийВСкобках(Запрос, ПолеОтбора="",ПоследняяПозиция=1)
	Результат = Новый Массив;

	//Нахожу первую открывающую
	//Нахожу первую закрывающую
	//Считаю сколько открывающих между ними
	//Пропускаю число закрывающих
	//Считаю число открывающих между первой закрывающей и последней закрывающей
	//Пропускаю число закрывающих
	//Повторяю пока в диапазоне число открытия и закрытия не совпадет
		
	НачалоПоиска = 1;
	Пока СтрНайти(Запрос, "(",,НачалоПоиска)>0 Цикл
		ПозицияОткрывающейСкобки = СтрНайти(Запрос, "(",,НачалоПоиска);
		ПозицияЗакрывающейСкобки = СтрНайти(Запрос, ")",,НачалоПоиска);
			
		Пока Истина Цикл
			
			ТекстМеждуСкобками = Сред(Запрос,ПозицияОткрывающейСкобки, ПозицияЗакрывающейСкобки-ПозицияОткрывающейСкобки+1);
			ЧислоОткрывающихСкобок = СтрЧислоВхождений(ТекстМеждуСкобками, "(");
			ЧислоЗакрывающихСкобок = СтрЧислоВхождений(ТекстМеждуСкобками, ")");
			
			НеобходимоеЧислоЗакрывающихСкобок = ЧислоОткрывающихСкобок - ЧислоЗакрывающихСкобок;
			Если НеобходимоеЧислоЗакрывающихСкобок = 0 Тогда
				Прервать;
			КонецЕсли;
			
			ПозицияЗакрывающейСкобки = СтрНайти(Запрос, ")",,ПозицияОткрывающейСкобки, ЧислоОткрывающихСкобок);
	
		КонецЦикла;
		
		СтрокаЗначений = Сред(Запрос, ПозицияОткрывающейСкобки,ПозицияЗакрывающейСкобки-ПозицияОткрывающейСкобки+1);
		НачалоПоиска = ПозицияЗакрывающейСкобки+1;
		
		Если ЗначениеЗаполнено(ПолеОтбора) Тогда
			ДобавитьСтрокуВРезультат = Найти(СтрокаЗначений, ПолеОтбора) > 0;
		Иначе
			ДобавитьСтрокуВРезультат = Истина;
		КонецЕсли;
 
		Если Результат.Найти(СтрокаЗначений) = Неопределено И ДобавитьСтрокуВРезультат Тогда
			//Результат.Добавить(СтрокаЗначений);
			// 20.02.2024 Берлизов Сергей. CE-Отсортируем по увеличению длины строки, что бы наименьшая длина была внизу, т.к. наименьшая длина может входить в другую подстроку 
			Сч = 0;
			Добавили = Ложь;
			Для каждого Рез Из Результат Цикл
				Если СтрДлина(СтрокаЗначений) >= СтрДлина(Рез) Тогда
					Результат.Вставить(Сч, СтрокаЗначений);
					Добавили = Истина;
					Прервать;
				КонецЕсли;	 
				Сч = СЧ + 1;
			КонецЦикла;              
			Если Не Добавили Тогда
				Результат.Добавить(СтрокаЗначений);
			КонецЕсли;
		КонецЕсли;
		
		// Это конец запроса
		Если НачалоПоиска >= СтрДлина(Запрос) Тогда
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Результат
	
КонецФункции

Функция МассивПодзапросов(Запрос,ПоследняяПозиция) 
	
	Результат = Новый Массив;

	Результат = МассивВыраженийВСкобках(Запрос, КомандаSELECT(),ПоследняяПозиция);
	Возврат Результат;
	
КонецФункции

Процедура ПронумероватьВыборкиВЗапросе(Запрос)
	
	МассивЧастейЗапроса = РазложитьСтрокуВМассивПодстрок(Запрос, КомандаSELECT() + " ", Ложь);
	ИтоговыйЗапрос = "";
	СчетчикВыборок = 1;
	Для Каждого ЧастьЗапроса Из МассивЧастейЗапроса Цикл
		Если СчетчикВыборок > МассивЧастейЗапроса.Вграница() Тогда
			ИтоговыйЗапрос  = ИтоговыйЗапрос + ЧастьЗапроса;
			Прервать;
		КонецЕсли;
		
		//ИтоговыйЗапрос  = ИтоговыйЗапрос + ЧастьЗапроса + КомандаSELECT() + " " + КлючНомераВыборки() + СчетчикВыборок + КлючНомераВыборки();
		ИтоговыйЗапрос  = ИтоговыйЗапрос + ЧастьЗапроса + КомандаSELECT() + " " + КлючНомераВыборки() + СчетчикВыборок + КлючНомераВыборки() + " "; // 19.02.2024 Берлизов Сергей. CE-Добавил пробел
		СчетчикВыборок = СчетчикВыборок + 1;	
	КонецЦикла;
	
	Запрос = ИтоговыйЗапрос;
	
КонецПроцедуры

Функция НормализованныйТекстЗапроса(Знач Запрос)

	//МассивСтроковыхЗначений = СтроковыеЗначенияВЗапросе(Запрос);
	//ЗаменитьСтроковыеЗначенияНаПараметры(Запрос, МассивСтроковыхЗначений, "##str##");
	
	// Нужна нейтрализация комментариев
	
	Запрос = СтрЗаменить(Запрос, Символы.ПС, " ");
	Запрос = СтрЗаменить(Запрос, Символы.ВК, " ");
	Запрос = СтрЗаменить(Запрос, Символы.ВТаб, " ");
	Запрос = СтрЗаменить(Запрос, Символы.ПФ, " ");
	Запрос = СтрЗаменить(Запрос, Символы.Таб, " ");
	Запрос = СтрЗаменить(Запрос, "  ", " ");
	Запрос = СтрЗаменить(Запрос, "  ", " ");
	
	//ЗаменитьПараметрыНаСтроковыеЗначения(Запрос, МассивСтроковыхЗначений, "##str##");
	
	Запрос = Запрос + " ";// 19.02.2024 Берлизов Сергей. CE-Добавил пробел в конце
	Возврат Запрос;
	
КонецФункции

Функция СтроковыеЗначенияВЗапросе(Запрос)
	
	НачалоПоиска = 1;
	МассивСтроковыхЗначений = Новый Массив;
	Пока СтрНайти(Запрос, "'",,НачалоПоиска)>0 Цикл
		ПозицияОткрывающейКавычки = СтрНайти(Запрос, "'",,НачалоПоиска);
		ПозицияЗакрывающейКавычки = СтрНайти(Запрос, "'",,НачалоПоиска,2);
		
		СтрокаЗначений = Сред(Запрос, ПозицияОткрывающейКавычки,ПозицияЗакрывающейКавычки-ПозицияОткрывающейКавычки);
		НачалоПоиска = ПозицияЗакрывающейКавычки+1;
		
		Если МассивСтроковыхЗначений.Найти(СтрокаЗначений) = Неопределено Тогда
			МассивСтроковыхЗначений.Добавить(СтрокаЗначений);
		КонецЕсли;
		
		Если СтрДлина(Запрос) <= НачалоПоиска Тогда
			Прервать;	
		КонецЕсли;
	КонецЦикла;
	
	Возврат МассивСтроковыхЗначений;
	
КонецФункции

Функция ПозицияБлижайшегоЗарезервированногоСлова(Текст)
	
	ПозицияБлижайшегоСлова = СтрДлина(Текст);
	МассивЗарезервированныхОсновныхСлов = МассивЗарезервированныхОсновныхСлов();
	Для Каждого Слово Из МассивЗарезервированныхОсновныхСлов Цикл
		ПозицияСлова = СтрНайти(Текст, " " + Слово + " ");
		Если ПозицияСлова > 0 Тогда
			ПозицияБлижайшегоСлова = Мин(ПозицияБлижайшегоСлова,ПозицияСлова);
		КонецЕсли;
	КонецЦикла;
	
	Возврат ПозицияСлова;
	
КонецФункции

Функция КлючНомераВыборки()
	Возврат "##НВ##";	
КонецФункции

Функция КлючПодзапросов()
	Возврат "##zapros##";	
КонецФункции

Функция ПолучитьТекстЗаменыПоКлючу(Текст, Ключ, МассивСтрок)
	
	НомерВМассиве = Число(ДанныеВКлюче(Текст,Ключ));
	
	Возврат МассивСтрок[НомерВМассиве-1];
	
КонецФункции

Функция ДанныеВКлюче(Текст,Ключ)
	
	НачалоКлюча = СтрНайти(Текст, Ключ) + СтрДлина(Ключ);
	КонецКлюча = СтрНайти(Текст, Ключ,,,2);
	
	Возврат Сред(Текст,НачалоКлюча,КонецКлюча - НачалоКлюча);
	
КонецФункции

Процедура ЗаменитьСтроковыеЗначенияНаПараметры(Запрос, МассивСтроковыхЗначений, КлючПараметра, Префикс = "") Экспорт 
	
	Если Не ЗначениеЗаполнено(МассивСтроковыхЗначений) Тогда
		Возврат	
	КонецЕсли;
	
	Сч = 0;
	Для Каждого СтроковоеЗначение Из МассивСтроковыхЗначений Цикл

		Сч = Сч + 1;
		Запрос = СТрЗаменить(Запрос, Префикс + СтроковоеЗначение, КлючПараметра+Сч+КлючПараметра);
		
	КонецЦикла;

КонецПроцедуры

Процедура ЗаменитьПараметрыНаСтроковыеЗначения(Запрос, МассивСтроковыхЗначений, КлючПараметра) Экспорт 
	
	Если Не ЗначениеЗаполнено(МассивСтроковыхЗначений) Тогда
		Возврат	
	КонецЕсли;
	
	Сч = 0;
	Для Каждого СтроковоеЗначение Из МассивСтроковыхЗначений Цикл
		
		Если СтроковоеЗначение = "''''" Тогда
			СтроковоеЗначение = "''::mvarchar";
		ИначеЕсли СтроковоеЗначение <> "''" Тогда
			СтроковоеЗначение = СтрЗаменить(СтроковоеЗначение, "''", "'");
		КонецЕсли;

		Сч = Сч + 1;
		Запрос = СТрЗаменить(Запрос, КлючПараметра+Сч+КлючПараметра, СтроковоеЗначение);
		
	КонецЦикла;

КонецПроцедуры

Процедура ЗаменитьИмеющиесяПараметрыНаСтроковыеЗначения(Запрос, МассивСтроковыхЗначений, КлючПараметра) Экспорт 
	
	Если Не ЗначениеЗаполнено(МассивСтроковыхЗначений) Тогда
		Возврат	
	КонецЕсли;
	
	ШаблонРег = СтрШаблон("%1(\d+)%1", КлючПараметра);
	РезультатыПоиска = СтрНайтиВсеПоРегулярномуВыражению(Запрос, ШаблонРег);
	Для каждого РезультатПоиска Из РезультатыПоиска Цикл
		
		СтроковоеЗначение = МассивСтроковыхЗначений[Число(РезультатПоиска.ПолучитьГруппы()[0].Значение) - 1];
		
		Если СтроковоеЗначение = "''''" Тогда
			СтроковоеЗначение = "''::mvarchar";
		КонецЕсли;
		
		Запрос = СТрЗаменить(Запрос, РезультатПоиска.Значение, СтроковоеЗначение);
		
	КонецЦикла;
	
КонецПроцедуры

// Конструкции языка SQL

Функция МассивЗарезервированныхОсновныхСлов()

	//СписокСлов = "SELECT,FROM,LEFT,RIGHT,FULL,OUTER,INNER,WHERE,GROUP,ORDER,JOIN";
	СписокСлов = "select,from,left,right,full,outer,inner,where,group,order,join";
	
	Возврат СтрРазделить(СписокСлов,",",Ложь);
	
КонецФункции

Функция КомандаAS()	
	Возврат "as";
КонецФункции

Функция КомандаVALUES()
	//Возврат "VALUES";
	Возврат "values";
КонецФункции

Функция КомандаUNIONALL()
	//Возврат "UNION ALL";	
	Возврат "union all";	
КонецФункции

Функция КомандаUNION()
	//Возврат "UNION";	
	Возврат "union";	
КонецФункции

Функция КомандаJOIN()
	//Возврат "JOIN";	
	Возврат "join";	
КонецФункции

Функция КомандаFROM()
	//Возврат "FROM";	
	Возврат "from";	
КонецФункции

Функция КомандаDISTINCT()
	//Возврат "DISTINCT";	
	Возврат "distinct";	
КонецФункции

Функция КомандаSELECT()
	//Возврат "SELECT";	
	Возврат "select";	
КонецФункции

Функция КомандаTOP()
	//Возврат "TOP";	
	Возврат "top";	
КонецФункции

Функция КомандаON()
	//Возврат "ON";	
	Возврат "on";	
КонецФункции

Функция КомандаINSERINTO()
	//Возврат "INSERT INTO";	
	Возврат "insert into";	
КонецФункции

Функция КомандаWITH()
	Возврат "with";
КонецФункции


// Структуры основных элементов запроса

Функция СтруктураЗапроса()
	Возврат Новый Структура("МассивПолей,Первые,Различные,РазличныеДоПервых,НомерВыборки,ОсновнаяТаблица,МассивСоединений,Условия,ПоляСортировки,ПоляГруппировки");	
КонецФункции

Функция СтруктураИсточника()
	Возврат Новый Структура("Таблица, Запрос, Псевдоним");	
КонецФункции

Функция СтруктураСоединения()
		Возврат Новый Структура("Источник, Условия");	
КонецФункции
	
Функция СтруктураУсловия() 
	Возврат Новый Структура("ГруппыИ, ГруппыИЛИ");
КонецФункции 

Функция СтруктураУсловие() 
	Возврат Новый Структура("ЛевоеЗначениеУсловия, ПравоеЗначениеУсловия, МетодСравнения");
КонецФункции

Функция СтруктураЗначениеУсловия()
	// Нужно подумать как отобразить подзапросы в условиях 
	Возврат Новый Структура("Поле, Источник");
КонецФункции		
	
Функция CтруктураПоля()

	Возврат Новый Структура("Поле, Псевдоним");
	
КонецФункции

// Из общего назначения

Функция РазложитьСтрокуВМассивПодстрок(Знач Значение, Знач Разделитель = ",", Знач ПропускатьПустыеСтроки = Неопределено, 
	СокращатьНепечатаемыеСимволы = Ложь)

	Результат = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Значение,Разделитель,ПропускатьПустыеСтроки);
	Возврат Результат;
	
КонецФункции 

Функция ОбъектВJSON(Данные)
	
	ЗаписьJSON = Новый ЗаписьJSON;			
	ЗаписьJSON.УстановитьСтроку();
	ЗаписатьJSON(ЗаписьJSON,Данные);			
	Возврат ЗаписьJSON.Закрыть();  
	
КонецФункции

Функция ТекстТекущегоЗапроса(Знач Результат, ЗапросИсточник, ПолеИсточник) Экспорт 
	
	ПодстрокаЗапроса = "\bselect\b";
	ПозНач = СтрНайтиПоРегулярномуВыражению(Результат, ПодстрокаЗапроса,, , ПолеИсточник.НомерВыборки).НачальнаяПозиция;
	Сч = ЗапросИсточник.Найти(ПолеИсточник);
	Если Сч = ЗапросИсточник.ВГраница() Тогда
		ПозКон = СтрДлина(Результат);
	Иначе
		ПозКон = СтрНайтиПоРегулярномуВыражению(Результат, ПодстрокаЗапроса,, , ЗапросИсточник[Сч + 1].НомерВыборки).НачальнаяПозиция;
	КонецЕсли;
	ТекЗапрос = Сред(Результат, ПозНач, ПозКон - ПозНач + 1);

	Возврат ТекЗапрос;
	
КонецФункции
