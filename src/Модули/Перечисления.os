Перем ТипыФайлов Экспорт;		// Перечисление.ТипыФайлов

// Процедура добавляет значение перечисления в структуру
//   
// Параметры:
//   Перечисление		 	- Структура		- перечисление
//   Имя				 	- Строка		- имя значения перечисления
//   Значение			 	- Строка		- значение перечисления
//
Процедура ДобавитьЗначениеПеречисления(Перечисление, Знач Имя, Знач Значение)
	
	Если НЕ ТипЗнч(Перечисление) = Тип("Структура") Тогда
		Перечисление = Новый Структура();
	КонецЕсли;

	Перечисление.Вставить(Имя, Значение);

КонецПроцедуры // ДобавитьЗначениеПеречисления()

// Процедура инициализирует значения перечислений
//   
Процедура Инициализация()

	ЗаполнитьТипыФайлов();
	 
КонецПроцедуры // Инициализация()

// Процедура - заполняет значения перечисления ТипыФайлов
//
Процедура ЗаполнитьТипыФайлов()

	ДобавитьЗначениеПеречисления(ТипыФайлов, "НастройкиКластера", "LST");
	ДобавитьЗначениеПеречисления(ТипыФайлов, "СловарьЖР"        , "LGP");
	ДобавитьЗначениеПеречисления(ТипыФайлов, "ЖР"               , "LGF");

КонецПроцедуры // ЗаполнитьТипыФайлов()

Инициализация();