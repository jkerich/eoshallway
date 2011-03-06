package  {
	import flash.events.KeyboardEvent;
	import fl.controls.List;

	public class ListNoKeyboard extends List{

		public function ListNoKeyboard() {
			super();
		}
		
		override protected function keyDownHandler(event:KeyboardEvent):void {
			
		}

	}
	
}
