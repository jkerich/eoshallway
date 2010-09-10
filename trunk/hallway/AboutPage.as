package  {
	import flash.text.*;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.SimpleButton;
	import fl.transitions.Tween;
	import flash.display.Stage;
	import fl.transitions.TweenEvent;
	
	public class AboutPage extends MovieClip {
		//mcs
		private var dc:DisplayContainer;
		private var tabs:MovieClip;
		private var aboutTitle:MovieClip;
		private var textContent:MovieClip; 
		
		//constants
		private var sH:Number;
		private var sW:Number;
		private var tabH:Number;
		private var titleW:Number;
		private var titleH:Number = 65;
		private var titleSize:Number = 35;
		private var outlineColor:uint = 0xFFFFFF;
	
		private var tabFormat:TextFormat;
		private var sats:Array = ["aqua","aura","terra","trmm"];
		private var tabButtons:Array;
		private var aT:Tween;
		private var effectSpeed:Number = .5;
		
		//insert a name title somewhere
		public function AboutPage(stageWidth:Number,stageHeight:Number,sat:String = "aqua") {
			sW = stageWidth;
			sH = stageHeight;
			dc = new DisplayContainer(sW,sH,0x000000,0,true);
			textContent = new MovieClip();
			aboutTitle = new MovieClip();
			tabFormat = new TextFormat("Arial",26,0xFFFFFF);
			tabButtons = [new AquaTab(),new AuraTab(),new TerraTab(), new TrmmTab()];
			//add title
			aboutTitle.addChild(new AboutTitle());
			
			//create tabs
			tabs = createTabStrip();
			tabs.y = titleH-tabs.height;
			tabs.x = aboutTitle.x + aboutTitle.width; 
			
			
			//display container hitbox
			drawHitBox(dc,sW,sH-titleH,0x000000,.65);
			dc.x = 0;
			dc.y = tabs.y + tabs.height;
			
			//initialize sat
			sat = sat.toLowerCase();
			if(sat == "aqua") {
				dc.changeContent(new AquaAboutText());
			}else if(sat == "aura") {
				dc.changeContent(new AuraAboutText());
			}else if(sat == "terra") {
				dc.changeContent(new TerraAboutText());
			}else if(sat == "trmm") {
				dc.changeContent(new TrmmAboutText());
			}
			
			//add mcs to stage
			addChild(aboutTitle);
			addChild(tabs);
			addChild(dc);
		}
		//creates a tabStrip
		public function createTabStrip():MovieClip {
			var tabStrip:MovieClip = new MovieClip();
			
			for(var i:Number = 0; i<tabButtons.length;i++) {
				var sTab:SimpleButton = tabButtons[i];
				sTab.name = sats[i];
				sTab.x = sTab.width * i;
				sTab.addEventListener(MouseEvent.CLICK,clicked);
				tabStrip.addChild(sTab);
			}
			
			return tabStrip;
		}
		public function clicked(e:MouseEvent) {
			var sat:String= e.target.name;
			//find out which sat was clicked
			if(sat == "aqua") {
				dc.changeContent(new AquaAboutText());
			}else if(sat == "aura") {
				dc.changeContent(new AuraAboutText());
			}else if(sat == "terra") {
				dc.changeContent(new TerraAboutText());
			}else if(sat == "trmm") {
				dc.changeContent(new TrmmAboutText());
			}
			
		}
		public function changeDisplay(c:MovieClip):void {
			textContent = c;
			//hide
			aT = new Tween(dc,"alpha",null,dc.alpha,0,effectSpeed,true);
			aT.addEventListener(TweenEvent.MOTION_FINISH,effectOut);
			
		}
		private function effectOut(e:TweenEvent):void { //effect used to change display is done
			//center content
			if (textContent.width > dc.width) {
				textContent.width = dc.width;
			}else {
				textContent.x = (dc.width - textContent.width)/2;
			}
			if (textContent.height > dc.height) {
				textContent.height = dc.height;
			}
			//change
			changeContent(dc,textContent);
			//effect back in
			new Tween(dc,"alpha",null,dc.alpha,1,effectSpeed,true);
		}
		//utility
		private function changeContent(con:*,obj:*):void { 
			while(con.numChildren) {
				con.removeChildAt(0);
			}
			con.addChild(obj);
		}
		private function drawHitBox(obj:*,w:Number,h:Number,color:uint = 0xFFFFFF,a:Number = 0):void {
			obj.graphics.clear();
			obj.graphics.beginFill(color,a);
			obj.graphics.drawRect(0,0,w,h);
			obj.graphics.endFill();
		}
		
	}
	
}
