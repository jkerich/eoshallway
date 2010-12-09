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
		private var angle:Number;
		var p1:Point;
		var base:Point;
		public function Main() {
			lines = new MovieClip();
			t = new TextField();
			sW = stage.stageWidth;
			sH = stage.stageHeight;

			stage.addEventListener(MouseEvent.CLICK,fire);
			this.addEventListener(Event.ENTER_FRAME,enterframe);
			
			
		}
		private function enterframe(e:Event):void {
			//trace(mouseX,mouseY);
			this.graphics.clear();
			this.graphics.lineStyle(2,0xFFFFFF,1.0);
			
			
			//using points
			p1 = new Point();
			p1.x = mouseX;
			p1.y = mouseY;
			
			base = new Point();
			base.x = sW/2;
			base.y = sH;
			
			this.graphics.moveTo(base.x,base.y);
			this.graphics.lineTo(p1.x,p1.y);
			this.graphics.lineTo(p1.x,base.y);
			this.graphics.lineTo(base.x,base.y);
			
			//calc angle - default radians
			var dx:Number = p1.x - base.x;
			var dy:Number = p1.y - base.y;
			angle = Math.atan2(dy,dx);
			//convert to degrees
			angle = angle * (180/Math.PI);
			
		}
		private function fire(e:MouseEvent):void {
			var s:MovieClip = makeShot();
			//s.rotation = angle;
			s.x = base.x;
			s.y = base.y;
			//obj,prop,easing,initial,final,seconds/frame,t=seconds;f=frames
			new Tween(s,"x",null,s.x,mouseX,3,true);
			new Tween(s,"y",null,s.y,mouseX,3,true);
			
			stage.addChild(s);
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
