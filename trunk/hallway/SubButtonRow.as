package  {
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import flash.events.Event;
	//import fl.transitions.easing.*;

	public class SubButtonRow extends MovieClip{
		private var satName:String;
		private var aT:Tween;
		private var textFormat:TextFormat;
		private var names:Array;
		private var handlers:Array;
		private var aSpeed:Number = .3;
		private var jumpDistance:Number =150; //make dynamic
		private var animating:Boolean = false;
		//add text format
		public function SubButtonRow(sn:String,w:Number,h:Number,names:Array,handlers:Array,tf:TextFormat = null) {
			this.satName = sn;
			this.names = names;
			this.handlers = handlers;
			if(names.length != handlers.length) {
				trace("Names array and Handlers array have differeing lengths");
			}
			drawHitBox(w,h,0x000000,.65); //not necessary in this instance
			
			//check for a text format
			textFormat = (tf == null) ? new TextFormat("Walkway SemiBold",26,0xFFFFFF):tf;
			
			this.addEventListener(Event.ADDED_TO_STAGE,init); //in order to access x and y values
			
		}
		private function init(e:Event):void {
			this.changeSat(this.getName(),this.names,this.handlers);
		}
		
		public function changeSat(sn:String,names:Array,handlers:Array):void {
			//reset
			/*if(aT) {
				this.y = aT.finish;
			}*/
			if(animating) {
				return;
			}
			animating = true;
			//begin change
			this.satName = sn;
			this.names = names;
			this.handlers = handlers;
			aT = new Tween(this,"y",null,this.y,this.y+jumpDistance,aSpeed,true);
			aT.addEventListener(TweenEvent.MOTION_FINISH,animateFinish);
			
		}
		private function animateFinish(e:TweenEvent):void {
			aT.removeEventListener(TweenEvent.MOTION_FINISH,animateFinish);
			//reset
			while(this.numChildren) {
				this.removeChildAt(0);
			}
			//change sub buttons
			var bwidth:Number = this.width/this.names.length; //can be either names or handlers length
			for(var i:Number = 0;i<this.names.length;i++) {
				var sbutton:SubButton = new SubButton(this.names[i],bwidth,this.height,this.handlers[i],this.textFormat);
				sbutton.x = bwidth * i;
				sbutton.y = 0;
				addChild(sbutton);
			}
			aT = new Tween(this,"y",null,this.y,this.y-jumpDistance,aSpeed/2,true);
			aT.addEventListener(TweenEvent.MOTION_FINISH,endReturn);
		}
		private function endReturn(e:TweenEvent):void {
			animating = false;
		}
		public function getName():String {
			return this.satName;
		}
		private function drawHitBox(w:Number,h:Number,color:uint = 0xFFFFFF,a:Number = 0):void {
			this.graphics.clear();
			this.graphics.beginFill(color,a);
			this.graphics.drawRect(0,0,w,h);
			this.graphics.endFill();
		}
	}
	
}
