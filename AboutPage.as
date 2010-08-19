package  {
	import flash.text.*;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.SimpleButton;
	import fl.transitions.Tween;
	import flash.display.Stage;
	
	public class AboutPage extends MovieClip {
		//mcs
		private var displayContainer:MovieClip;
		private var tabs:MovieClip;
		private var buttons:MovieClip;
		private var aboutTitle:TextField;
		//constants
		private var sH:Number;
		private var sW:Number;
		private var tabH:Number;
		private var buttonH:Number;
		private var titleH:Number = 36;
		private var outlineColor:uint = 0xFFFFFF;
		private var displayWidth:Number = 700;
		private var displayHeight:Number = 600;
		private var tabFormat:TextFormat;
		private var sats:Array = ["AQUA","AURA","TERRA","TRMM"];
		private var tabButtons:Array;
		private var picButtons:Array;
		private var aT:Tween;
		private var bT:Tween;
		
		//title
		
		public function AboutPage(stageWidth:Number,stageHeight:Number) {
			this.sW = stageWidth;
			this.sH = stageHeight;
			var buttonContainer:MovieClip = new ButtonContainer();
			displayContainer = new MovieClip();
			aboutTitle = new TextField();
			tabFormat = new TextFormat("Arial",26,0xFFFFFF);
			tabButtons = [new AquaTab(),new AuraTab(),new TerraTab(), new TrmmTab()];
			picButtons = [new AquaButton(),new AuraButton(), new TerraButton(), new TrmmButton()];
			
			
			//add background
			var bg:MovieClip = new GradientBackground();
			bg.width = sW;
			bg.height = sH;
			bg.x = 0;
			bg.y = 0;
			
			//add title
			var tf:TextFormat = new TextFormat("Walkway SemiBold",titleH,0xFFFFFF);
			aboutTitle.text = "EOS Spacecraft Quick Facts";
			aboutTitle.setTextFormat(tf);
			aboutTitle.autoSize = TextFieldAutoSize.CENTER;
			aboutTitle.x = 0;
			aboutTitle.y = 0;
			
			//create tabs and button strip
			buttons = createButtons();
			tabs = createTabStrip();
			//must be this order
			buttons.x = 0;
			tabs.y = 40;
			buttons.y = tabs.y + tabs.height;
			tabs.x = buttons.x + buttons.width; 
			
			
			
			//display container hitbox
			displayContainer.graphics.clear();
			displayContainer.graphics.beginFill(0xFFFFFF,0);
			displayContainer.graphics.drawRect(0,0,displayWidth,displayHeight);
			displayContainer.graphics.endFill();
			displayContainer.x = tabs.x + 10;
			displayContainer.y = tabs.y + tabs.height + 10;
			
			
			
			//add mcs to stage
			addChild(bg);
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
			//hide
			displayContainer.alpha = 0
			//reset
			if(displayContainer.numChildren > 0) {
				displayContainer.removeChildAt(0);
			}
			//center content
			if (c.width > displayContainer.width) {
				c.width = displayContainer.width;
			}else {
				c.x = (displayContainer.width - c.width)/2;
			}
			if (c.height > displayContainer.height) {
				c.height = displayContainer.height;
			}
			//add to stage and tween
			displayContainer.addChild(c);
			new Tween(displayContainer,"alpha",null,displayContainer.alpha,1,.5,true);
		}
	}
	
}
