package  {
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Point;
	
	public class Main2 extends MovieClip{
		private var fol:MovieClip;
		private var speed:Number = 2.5;
		public function Main2() {
			fol = new Shot();
			addChild(fol);
			fol.addEventListener(Event.ENTER_FRAME,moveFol);
		}
		private function moveFol(e:Event):void {
			var dx:Number = mouseX - fol.x;
			var dy:Number = mouseY - fol.y;
			
			var angle:Number = Math.atan2(dy,dx);
			fol.rotation = angle * 180/Math.PI;
			
			var vx:Number = Math.cos(angle) * speed;
			var vy:Number = Math.sin(angle) * speed;
			
			fol.x += vx;
			fol.y += vy;
		}
	}
	
}
