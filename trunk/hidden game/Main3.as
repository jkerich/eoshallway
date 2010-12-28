package  {
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Point;
	
	public class Main3 extends MovieClip{
		private var fol:MovieClip;
		private var speed:Number = 1.5;
		private var force:Number = .5;
		private var friction:Number = .98;
		private var vx:Number = 0;
		private var vy:Number = 0;
		
		public function Main3() {
			fol = drawTriangle(30);
			//fol = new Shot();
			fol.x = (stage.stageWidth - fol.width)/2;
			fol.y = (stage.stageHeight - fol.height)/2;
			addChild(fol);
			fol.addEventListener(Event.ENTER_FRAME,moveFol);
		}
		private function follow(e:Event):void {
			e.target.x = mouseX;
			e.target.y = mouseY;
		}
		private function moveFol(e:Event):void {
			//distance
			var dx:Number = mouseX - fol.x;
			var dy:Number = mouseY - fol.y;
			
			//find angle
			var angle:Number = Math.atan2(dy,dx);
			fol.rotation = angle * 180/Math.PI + 90; //add 90 to make it point the right direction
			
			//accel
			var ax:Number = Math.cos(angle) * force;
			var ay:Number = Math.sin(angle) * force;
			
			//add to velocity
			vx += ax;	
			vy += ay; 
			
			//apply vel to obj
			fol.x += vx;
			fol.y += vy;
			
			//apply fric
			vx *= friction;
			vy *= friction;
		}
		private function drawTriangle(h:Number):MovieClip {
			var con:MovieClip = new MovieClip();
			var tri:Shape = new Shape();
			tri.graphics.lineStyle(1,0xffffff,1);
			tri.graphics.lineTo(-h/2,h);
			tri.graphics.lineTo(h/2,h);
			tri.graphics.lineTo(0,0);
			tri.graphics.lineStyle(1,0x00ff00,1);
			tri.graphics.moveTo(-h/2,0);
			tri.graphics.lineTo(h/2,0);
			con.addChild(tri);
			return con;
		}
	}
}
