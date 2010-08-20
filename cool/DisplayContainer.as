package  {
	import flash.display.MovieClip;
	import fl.transitions.Tween;
	
	public class DisplayContainer extends MovieClip{
		private var cont:MovieClip;
		private var tw:Tween;
		
		public function DisplayContainer(w:Number,h:Number,c:MovieClip = null, t:Tween = null) {
			//draw hitbox
			drawHitBox(w,h,0x000000,.65);
			
			//initialize content variable
			this.changeContent(c,t);
			
		}
		public function changeContent(c:MovieClip = null,t:Tween = null):void {
			//initialize
			this.cont = (c == null) ? new MovieClip():c;
			this.cont.alpha = 0;
			
			//reset
			while(this.numChildren) {
				this.removeChildAt(0);
			}
			
			//center content
			if (this.cont.width > this.width) {
				this.cont.width = this.width;
			}else {
				this.cont.x = (this.width - this.cont.width)/2;
			}
			if (this.cont.height > this.height) {
				this.cont.height = this.height;
			}else {
				this.cont.y = (this.height - this.cont.height)/2;
			}
			
			//add to stage and tween
			this.addChild(this.cont);
			this.tw = (t == null) ? new Tween(this.cont,"alpha",null,this.cont.alpha,1,.5,true):t;
			
			
		}
		private function drawHitBox(w:Number,h:Number,color:uint = 0xFFFFFF,a:Number = 0):void {
			this.graphics.clear();
			this.graphics.beginFill(color,a);
			this.graphics.drawRect(0,0,w,h);
			this.graphics.endFill();
		}

	}
	
}
