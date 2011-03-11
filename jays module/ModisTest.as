package  {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	
	public class ModisTest extends MovieClip {
		var mg:ModisGrab;
		
		public function ModisTest() {
			// constructor code
			mg = new ModisGrabTest();
			
			mg.getLatestImage("aqua");
			this.addChild(mg);
			
			this.addEventListener(MouseEvent.MOUSE_WHEEL,slideChange);
			
		}
		private function slideChange(e:MouseEvent):void {
			trace(e.delta);
			if(e.delta >=0){
				//next
				trace(mg.nextImage());
			}else if(e.delta < 0) {
				//prev
				trace(mg.prevImage());
			}
		}
	}
	
}
