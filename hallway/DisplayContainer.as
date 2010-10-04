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
		private var bT:Tween;
		private var effectSpeed:Number = .3;
		private var center:Boolean;
		private var w:Number;
		private var h:Number;
		//check if animating
		private var animating:Boolean = false;
		
		public function DisplayContainer(w:Number,h:Number,color:uint=0x000000,a:Number = 0,center:Boolean = false,initialContent:* = null, t:Tween = null) {
			this.w = w;
			this.h = h;
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
			if(animating) {
				return;
			}
			animating = true;
			newCont = c;
			//hide
			aT = new Tween(cont,"alpha",null,cont.alpha,0,effectSpeed,true);
			aT.addEventListener(TweenEvent.MOTION_FINISH,effectOut);
		}
		private function effectOut(e:TweenEvent):void { 
			//trace("effecting out");
			
			
			//change
			changeChild(cont,newCont);
			cont = Utils.scale(cont,w,h);
			
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
			//trace("effecting back in");
			//effect back in
			bT = new Tween(cont,"alpha",null,cont.alpha,1,effectSpeed,true);
			bT.addEventListener(TweenEvent.MOTION_FINISH,endEffect);
		}
		private function endEffect(e:TweenEvent):void {
			//trace("effect end");
			animating = false;
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
		private function scale(tar:*,w:Number,h:Number):* {
			//scaling
			trace("dc scale");
			//trace(tar.width,tar.height);
			tar.width = w;
			tar.height = h;
			(tar.scaleX > tar.scaleY) ? tar.scaleX = tar.scaleY:tar.scaleY = tar.scaleX;
			//trace(tar.width,tar.height);
			return tar;
		}

	}
	
}
