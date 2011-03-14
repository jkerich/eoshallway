package  {
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	//import flash.system.*;
	//import flash.net.*;
	//import fl.transitions.easing.*;
	
	public class SpecsPage extends MovieClip {
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
		private var RETURNEVENT:String = "RETURNHOME";
	
		private var tabFormat:TextFormat;
		private var sats:Array = ["home","aqua","aura","terra"];
		private var tabButtons:Array;
		private var aT:Tween;
		private var effectSpeed:Number = .5;
		
		//insert a name title somewhere
		public function SpecsPage(stageWidth:Number,stageHeight:Number,sat:String = "aqua") {
			
			sW = stageWidth;
			sH = stageHeight;
			dc = new DisplayContainer(sW,sH,0x000000,0,true); //TODO: why draw hitbox twice (see statements below)?
			textContent = new MovieClip();
			aboutTitle = new MovieClip();
			tabFormat = new TextFormat("Arial",26,0xFFFFFF);
			tabButtons = [new HomeBtn(),new AquaTab(),new AuraTab(),new TerraTab()];
			//add title
			aboutTitle.addChild(new AboutTitle());
			
			//create tabs
			tabs = createTabStrip();
			tabs.y = titleH-tabs.height;
			tabs.x = aboutTitle.x + aboutTitle.width; 
			
			
			//display container hitbox
			Utils.drawHitBox(dc,sW,sH-titleH,0x000000,.65);
			dc.x = 0;
			dc.y = tabs.y + tabs.height;
			
			//initialize sat
			sat = sat.toLowerCase();
			if(sat == "aqua") {
				dc.changeContent(new AquaDetails());
			}else if(sat == "aura") {
				dc.changeContent(new AuraDetails());
			}else if(sat == "terra") {
				dc.changeContent(new TerraDetails());
			}else if(sat == "trmm") {
				dc.changeContent(new TrmmSpecs());
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
			tabStrip = Utils.scale(tabStrip,sW - aboutTitle.width,tabStrip.height); //resize properly
			return tabStrip;
		}
		public function clicked(e:MouseEvent) {
			var sat:String= e.target.name;
			//kill any flv videos playing on frame
			Utils.stopPlayback(dc.getContent());
			
			//find out which sat was clicked
			if(sat == "aqua") {
				dc.changeContent(new AquaDetails());
			}else if(sat == "aura") {
				dc.changeContent(new AuraDetails());
			}else if(sat == "terra") {
				dc.changeContent(new TerraDetails());
			}else if(sat == "trmm") {
				dc.changeContent(new TrmmSpecs());
			}else if(sat == "home") {
				dispatchEvent(new Event(RETURNEVENT)); // -----change this later
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
			Utils.changeContent(dc,textContent);
			//effect back in
			new Tween(dc,"alpha",null,dc.alpha,1,effectSpeed,true);
		}
		
	}
	
}
