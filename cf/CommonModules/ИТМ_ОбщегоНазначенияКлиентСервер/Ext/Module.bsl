﻿

Функция ФайлСуществует(ПолноеИмяФайла) Экспорт
	Файл = Новый Файл(ПолноеИмяФайла);
	Возврат Файл.Существует();
КонецФункции

Функция СериализоватьОбъект(Значение) Экспорт
    
    ЗаписьXML = Новый ЗаписьXML();
    ЗаписьXML.УстановитьСтроку();
	#Если Не ВебКлиент Тогда
    	СериализаторXDTO.ЗаписатьXML(ЗаписьXML, Значение);
	#Иначе
		ВызватьИсключение "Объект СериализаторXDTO не доступен в ВебКлиенте";
	#КонецЕсли
    СтрокаXML = ЗаписьXML.Закрыть();    
    
    Возврат СтрокаXML;
    
КонецФункции
 
Функция ДеСериализоватьОбъект(СтрокаXML) Экспорт
    
	ЧтениеXML = Новый ЧтениеXML();
    ЧтениеXML.УстановитьСтроку(СтрокаXML);
    
	Попытка
		#Если Не ВебКлиент Тогда
        Значение = СериализаторXDTO.ПрочитатьXML(ЧтениеXML);
		#Иначе
		ВызватьИсключение "Объект СериализаторXDTO не доступен в ВебКлиенте";
		#КонецЕсли
    Исключение
        Значение = Неопределено;
    КонецПопытки;
    
    Возврат Значение;
    
КонецФункции

Функция ПолучитьСледующийПодномер(Знач ТекНомер, Разделитель = "") Экспорт
	Если Не ЗначениеЗаполнено(Разделитель) Тогда
		Разделитель = "/";
	КонецЕсли;
	
	Счетчик = 0;
	Если Найти(ТекНомер, Разделитель) > 0 Тогда
		РазделенныйНомер = СтрРазделить(ТекНомер, Разделитель, Ложь);
		ТекНомер = СокрЛП(РазделенныйНомер[0]);
		Счетчик = Число(СокрЛП(РазделенныйНомер[1]));
	КонецЕсли;
	
	Счетчик = Счетчик + 1;
	
	Возврат СокрЛП(ТекНомер) + Разделитель + Счетчик;
КонецФункции

//18.11.2020 Шакун Денис: AUTOOPT
// Преобразует таблицу формы в массив структур. В первом элементе структура колонок.
//
// Параметры:
//  ТаблицаФормы - ДанныеФормыКоллекция - исходная таблица значений.
//  Колонки      - Строка               - наименования колонок для копирования.
//
// Возвращаемое значение:
//  Массив - коллекция строк таблицы в виде структур.
//
Функция ТаблицаФормыВМассив(ТаблицаФормы, Колонки, ПерваяПустаяСтруктура = Истина, СИдентификаторамиСтрок = Ложь) Экспорт
	
	Массив = Новый Массив;
	НоваяСтрока = Новый Структура(Колонки);
	// << 22.11.2022 Данилов Артур: AUTOOPT-2154
	Если СИдентификаторамиСтрок Тогда
		НоваяСтрока.Вставить("_ИдентификаторСтроки");
	КонецЕсли;
	// >> 22.11.2022 Данилов Артур
	Если ПерваяПустаяСтруктура Тогда
		Массив.Добавить(НоваяСтрока);
	КонецЕсли;
	Если ТаблицаФормы.Количество() = 0 Тогда
		Возврат Массив;
	КонецЕсли;
	Для Каждого Строка Из ТаблицаФормы Цикл
		НоваяСтрока = Новый Структура(Колонки);
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);
		// << 22.11.2022 Данилов Артур: AUTOOPT-2154
		Если СИдентификаторамиСтрок Тогда
			НоваяСтрока.Вставить("_ИдентификаторСтроки", Строка.ПолучитьИдентификатор());
		КонецЕсли;
		// >> 22.11.2022 Данилов Артур
		Массив.Добавить(НоваяСтрока);
	КонецЦикла;
	Возврат Массив;

КонецФункции

// 27.11.2020 Леонов Александр:
Процедура ДобавитьСвязьПараметровВыбора(ЭлементФормы, Имя, ПутьКДанным) Экспорт
	
	МассивСвязей = Новый Массив();
	МассивСвязей.Добавить(Новый СвязьПараметраВыбора(Имя, ПутьКДанным));
	
	Для Каждого ЭлементСвязи Из ЭлементФормы.СвязиПараметровВыбора Цикл
		МассивСвязей.Добавить(ЭлементСвязи);
	КонецЦикла;
	
	НовыеСвязи = Новый ФиксированныйМассив(МассивСвязей);
	ЭлементФормы.СвязиПараметровВыбора = НовыеСвязи;

КонецПроцедуры

Процедура ДобавитьПараметрВыбора(ЭлементФормы, Имя, Значение) Экспорт
	
	Если ТипЗнч(Значение) = Тип("Массив") Тогда
		Значение = Новый ФиксированныйМассив(Значение);
	ИначеЕсли ТипЗнч(Значение) = Тип("СписокЗначений") Тогда
		Значение = Новый ФиксированныйМассив(Значение.ВыгрузитьЗначения());
	КонецЕсли;
	
	МассивПараметров = Новый Массив();
	МассивПараметров.Добавить(Новый ПараметрВыбора(Имя, Значение));
	
	Для Каждого ЭлементСвязи Из ЭлементФормы.ПараметрыВыбора Цикл
		МассивПараметров.Добавить(ЭлементСвязи);
	КонецЦикла;
	
	НовыеПараметрыВыбора = Новый ФиксированныйМассив(МассивПараметров);
	ЭлементФормы.ПараметрыВыбора = НовыеПараметрыВыбора;
	
КонецПроцедуры

Процедура ЗаписатьТекстовыйФайл(ИмяФайла, СодержимоеФайла) Экспорт

	ТекстовыйФайл = Новый ТекстовыйДокумент;
	ТекстовыйФайл.УстановитьТекст(СодержимоеФайла);
	ТекстовыйФайл.Записать(ИмяФайла);
	
КонецПроцедуры

// 24.02.2021 Леонов Александр: AUTOOPT
Функция ТаблицаHTMLПоТабличномуДокументу(ТабличныйДокумент) Экспорт 

	Результат = "";
	#Если Не ВебКлиент Тогда
		ИмяФайла = ПолучитьИмяВременногоФайла("html");
	#Иначе
		ИмяФайла = "ВремФайл.html";
	#КонецЕсли
	
	ТабличныйДокумент.Записать(ИмяФайла, ТипФайлаТабличногоДокумента.HTML3);
	ТекстHTML = ПрочитатьТекстовыйФайл(ИмяФайла);
	УдалитьФайлы(ИмяФайла);

	ТекстHTML = Прав(ТекстHTML, СтрДлина(ТекстHTML)-144);
	
	ТекстЗамены = "
	|</BODY>
	|</HTML>";
	ТекстHTML = СтрЗаменить(ТекстHTML, ТекстЗамены, "");
	
	Возврат ТекстHTML;
КонецФункции

Функция ПрочитатьТекстовыйФайл(ПолноеИмяФайла) Экспорт
	
	ТекстовыйФайл = Новый ТекстовыйДокумент;
	ТекстовыйФайл.Прочитать(ПолноеИмяФайла);
	
	Возврат ТекстовыйФайл.ПолучитьТекст();
	
КонецФункции

//16.07.2021 Иванов Виталий: AUTOOPT
Функция УдалитьНедопустимыеСимволы(Строка, НедопустимыеСимволы = "") Экспорт
	
	Если НедопустимыеСимволы = "" Тогда
		НедопустимыеСимволы = """'`/\[]{}:;|-=?*<>,.()+#№@!%^&~«»";
		НедопустимыеСимволы = НедопустимыеСимволы + Символы.ПС + Символы.ВК + Символы.Таб + Символы.ПФ + Символы.ВТаб + Символы.НПП;
	КонецЕсли;
	
	Возврат СтрСоединить(СтрРазделить(Строка, НедопустимыеСимволы, Истина));
	
КонецФункции

//26.05.2022 Данилов Артур: AUTOOPT
Функция ОставитьТолькоДопустимыеСимволы(Знач Строка, ДопустимыеСимволы = "") Экспорт
	
	НедопустимыеСимволы = СтрРазделить(Строка, ДопустимыеСимволы, Ложь);
	Для каждого НедопустимыйСимвол Из НедопустимыеСимволы Цикл
		Строка = СтрЗаменить(Строка, НедопустимыйСимвол, "");
	КонецЦикла;
	
	Возврат Строка;
	
КонецФункции

//07.09.2021 Шакун Денис: AUTOOPT
Функция РазрешеноИспользованиеФункционала(СтрокаОграничения) Экспорт
	Если Найти(ИТМ_ОбщегоНазначенияПовтИсп.ЗначениеКонстанты("ИТМ_СтрокаОграниченияФункционала",Ложь),СтрокаОграничения) = 0 Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
КонецФункции

//16.09.2021 Шакун Денис: AUTOOPT-993
Процедура ДополнитьСписок(СписокПриемник, СписокИсточник, ТолькоУникальныеЗначения = Ложь) Экспорт
	
	Если ТолькоУникальныеЗначения Тогда
		
		УникальныеЗначения = Новый Соответствие;
		
		Для Каждого ЭлементСписка Из СписокПриемник Цикл
			УникальныеЗначения.Вставить(ЭлементСписка.Значение, Истина);
		КонецЦикла;
		
		Для Каждого ЭлементСписка Из СписокИсточник Цикл
			Если УникальныеЗначения[ЭлементСписка.Значение] = Неопределено Тогда
				СписокПриемник.Добавить(ЭлементСписка.Значение,ЭлементСписка.Представление,ЭлементСписка.Пометка,ЭлементСписка.Картинка);
				УникальныеЗначения.Вставить(ЭлементСписка.Значение, Истина);
			КонецЕсли;
		КонецЦикла;
		
	Иначе
		
		Для Каждого ЭлементСписка Из СписокИсточник Цикл
			СписокПриемник.Добавить(ЭлементСписка.Значение,ЭлементСписка.Представление,ЭлементСписка.Пометка,ЭлементСписка.Картинка);
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

// 12.10.2021 Берлизов Сергей: AUTOOPT-
Функция ОсновныеРасширенияФайловИзображений() Экспорт 
	РасширенияФайлов = Новый Массив;
	РасширенияФайлов.Добавить("jpg");
	РасширенияФайлов.Добавить("jpeg");
	РасширенияФайлов.Добавить("bmp");
	РасширенияФайлов.Добавить("png");
	РасширенияФайлов.Добавить("dib");
	РасширенияФайлов.Добавить("rle");
	РасширенияФайлов.Добавить("tif");
	РасширенияФайлов.Добавить("wmf");
	РасширенияФайлов.Добавить("emf");
	РасширенияФайлов.Добавить("ECW");
	РасширенияФайлов.Добавить("GIF");
	РасширенияФайлов.Добавить("ICO");
	РасширенияФайлов.Добавить("ILBM");
	РасширенияФайлов.Добавить("jp2");
	РасширенияФайлов.Добавить("MrSID");
	РасширенияФайлов.Добавить("PCX");
	РасширенияФайлов.Добавить("PSD");
	РасширенияФайлов.Добавить("TGA");
	РасширенияФайлов.Добавить("TIFF");
	РасширенияФайлов.Добавить("WebP");
	РасширенияФайлов.Добавить("XBM");
	РасширенияФайлов.Добавить("XPS");
	РасширенияФайлов.Добавить("RLA");
	РасширенияФайлов.Добавить("RPF");
	РасширенияФайлов.Добавить("PNM");
	РасширенияФайлов.Добавить("pdf");
	РасширенияФайлов.Добавить("DjVu");
	РасширенияФайлов.Добавить("CGM");
	Возврат РасширенияФайлов;			
КонецФункции

///{+ 2021.11.10 16:47:50, #Лелеко #AUTOOPT   
 // Проверяет наличие свойства у объекта и получает его по аналогии со Структура.Свойство('Имя', [Значение])
 // Версия: 1.1.4.4.-
 // Параметры:
 //  Объект  - произвольный - некий объект
 //  Свойство - Строка, Массив, Структура, Соответствие - имя искомого свойства/свойствоов, в случае не одного имени имена считаются равнозначными и допустимыми, возвращется первое найденное
 //		1. Строка 			- имя проверяемого свойства или имена равнозначных свойствоов через ',' (тогда будет возвращен первый найденный, удовлетворяющий условиям)
 //		2. Массив 			- массив имен свойствоов
 //		3. Структура 		- структура, содержащая в ключах имена свойствоов
 //		4. Соответствие 	- соответсвие, содержащее в ключах имена свойствоов
 //	ЗначениеСвойства - Произвольный - (возвращаемый) значение свойства, если был найден, иначе - неизменное значение            
 //  СтрогийТип - Тип, ОписаниеТипов, Строка - дополнительная проверка найденного свойства на соответсвие типу, если свойство не соответсвует типу, то он не возвращается, поиск продолжается
 //		*. Строка - строка, содержащая имена подлежащих типов через ','
 //	ДополнительныеПараметры - Структура - (передаваемый / возвращаемый) 
 //		1. {ИмяНайденного, [Строка]} - (возвращаемый) имя найденного свойства, если был найден, имеет смысл если в качестве искомого выступало более чем одно имя
 // Возвращаемое значение:
 //   Булево - истина, если свойство есть, ложь - иначе
Функция ЕстьСвойствоОбъекта(Объект, Знач Свойство, ЗначениеСвойстваOut = Неопределено, Знач СтрогийТип = Неопределено, ДополнительныеПараметры = Неопределено) ЭКСПОРТ
	
	Перем КлючУникальности, ТипСвойство, ТипСтрогогоТипа, МассивТипов, ЗначениеСвойстваПоКлючу;
	
	Если Объект = Неопределено Тогда 
		Возврат Ложь; 
	КонецЕсли;
	
	Если (ДополнительныеПараметры = Неопределено) 
		Тогда ДополнительныеПараметры = Новый Структура;
	КонецЕсли;
 	
 	ТипСвойство = ТипЗнч(Свойство); // Конвертируем свойство в структуру
	Если ТипСвойство = Тип("Строка") Тогда 
		Свойство = Новый Структура(Свойство);
 	ИначеЕсли ТипСвойство = Тип("Структура") Тогда ;
	ИначеЕсли ТипСвойство = Тип("ФиксированнаяСтруктура")
		Тогда Свойство = Новый Структура(Свойство);
	ИначеЕсли ТипСвойство = Тип("Массив") ИЛИ ТипСвойство = Тип("ФиксированныйМассив") Тогда 
		СтарыйСвойство = Свойство; 
		Свойство = Новый Структура; 
		Для Каждого Подсвойство Из СтарыйСвойство Цикл 
			Если (НЕ Свойство.Свойство(Строка(Подсвойство))) Тогда 
				Свойство.Вставить(Строка(Подсвойство)); 
			КонецЕсли; 
		КонецЦикла; 
	ИначеЕсли ТипСвойство = Тип("Соответствие") ИЛИ ТипСвойство = Тип("ФиксированноеСоответствие") 	Тогда 
		СтарыйСвойство = Свойство; 
		Свойство = Новый Структура; 
		Для Каждого Подсвойство Из СтарыйСвойство Цикл 
			Свойство.Вставить(Строка(Подсвойство.Ключ)); 
		КонецЦикла; 
	Иначе 
		Свойство = Новый Структура(Свойство);
 	КонецЕсли; 
 	
 	КлючУникальности = Новый УникальныйИдентификатор; 	// Заполняем данные значением ключа уникальности (ЗЗС его перезатрет)
	Для Каждого КлючЗначение Из Свойство Цикл 
		Свойство[КлючЗначение.Ключ] = КлючУникальности; 
	КонецЦикла;  
 	ЗаполнитьЗначенияСвойств(Свойство, Объект);			// Заполняем данные из источника
 	
 	Если СтрогийТип <> Неопределено Тогда // Фишка со строгим контролем типа
 		ТипСтрогогоТипа = ТипЗнч(СтрогийТип);
		Если ТипСтрогогоТипа = Тип("Тип") Тогда 
			МассивТипов = Новый Массив(); 
			МассивТипов.Добавить(СтрогийТип); 
			СтрогийТип = Новый ОписаниеТипов(МассивТипов);  	// Тип -> МассивТипов -> ОписаниеТипов
 		ИначеЕсли ТипСтрогогоТипа = Тип("ОписаниеТипов") Тогда ; 																												// ОписаниеТипов
		ИначеЕсли ТипСтрогогоТипа = Тип("Массив") Тогда 
			СтрогийТип = Новый ОписаниеТипов(СтрогийТип); 		// Массив -> ОписаниеТипов
		ИначеЕсли ТипСтрогогоТипа = Тип("ФиксированныйМассив") Тогда 
			СтрогийТип = Новый ОписаниеТипов(Новый Массив(СтрогийТип)); 	// ФиксированныйМассив -> Массив -> ОписаниеТипов
		ИначеЕсли ТипСтрогогоТипа = Тип("Строка") Тогда 
			СтрогийТип = Новый ОписаниеТипов(СтрогийТип); 		// Строка -> ОписаниеТипов
		Иначе 
			СтрогийТип = Новый ОписаниеТипов(СтрогийТип); 
 		КонецЕсли; 	                           
 	КонецЕсли;
 	
 	Для Каждого КлючЗначение Из Свойство Цикл
 		ЗначениеСвойстваПоКлючу = КлючЗначение.Значение;
		Если (ЗначениеСвойстваПоКлючу <> КлючУникальности) Тогда 
			Если (СтрогийТип = Неопределено) ИЛИ СтрогийТип.СодержитТип(ТипЗнч(ЗначениеСвойстваПоКлючу)) Тогда 
				ЗначениеСвойстваOut = ЗначениеСвойстваПоКлючу; 
				Если ДополнительныеПараметры.Свойство("ИмяНайденного") Тогда 
					ДополнительныеПараметры["ИмяНайденного"] = КлючЗначение.Ключ; 
				Иначе 
					ДополнительныеПараметры.Вставить("ИмяНайденного", КлючЗначение.Ключ); 
				КонецЕсли; 
				Возврат Истина; 
			КонецЕсли; 
		КонецЕсли;
 	КонецЦикла;
 	
	Возврат Ложь;
	
КонецФункции //+} #Лелеко 2021.11.10 16:47:50 

//{+ #Лелеко 2021.11.17 15:54:58 AUTOOPT
// Обертка для стандартной функции 'СтрШаблон' которая позволяет передавать массив параметров
// Параметры:                                                                                
//	Шаблон - Строка - Строка, содержащая маркеры подстановки вида: "%1..%N". Нумерация маркеров начинается с 1. N не может быть больше 10. 
//	Параметры - Массив - массив параметров для подстановки
// Возвращаемое значение:
//	Строка - Строка шаблона с подставленными параметрами
Функция СтрШаблонПарам(Шаблон, Параметры) ЭКСПОРТ
	
	Перем Результат, Количество;
	
	Количество = Параметры.Количество();
	Если Количество = 0 Тогда
		Результат = Шаблон;
	ИначеЕсли Количество = 1 Тогда
		Результат = СтрШаблон(Шаблон, Параметры[0]);
    ИначеЕсли Количество = 2 Тогда
		Результат = СтрШаблон(Шаблон, Параметры[0], Параметры[1]);
    ИначеЕсли Количество = 3 Тогда
		Результат = СтрШаблон(Шаблон, Параметры[0], Параметры[1], Параметры[2]);
    ИначеЕсли Количество = 4 Тогда
		Результат = СтрШаблон(Шаблон, Параметры[0], Параметры[1], Параметры[2], Параметры[3]);
    ИначеЕсли Количество = 5 Тогда
		Результат = СтрШаблон(Шаблон, Параметры[0], Параметры[1], Параметры[2], Параметры[3], Параметры[4]);
    ИначеЕсли Количество = 6 Тогда
		Результат = СтрШаблон(Шаблон, Параметры[0], Параметры[1], Параметры[2], Параметры[3], Параметры[4], Параметры[5]);
    ИначеЕсли Количество = 7 Тогда
		Результат = СтрШаблон(Шаблон, Параметры[0], Параметры[1], Параметры[2], Параметры[3], Параметры[4], Параметры[5], Параметры[6]);
	ИначеЕсли Количество = 8 Тогда
		Результат = СтрШаблон(Шаблон, Параметры[0], Параметры[1], Параметры[2], Параметры[3], Параметры[4], Параметры[5], Параметры[6], Параметры[7]);
	ИначеЕсли Количество = 9 Тогда
		Результат = СтрШаблон(Шаблон, Параметры[0], Параметры[1], Параметры[2], Параметры[3], Параметры[4], Параметры[5], Параметры[6], Параметры[7], Параметры[8]);	
	ИначеЕсли Количество = 10 Тогда
		Результат = СтрШаблон(Шаблон, Параметры[0], Параметры[1], Параметры[2], Параметры[3], Параметры[4], Параметры[5], Параметры[6], Параметры[7], Параметры[8], Параметры[9]);
	Иначе
		ВызватьИсключение "Стандарт функции 'СтрШаблон' от 1С не предполагает более 10 параметров";	
	КонецЕсли;

	Возврат Результат;
	
КонецФункции //+} #Лелеко 2021.11.17 15:54:58 

// << 23.11.2021 Берлизов Сергей

// Возвращает массив с выделенными подстроками, обрамленными заданными символами из исходной строки.
// Например ЗначенияПараметровИзСтроки("По текущему заказу [ЗаказКлиента] назначена машина [МашинаОгрузки]") вернет массив из элементов "ЗаказКлиента" и "МашинаОгрузки"
// Параметры:
// 	СтрокаСПараметрами - Строка - Исходная строка, в которой заданы шаблоны - подстроки обрамленные парами из подстрок начала и окончания
//	ПодстрокаНачала - Строка - Указывает на начало параметра
//	ПодстрокаОкончания - Строка - Указывает на окончание параметра
//	ВыдаватьОшибку - булево - вызывать исключение, если некорректно задана СтрокаСПараметрами - непарные ПодстрокаНачала и ПодстрокаОкончания или несооветствует их количество друг другу
// Возвращаемое значение:
// 	Массив из подстрок, выделенных из текущей строки шаблона
Функция ПараметрыИзСтроки(Знач СтрокаСПараметрами, ПодстрокаНачала = "[", ПодстрокаОкончания = "]", ВыдаватьОшибку = Ложь) Экспорт
	Результат = Новый Массив;
	ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("Некорректно задана строка шаблонов с параметрами:%4""%1"".%4Подстрока начала ""%2"".%4Подстрока окончания ""%3""",
		СтрокаСПараметрами,
		ПодстрокаНачала,
		ПодстрокаОкончания,
		Символы.ПС);
	Если ЗначениеЗаполнено(СтрокаСПараметрами) Тогда
		ЧислоВхождений = СтрЧислоВхождений(СтрокаСПараметрами, ПодстрокаНачала);
		ЧислоВхожденийОкончания = СтрЧислоВхождений(СтрокаСПараметрами, ПодстрокаОкончания);
		Если ВыдаватьОшибку И ЧислоВхождений <> ЧислоВхожденийОкончания Тогда
			ВызватьИсключение ТекстОшибки;	
		КонецЕсли;
		Если ЧислоВхождений > 0 Тогда
			Для Сч = 1 По ЧислоВхождений Цикл
				ПозицияНачала = СтрНайти(СтрокаСПараметрами, ПодстрокаНачала, НаправлениеПоиска.СНачала, 1, Сч) + СтрДлина(ПодстрокаНачала);
				ПозицияКонца = СтрНайти(СтрокаСПараметрами, ПодстрокаОкончания, НаправлениеПоиска.СНачала, 1, Сч);
				Если ПозицияНачала < ПозицияКонца И ЗначениеЗаполнено(ПозицияНачала) Тогда
					Параметр = Сред(СтрокаСПараметрами, ПозицияНачала, ПозицияКонца - ПозицияНачала);
					Результат.Добавить(Параметр);
				ИначеЕсли ВыдаватьОшибку Тогда	
					ВызватьИсключение ТекстОшибки;	
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	Результат = ОбщегоНазначенияКлиентСервер.СвернутьМассив(Результат);
	Возврат Результат;
КонецФункции

// Заменяет в строке параметры - подстроками обрамленными ПодстрокаНачала и ПодстрокаОкончания на соовтетсвующие значения из структуры Параметры.
// Автоматически выполняется замена текста для получения гиперссылок ссылочных параметров, если перед ПодстрокаНачала стоит "n|", а после ПодстрокаОкончания идет "|n".
// Представление ссылки для формирования текста гиперссылки ищется в ПоляШаблона, по следующим правилам: 
// 	1. К имени параметра добавляется "Представление", (например Имя параметра ЗаказКлиента, а Имя параметра представления "ЗаказКлиентаПредставление"
// 	2. Если Имя параметра заканчивается на "Ссылка", то имя представления будет без "Ссылка" (например Имя параметра ЗаказКлиентаСсылка, а Имя параметра представления "ЗаказКлиента")
// 	3. Представление может быть и не задано, тогда оно определяется обращением к БД.
// Параметры:
// 	Параметры: Структура - где ключи имена параметров, а значения - значения на которые будут заменены параметры в строке
// 	СтрокаСПараметрами - Строка - Исходная строка, в которой заданы шаблоны - подстроки обрамленные парами из подстрок начала и окончания
//	ПодстрокаНачала - Строка - Указывает на начало параметра
//	ПодстрокаОкончания - Строка - Указывает на окончание параметра
//	ВыдаватьОшибку - булево - вызывать исключение, если некорректно задана СтрокаСПараметрами - непарные ПодстрокаНачала и ПодстрокаОкончания или несооветствует их количество друг другу
// Возвращаемое значение:
//	Строка у которой были заменены параметры на их значения
Функция ЗаполнитьПараметрыВСтрокеШаблоне(Знач Параметры, Знач СтрокаСПараметрами, ПодстрокаНачала = "[", ПодстрокаОкончания = "]", ВыдаватьОшибку = Ложь) Экспорт
	Перем Значение, Представление;
	Результат = СтрокаСПараметрами;
	Обходы = Новый Массив;
	Обход = Новый Структура("ПодстрокаНачала,ПодстрокаОкончания,НавигационныеСсылки", "n|" + ПодстрокаНачала, ПодстрокаОкончания + "|n", Истина);
	Обходы.Добавить(Обход);
	Обход = Новый Структура("ПодстрокаНачала,ПодстрокаОкончания,НавигационныеСсылки", ПодстрокаНачала, ПодстрокаОкончания, Ложь);
	Обходы.Добавить(Обход);
	
	Для каждого КиЗ Из Обходы Цикл
		ИспользуемыеПараметры = ИТМ_ОбщегоНазначенияКлиентСервер.ПараметрыИзСтроки(СтрокаСПараметрами, КиЗ.ПодстрокаНачала, КиЗ.ПодстрокаОкончания, ВыдаватьОшибку);
		Для каждого Параметр Из ИспользуемыеПараметры Цикл
			ПодстрокаПоиска = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("%1%2%3", КиЗ.ПодстрокаНачала, Параметр, КиЗ.ПодстрокаОкончания);
			Параметры.Свойство(Параметр, Значение);
			ПодстрокаЗамены = Значение; // 06.12.2021 Данилов Артур: AUTOOPT
			Если КиЗ.НавигационныеСсылки Тогда
				Если ЗначениеЗаполнено(Значение) Тогда
					ИмяПредставления = СтрШаблон("%1Представление", Параметр);
					Параметры.Свойство(ИмяПредставления, Представление);
					Если 	НЕ ЗначениеЗаполнено(Представление)  
							И СтрДлина(Параметр) > СтрДлина("Ссылка") 
							И Прав(Параметр, СтрДлина("Ссылка")) = "Ссылка" Тогда
						ИмяПредставления = Лев(Параметр, СтрДлина(Параметр) - СтрДлина("Ссылка"));
						Параметры.Свойство(ИмяПредставления, Представление);
					КонецЕсли;
					ПодстрокаЗамены = ТекстГиперссылкиДляHTMLДокумента(Значение, Представление);	
				Иначе
					ПодстрокаЗамены = "";	
				КонецЕсли;
			КонецЕсли;		
			Результат = СтрЗаменить(Результат, ПодстрокаПоиска, ПодстрокаЗамены); 
		КонецЦикла;
	КонецЦикла;
	
	// Установка разрывов строки
	Результат = СтрЗаменить(Результат, "{Символы.ПС}", Символы.ПС);
	Возврат Результат;
КонецФункции

// Получает текст гипессылки по переданному значению объекта ссылочного типа для вставки его в HTML документ
// Параметры:
// 	Ссылка - любая ссылка, РегистсведенийКлючЗаписи или другой объект для которого применима функция ПолучитьНавигационнуюСсылку
// 	Представление - Строка - представление ссылки в тексте гиперссылки.
// Возвращаемое значение:
// 	Строка гиперссылки для вставки в HTML документ
Функция ТекстГиперссылкиДляHTMLДокумента(Ссылка, Представление = Неопределено) Экспорт 
	Если ЗначениеЗаполнено(Ссылка) Тогда
		Если Не ЗначениеЗаполнено(Представление) Тогда
			Представление = СокрЛП(Ссылка);
		КонецЕсли;		                     
		Результат = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			"<A href= ""%1"" >%2</A>",
			ПолучитьНавигационнуюСсылку(Ссылка),
			Представление);
	Иначе
		Результат = "";
	КонецЕсли;    
	Возврат Результат;
КонецФункции

// >> 23.11.2021 Берлизов Сергей

//24.05.2022 Шакун Денис: AUTOOPT-1911
Функция ПолучитьПредставлениеОбъектаЗамераВремени(СсылкаНаОбъект, Знач ПредставлениеОбъекта = "") Экспорт
	Если НЕ ЗначениеЗаполнено(СсылкаНаОбъект) Тогда
		Возврат ПредставлениеОбъекта;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ПредставлениеОбъекта) Тогда
		ПредставлениеОбъекта = Строка(СсылкаНаОбъект);
	КонецЕсли;
	
	Возврат ПредставлениеОбъекта + " (" + ПолучитьНавигационнуюСсылку(СсылкаНаОбъект) + ")";
КонецФункции
