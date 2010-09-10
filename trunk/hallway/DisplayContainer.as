package  {
	import flash.display.*;
	import flash.net.*;
	import flash.events.*;
	import flash.text.*;
	import fl.transitions.*;
	
	public class DisplayContainer extends MovieClip{
		private var cont:MovieClip;
		private var newCont:*;
		private var aT:Tween;
		private var effectSpeed:Number = .3;
		private var center:Boolean;
		
		public function DisplayContainer(w:Number,h:Number,color:uint=0x000000,a:Number = 0,center:Boolean = false,initialContent:* = null, t:Tween = null) {
			this.center = center;
			cont = new MovieClip();
			//draw hitbox
			drawHitBox(w,h,color,a);
			
			//initialize content variable
			if(initialContent != null)
				this.changeContent(initialContent);
			
			this.addChild(cont);
		}
		public function changeContent(c:*):void {
			newCont = c;
			//hide
			aT = new Tween(cont,"alpha",null,cont.alpha,0,effectSpeed,true);
			aT.addEventListener(TweenEvent.MOTION_FINISH,effectOut);
		}
		private function effectOut(e:TweenEvent):void { 
			//change
			changeChild(cont,newCont);
			
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
			//effect back in
			aT = new Tween(cont,"alpha",null,cont.alpha,1,effectSpeed,true);
		}
		//utility
		private function changeChild(con:*,obj:*):void { 
			while(con.numChildren) {
				con.removeChildAt(0);
			}
			con.addChild(obj);
		}
		private function drawHitBox(w:Number,h:Number,color:uint = 0xFFFFFF,a:Number = 0):void {
			this.graphics.clear();
			this.graphics.beginFill(color,a);
			this.graphics.drawRect(0,0,w,h);
			this.graphics.endFill();
		}

	}
	
}
