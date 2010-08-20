package  {
	import flash.display.MovieClip;
	import fl.transitions.Tween;
	
	public class DisplayContainer extends MovieClip{
		private var cont:MovieClip;
		private var tw:Tween;
		
		public function DisplayContainer(w:Number,h:Number,c:MovieClip = null, t:Tween = null) {
			//draw hitbox
			drawHitBox(w,h);
			
			//initialize content variable
			this.changeContent(c,t);
			
		}
		public function changeContent(c:MovieClip = null,t:Tween = null):void {
			//initialize
			this.cont = (c == null) ? new MovieClip():c;
			this.cont.alpha = 0;
			
			//reset
			if(this.numChildren > 0) {
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
		private function drawHitBox(w:Number,h:Number):void {
			this.graphics.clear();
			this.graphics.beginFill(0xFFFFFF,0);
			this.graphics.drawRect(0,0,w,h);
			this.graphics.endFill();
		}

	}
	
}
