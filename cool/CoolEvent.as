package {

	import flash.events.Event;
	/* uncessary. was going to use it to save some cpu cycles by dispatching this event whenever the user clicked on a big 
		button and have the strip listen for that event and move accordingly 
	*/
	public class CoolEvent extends flash.events.Event {
		public static const FRAME_MOVE:String = "frameMove";
		private var type:String;

		public function CoolEvent($type:String,$bubbles:Boolean = false, $cancelable:Boolean = false){
			super($type,$bubbles,$cancelable);
			this.type = $type;
		}
		
		public override function clone():Event {
			return new CoolEvent(type,bubbles,cancelable);
		}
	}

}