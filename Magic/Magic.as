package  {
	import flash.display.*;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import fl.transitions.Tween;
	import fl.transitions.easing.Back;
	import flash.net.URLRequest;
    import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextField;
	import BigButton;
	import flashx.textLayout.accessibility.TextAccImpl;
	
	//make stripes object
	//add ability to have unique sub buttons
	public class Magic extends MovieClip{
		var sH:Number = stage.stageHeight;
		var sW:Number = stage.stageWidth;
		//TODO: dynamically size boxes to available space
		var boxwidth:Number = 320; 
		var boxheight:Number = 200;//height of both the frame and the stripe
		var linesize:Number = 3.0;
		var subh:Number = 75; //sub button height
		var subw:Number = 320; //sub button width
		var startpoint:Number;
		var stripealpha = .75; //opacity of the stripe
		var titleh = 45;
		//tweens
		var xT:Tween;
		//mcs
		var frame:MovieClip;
		var sbuttonrow:SubButtonRow;
		var displaycontainer:DisplayContainer;
		var nasatitle:MovieClip;
		//array of image names
		var iconnames:Array = ["aqua_clean.png","aura_clean.png","TerraIcon.png","TrmmIcon.png"];
		var buttonnames:Array = ["aqua","aura","terra","trmm"];
		var images:Array;
		//sub button arrays -  custom ones can be added later
		var defaultnames:Array = new Array("about","presentations","videos","specs","images");
		var defaulthandlers:Array = new Array(aboutclick,presentationbtnclick,videobtnclick,specbtnclick,imagebtnclick);
			
		
		public function Magic() {
			//initialize variables
			images = new Array();
			startpoint = sH-(boxheight+subh);
			frame = new MovieClip();
			nasatitle = new MovieClip();
			
			//initialize objects
			
			//draw outline
			this.graphics.lineStyle(linesize,0xFFFFFF,1.0,false,"normal",CapsStyle.SQUARE);
			this.graphics.drawRect(linesize/2,linesize/2,sW-linesize,sH-linesize);
			
			
			//the button out line aka stripe
			var btnout:MovieClip = new MovieClip();
			btnout.addEventListener(Event.ENTER_FRAME,onenter);
			
			//title
			var t:TextField = new TextField();
			t.text = "NASA Earth Sciences";
			t.autoSize = TextFieldAutoSize.CENTER;
			nasatitle.addChild(t);
			nasatitle.x = (sW/2) - (t.width/2);
			nasatitle.y = 0;
			var tf:TextFormat = new TextFormat("Walkway SemiBold",titleh,0xFFFFFF);
			t.setTextFormat(tf);;
			
			
			
			//frame
			frame = drawframe(frame);
			frame.x = 0;
			frame.y = sH - (boxheight + subh);
			
			//display container
			displaycontainer = new DisplayContainer(sW,startpoint-titleh);
			displaycontainer.x = 0;
			displaycontainer.y = titleh;
			
			
			
			//add all to stage
			
			addChild(btnout);
			loadbuttons();
			addChild(frame);
			addChild(displaycontainer);
			addChild(nasatitle);
			
		}
		///---------------------------------- stripe creation ---------------\\\
		public function onenter(e:Event):void {
			var tar:Object = e.target;
			tar.graphics.clear();
			
			//left stripe
			tar.graphics.lineStyle(0,0,0);
			tar.graphics.beginFill(0xFF0000,stripealpha);
			tar.graphics.drawRect(0,startpoint,frame.x,boxheight);
			//right stripe
			tar.graphics.drawRect(frame.x+frame.width,startpoint,sW,boxheight);
			
			//top line - left
			tar.graphics.lineStyle(linesize,0xFFFFFF,1.0,false,"normal",CapsStyle.SQUARE,JointStyle.MITER);
			tar.graphics.moveTo(0,startpoint);
			tar.graphics.lineTo(frame.x,startpoint);
			//bottom line - left
			tar.graphics.moveTo(0,startpoint+boxheight);
			tar.graphics.lineTo(frame.x,startpoint+boxheight);
			
			//top line - right
			tar.graphics.moveTo(sW,startpoint);
			tar.graphics.lineTo(frame.x+boxwidth,startpoint);
			//bottom line - right
			tar.graphics.moveTo(sW,startpoint+boxheight);
			tar.graphics.lineTo(frame.x+boxwidth,startpoint+boxheight);
		}
		//frame
		public function drawframe(mc:MovieClip):MovieClip {
			mc.graphics.lineStyle(linesize,0xFFFFFF,1.0,false,"normal",CapsStyle.SQUARE,JointStyle.MITER);
			mc.graphics.moveTo(linesize/2,0);
			mc.graphics.lineTo(linesize/2,boxheight);
			mc.graphics.moveTo(boxwidth-linesize/2,0);
			mc.graphics.lineTo(boxwidth-linesize/2,boxheight);
			
			return mc;
		}
		///----------------------------------sub button addition---------------\\\
		public function addsubbuttons(satname:String):void {
			//remove old sbuttonrow-ignore initial error about sbuttonrow not being on the stage,this happens on first run
			try {
				removeChild(getChildByName("sbuttonrow"));
			}catch(e:Error) {
				trace(e.message);
			}
			for(var i:Number = 0; i<buttonnames.length;i++) {
				if(satname == buttonnames[i]) {
					sbuttonrow = new SubButtonRow(satname,sW,subh,defaultnames,defaulthandlers);
					sbuttonrow.name = "sbuttonrow";
					sbuttonrow.x = 0;
					sbuttonrow.y = sH - subh;
					
					addChild(sbuttonrow);
				}
			}
		}
		///----------------------------------sub button click handlers ---------------\\\
		public function imagebtnclick(e:MouseEvent):void {
			var tar:MovieClip = e.currentTarget as MovieClip;
			//change display mc
			var sbr:SubButtonRow = tar.parent as SubButtonRow;
			trace("image clicked under " + sbr.getSatName());
		}
		public function specbtnclick(e:MouseEvent):void {
			var tar:MovieClip = e.currentTarget as MovieClip;
			//change display mc
			trace("spec sub button clicked");
		}
		public function aboutclick(e:MouseEvent):void {
			var tar:MovieClip = e.currentTarget as MovieClip;
			//change display mc
			trace("about sub button clicked");
			var abt:AboutPage = new AboutPage(sW,sH);
		}
		public function presentationbtnclick(e:MouseEvent):void {
			var tar:MovieClip = e.currentTarget as MovieClip;
					
			displaycontainer.changeContent(new DummyPresent());
		}
		public function videobtnclick(e:MouseEvent):void {
			var tar:MovieClip = e.currentTarget as MovieClip;
			//change display mc
			trace("video sub button clicked");
		}
		
		///------------------------------------ button loading-----------------------------\\\
		public function loadbuttons():void {
			for (var i:Number = 0;i<iconnames.length;i++) {
				images.push(new BigButton(buttonnames[i],iconnames[i],boxwidth,boxheight));
				trace(images[i].n);
				images[i].x = boxwidth*i;
				images[i].y = startpoint;
				images[i].addEventListener(MouseEvent.CLICK,buttonclicked);
								
				addChild(images[i]);
			}
						
		}
		//button click
		public function buttonclicked(e:MouseEvent):void {
			var tar:BigButton = e.target as BigButton;
			xT = new Tween(frame, "x",Back.easeIn,frame.x,tar.x,.3,true);
			
			//create sub button
			addsubbuttons(tar.n); 
			
			//short about
			if(tar.n == "aqua") {
				displaycontainer.changeContent(new AquaAbout());
			}else if(tar.n == "aura") {
				displaycontainer.changeContent(new AuraAbout());
			}else if(tar.n == "terra") {
				displaycontainer.changeContent(new TerraAbout());
			}else if(tar.n == "trmm") {
				displaycontainer.changeContent(new TrmmAbout());
			}
		}
	}
	
}
