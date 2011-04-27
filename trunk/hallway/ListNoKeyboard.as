package  {
	import flash.events.KeyboardEvent;
	import fl.controls.List;

	public class ListNoKeyboard extends List{
		/*
		ListNoKeyboard.as
			This class is used to override the keyboard controls of the List compononent.
		*/
		public function ListNoKeyboard() {
			super();
		}
		
		override protected function keyDownHandler(event:KeyboardEvent):void {
			
		}

	}
	
}
