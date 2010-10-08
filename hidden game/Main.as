package  {
	import flash.display.*;
	import flash.net.*;
	import flash.events.*;
	import flash.text.*;
	import fl.transitions.*;
	import fl.transitions.easing.*;
	import flash.system.*;
	
	public class Main extends MovieClip{
		
		private var lines:MovieClip;
		private var t:TextField;
		private var sW:Number;
		private var sH:Number;
		public function Main() {
			lines = new MovieClip();
			t = new TextField();
			sW = stage.stageWidth;
			sH = stage.stageHeight;

			addEventListener(MouseEvent.CLICK,fire);
			addEventListener(Event.ENTER_FRAME,enterframe);
			
			
		}
		private function enterframe(e:Event):void {
			//trace(mouseX,mouseY);
			this.graphics.clear();
			this.graphics.lineStyle(2,0xFFFFFF,1.0);
			this.graphics.moveTo(sW/2,sH);
			this.graphics.lineTo(mouseX,mouseY);
			this.graphics.lineTo(mouseX,sH);
			this.graphics.lineTo(sW/2,sH);
			
			
			//calc angle
			var angle:Number = 0;
			var dx:Number = Math.abs(mouseX - sW/2);
			var dy:Number = Math.abs(mouseY - sH);
			
			
			
		}
		private function fire(e:MouseEvent):void {
			var s:MovieClip = makeShot();
			
			
		}
		private function makeShot(w:Number=2,h:Number=10,color:uint = 0xffffff, a:Number = 1.0):MovieClip{
			var shot:MovieClip = new MovieClip();
			shot.graphics.beginFill(color,a);
			shot.graphics.drawRect(0,0,w,h);
			shot.graphics.endFill();
			return shot;
		}
	}
	
}
