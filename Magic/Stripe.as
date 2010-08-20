package  {
	
	public class Stripe {

		public function Stripe(w:Number,h:Number) {
			
			
			this.graphics.clear();
			
			//left stripe
			this.graphics.lineStyle(0,0,0);
			this.graphics.beginFill(0xFF0000,stripealpha);
			this.graphics.drawRect(0,sthistpoint,frame.x,boxheight);
			//right stripe
			this.graphics.drawRect(frame.x+frame.width,sthistpoint,sW,boxheight);
			
			//top line - left
			this.graphics.lineStyle(linesize,0xFFFFFF,1.0,false,"normal",CapsStyle.SQUARE,JointStyle.MITER);
			this.graphics.moveTo(0,sthistpoint);
			this.graphics.lineTo(frame.x,sthistpoint);
			//bottom line - left
			this.graphics.moveTo(0,sthistpoint+boxheight);
			this.graphics.lineTo(frame.x,sthistpoint+boxheight);
			
			//top line - right
			this.graphics.moveTo(sW,sthistpoint);
			this.graphics.lineTo(frame.x+boxwidth,sthistpoint);
			//bottom line - right
			this.graphics.moveTo(sW,sthistpoint+boxheight);
			this.graphics.lineTo(frame.x+boxwidth,sthistpoint+boxheight);
		}
		
		public function drawframe(mc:MovieClip):MovieClip {
			//could have an object with the properties of the parameters for linestyle
			mc.graphics.lineStyle(linesize,0xFFFFFF,1.0,false,"normal",CapsStyle.SQUARE,JointStyle.MITER);
			mc.graphics.moveTo(linesize/2,0);
			mc.graphics.lineTo(linesize/2,boxheight);
			mc.graphics.moveTo(boxwidth-linesize/2,0);
			mc.graphics.lineTo(boxwidth-linesize/2,boxheight);
			
			return mc;
		}
	}
	
}
