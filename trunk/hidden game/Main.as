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
<<<<<<< .mine
		private var angle:Number;
		private var speed:Number = 10;
		private var base:Point;
		
=======
		private var angle:Number;
		var p1:Point;
		var base:Point;
>>>>>>> .r74
		public function Main() {
			lines = new MovieClip();
			t = new TextField();
			sW = stage.stageWidth;
			sH = stage.stageHeight;

<<<<<<< .mine
			stage.addEventListener(MouseEvent.CLICK,fire);
			addEventListener(Event.ENTER_FRAME,enterframe);
=======
			stage.addEventListener(MouseEvent.CLICK,fire);
			this.addEventListener(Event.ENTER_FRAME,enterframe);
>>>>>>> .r74
			
		}
		private function enterframe(e:Event):void {
			//trace(mouseX,mouseY);
			this.graphics.clear();
			this.graphics.lineStyle(2,0xFFFFFF,1.0);
			
<<<<<<< .mine
			base = new Point();
=======
			
			//using points
			p1 = new Point();
			p1.x = mouseX;
			p1.y = mouseY;
			
			base = new Point();
>>>>>>> .r74
			base.x = sW/2;
			base.y = sH;
			
			this.graphics.lineStyle(.5,0xffffff,.5);
			this.graphics.moveTo(base.x,base.y);
			this.graphics.lineTo(mouseX,mouseY);
			this.graphics.lineTo(mouseX,base.y);
			this.graphics.lineTo(base.x,base.y);
			
			//calc angle - default radians
<<<<<<< .mine
			var dx:Number = base.x - mouseX;
			var dy:Number = base.y - mouseY;
			angle = Math.atan2(dy,dx);
=======
			var dx:Number = p1.x - base.x;
			var dy:Number = p1.y - base.y;
			angle = Math.atan2(dy,dx);
>>>>>>> .r74
			//convert to degrees
			angle = angle * (180/Math.PI);
			
		}
		private function fire(e:MouseEvent):void {
			var s:MovieClip = makeShot();
<<<<<<< .mine
			s.x = base.x;
			s.y = base.y;
			s.ang = angle * Math.PI/2;
			trace(s.ang); 
			s.addEventListener(Event.ENTER_FRAME,moveShot);
			addChild(s);
=======
			//s.rotation = angle;
			s.x = base.x;
			s.y = base.y;
			//obj,prop,easing,initial,final,seconds/frame,t=seconds;f=frames
			new Tween(s,"x",null,s.x,mouseX,3,true);
			new Tween(s,"y",null,s.y,mouseX,3,true);
>>>>>>> .r74
			
<<<<<<< .mine
		}
		private function moveShot(e:Event):void {
			var s:MovieClip = e.target as MovieClip;
			var vx:Number = Math.cos(s.ang) * speed;
			var vy:Number = Math.sin(s.ang) * speed;
			
=======
			stage.addChild(s);
>>>>>>> .r74
			s.x += vx;
			s.y += vy;
		}
		private function makeShot(w:Number=2,h:Number=10,color:uint = 0xffffff, a:Number = 1.0):MovieClip{
			var shot:MovieClip = new MovieClip();
			shot.ang = 0;
			shot.graphics.beginFill(color,a);
			shot.graphics.drawRect(0,0,w,h);
			shot.graphics.endFill();
			return shot;
		}
	}
	
}
