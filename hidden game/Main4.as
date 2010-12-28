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
		
		public function Main4() {
			//create shooter
			shooter = new Shooter();
			shooter.x = (stage.stageWidth - shooter.width)/2;
			shooter.y = stage.stageHeight; 
			
			//make it aware
			shooter.addEventListener(Event.ENTER_FRAME,rotate); //could be enterframe as well
			stage.addEventListener(MouseEvent.CLICK,fire);
			
			//add shooter to stage
			addChild(shooter);
			
		}
		private function fire(e:MouseEvent):void {
			var shot:MovieClip = new Shot();
			shot.x = shooter.x;
			shot.y = shooter.y;
			
			var vx:Number = Math.cos(shooter.rotation) * speed;
			var vy:Number = Math.sin(shooter.rotation) * speed;
			
			//add shot event listener to shot
			
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
