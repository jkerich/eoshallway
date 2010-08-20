package  {
	import flash.display.*;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import fl.transitions.Tween;
	import fl.transitions.easing.Back;
	import flash.net.URLRequest;
	
	public class Magic extends MovieClip{
		var sH:Number = stage.stageHeight;
		var sW:Number = stage.stageWidth;
		var boxwidth:Number = 320;
		var boxheight:Number = 200;
		var linesize:Number = 3.0;
		var stripeh:Number = 200;
		var subh:Number = 50; //sub button height
		var startpoint:Number;
		//tweens
		var xT:Tween;
		//mcs
		var frame:MovieClip;
		//array of image names
		var imagenames:Array = ["aqua_clean.png","aura_clean.png","terra_clean.png","trmm_clean.png"];
		var images:Array;
		public function Magic() {
			//initialize variables
			images = new Array();
			startpoint = sH-(stripeh+subh);
			//draw outline
			this.graphics.lineStyle(linesize,0xFFFFFF,1.0,false,"normal",CapsStyle.SQUARE);
			this.graphics.drawRect(linesize/2,linesize/2,sW-linesize,sH-linesize);
			
			//bg stripe
			var stripe:MovieClip = new MovieClip();
			stripe = drawstripe(stripe);
			
			//the button out line
			var btnout:MovieClip = new MovieClip();
			btnout.addEventListener(Event.ENTER_FRAME,onenter);
			
			frame = new MovieClip();
			frame = drawframe(frame);
			frame.x = 0;
			frame.y = sH - (stripeh + subh);
			
			
			
			addChild(stripe);
			loadbuttonimages();
			addChild(btnout);
			addChild(frame);
			
		}
		public function onenter(e:Event):void {
			var tar:Object = e.target;
			tar.graphics.clear();
			
			//top line - left
			tar.graphics.lineStyle(linesize,0xFFFFFF,1.0,false,"normal",CapsStyle.SQUARE,JointStyle.MITER);
			tar.graphics.moveTo(0,startpoint);
			tar.graphics.lineTo(frame.x,startpoint);
			//bottom line - left
			tar.graphics.moveTo(0,startpoint+stripeh);
			tar.graphics.lineTo(frame.x,startpoint+stripeh);
			
			//top line - right
			tar.graphics.moveTo(sW,startpoint);
			tar.graphics.lineTo(frame.x+boxwidth,startpoint);
			//bottom line - right
			tar.graphics.moveTo(sW,startpoint+stripeh);
			tar.graphics.lineTo(frame.x+boxwidth,startpoint+stripeh);
			
		}
		//make it draw at 0,0
		public function drawstripe(mc:MovieClip):MovieClip {
			mc.graphics.lineStyle(0,0,0);
			mc.graphics.beginFill(0xCC0000);
			mc.graphics.drawRect(0,startpoint,sW,stripeh);
			mc.graphics.endFill();
			return mc;
		}
		public function drawframe(mc:MovieClip):MovieClip {
			mc.graphics.lineStyle(linesize,0xFFFFFF,1.0,false,"normal",CapsStyle.SQUARE,JointStyle.MITER);
			mc.graphics.moveTo(linesize/2,0);
			mc.graphics.lineTo(linesize/2,boxheight);
			mc.graphics.moveTo(boxwidth-linesize/2,0);
			mc.graphics.lineTo(boxwidth-linesize/2,boxheight);
			
			return mc;
		}
		//buttons
		public function loadbuttonimages():void {
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,createbuttonarray);
			loader.load(new URLRequest("clean/"+imagenames[0]));
			
			imagenames.splice(0,1);
		}
		//put sub buttons here------------------------------------
		public function createbuttonarray(e:Event):void {
			//size and position image
			var tar:Bitmap = (Bitmap)(e.target.content);
			tar.width = boxwidth;
			tar.height = boxheight;
			tar.scaleY = tar.scaleX;
			tar.x = (boxwidth - tar.width)/2;
			tar.y = (boxheight - tar.height)/2;
			//container movieclip
			var mc:MovieClip = new MovieClip();
			mc.addChild(tar);
			//hitbox
			mc.graphics.beginFill(0xFFFFFF,0);
			mc.graphics.drawRect(0,0,boxwidth,boxheight);
			mc.addEventListener(MouseEvent.CLICK,buttonclicked);
			images.push(mc);
			
			//once all images are loaded
			if(imagenames.length==0){
				addbuttons();
			}else {
				loadbuttonimages();
			}
			
		}
		public function buttonclicked(e:MouseEvent):void {
			xT = new Tween(frame, "x",Back.easeIn,frame.x,e.target.x,.3,true);
		}
		public function addbuttons():void {		
			for (var i:Number = 0;i<images.length;i++) {
				images[i].x = boxwidth*i;
				images[i].y = startpoint;
				addChild(images[i]);
			}
		}
		
	}
	
}
