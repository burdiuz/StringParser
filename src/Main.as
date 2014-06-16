package
{
	import flash.display.Sprite;
	
	public class Main extends Sprite
	{
		public function Main()
		{
			
		}
	}
}

/**
 StringParser:
 1. Регистрировать субпарсеры через dataType:String
 2. Каждый субпарсер должен иметь возможность передать в главный рапсер часть своей внутренней информации.
 3. Парсер во время работы создаёт раннеры с индексом последнего обработанного символа+1(след. символ) и их передаёт дальше и дальше.
 ParserRunner:
 startIndex:int -- начало субстроки
 index:int -- индекс обработки в субстроке или полный индекс(+startIndex)
 length:int -- длинна субстроки или длинна субстроки +startIndex
 3а. Раннеры можно кешировать, но они не должны содержать логики, так что можно и создавать.
 4. Каждый субпарсер может передать парсеру дата типы которые, возможно, могут в нём нахлодится, чтоб облегчить поиск.
 5. Обдумать как связать информацию о дататипе с символом начала дататипа. Признак "начальный символ" будет общим правилом для всех субпарсеров или только частным случаем -- лучше второе.
 6. 
 */