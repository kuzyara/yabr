Перем Результат;
Перем Параметры;

#Область ПрограммныйИнтерфейс

// Функция - возвращает тип файла, обрабатываемый данной обработкой
// 
// Возвращаемое значение:
//  Строка -  тип файла, обрабатываемый данной обработкой
//
Функция ТипФайла() Экспорт
	
	Возврат Перечисления.ТипыФайлов.ЖР;
	
КонецФункции // ТипФайла()

// Функция - возвращает результат, накопленный обработкой
// 
// Возвращаемое значение:
//  Произвольный -  результат, накопленный обработкой
//
Функция ПолучитьРезультат() Экспорт
	
	Возврат Результат;
	
КонецФункции // ПолучитьРезультат()

// Процедура - проверяет, что элемент является записью журнала регистрации
// и добавляет его в массив записей
//
// Параметры:
//	Элемент         - Структура       проверяемый элемент
//		*Родитель            - Структура                 - ссылка на элемент-родитель
//		*Уровень             - Число                     - уровень иерархии элемента
//		*Индекс              - Число                     - индекс элемента в массиве значений родителя
//		*НомераСтрок         - Соответсвие(Число)        - массив номеров строк из которых был прочитан элемент и его дочерние элементы
//		*Значения            - Массив(Структура)         - массив дочерних элементов
//
Процедура ДобавитьЗапись(Элемент) Экспорт
	
	Если НЕ Элемент.Уровень = 1 Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ Элемент.Родитель.Индекс = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ТипЗнч(Словари) = Тип("Структура") Тогда
		Словари = ПолучитьСловариДанныхЖР();
	КонецЕсли;
	
	Запись = Новый Структура();
	Запись.Вставить("Время", Элемент.Значения[0]);
	Запись.Вставить("СтатусТранзакции", Элемент.Значения[1]);
	
	Пользователь = Число(Элемент.Значения[3]);
	Если Словари.Свойство("Пользователи") Тогда
		ВремЗначение = Словари.Пользователи.Получить(Пользователь);
		Если НЕ ВремЗначение = Неопределено Тогда
			Пользователь = ВремЗначение;
		КонецЕсли;
	КонецЕсли;
	Запись.Вставить("Пользователь", Пользователь);
	
	Компьютер = Число(Элемент.Значения[4]);
	Если Словари.Свойство("Компьютеры") Тогда
		ВремЗначение = Словари.Компьютеры.Получить(Компьютер);
		Если НЕ ВремЗначение = Неопределено Тогда
			Компьютер = ВремЗначение;
		КонецЕсли;
	КонецЕсли;
	Запись.Вставить("Компьютер", Компьютер);
	
	Событие = Число(Элемент.Значения[7]);
	Если Словари.Свойство("События") Тогда
		ВремЗначение = Словари.События.Получить(Событие);
		Если НЕ ВремЗначение = Неопределено Тогда
			Событие = ВремЗначение;
		КонецЕсли;
	КонецЕсли;
	Запись.Вставить("Событие", Событие);
	
	Запись.Вставить("Важность", Элемент.Значения[8]);
	Запись.Вставить("Комментарий", Служебный.ОбработатьКавычкиВСтроке(Элемент.Значения[9]));
	
	Метаданные = Число(Элемент.Значения[7]);
	Если Словари.Свойство("Метаданные") Тогда
		ВремЗначение = Словари.Метаданные.Получить(Метаданные);
		Если НЕ ВремЗначение = Неопределено Тогда
			Метаданные = ВремЗначение;
		КонецЕсли;
	КонецЕсли;
	Запись.Вставить("Метаданные", Метаданные);
	
	Запись.Вставить("ТипДанных", Служебный.ОбработатьКавычкиВСтроке(Элемент.Значения[11].Значения[0]));
	Если Элемент.Значения[11].Значения.Количество() > 1 Тогда
		Запись.Вставить("Данные", Служебный.ОбработатьКавычкиВСтроке(Элемент.Значения[11].Значения[1]));
	Иначе
		Запись.Вставить("Данные", "");
	КонецЕсли;
	Запись.Вставить("ПредставлениеДанных", Служебный.ОбработатьКавычкиВСтроке(Элемент.Значения[12]));
	
	Если НЕ ТипЗнч(Результат) = Тип("Массив") Тогда
		Результат = Новый Массив();
	КонецЕсли;
	
	Результат.Добавить(Запись);

КонецПроцедуры // ДобавитьЗапись()

// Функция - проверяет, что элемент является записью журнала регистрации
// и проверяет необходимость удаления элемента
//
// Параметры:
//	Элемент                  - Структура          - проверяемый элемент (см. НужноУдалитьЭлемент)
//		*Родитель            - Структура                 - ссылка на элемент-родитель
//		*Уровень             - Число                     - уровень иерархии элемента
//		*Индекс              - Число                     - индекс элемента в массиве значений родителя
//		*НомераСтрок         - Соответсвие(Число)        - массив номеров строк из которых был прочитан элемент и его дочерние элементы
//		*Значения            - Массив(Структура)         - массив дочерних элементов
//
// Возвращаемое значение:
//   Булево - Истина - элемент нужно удалить после обработки
//
Функция НужноУдалитьЭлемент(Элемент) Экспорт
	
	Если НЕ Элемент.Уровень = 1 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если НЕ Элемент.Родитель.Индекс = 0 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции // НужноУдалитьЭлемент()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Функция - возвращает словари данных для чтения журнала регистрации
//
// Возвращаемое значение:
//   Структура - словари данных журнала регистрации
//
Функция ПолучитьСловариДанныхЖР()
	
	ФайлЖурнала = Новый Файл(Параметры.ПутьКФайлу);
	
	ПутьКФайлу = ФайлЖурнала.Путь + "1Cv8.lgf";
	
	Попытка
		РезультатЧтенияСловарей = ЧтениеСкобкоФайла.ПрочитатьСкобкофайл(ПутьКФайлу);
	Исключение
		Возврат Новый Структура();
	КонецПопытки;
	
	Если РезультатЧтенияСловарей.Количество() = 0 Тогда
		Возврат Новый Структура();
	Иначе
		Возврат РезультатЧтенияСловарей[0];
	КонецЕсли; 
	
КонецФункции // ПолучитьСловариДанныхЖР()

#КонецОбласти

#Область ОбработчикиСобытий

// Процедура - Обработчик события формы "ПриСозданииОбъекта"
//
// Параметры:
//	Чтение                - ЧтениеСкобкоФайла  - Объект чтения скобкофайла из которого выполняется вызов обработчика
//	ПараметрыОбработки    - Структура          - дополнительные параметры обработки
//
Процедура ПриСозданииОбъекта(Чтение, ПараметрыОбработки = Неопределено)
	
	ЧтениеСкобкоФайла = Чтение;

	Параметры = Новый Структура();

	Если ТипЗнч(ПараметрыОбработки) = Тип("Структура") Тогда
		Параметры = ПараметрыОбработки;
	КонецЕсли;
	
КонецПроцедуры // ПриСозданииОбъекта()

#КонецОбласти
