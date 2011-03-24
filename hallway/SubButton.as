package  {
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	public class SubButton extends MovieClip{

		public function SubButton(n:String,w:Number,h:Number,handler:Function,textFormat:TextFormat = null) {
			//add text
			var t:TextField = new TextField();
			//apply default formatting if no value for textFormat
			t.defaultTextFormat = (textFormat == null) ? new TextFormat("Walkway SemiBold",26,0xFFFFFF):textFormat;
			t.text = n;
			t.selectable = false;
			t.autoSize = TextFieldAutoSize.CENTER;
			//make sure it fits
			if(w>=t.width) {
				t.x = (w-t.width)/2;
			}else {
				w = t.width;
				t.x = 0;
			}
			
			if(h>=t.height) {
				t.y = (h-t.height)/2;
			}else {
				h = t.height;
				t.y = 0;
			}
			
			//draw hit box
			drawHitBox(w,h);
			
			//add text field
			this.addChild(t);
			
			//add event listener
			this.addEventListener(MouseEvent.CLICK,handler,false,0,true);
		}
		private function drawHitBox(w:Number,h:Number,color:uint = 0xFFFFFF,a:Number = 0):void {
			this.graphics.clear();
			this.graphics.beginFill(color,a);
			this.graphics.drawRect(0,0,w,h);
			this.graphics.endFill();
		}

	}
	
}
