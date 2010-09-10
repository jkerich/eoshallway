package  {
	import flash.display.*;
	import flash.net.*;
	import flash.events.*;
	import flash.text.*;
	import fl.transitions.*;
	
	public class DisplayContainer extends MovieClip{
		private var cont:*;
		private var aT:Tween;
		private var effectSpeed:Number = .3;
		private var center:Boolean;
		
		public function DisplayContainer(w:Number,h:Number,color:uint=0x000000,a:Number = 0,center:Boolean = false,initialContent:* = null, t:Tween = null) {
			this.center = center;
			//draw hitbox
			drawHitBox(w,h,color,a);
			
			//initialize content variable
			if(initialContent != null)
				this.changeContent(initialContent);
			
		}
		public function changeContent(c:*):void {
			cont = c;
			//hide
			aT = new Tween(this,"alpha",null,this.alpha,0,effectSpeed,true);
			aT.addEventListener(TweenEvent.MOTION_FINISH,effectOut);
		}
		private function effectOut(e:TweenEvent):void { 
			//center content
			if(center) {
				if (cont.width > this.width) {
					cont.width = this.width;
				}else {
					cont.x = (this.width - cont.width)/2;
				}
				if (cont.height > this.height) {
					cont.height = this.height;
				}else {
					cont.y = (this.height - cont.height)/2;
				}
			}
			
			//change
			changeChild(cont);
			//effect back in
			new Tween(this,"alpha",null,this.alpha,1,effectSpeed,true);
		}
		//utility
		private function changeChild(obj:*):void { 
			while(this.numChildren) {
				this.removeChildAt(0);
			}
			this.addChild(obj);
			
		}
		private function drawHitBox(w:Number,h:Number,color:uint = 0xFFFFFF,a:Number = 0):void {
			this.graphics.clear();
			this.graphics.beginFill(color,a);
			this.graphics.drawRect(0,0,w,h);
			this.graphics.endFill();
		}

	}
	
}
