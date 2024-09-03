﻿#Область ПрограммныйИнтерфейс

Процедура ЗагрузитьДанныеФон(Параметры, АдресХранилища) Экспорт 

	Результат = ЗагрузитьДанные(Параметры.НастройкаТеста, Параметры.ОчиститьЭтап, Параметры.Вариант, Параметры.ДанныеФайлов, Параметры.ПараметрыТеста);
	ПоместитьВоВременноеХранилище(Результат, АдресХранилища);

КонецПроцедуры

Функция ЗагрузитьДанные(НастройкаТеста, ОчиститьЭтап = Ложь, Вариант, ДанныеФайлов, ПараметрыТеста = Неопределено, ДобавитьЧасыКДатеПриЗагрузке = 0) Экспорт 
	
    ДатаНачалаОбщая = ТекущаяУниверсальнаяДатаВМиллисекундах();
	Если ПараметрыТеста = Неопределено Тогда
		ПараметрыТеста = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(НастройкаТеста, "СтрокаПодключенияКБазеСобытий,РежимЗагрузкиСобытий,НеЗагружатьПропущенныеЗапросы,НеЗагружатьНенужныеЗапросы,ПорцияЗагрузкиДанных,ИнтервалОбработкиДанных,ПользовательБазыСобытий,ПарольБазыСобытий,ДобавитьЧасыКДатеПриЗагрузке");
	КонецЕсли;
	
	Результат = НастройкаТестовСервер.РезультатВыполненияФоновогоЗаданияЭтапа();
	Попытка
		
		Если ОчиститьЭтап Тогда                                                                                                  
			НастройкаТестовСервер.УдалитьДанныеРегистровНастройкиТеста(НастройкаТеста, Вариант);
		КонецЕсли;
		
		Для каждого ДанныеФайла Из ДанныеФайлов Цикл
			
			//ДанныеФайла.Вставить("ПутьНаСервере", ПолучитьИмяВременногоФайла(ДанныеФайла.Расширение));
			//ДвоичныеДанные = ПолучитьИзВременногоХранилища(ДанныеФайла.Адрес);
		    ДанныеФайла.ДвоичныеДанные.Записать(ДанныеФайла.ПутьНаСервере);
			
		КонецЦикла;
		
		// Если нужно загрузить данные по временным таблицам
		Если Вариант = 1 Или Вариант = 3 Или Вариант = 5 Тогда
			
			ТекстовыйДокумент = Новый ТекстовыйДокумент;
			ТекстовыйДокумент.Прочитать(ДанныеФайлов[0].ПутьНаСервере);
			
			НаборЗаписей = РегистрыСведений.ВременныеТаблицы.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.НастройкаТеста.Установить(НастройкаТеста);
			
			Если Вариант = 5 Тогда
				НаборЗаписей.Прочитать();
				ТаблицаРегистра = НаборЗаписей.Выгрузить();
				КоличествоЗаписей = ТаблицаРегистра.Количество();
				НаборЗаписей.Очистить();
				НаборЗаписей.Записать();
			Иначе	
				// Очистка существующих данных
				Если Вариант = 3 Тогда
					НаборЗаписей.Записать();  
				КонецЕсли;
				ТаблицаРегистра = НаборЗаписей.ВыгрузитьКолонки();
			КонецЕсли;
			
			#Область Закоменченный_Цикл
			// ЦИКЛ В ОДНУ СТРОКУ
			//Для Сч = 1 По ТекстовыйДокумент.КоличествоСтрок() Цикл
			//	
			//	Строка = ТекстовыйДокумент.ПолучитьСтроку(Сч);
			//	Массив = СтрРазделить(Строка, ";", Истина);
			//	НоваяСтрока = ТаблицаРегистра.Добавить();
			//	НоваяСтрока.table_id = Массив[1];
			//	НоваяСтрока.table_name = Массив[3];
			//	НоваяСтрока.col_id = Массив[4];
			//	НоваяСтрока.col_name = НРег(Массив[5]);
			//	НоваяСтрока.data_name = НРег(Массив[6]);
			//	НоваяСтрока.data_len = Массив[7];
			//	НоваяСтрока.precision = Массив[8];
			//	НоваяСтрока.scale = Массив[9];
			//	НоваяСтрока.data_nullable = Массив[10];
			//	НоваяСтрока.col_max = Массив[11];
			//	
			//КонецЦикла;
			#КонецОбласти
			Для Сч = 1 По ТекстовыйДокумент.КоличествоСтрок() Цикл  Строка = ТекстовыйДокумент.ПолучитьСтроку(Сч);Массив = СтрРазделить(Строка, ";", Истина);НоваяСтрока = ТаблицаРегистра.Добавить();НоваяСтрока.table_id = Массив[1];НоваяСтрока.table_name = Массив[3];НоваяСтрока.col_id = Массив[4];НоваяСтрока.col_name = НРег(Массив[5]);НоваяСтрока.data_name = НРег(Массив[6]);НоваяСтрока.data_len = Массив[7];НоваяСтрока.precision = Массив[8];НоваяСтрока.scale = Массив[9];НоваяСтрока.data_nullable = Массив[10];НоваяСтрока.col_max = Массив[11]; КонецЦикла;			
			
			ТаблицаРегистра.ЗаполнитьЗначения(НастройкаТеста, "НастройкаТеста");
			
			Если Вариант = 5 Тогда
				ТаблицаРегистра.Свернуть("НастройкаТеста,table_id,col_id,table_name,col_name,data_name,data_len,data_nullable,col_max,precision,scale");
			КонецЕсли;
			
			НаборЗаписей.Загрузить(ТаблицаРегистра);
			НаборЗаписей.Записать(Ложь);
			
			Если Вариант = 5 Тогда
				ОбщегоНазначения.СообщитьПользователю(СтрШаблон("Догружено записей по ВТ - %1", ТаблицаРегистра.Количество() - КоличествоЗаписей));
			Иначе
				ОбщегоНазначения.СообщитьПользователю(СтрШаблон("Загружено записей по ВТ - %1", ТаблицаРегистра.Количество()));
			КонецЕсли;

		КонецЕсли;
		
		Если Вариант = 1 Или Вариант = 2 Тогда
			
			НаборЗаписей = РегистрыСведений.РезультатыВыполненияЗапросов.СоздатьНаборЗаписей();
			ТаблицаРегистра = НаборЗаписей.ВыгрузитьКолонки();
			ТаблицаРегистра.Колонки.Добавить("ИмяСобытия", ОбщегоНазначения.ОписаниеТипаСтрока(30)); 
			ВидыСобытий = ЗаполнитьВидыСобытий();
			Номера = ДанныеПозицийXML(); // Номера позиций для получения данных
			
			Если ПараметрыТеста.РежимЗагрузкиСобытий = 0 Тогда
				
				НачСч = ?(Вариант = 1, 1, 0);
				
				Для Сч = НачСч По ДанныеФайлов.Количество()-1 Цикл
					
					ЧтениеXML = Новый ЧтениеXML;
					ЧтениеXML.ОткрытьФайл(ДанныеФайлов[Сч].ПутьНаСервере); 
					СписокXDTOСобытий = Новый Массив;
					
					СобытияXDTO = ФабрикаXDTO.ПрочитатьXML(ЧтениеXML); 
					Для каждого СобытиеXDTO Из СобытияXDTO.event Цикл
						Поз = Номера[СобытиеXDTO.name];
						
						НоваяЗапись = ТаблицаРегистра.Добавить();
						//НоваяЗапись.ИмяСобытия = СобытиеXDTO.name;
						НоваяЗапись.ДатаСобытия = timestampВФормат1С(СобытиеXDTO.timestamp, ПараметрыТеста.ДобавитьЧасыКДатеПриЗагрузке);
						НоваяЗапись.НомерСессии = XMLЗначение(Тип("Число"), СобытиеXDTO.action[Поз.session_id].value);
						НоваяЗапись.НомерСобытия = XMLЗначение(Тип("Число"), СобытиеXDTO.action[Поз.event_sequence].value);
						НоваяЗапись.ДлительностьВыполненияMSSQL = Окр(XMLЗначение(Тип("Число"), СобытиеXDTO.data[Поз.duration].value) / 1000, 0);
						НоваяЗапись.ТекстОшибки = СобытиеXDTO.data[Поз.result].text;
						НоваяЗапись.КоличествоСтрокMSSQL = XMLЗначение(Тип("Число"), СобытиеXDTO.data[Поз.row_count].value);
						Если НоваяЗапись.ТекстОшибки = "OK" Тогда
							НоваяЗапись.ТекстОшибки	 = "";
						Иначе
							НоваяЗапись.ВидОшибки = Перечисления.ВидыОшибокЗапросов.ОшибкаMSSQL;	
						КонецЕсли;
						НоваяЗапись.ТекстЗапросаMSSQL = СобытиеXDTO.data[Поз.batch_text].value;

					КонецЦикла;	
					
					ЧтениеXML.Закрыть();
				КонецЦикла;
				
				#Область Закоменченный_Цикл
				// ЦИКЛ В ОДНУ СТРОКУ
				//Для каждого НоваяЗапись Из ТаблицаРегистра Цикл
				//	
				//	Поз = Номера[НоваяЗапись.ИмяСобытия];
				//	
				//	Пропуск = Ложь;
				//	Для каждого Стр Из Поз.ПодстрокиИсключения Цикл
				//		Если СтрНайти(НоваяЗапись.ТекстЗапросаMSSQL, Стр) > 0 Тогда
				//			Пропуск = Истина;
				//			Прервать;
				//		КонецЕсли;	
				//	КонецЦикла;
				//	
				//	Если Пропуск Тогда
				//		НоваяЗапись.ВидОшибки = Перечисления.ВидыОшибокЗапросов.ПропущенныйЗапросMsSQL;
				//		Продолжить;	
				//	КонецЕсли;   
				//	
				//	ТекстЗапроса = НастройкаТестовСервер.ТекстЗапросаMSSQL(НоваяЗапись.ТекстЗапросаMSSQL, Истина);

				//	Для каждого СтрокаТЗ Из ВидыСобытий Цикл
				//		Нашли = Ложь;
				//		ЕстьНачинаетсяС = ЗначениеЗаполнено(СтрокаТЗ.НачинаетсяС);
				//		ЕстьПодстрока = ЗначениеЗаполнено(СтрокаТЗ.Подстрока);
				//		Если ЕстьНачинаетсяС И Лев(ТекстЗапроса, СтрДлина(СтрокаТЗ.НачинаетсяС)) = СтрокаТЗ.НачинаетсяС Тогда
				//			НоваяЗапись.ВидСобытия = СтрокаТЗ.ВидСобытия;
				//			Нашли = Истина;
				//		КонецЕсли;
				//		Если ЕстьПодстрока И (ЕстьНачинаетсяС И Нашли Или Не ЕстьНачинаетсяС) Тогда
				//			Нашли = СтрНайти(ТекстЗапроса, СтрокаТЗ.Подстрока) > 0;
				//		КонецЕсли;
				//		Если Нашли Тогда
				//			Прервать;	
				//		КонецЕсли;
				//	КонецЦикла;
				//	
				//КонецЦикла;
				#КонецОбласти
				Для каждого НоваяЗапись Из ТаблицаРегистра Цикл  Поз = Номера[НоваяЗапись.ИмяСобытия]; Пропуск = Ложь;Для каждого Стр Из Поз.ПодстрокиИсключения Цикл Если СтрНайти(НоваяЗапись.ТекстЗапросаMSSQL, Стр) > 0 Тогда Пропуск = Истина;Прервать;КонецЕсли;КонецЦикла; Если Пропуск Тогда НоваяЗапись.ВидОшибки = Перечисления.ВидыОшибокЗапросов.ПропущенныйЗапросMsSQL;Продолжить;КонецЕсли; ТекстЗапроса = НастройкаТестовСервер.ТекстЗапросаMSSQL(НоваяЗапись.ТекстЗапросаMSSQL, Истина); Для каждого СтрокаТЗ Из ВидыСобытий Цикл Нашли = Ложь;ЕстьНачинаетсяС = ЗначениеЗаполнено(СтрокаТЗ.НачинаетсяС);ЕстьПодстрока = ЗначениеЗаполнено(СтрокаТЗ.Подстрока);Если ЕстьНачинаетсяС И Лев(ТекстЗапроса, СтрДлина(СтрокаТЗ.НачинаетсяС)) = СтрокаТЗ.НачинаетсяС Тогда НоваяЗапись.ВидСобытия = СтрокаТЗ.ВидСобытия;Нашли = Истина;КонецЕсли;Если ЕстьПодстрока И (ЕстьНачинаетсяС И Нашли Или Не ЕстьНачинаетсяС) Тогда Нашли = СтрНайти(ТекстЗапроса, СтрокаТЗ.Подстрока) > 0;КонецЕсли;Если Нашли Тогда Прервать;КонецЕсли;КонецЦикла; КонецЦикла;			
				
				Если ПараметрыТеста.НеЗагружатьПропущенныеЗапросы Тогда
					
					СтрокиТаблицы = ТаблицаРегистра.НайтиСтроки(Новый Структура("ВидОшибки", Перечисления.ВидыОшибокЗапросов.ПропущенныйЗапросMsSQL));
					Для каждого СтрокаТаблицы Из СтрокиТаблицы Цикл	ТаблицаРегистра.Удалить(СтрокаТаблицы);	КонецЦикла;
					
				КонецЕсли;
				
				НачатьТранзакцию();
				НастройкаТеста.ЗагрузитьДанныеВРегистр(НастройкаТеста, ТаблицаРегистра, Ложь);
				ЗафиксироватьТранзакцию();
				
			Иначе
				
				ДопПараметры = Новый Структура;
				ДопПараметры.Вставить("ПараметрыТеста", 				ПараметрыТеста);
				ДопПараметры.Вставить("Номера", 						Номера);
				ДопПараметры.Вставить("ВидыСобытий", 					ВидыСобытий);
				ДопПараметры.Вставить("ДобавитьЧасыКДатеПриЗагрузке", 	ПараметрыТеста.ДобавитьЧасыКДатеПриЗагрузке);
				ЗагрузкаИзБазы(НастройкаТеста, ДопПараметры);
				
			КонецЕсли;
			
			Результат.Результат = НастройкаТестовСервер.СообщитьДлительностьОперации(НастройкаТеста,"Загрузка данных", ДатаНачалаОбщая);
			Результат.Вставить("ЭтапЗавершен", Истина);
	
		КонецЕсли;
		
	Исключение
		
		НастройкаТестовСервер.СообщитьОшибку(НастройкаТеста, "ЗагрузкаДанных", ИнформацияОбОшибке(), Результат);
		
	КонецПопытки;
	
	Для каждого ДанныеФайла Из ДанныеФайлов Цикл
		Если ПараметрыТеста.РежимЗагрузкиСобытий = 0 Тогда
			Попытка
				ЧтениеXML.Закрыть();
			Исключение
			КонецПопытки;
		КонецЕсли;
		УдалитьФайлы(ДанныеФайла.ПутьНаСервере);	
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции 

Процедура ЗагрузкаИзБазы(НастройкаТеста, ДопПараметры)
	Перем ЗаголовокСообщения, МаксID;
	
	УстановитьСоединениеСВнешнимиИсточникамиДанных(ДопПараметры);
				
	// Определяем с какой итерации можно записывать в РС без замещения
	ЭтапОбработки = НастройкаТестовСервер.ЭтапОбработки(НастройкаТеста, Перечисления.ВидыЭтаповОбработки.ЗагрузкаДанных);
	Если ЭтапОбработки.НомерИтерации = 0 Тогда
		ЭтапЗаписьЛожь = 0;
	Иначе
		ЭтапЗаписьЛожь = ЭтапОбработки.НомерИтерации + 1;
	КонецЕсли;
	
	Пока Истина Цикл
		ДатаНачала = ТекущаяУниверсальнаяДатаВМиллисекундах();
		
		ЭтапОбработки = НастройкаТестовСервер.ЭтапОбработки(НастройкаТеста, Перечисления.ВидыЭтаповОбработки.ЗагрузкаДанных);
        ЭтапОбработки.НомерИтерации = ЭтапОбработки.НомерИтерации + 1;
		Если ЭтапОбработки.НомерИтерации > ЭтапЗаписьЛожь Тогда
			Замещать = Ложь;
		Иначе
			Замещать = Истина;
		КонецЕсли;
		
		Выборка = РезультатИзБазы(НастройкаТеста, ДопПараметры.ПараметрыТеста, ЭтапОбработки, ЗаголовокСообщения, МаксID);

		Шагов = 10;
		Шаг = Цел(Выборка.Количество() / Шагов) - 1;
		Сч = 0;
		ТекстСообещения = "Обработка и загрузка..."; 
		
		ТаблицаРегистра = РегистрыСведений.РезультатыВыполненияЗапросов.СоздатьНаборЗаписей().ВыгрузитьКолонки();
		ТаблицаРегистра.Колонки.Добавить("ИмяСобытия", ОбщегоНазначения.ОписаниеТипаСтрока(30)); 
		
		// Из-за порционности загрузки теоретически в предыдущем цикле может быть загружено Создание оператора, а в следующем цикле остануются строки с Выполнением подготовленного опрератора
		ПодгОперВТ = ПереходящиеПодготовленныеОператоры(НастройкаТеста); 
		
		#Область Закоменченный_цикл
		//Пока Выборка.Следующий() Цикл
		//	
		//	Если Сч % Шаг = 0 Тогда
		//		НастройкаТестовСервер.СообщитьПрогрессаЭтапа(ЗаголовокСообщения, ТекстСообещения, Окр(Сч/Выборка.Количество()*100, 0));
		//	КонецЕсли;
		//	Сч = Сч + 1;
		//	
		//	НоваяЗапись = Новый Структура("ДатаСобытия,НомерСессии,НомерСобытия,ИмяСобытия,ВидСобытия,ТекстЗапросаMSSQL,КоличествоСтрокMSSQL,ДлительностьВыполненияMSSQL,ТекстОшибки,ВидОшибки,ВидСобытия");
		//    ЗаполнитьЗначенияСвойств(НоваяЗапись, Выборка, "ИмяСобытия,НомерСессии,НомерСобытия,ДлительностьВыполненияMSSQL,ТекстОшибки,ТекстЗапросаMSSQL,КоличествоСтрокMSSQL");                                     
		//	НоваяЗапись.ДатаСобытия = timestampВФормат1С(Выборка.timestamp, ДопПараметры.ДобавитьЧасыКДатеПриЗагрузке);
		//	Если Не ПустаяСтрока(НоваяЗапись.ТекстОшибки) Тогда
		//		НоваяЗапись.ВидОшибки = Перечисления.ВидыОшибокЗапросов.ОшибкаMSSQL;
		//	КонецЕсли; 
		//	
		//	Поз = ДопПараметры.Номера[НоваяЗапись.ИмяСобытия];
		//	
		//	Пропуск = Ложь;
		//	Для каждого Стр Из Поз.ПодстрокиИсключения Цикл
		//		Если СтрНайти(НоваяЗапись.ТекстЗапросаMSSQL, Стр) > 0 Тогда
		//			Пропуск = Истина;
		//			Прервать;
		//		КонецЕсли;	
		//	КонецЦикла;
		//	
		//	Если Пропуск Тогда
		//		Если ДопПараметры.ПараметрыТеста.НеЗагружатьПропущенныеЗапросы Тогда
		//			Продолжить;	
		//		КонецЕсли;
		//		НоваяЗапись.ВидОшибки = Перечисления.ВидыОшибокЗапросов.ПропущенныйЗапросMsSQL;
		//	КонецЕсли;   
		//	
		//	ТекстЗапроса = НастройкаТестовСервер.ТекстЗапросаMSSQL(НоваяЗапись.ТекстЗапросаMSSQL, Истина);

		//	Для каждого СтрокаТЗ Из ДопПараметры.ВидыСобытий Цикл
		//		Нашли = Ложь;
		//		ЕстьНачинаетсяС = ЗначениеЗаполнено(СтрокаТЗ.НачинаетсяС);
		//		ЕстьПодстрока = ЗначениеЗаполнено(СтрокаТЗ.Подстрока);
		//		Если ЕстьНачинаетсяС И Лев(ТекстЗапроса, СтрДлина(СтрокаТЗ.НачинаетсяС)) = СтрокаТЗ.НачинаетсяС Тогда
		//			НоваяЗапись.ВидСобытия = СтрокаТЗ.ВидСобытия;
		//			Нашли = Истина;
		//		КонецЕсли;
		//		Если ЕстьПодстрока И (ЕстьНачинаетсяС И Нашли Или Не ЕстьНачинаетсяС) Тогда
		//			Нашли = СтрНайти(ТекстЗапроса, СтрокаТЗ.Подстрока) > 0;
		//		КонецЕсли;
		//		Если Нашли Тогда
		//			Прервать;	
		//		КонецЕсли;
		//	КонецЦикла;
		//	
		//	УточнитьВидПодготовленогоОператора(НоваяЗапись,ПодгОперВТ);
		//	
		//	Если ДопПараметры.ПараметрыТеста.НеЗагружатьНенужныеЗапросы 
		//		И (	НоваяЗапись.ВидСобытия=Неопределено
		//			ИЛИ НоваяЗапись.ВидСобытия=Перечисления.ВидыСобытийЗапросов.ВставкаДанных
		//			ИЛИ НоваяЗапись.ВидСобытия=Перечисления.ВидыСобытийЗапросов.ВызовПодготовленногоОператора
		//			ИЛИ НоваяЗапись.ВидСобытия=Перечисления.ВидыСобытийЗапросов.ОбновлениеДанных
		//			ИЛИ НоваяЗапись.ВидСобытия=Перечисления.ВидыСобытийЗапросов.ОпределениеПодготовленногоОператора
		//			ИЛИ НоваяЗапись.ВидСобытия=Перечисления.ВидыСобытийЗапросов.ПотоковаяВставкаВВременнуюТаблицу
		//			ИЛИ НоваяЗапись.ВидСобытия=Перечисления.ВидыСобытийЗапросов.РазрушениеПодготовленногоОператора
		//			ИЛИ НоваяЗапись.ВидСобытия=Перечисления.ВидыСобытийЗапросов.УдалениеДанных
		//			) Тогда
		//		Продолжить;	
		//	КонецЕсли;
		//	
		//	СтрокаТаблицы = ТаблицаРегистра.Добавить();
		//    ЗаполнитьЗначенияСвойств(СтрокаТаблицы, НоваяЗапись); 
		//
		//КонецЦикла;
		#КонецОбласти
		Пока Выборка.Следующий() Цикл  Если Сч % Шаг = 0 Тогда НастройкаТестовСервер.СообщитьПрогрессаЭтапа(ЗаголовокСообщения, ТекстСообещения, Окр(Сч/Выборка.Количество()*100, 0));КонецЕсли;Сч = Сч + 1; НоваяЗапись = Новый Структура("ДатаСобытия,НомерСессии,НомерСобытия,ИмяСобытия,ВидСобытия,ТекстЗапросаMSSQL,КоличествоСтрокMSSQL,ДлительностьВыполненияMSSQL,ТекстОшибки,ВидОшибки,ВидСобытия");ЗаполнитьЗначенияСвойств(НоваяЗапись, Выборка, "ИмяСобытия,НомерСессии,НомерСобытия,ДлительностьВыполненияMSSQL,ТекстОшибки,ТекстЗапросаMSSQL,КоличествоСтрокMSSQL");НоваяЗапись.ДатаСобытия = timestampВФормат1С(Выборка.timestamp,ДопПараметры.ДобавитьЧасыКДатеПриЗагрузке);Если Не ПустаяСтрока(НоваяЗапись.ТекстОшибки) Тогда НоваяЗапись.ВидОшибки = Перечисления.ВидыОшибокЗапросов.ОшибкаMSSQL;КонецЕсли; Поз = ДопПараметры.Номера[НоваяЗапись.ИмяСобытия]; Пропуск = Ложь;Для каждого Стр Из Поз.ПодстрокиИсключения Цикл Если СтрНайти(НоваяЗапись.ТекстЗапросаMSSQL, Стр) > 0 Тогда Пропуск = Истина;Прервать;КонецЕсли;КонецЦикла; Если Пропуск Тогда Если ДопПараметры.ПараметрыТеста.НеЗагружатьПропущенныеЗапросы Тогда Продолжить;КонецЕсли;НоваяЗапись.ВидОшибки = Перечисления.ВидыОшибокЗапросов.ПропущенныйЗапросMsSQL;КонецЕсли; ТекстЗапроса = НастройкаТестовСервер.ТекстЗапросаMSSQL(НоваяЗапись.ТекстЗапросаMSSQL, Истина); Для каждого СтрокаТЗ Из ДопПараметры.ВидыСобытий Цикл Нашли = Ложь;ЕстьНачинаетсяС = ЗначениеЗаполнено(СтрокаТЗ.НачинаетсяС);ЕстьПодстрока = ЗначениеЗаполнено(СтрокаТЗ.Подстрока);Если ЕстьНачинаетсяС И Лев(ТекстЗапроса, СтрДлина(СтрокаТЗ.НачинаетсяС)) = СтрокаТЗ.НачинаетсяС Тогда НоваяЗапись.ВидСобытия = СтрокаТЗ.ВидСобытия;Нашли = Истина;КонецЕсли;Если ЕстьПодстрока И (ЕстьНачинаетсяС И Нашли Или Не ЕстьНачинаетсяС) Тогда Нашли = СтрНайти(ТекстЗапроса, СтрокаТЗ.Подстрока) > 0;КонецЕсли;Если Нашли Тогда Прервать;КонецЕсли;КонецЦикла; УточнитьВидПодготовленогоОператора(НоваяЗапись,ПодгОперВТ); Если ДопПараметры.ПараметрыТеста.НеЗагружатьНенужныеЗапросы И (	НоваяЗапись.ВидСобытия=Неопределено ИЛИ НоваяЗапись.ВидСобытия=Перечисления.ВидыСобытийЗапросов.ВставкаДанных ИЛИ НоваяЗапись.ВидСобытия=Перечисления.ВидыСобытийЗапросов.ВызовПодготовленногоОператора ИЛИ НоваяЗапись.ВидСобытия=Перечисления.ВидыСобытийЗапросов.ОбновлениеДанных ИЛИ НоваяЗапись.ВидСобытия=Перечисления.ВидыСобытийЗапросов.ОпределениеПодготовленногоОператора ИЛИ НоваяЗапись.ВидСобытия=Перечисления.ВидыСобытийЗапросов.ПотоковаяВставкаВВременнуюТаблицу ИЛИ НоваяЗапись.ВидСобытия=Перечисления.ВидыСобытийЗапросов.РазрушениеПодготовленногоОператора ИЛИ НоваяЗапись.ВидСобытия=Перечисления.ВидыСобытийЗапросов.УдалениеДанных ) Тогда Продолжить;КонецЕсли; СтрокаТаблицы = ТаблицаРегистра.Добавить();ЗаполнитьЗначенияСвойств(СтрокаТаблицы, НоваяЗапись); КонецЦикла;		
		
		ТаблицаРегистра.ЗаполнитьЗначения(НастройкаТеста, "НастройкаТеста");
		ЭтапОбработки.ТекущееID = Выборка.ID;
		Если ДопПараметры.ПараметрыТеста.ПорцияЗагрузкиДанных = 0 Тогда
			ЭтапОбработки.Завершен = Истина;
		Иначе
			ЭтапОбработки.Завершен = Выборка.ID = МаксID;
		КонецЕсли;
		
		НачатьТранзакцию();
		
		НастройкаТестовСервер.ЗагрузитьДанныеВРегистр(НастройкаТеста, ТаблицаРегистра, Замещать);
		СохранитьПереходящиеОператоры(НастройкаТеста, ПодгОперВТ);
		НастройкаТестовСервер.СообщитьДлительностьОперации(НастройкаТеста,СтрШаблон("Загрузка %1 итерации данных", ЭтапОбработки.НомерИтерации), ДатаНачала, ЭтапОбработки); 
		
		ЗафиксироватьТранзакцию();
		
		ТаблицаРегистра = Неопределено;
		Если ЭтапОбработки.Завершен Тогда
			Прервать;	
		КонецЕсли;
		
	КонецЦикла;

КонецПроцедуры

Функция ЗаполнитьВидыСобытий()
	
	ВидыСобытий = Новый ТаблицаЗначений;
	ВидыСобытий.Колонки.Добавить("НачинаетсяС", Новый ОписаниеТипов("Строка", ,
												Новый КвалификаторыСтроки(0, ДопустимаяДлина.Переменная)));
	ВидыСобытий.Колонки.Добавить("ВидСобытия", Новый ОписаниеТипов("ПеречислениеСсылка.ВидыСобытийЗапросов"));
	ВидыСобытий.Колонки.Добавить("Подстрока", Новый ОписаниеТипов("Строка", ,
												Новый КвалификаторыСтроки(0, ДопустимаяДлина.Переменная)));
	
	//ПОРЯДОК СТРОК ВАЖЕН, ПОЭТОМУ НЕ СООТВЕТСТВИЕ, А ТАБЛИЦА!!!
	НоваяСтрока = ВидыСобытий.Добавить(); НоваяСтрока.НачинаетсяС = "SELECT"; НоваяСтрока.ВидСобытия = Перечисления.ВидыСобытийЗапросов.ВыборкаДанных;
	НоваяСтрока = ВидыСобытий.Добавить(); НоваяСтрока.НачинаетсяС = "INSERT INTO #tt"; НоваяСтрока.ВидСобытия = Перечисления.ВидыСобытийЗапросов.ЗаполнениеВременнойТаблицы;
	НоваяСтрока = ВидыСобытий.Добавить(); НоваяСтрока.НачинаетсяС = "CREATE TABLE #tt"; НоваяСтрока.ВидСобытия = Перечисления.ВидыСобытийЗапросов.СозданиеВременнойТаблицы;
	НоваяСтрока = ВидыСобытий.Добавить(); НоваяСтрока.НачинаетсяС = "TRUNCATE TABLE #tt"; НоваяСтрока.ВидСобытия = Перечисления.ВидыСобытийЗапросов.ОчисткаВременнойТаблицы;
	НоваяСтрока = ВидыСобытий.Добавить(); НоваяСтрока.НачинаетсяС = "INSERT INTO"; НоваяСтрока.ВидСобытия = Перечисления.ВидыСобытийЗапросов.ВставкаДанных;
	НоваяСтрока = ВидыСобытий.Добавить(); НоваяСтрока.НачинаетсяС = "DELETE FROM"; НоваяСтрока.ВидСобытия = Перечисления.ВидыСобытийЗапросов.УдалениеДанных;
	НоваяСтрока = ВидыСобытий.Добавить(); НоваяСтрока.НачинаетсяС = "UPDATE"; НоваяСтрока.ВидСобытия = Перечисления.ВидыСобытийЗапросов.ОбновлениеДанных;
	НоваяСтрока = ВидыСобытий.Добавить(); НоваяСтрока.НачинаетсяС = "CREATE CLUSTERED INDEX"; НоваяСтрока.Подстрока = "ON #tt"; НоваяСтрока.ВидСобытия = Перечисления.ВидыСобытийЗапросов.СозданиеИндексаВременнойТаблицы;
	НоваяСтрока = ВидыСобытий.Добавить(); НоваяСтрока.НачинаетсяС = "CREATE UNIQUE CLUSTERED INDEX"; НоваяСтрока.Подстрока = "ON #tt"; НоваяСтрока.ВидСобытия = Перечисления.ВидыСобытийЗапросов.СозданиеИндексаВременнойТаблицы;
	НоваяСтрока = ВидыСобытий.Добавить(); НоваяСтрока.НачинаетсяС = "declare @p"; НоваяСтрока.Подстрока = "exec sp_prepare @p"; НоваяСтрока.ВидСобытия = Перечисления.ВидыСобытийЗапросов.ОпределениеПодготовленногоОператора;
	НоваяСтрока = ВидыСобытий.Добавить(); НоваяСтрока.НачинаетсяС = "exec sp_execute"; НоваяСтрока.ВидСобытия = Перечисления.ВидыСобытийЗапросов.ВызовПодготовленногоОператора;
	НоваяСтрока = ВидыСобытий.Добавить(); НоваяСтрока.НачинаетсяС = "exec sp_unprepare "; НоваяСтрока.ВидСобытия = Перечисления.ВидыСобытийЗапросов.РазрушениеПодготовленногоОператора;
	НоваяСтрока = ВидыСобытий.Добавить(); НоваяСтрока.НачинаетсяС = "insert bulk "; НоваяСтрока.ВидСобытия = Перечисления.ВидыСобытийЗапросов.ПотоковаяВставкаВВременнуюТаблицу;
	
	Возврат ВидыСобытий
	
КонецФункции

Функция ДанныеПозицийXML()
	
	Номера = Новый Структура; 
	
	// Для rpc_completed
	Структура = Новый Структура;
	Структура.Вставить("name", "rpc_completed"); 
	Структура.Вставить("session_id", 0); 
	Структура.Вставить("event_sequence", 1); 
	Структура.Вставить("duration", 1); 
	Структура.Вставить("result", 6); 
	Структура.Вставить("row_count", 7); 
	Структура.Вставить("batch_text", 10);
	
	ПодстрокиИсключения = Новый Массив;
	ПодстрокиИсключения.Добавить("FROM dbo._InternalSettings ");
	ПодстрокиИсключения.Добавить("FROM Config ");
	ПодстрокиИсключения.Добавить("FROM dbo._SystemSettings ");
	
	ПодстрокиИсключения.Добавить("select * from #tt");
	ПодстрокиИсключения.Добавить(" dbo._UsersWorkHistory");
	ПодстрокиИсключения.Добавить("FROM dbo._CommonSettings");
	ПодстрокиИсключения.Добавить("FROM dbo._ExtensionsInfo");
	ПодстрокиИсключения.Добавить("FROM v8users");
	ПодстрокиИсключения.Добавить("FROM Files ");
	ПодстрокиИсключения.Добавить("FROM Params ");
	ПодстрокиИсключения.Добавить("FROM ConfigCAS ");
	ПодстрокиИсключения.Добавить("FROM V8USERPWDPLCS");
	ПодстрокиИсключения.Добавить("FROM dbo._FrmDtSettings");
	ПодстрокиИсключения.Добавить("FROM dbo._ExtensionsRestruct");
	ПодстрокиИсключения.Добавить("FROM dbo._ErrorProcessingSettings");
	ПодстрокиИсключения.Добавить("FROM dbo._URLExternalData");
	ПодстрокиИсключения.Добавить("FROM dbo._RepSettings");
	ПодстрокиИсключения.Добавить("sys.database_principals");
	ПодстрокиИсключения.Добавить("sys.all_objects");
	ПодстрокиИсключения.Добавить(" sys.indexes ");
	ПодстрокиИсключения.Добавить("FROM dbo._RepVarSettings");
	ПодстрокиИсключения.Добавить("FROM dbo._DynListSettings");
	ПодстрокиИсключения.Добавить("FROM ConfigSave");
	
	Структура.Вставить("ПодстрокиИсключения", ПодстрокиИсключения);
	
	Номера.Вставить("rpc_completed", Структура);
	
	// Для sql_batch_completed
	Структура = Новый Структура;
	Структура.Вставить("name", "sql_batch_completed"); 
	Структура.Вставить("session_id", 0); 
	Структура.Вставить("event_sequence", 1); 
	Структура.Вставить("duration", 1); 
	Структура.Вставить("row_count", 7); 
	Структура.Вставить("result", 8); 
	Структура.Вставить("batch_text", 9);
	
	ПодстрокиИсключения = Новый Массив;
	ПодстрокиИсключения.Добавить("COMMIT TRANSACTION");
	ПодстрокиИсключения.Добавить("SET TRANSACTION");
	ПодстрокиИсключения.Добавить("ROLLBACK TRANSACTION");
	ПодстрокиИсключения.Добавить("SELECT 1 WHERE OBJECT_ID('tempdb..#tt");
	//ПодстрокиИсключения.Добавить(СтрШаблон("SELECT%1%2CAST(COUNT_BIG(*) AS NUMERIC(12))%1%2FROM #tt", Символ(13), Символ(10)));
	ПодстрокиИсключения.Добавить(СтрШаблон("SELECT%1CAST(COUNT_BIG(*) AS NUMERIC(12))%1FROM #tt", Символ(10)));
	
	//ПодстрокиИсключения.Добавить("insert bulk #tt");
	ПодстрокиИсключения.Добавить("select databasepropertyex");
	ПодстрокиИсключения.Добавить("select xtype from sys.sysobjects");
	ПодстрокиИсключения.Добавить("Select count(*)");
	ПодстрокиИсключения.Добавить("select count(*)");
	ПодстрокиИсключения.Добавить("SET LOCK_TIMEOUT");
	ПодстрокиИсключения.Добавить("SET ARITHABORT");
	ПодстрокиИсключения.Добавить("SET DATEFIRST");
	ПодстрокиИсключения.Добавить("SET XACT_ABORT");
	ПодстрокиИсключения.Добавить("select Offset");
	ПодстрокиИсключения.Добавить("select @@max_precision");
	ПодстрокиИсключения.Добавить("FROM sys.databases ");
	ПодстрокиИсключения.Добавить("FROM master.dbo.sysprocesses ");
	ПодстрокиИсключения.Добавить("SELECT @@TRANCOUNT");
	ПодстрокиИсключения.Добавить("SELECT DATABASEPROPERTYEX");
	ПодстрокиИсключения.Добавить("SELECT @@SPID");
	ПодстрокиИсключения.Добавить("FROM dbo._ExtensionsInfo");
	ПодстрокиИсключения.Добавить(" master.sys");
	
	Структура.Вставить("ПодстрокиИсключения", ПодстрокиИсключения);
	
	Номера.Вставить("sql_batch_completed", Структура);

	Возврат Номера;
	
КонецФункции

// Преобразует дату MS SQL формата timestamp в дату 1С
Функция timestampВФормат1С(Строка, ДобавитьЧасыКДатеПриЗагрузке)
	
	Дата = Дата(СтрШаблон("%1%2%3%4%5%6", Сред(Строка, 1, 4), Сред(Строка, 6, 2), Сред(Строка, 9, 2), Сред(Строка, 12, 2), Сред(Строка, 15, 2), Сред(Строка, 18, 2)));
	Дата = Дата + ДобавитьЧасыКДатеПриЗагрузке * 3600;
	Возврат Дата 
	
КонецФункции

Процедура УстановитьСоединениеСВнешнимиИсточникамиДанных(ДопПараметры)
				
	Если ВнешниеИсточникиДанных.РасширенныеСобытия.ПолучитьСостояние() = СостояниеВнешнегоИсточникаДанных.Отключен Тогда
		ПараметрыСоединения = Новый ПараметрыСоединенияВнешнегоИсточникаДанных;
		ПараметрыСоединения.СУБД 				= "MSSQLServer";
		ПараметрыСоединения.СтрокаСоединения 	= ДопПараметры.ПараметрыТеста.СтрокаПодключенияКБазеСобытий;
		ПараметрыСоединения.ИмяПользователя 	= ДопПараметры.ПараметрыТеста.ПользовательБазыСобытий;
		ПараметрыСоединения.Пароль 				= ДопПараметры.ПараметрыТеста.ПарольБазыСобытий;
		
		ВнешниеИсточникиДанных.РасширенныеСобытия.УстановитьОбщиеПараметрыСоединения(ПараметрыСоединения);
		ВнешниеИсточникиДанных.РасширенныеСобытия.УстановитьСоединение(); 
	КонецЕсли;
		
КонецПроцедуры

Функция РезультатИзБазы(НастройкаТеста, ПараметрыТеста, ЭтапОбработки, ЗаголовокСообщения, МаксID)
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	//|ВЫБРАТЬ ПЕРВЫЕ 100000
	|ВЫБРАТЬ //%Первые%
	|	name КАК ИмяСобытия,   
	|	session_id КАК НомерСессии,
	|	timestamp КАК timestamp,
	|	event_sequence КАК НомерСобытия,
	|	ВЫРАЗИТЬ(duration / 1000 КАК ЧИСЛО(10)) КАК ДлительностьВыполненияMSSQL,
	|	ВЫБОР
	|		КОГДА result = ""OK""
	|			ТОГДА """"
	|		ИНАЧЕ result
	|	КОНЕЦ КАК ТекстОшибки,
	|	ВЫБОР
	|		КОГДА name = ""rpc_completed""
	|			ТОГДА statement
	|		ИНАЧЕ batch_text
	|	КОНЕЦ КАК ТекстЗапросаMSSQL,
	|	row_count КАК КоличествоСтрокMSSQL,
	|	ID КАК ID
	|ИЗ
	|  	ВнешнийИсточникДанных.РасширенныеСобытия.Таблица.dbo_QueryAnalysis
	|//%Отбор%
	|УПОРЯДОЧИТЬ ПО 
	|	ID Возр
	|";
	
	Если ПараметрыТеста.ПорцияЗагрузкиДанных = 0 Тогда 
		
		ЗаголовокСообщения = "Загрузка данных";
		ТекстСообещения = "Чтение всех данных из базы расширенных событий";
		
	Иначе

		Запрос.Текст = СтрЗаменить(Запрос.Текст, "//%Первые%", СтрШаблон("ПЕРВЫЕ %1", Формат(ПараметрыТеста.ПорцияЗагрузкиДанных, "ЧГ=0")));
		Если ЗначениеЗаполнено(ЭтапОбработки.ТекущееID) Тогда
			Запрос.Текст = СтрЗаменить(Запрос.Текст, "//%Отбор%", СтрШаблон("ГДЕ%1ID > %2", Символы.ПС, Формат(ЭтапОбработки.ТекущееID, "ЧГ=0")));
		КонецЕсли;
		
		ЗапросКоличество = Новый Запрос;
		ЗапросКоличество.Текст = "
		|ВЫБРАТЬ
		|	Максимум(ID) КАК МаксID   
		|ИЗ
		|  	ВнешнийИсточникДанных.РасширенныеСобытия.Таблица.dbo_QueryAnalysis
		|";
		
		РезультатЗапроса = ЗапросКоличество.Выполнить();
		ВыборкаID = РезультатЗапроса.Выбрать();
		ВыборкаID.Следующий();
		МаксID = ВыборкаID.МаксID;
		
		Итераций = Цел(МаксID / ПараметрыТеста.ПорцияЗагрузкиДанных) + ?(МаксID % ПараметрыТеста.ПорцияЗагрузкиДанных > 0, 1, 0);
		
		ЗаголовокСообщения = СтрШаблон("Загрузка данных. Итерация %1 из %2", ЭтапОбработки.НомерИтерации, Итераций);
		ТекстСообещения = СтрШаблон("Чтение данных из базы расширенных событий %1 записей", ПараметрыТеста.ПорцияЗагрузкиДанных);
		
	КонецЕсли;
	
	НастройкаТестовСервер.СообщитьПрогрессаЭтапа(ЗаголовокСообщения, ТекстСообещения);
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();

	Возврат Выборка;
	
КонецФункции

Функция ПереходящиеПодготовленныеОператоры(НастройкаТеста)
	
	РезультатЗапроса = ИТМ_ОбщегоНазначенияСервер.ПолучитьРезультатЗапросаПоТаблице(
		"РегистрСведений.ПереходящиеПодготовленныеОператоры",
		,,,
		"ИмяОператора, ЭтоВременнаяТаблица",
		"НастройкаТеста = &НастройкаТеста",
		Новый Структура("НастройкаТеста", НастройкаТеста));
	Результат = РезультатЗапроса.Выгрузить();
	Возврат Результат;
	
КонецФункции

Процедура УточнитьВидПодготовленогоОператора(НоваяЗапись, ПодгОперВТ)

	// Пока только для ВТ
	Если 	НоваяЗапись.ВидСобытия = Перечисления.ВидыСобытийЗапросов.ОпределениеПодготовленногоОператора 
			Или НоваяЗапись.ВидСобытия = Перечисления.ВидыСобытийЗапросов.ВызовПодготовленногоОператора 
			Или НоваяЗапись.ВидСобытия = Перечисления.ВидыСобытийЗапросов.РазрушениеПодготовленногоОператора Тогда
			
		ИмяОператора = НастройкаТестовСервер.ИмяПодготовленногоОператора(НоваяЗапись);
		Если НоваяЗапись.ВидСобытия = Перечисления.ВидыСобытийЗапросов.ОпределениеПодготовленногоОператора Тогда 
			
			Если СтрНайти(НоваяЗапись.ТекстЗапросаMSSQL, ",N'INSERT INTO #tt") > 0 Тогда
				
				НоваяСтрока = ПодгОперВТ.Добавить();
				НоваяСтрока.ЭтоВременнаяТаблица = Истина;
				НоваяСтрока.ИмяОператора = ИмяОператора;
				НоваяЗапись.ВидСобытия = Перечисления.ВидыСобытийЗапросов.ОпределениеПодготовленногоОператораВТ;
				
			КонецЕсли;	
			
		Иначе

			Строки = ПодгОперВТ.НайтиСтроки(Новый Структура("ИмяОператора, ЭтоВременнаяТаблица", ИмяОператора, Истина));
			Если ЗначениеЗаполнено(Строки) Тогда
				
				Если НоваяЗапись.ВидСобытия = Перечисления.ВидыСобытийЗапросов.ВызовПодготовленногоОператора Тогда
					НоваяЗапись.ВидСобытия = Перечисления.ВидыСобытийЗапросов.ВызовПодготовленногоОператораВТ;
				Иначе
					НоваяЗапись.ВидСобытия = Перечисления.ВидыСобытийЗапросов.РазрушениеПодготовленногоОператораВТ;
					ПодгОперВТ.Удалить(Строки[0]);
				КонецЕсли;                                                                                        
				
			//Иначе
			//	
			//	НоваяЗапись.ВидОшибки = Перечисления.ВидыОшибокЗапросов.ОшибкаMSSQL;
			//	НоваяЗапись.ТекстОшибки = "Пропущено создание подготовленного оператора";
			//	
			КонецЕсли;
			
		КонецЕсли;
	КонецЕсли;
		
КонецПроцедуры

Процедура СохранитьПереходящиеОператоры(НастройкаТеста, ПодгОперВТ)
	
	НаборЗаписей = РегистрыСведений.ПереходящиеПодготовленныеОператоры.СоздатьНаборЗаписей(); 
	НаборЗаписей.Отбор.НастройкаТеста.Установить(НастройкаТеста);
	
	ПодгОперВТ.Свернуть("ИмяОператора,ЭтоВременнаяТаблица");
	ПодгОперВТ.Колонки.Добавить("НастройкаТеста", Новый ОписаниеТипов("СправочникСсылка.НастройкаТеста"));
	ПодгОперВТ.ЗаполнитьЗначения(НастройкаТеста, "НастройкаТеста");
	НаборЗаписей.Загрузить(ПодгОперВТ);
	НаборЗаписей.Записать(Истина);
	
КонецПроцедуры


#КонецОбласти

