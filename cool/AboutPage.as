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
		private var displayContainer:MovieClip;
		private var tabs:MovieClip;
		private var buttons:MovieClip;
		private var aboutTitle:MovieClip;
		private var textContent:MovieClip; 
		//constants
		private var sH:Number;
		private var sW:Number;
		private var tabH:Number;
		private var buttonH:Number;
		private var titleW:Number;
		private var titleH:Number = 65;
		private var titleSize:Number = 35;
		private var outlineColor:uint = 0xFFFFFF;
		private var displayWidth:Number = 700;
		private var displayHeight:Number = 600;
		private var tabFormat:TextFormat;
		private var sats:Array = ["AQUA","AURA","TERRA","TRMM"];
		private var tabButtons:Array;
		private var picButtons:Array;
		private var aT:Tween;
		private var effectSpeed:Number = .5;
		
		//title
		public function AboutPage(stageWidth:Number,stageHeight:Number,sat:String = "aqua") {
			sW = stageWidth;
			sH = stageHeight;
			displayContainer = new MovieClip();
			textContent = new MovieClip();
			aboutTitle = new MovieClip();
			tabFormat = new TextFormat("Arial",26,0xFFFFFF);
			tabButtons = [new AquaTab(),new AuraTab(),new TerraTab(), new TrmmTab()];
			picButtons = [new AquaButton(),new AuraButton(), new TerraButton(), new TrmmButton()];
			
			//add title
			aboutTitle.addChild(new AboutTitle());
			
			//create tabs and button strip
			buttons = createButtons();
			tabs = createTabStrip();
			//must be this order
			buttons.x = 0;
			tabs.y = titleH-tabs.height;
			buttons.y = aboutTitle.y + titleH;
			tabs.x = aboutTitle.x + aboutTitle.width; 
			
			
			//display container hitbox
			drawHitBox(displayContainer,displayWidth,displayHeight);
			displayContainer.x = tabs.x + 10;
			displayContainer.y = tabs.y + tabs.height + 10;
			
			//initialize sat
			sat = sat.toUpperCase();
			if(sat == "AQUA") {
				changeDisplay(new AquaAboutText());
			}else if(sat == "AURA") {
				changeDisplay(new AuraAboutText());
			}else if(sat == "TERRA") {
				changeDisplay(new TerraAboutText());
			}else if(sat == "TRMM") {
				changeDisplay(new TrmmAboutText());
			}
			
			//add mcs to stage
			addChild(aboutTitle);
			addChild(buttons);
			addChild(tabs);
			addChild(displayContainer);
		}
		public function createButtons():MovieClip {
			var container:MovieClip = new MovieClip();
			for(var i:Number = 0; i<picButtons.length;i++) {
				var btn:SimpleButton = picButtons[i];
				btn.name = sats[i];
				btn.y = btn.height * i;
				btn.addEventListener(MouseEvent.CLICK,clicked);
				container.addChild(btn);
			}
			return container;
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
			var tar:Object = e.target;
			//find out which sat was clicked
			if(tar.name == "AQUA") {
				changeDisplay(new AquaAboutText());
			}else if(tar.name == "AURA") {
				changeDisplay(new AuraAboutText());
			}else if(tar.name == "TERRA") {
				changeDisplay(new TerraAboutText());
			}else if(tar.name == "TRMM") {
				changeDisplay(new TrmmAboutText());
			}
			
		}
		public function changeDisplay(c:MovieClip):void {
			
			textContent = c;
			//hide
			aT = new Tween(displayContainer,"alpha",null,displayContainer.alpha,0,effectSpeed,true);
			aT.addEventListener(TweenEvent.MOTION_FINISH,effectOut);
			
		}
		private function effectOut(e:TweenEvent):void { //effect used to change display is done
			//center content
			if (textContent.width > displayContainer.width) {
				textContent.width = displayContainer.width;
			}else {
				textContent.x = (displayContainer.width - textContent.width)/2;
			}
			if (textContent.height > displayContainer.height) {
				textContent.height = displayContainer.height;
			}
			//change
			changeContent(displayContainer,textContent);
			//effect back in
			new Tween(displayContainer,"alpha",null,displayContainer.alpha,1,effectSpeed,true);
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
