package  {
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	public class Main4 extends MovieClip{
		private var shooter:MovieClip;
		private var speed:Number = 4.5;
		private var force:Number = .5;
		private var friction:Number = .98;
		private var vx:Number = 0;
		private var vy:Number = 0;
		private var sW:Number;
		private var sH:Number;
		private var shots:Array; //array to hold all the shots
		private var maxShots:Number = 3; //maximum number of shots that can be out at any moment
		private var coolDown:Number = 1000; //number of milli seconds to before next shot
		private var timer:Timer; //timer that controls shot intervals
		private var armed:Boolean = false;
		
		public function Main4() {
			sW = stage.stageWidth;
			sH = stage.stageHeight;
			shots = new Array();
			
			//create shooter
			shooter = new Cannon();
			shooter.x = (sW - shooter.width)/2;
			shooter.y = sH;
			
			//initialize timer
			timer = new Timer(shooter.coolDown);
			//setup timer to arm cannon
			timer.addEventListener(TimerEvent.TIMER,armCannon);
			
			//add shooter to stage
			addChild(shooter);
			
			//add fire
			stage.addEventListener(MouseEvent.CLICK,fire);
		}
		private function fire(e:MouseEvent):void {
			if(!shooter.armed) 
				return;
			//reset timer
			timer.reset();
			//create shot
			var shot:MovieClip = new Shot();
			//radius of circle in the shooter
			var r:Number = shooter.height/2;
			//angle of shooter in rads
			var rads:Number = shooter.rotation * Math.PI/180;
			//move shot to outer rim of shooter
			shot.x = shooter.x + Math.cos(rads)*r;
			shot.y = shooter.y + Math.sin(rads)*r;
			shot.rotation = shooter.rotation;
			
			//add shot event listener
			shot.addEventListener(Event.ENTER_FRAME,propel);
			
			//add to stage
			addChild(shot);
			
			//disarm
			shooter.disarm();
			//restart timer
			timer.start();			
		}
		private function propel(e:Event):void {
			var shot:MovieClip = e.target as MovieClip;
			
			//check if out of bounds, if so destroy
			if(shot.x > sW || shot.x < 0 || shot.y > sH || shot.y < 0) {
				shot.removeEventListener(Event.ENTER_FRAME,propel);
				removeChild(shot);
			}
			
			//convert angle to rads
			var rads:Number = shot.rotation * Math.PI/180;
			
			//add velocity
			shot.x += Math.cos(rads) * speed;
			shot.y += Math.sin(rads) * speed;
			
		}
		private function armCannon(e:TimerEvent):void {
			shooter.armed = true;
		}
	}
}
