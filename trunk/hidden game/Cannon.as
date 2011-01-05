package  {
	
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.utils.Timer;
	
	public class Cannon extends MovieClip {
		//shot vars
		private var speed:Number = 4.5;
		private var sW:Number;
		private var sH:Number;
		private var shots:Array; //array to hold all the shots
		private var maxShots:Number = 3; //maximum number of shots that can be out at any moment
		//timer vars
		public var coolDown:Number = 1000; //number of milli seconds to before next shot
		private var timer:Timer; //timer that controls shot intervals
		private var armed:Boolean = true;
		
		public function Cannon() {
			addEventListener(Event.ADDED_TO_STAGE,init);
		}
		private function init(e:Event):void {
			//stage values
			sW = stage.stageWidth;
			sH = stage.stageHeight;
			
			//rotate cannon
			this.addEventListener(Event.ENTER_FRAME,rotate);
			
		}
		private function rotate(e:Event):void {
			//distance
			var dx:Number = stage.mouseX - this.x;
			var dy:Number = stage.mouseY - this.y;
			
			//find angle
			var angle:Number = Math.atan2(dy,dx);
			
			//rotation
			this.rotation = angle * 180/Math.PI; 
		}
		public function armCannon(e:TimerEvent):void {
			this.armed = true;
		}
		//just in case it needs to be armed or disarmed independently of the timer
		public function arm():void {
			this.armed = true;
		}
		public function disarm():void {
			this.armed = false;
		}
	}
	
}
