package  {
	import flash.display.*;
	import flash.net.*;
	import flash.events.*;
	import flash.text.*;
	import fl.transitions.*;
	import fl.transitions.easing.*;
	import flash.system.*;
	import flash.geom.Point;
	
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
			
			
			//using points
			var p1:Point = new Point();
			p1.x = mouseX;
			p1.y = mouseY;
			
			var base:Point = new Point();
			base.x = sW/2;
			base.y = sH;
			
			this.graphics.moveTo(base.x,base.y);
			this.graphics.lineTo(p1.x,p1.y);
			this.graphics.lineTo(p1.x,base.y);
			this.graphics.lineTo(base.x,base.y);
			
			//calc angle - default radians
			var dx:Number = p1.x - base.x;
			var dy:Number = p1.y - base.y;
			var angle:Number = Math.atan2(dy,dx);
			//convert to degrees
			angle = angle * (180/Math.PI);
			
			trace(angle);
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
