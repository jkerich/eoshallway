package  {
	
	import flash.display.MovieClip;
	import flash.net.*;
	import flash.html.*;
	import flash.events.Event;
	
	public class FormatTest extends MovieClip {
		
		
		public function FormatTest() {
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE,partyTime);
			loader.load(new URLRequest("feedInfo.xml"));
			
		}
		private function partyTime(e:Event):void {
			var xml:XML = new XML(e.target.data);
			//starts from item
			//trace(xml.item[0].fulltext);			
			var ht:HTMLLoader = new HTMLLoader();
			ht.width = 400;
			ht.height = 400;
			ht.loadString(xml.item[0].fulltext);
			addChild(ht);
		}
	}
	
}
