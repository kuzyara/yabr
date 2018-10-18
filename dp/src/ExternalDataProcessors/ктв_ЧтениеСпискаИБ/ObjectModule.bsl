Перем Владелец;
Перем ПараметрыОбработки;
Перем Данные;
Перем НакопленныеДанные;

#Область ПрограммныйИнтерфейс

// Функция - Возвращает значения параметров обработки
// 
// Возвращаемое значение:
//	Структура - параметры обработки
//
Функция Параметры() Экспорт
	
	Возврат ПараметрыОбработки;
	
КонецФункции // Параметры()

// Процедура - Устанавливает значения параметров обработки
//
// Параметры:
//	СтруктураПараметров      - Структура     - значения параметров обработки
//
Процедура УстановитьПараметры(Знач СтруктураПараметров) Экспорт
	
	ПараметрыОбработки = СтруктураПараметров;
	
КонецПроцедуры // УстановитьПараметры()

// Процедура - устанавливает данные для обработки
//
// Параметры:
//	Данные      - Структура     - значения параметров обработки
//
Процедура УстановитьДанные(Знач ВходящиеДанные) Экспорт
	
	Данные = ВходящиеДанные;
	
КонецПроцедуры // УстановитьДанные()

// Функция - возвращает текущие результаты обработки
//
// Возвращаемое значение:
//	Произвольный     - результаты обработки данных
//
Функция РезультатыОбработки() Экспорт
	
	Возврат НакопленныеДанные;
	
КонецФункции // РезультатыОбработки()

// Процедура - выполняет обработку данных
//
Процедура ОбработатьДанные() Экспорт
	
	Если НЕ ДобавитьЗапись(Данные) Тогда
		Возврат;
	КонецЕсли;
	
	Владелец.ПродолжениеОбработкиДанных(НакопленныеДанные[НакопленныеДанные.ВГраница()], ПараметрыОбработки);
	
КонецПроцедуры // ОбработатьДанные()

// Процедура - выполняет действия при окончании обработки данных
// и оповещает объект владелец о завершении обработки данных
//
Процедура ЗавершениеОбработкиДанных() Экспорт
	
	Если НЕ Владелец = Неопределено Тогда
		Попытка
			Владелец.ЗавершениеОбработкиДанных(ПараметрыОбработки);
		Исключение
			ВызватьИсключение;
		КонецПопытки;
	КонецЕсли;
	
КонецПроцедуры // ЗавершениеОбработкиДанных()

#КонецОбласти

#Область ОбработкаДанных

// Процедура - проверяет, что элемент является записью ИБ файла настроек кластера
// и добавляет его в список информационных баз
//
// Параметры:
//	Элемент         - Структура       проверяемый элемент
//		*Родитель            - Структура                 - ссылка на элемент-родитель
//		*Уровень             - Число                     - уровень иерархии элемента
//		*Индекс              - Число                     - индекс элемента в массиве значений родителя
//		*НомераСтрок         - Соответсвие(Число)        - массив номеров строк из которых был прочитан элемент и его дочерние элементы
//		*НачСтрока           - Число                     - номер первой строки из которой был прочитан элемент и его дочерние элементы
//		*КонСтрока           - Число                     - номер последней строки из которой был прочитан элемент и его дочерние элементы
//		*Значения            - Массив(Структура)         - массив дочерних элементов
//
Функция ДобавитьЗапись(Элемент) Экспорт
	
	Если НЕ Элемент.Уровень = 4 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если НЕ Элемент.Родитель.Индекс = 12 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если НЕ Элемент.Родитель.Родитель.Индекс = 1 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Запись = Новый Структура();
	Запись.Вставить("Ид", Элемент.Значения[0]);
	Запись.Вставить("Имя", ОбработатьКавычкиВСтроке(Элемент.Значения[1]));
	Запись.Вставить("Описание", ОбработатьКавычкиВСтроке(Элемент.Значения[2]));
	Запись.Вставить("ТипСУБД", ОбработатьКавычкиВСтроке(Элемент.Значения[3]));
	Запись.Вставить("СерверСУБД", ОбработатьКавычкиВСтроке(Элемент.Значения[4]));
	Запись.Вставить("ИмяБазыСУБД", ОбработатьКавычкиВСтроке(Элемент.Значения[5]));
	Запись.Вставить("ПользовательСУБД", ОбработатьКавычкиВСтроке(Элемент.Значения[6]));
	
	ПараметрыИБ = СтрРазделить(ОбработатьКавычкиВСтроке(Элемент.Значения[8]), ";");
	Для Каждого ТекПараметр Из ПараметрыИБ Цикл
		ОписаниеПараметра = СтрРазделить(ТекПараметр, "=");
		Запись.Вставить(ОписаниеПараметра[0], ОписаниеПараметра[1]);
	КонецЦикла;
	
	Если НЕ ТипЗнч(НакопленныеДанные) = Тип("Массив") Тогда
		НакопленныеДанные = Новый Массив();
	КонецЕсли;
	
	НакопленныеДанные.Добавить(Запись);
	
	Возврат Истина;
	
КонецФункции // ДобавитьЗапись()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Функция - удаляет начальные, конечные и экранированные кавычки из строки
//
// Параметры:
//  ПарамСтрока	 - Строка - строка для обработки
// 
// Возвращаемое значение:
//   Строка - результирующая строка
//
Функция ОбработатьКавычкиВСтроке(Знач ПарамСтрока)
	
	ПарамСтрока = СтрЗаменить(ПарамСтрока, """""", """");
	
	Если Лев(ПарамСтрока, 1) = """" Тогда
		ПарамСтрока = Сред(ПарамСтрока, 2);
	КонецЕсли;
	
	Если Прав(ПарамСтрока, 1) = """" Тогда
		ПарамСтрока = Сред(ПарамСтрока, 1, СтрДлина(ПарамСтрока) - 1);
	КонецЕсли;
	
	Возврат СокрЛП(ПарамСтрока);
	
КонецФункции // ОбработатьКавычкиВСтроке()

#КонецОбласти
