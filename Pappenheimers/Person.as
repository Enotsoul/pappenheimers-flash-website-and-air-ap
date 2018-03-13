package
{
	public class Person
	{
		private var _id:int;
		private var _name:String;
		private var _address:String;
		private var _age:String;
		
		public function Person(id:int,name:String,address:String,age:String)
		{
			_id = id
			_name = name
			_address = address
			_age = age
		}



		public function get id():int
		{
			return _id;
		}

		public function set id(value:int):void
		{
			_id = value;
		}

		public function get name():String
		{
			return _name;
		}

		public function set name(value:String):void
		{
			_name = value;
		}

		public function get address():String
		{
			return _address;
		}

		public function set address(value:String):void
		{
			_address = value;
		}

		public function get age():String
		{
			return _age;
		}

		public function set age(value:String):void
		{
			_age = value;
		}

	}
}