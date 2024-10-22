﻿#Область ПрограммныйИнтерфейс


// Возвращает пустую структуру с параметрами строки ТЧ ЭтапыОбработкиДанных
Функция ПараметрыЗаписиЭтапа(ЭтапОбработки = Неопределено) Экспорт 

	Результат =  Новый Структура("ЭтапОбработки,", ЭтапОбработки);
	Результат.Вставить("Завершен", Ложь);
	Результат.Вставить("ТекущаяДатаСобытия", '00010101');
	Результат.Вставить("ТекущееID", 0);

	Возврат Результат;
	
КонецФункции

Функция ВыполнитьОдиночнуюЗамену(Знач Результат, ПозНач, ПодстрокаПоиска, ПодстрокаЗамены) Экспорт 
	
	//Результат = СтрШаблон("%1%2%3", Сред(Результат, 1, ПозНач - 1),  ПодстрокаЗамены, Сред(Результат, ПозНач + СтрДлина(ПодстрокаПоиска), СтрДлина(Результат) - (Сч - ПозНач)));
	Результат = СтрШаблон("%1%2%3", Лев(Результат, ПозНач - 1), ПодстрокаЗамены, Прав(Результат, СтрДлина(Результат) - ПозНач - СтрДлина(ПодстрокаПоиска) + 1));
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции 

Функция ШаблонОтдельностоящих0x01() Экспорт 
	Результат = "((select(\s+top\s+\d?)?(\s+distinct)?\s+|\v|,)\s*)(0x01|\(0x01\))(\s*(union|from|,|\z))";
	Возврат Результат;
КонецФункции

Функция Шаблон0x01вCase() Экспорт 
	Результат = "\b((then|else)\s*)0x01\b";
	Возврат Результат;
КонецФункции

Функция ШаблонTOP() Экспорт 
	Результат = "\b(select(\s+distinct)?)\s+top\s+(\d+)\b";
	Возврат Результат;
КонецФункции

#КонецОбласти