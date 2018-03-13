package
{
	public class Question
	{
		private var _id:int;
		private var _question:String;
		private var _goodanswer:String;
		private var _badanswer1:String;
		private var _badanswer2:String;
		
		public function Question(id:int,question:String,goodanswer:String,badanswer1:String,badanswer2:String)
		{
			_id = id
			_question = question
			_goodanswer = _goodanswer
			_badanswer1 = badanswer1
			_badanswer2 = badanswer2
		}

		public function get badanswer2():String
		{
			return _badanswer2;
		}

		public function set badanswer2(value:String):void
		{
			_badanswer2 = value;
		}

		public function get badanswer1():String
		{
			return _badanswer1;
		}

		public function set badanswer1(value:String):void
		{
			_badanswer1 = value;
		}

		public function get goodanswer():String
		{
			return _goodanswer;
		}

		public function set goodanswer(value:String):void
		{
			_goodanswer = value;
		}

		public function get question():String
		{
			return _question;
		}

		public function set question(value:String):void
		{
			_question = value;
		}

		public function get id():int
		{
			return _id;
		}

		public function set id(value:int):void
		{
			_id = value;
		}

	}
}