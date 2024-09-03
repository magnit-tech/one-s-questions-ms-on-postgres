﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// См. Пользователи.АвторизованныйПользователь.
Функция АвторизованныйПользователь() Экспорт
	
	Возврат СтандартныеПодсистемыКлиент.ПараметрКлиента("АвторизованныйПользователь");
	
КонецФункции

// См. Пользователи.ТекущийПользователь.
Функция ТекущийПользователь() Экспорт
	
	Возврат ПользователиСлужебныйКлиентСервер.ТекущийПользователь(АвторизованныйПользователь());
	
КонецФункции

// См. Пользователи.ЭтоСеансВнешнегоПользователя.
Функция ЭтоСеансВнешнегоПользователя() Экспорт
	
	Возврат СтандартныеПодсистемыКлиент.ПараметрКлиента("ЭтоСеансВнешнегоПользователя");
	
КонецФункции

// Проверяет, является ли текущий пользователь полноправным.
// 
// Параметры:
//  ПроверятьПраваАдминистрированияСистемы - см. Пользователи.ЭтоПолноправныйПользователь.ПроверятьПраваАдминистрированияСистемы
//
// Возвращаемое значение:
//  Булево - если Истина, пользователь является полноправным.
//
Функция ЭтоПолноправныйПользователь(ПроверятьПраваАдминистрированияСистемы = Ложь) Экспорт
	
	Если ПроверятьПраваАдминистрированияСистемы Тогда
		Возврат СтандартныеПодсистемыКлиент.ПараметрКлиента("ЭтоПолноправныйПользователь");
	Иначе
		Возврат СтандартныеПодсистемыКлиент.ПараметрКлиента("ЭтоАдминистраторСистемы");
	КонецЕсли;
	
КонецФункции

#КонецОбласти
