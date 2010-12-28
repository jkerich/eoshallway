package  {
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Point;
	
	public class Main4 extends MovieClip{
		private var shooter:MovieClip;
		private var speed:Number = 1.5;
		private var force:Number = .5;
		private var friction:Number = .98;
		private var vx:Number = 0;
		private var vy:Number = 0;
		private var sW:Number;
		private var sH:Number;
		
		public function Main4() {
			sW = stage.stageWidth;
			sH = stage.stageHeight;
			
			//create shooter
			shooter = new Shooter();
			shooter.x = (sW - shooter.width)/2;
			shooter.y = sH; 
			
			//make it aware
			shooter.addEventListener(Event.ENTER_FRAME,rotate); //could be enterframe as well
			stage.addEventListener(MouseEvent.CLICK,fire);
			
			//add shooter to stage
			addChild(shooter);
			
		}
		private function fire(e:MouseEvent):void {
			//create shot
			var shot:MovieClip = new Shot();
			shot.x = shooter.x;
			shot.y = shooter.y;
			shot.rotation =shooter.rotation;
			trace(shooter.rotation,shot.rotation);
			//add shot event listener
			shot.addEventListener(Event.ENTER_FRAME,propel);
			
			//add to stage
			addChild(shot);
			
		}
		private function propel(e:Event):void {
			var shot:MovieClip = e.target as MovieClip;
			
			//check if out of bounds, if so destroy
			if(shot.x > sW || shot.x < 0 || shot.y > sH || shot.y < sH) {
				//removeChild(e.target as DisplayObject);
			}
			
			//add velocity
			shot.x += Math.cos(shot.rotation) * speed;
			shot.y += Math.sin(shot.rotation) * speed;
			
		}
		private function rotate(e:Event):void {
			//distance
			var dx:Number = mouseX - shooter.x;
			var dy:Number = mouseY - shooter.y;
			
			//find angle
			var angle:Number = Math.atan2(dy,dx);
			
			//rotation
			shooter.rotation = angle * 180/Math.PI + 90; //add 90 to point in right direction
			
			
		}
		
		private function follow(e:Event):void {
			e.target.x = mouseX;
			e.target.y = mouseY;
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
