package  {
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	public class SubButtonRow extends MovieClip{
		private var satName:String;
		//add text format
		public function SubButtonRow(sn:String,w:Number,h:Number,names:Array,handlers:Array,textFormat:TextFormat = null) {
			this.satName = sn;
			if(names.length != handlers.length) {
				trace("Names array and Handlers array have differeing lengths");
			}
			drawHitBox(w,h); //not necessary in this instance
			
			//check for a text format
			(textFormat == null) ? new TextFormat("Walkway SemiBold",32,0xFFFFFF):textFormat;
			
			var bwidth:Number = w/names.length; //can be either names or handlers length
			for(var i:Number = 0;i<names.length;i++) {
				var sbutton:SubButton = new SubButton(names[i],bwidth,h,handlers[i],textFormat);
				sbutton.x = bwidth * i;
				sbutton.y = 0;
				
				addChild(sbutton);
			}
			
		}
		public function getSatName():String {
			return this.satName;
		}
		private function drawHitBox(w:Number,h:Number):void {
			this.graphics.clear();
			this.graphics.beginFill(0xFFFFFF,0);
			this.graphics.drawRect(0,0,w,h);
			this.graphics.endFill();
		}
	}
	
}
