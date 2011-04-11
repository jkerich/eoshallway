package  {
	import flash.display.MovieClip;
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import fl.transitions.easing.Back;
	/*
	DisplayContainer.as
		This class extends the movieclip class. It allows instantiation with a set size and color.
	*/
	public class DisplayContainer extends MovieClip{
		private var cont:MovieClip;
		private var newCont:*; //temporary holder
		private var aT:Tween;
		private var bT:Tween;
		private var effectSpeed:Number = .3;
		private var center:Boolean;
		private var w:Number;
		private var h:Number;
		//check if animating
		private var animating:Boolean = false;
		/*
			Constructor 
				
				Parameters:
					     w: width of the display container
					     h: height of the display container
					 color: color of the hitbox to be drawn in the display container, default is black
					     a: the alpha value of the hitbox, default 0 (invisible)
					center: flag for whether items are centered
		*/
		public function DisplayContainer(w:Number,h:Number,color:uint=0x000000,a:Number = 0,center:Boolean = false,initialContent:* = null, t:Tween = null) {
			this.w = w;
			this.h = h;
			this.center = center;
			cont = new MovieClip();
			//draw hitbox
			Utils.drawHitBox(this,w,h,color,a);
			
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
			aT.addEventListener(TweenEvent.MOTION_FINISH,effectOut,false,0,true);
		}
		/*
		
		*/
		private function effectOut(e:TweenEvent):void { 
			//trace("effecting out");
			//change
			Utils.changeContent(cont,newCont);
			cont = Utils.scale(cont,w,h);
			
			//center content
			cont.x = cont.y = 0; //reset position
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
			bT.addEventListener(TweenEvent.MOTION_FINISH,endEffect,false,0,true);
		}
		private function endEffect(e:TweenEvent):void {
			//trace("effect end");
			animating = false;
		}
		//utility
		public function getContent():MovieClip {
			return cont;
		}
		

	}
	
}
