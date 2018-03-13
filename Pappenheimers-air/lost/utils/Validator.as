package lost.utils
{
	public class Validator
	{
		public function Validator()
		{
		}
		public static function validateEmail(str:String):Boolean {
			var pattern:RegExp = /(\w|[_.\-])+@((\w|-)+\.)+\w{2,4}+/;
			var result:Object = pattern.exec(str);
			if(result == null) {
				return false;
			}
			return true;
			
		}
		public static function validateAge(obj:Object):Boolean {
			if (obj is int) {
				trace("isNumber");
				var nr:int = int(obj);
				if (nr >= 18) {
					trace("is above 18");
					return false
				}
			}
			return true;
		}
		
	}
}