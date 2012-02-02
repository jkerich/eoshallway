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
		private var tabFormat:TextFormat;
		private var tabButtonNames:Array;
		private var tabButtons:Array;
		private var aT:Tween;
		private var effectSpeed:Number = .5;
		
		/*
		SpecsPage.as
			This class describes the details page slideshow. Note that there is code attached to the first frames of each of the 
			loaded slide shows.
		*/		
		public function SpecsPage(stageWidth:Number,stageHeight:Number,sat:String = "aqua") {
			
			sW = stageWidth;
			sH = stageHeight;
			dc = new DisplayContainer(sW,sH,0x000000,0,true); //TODO: why draw hitbox twice (see statements below)?
			textContent = new MovieClip();
			aboutTitle = new MovieClip();
			tabFormat = new TextFormat("Arial",26,0xFFFFFF);
			
			/* 
			ADD/CHANGE tab row buttons here make sure the array indicies match
			GENERIC EXAMPLE:
				tabButtonNames = ["New Button"];
				tabButtons = [new newButtonLibraryAsset()];
			*/
			tabButtonNames = ["home","aqua","aura","terra"];
			tabButtons = [new HomeBtn(),new AquaTab(),new AuraTab(),new TerraTab()];
			
			//CHANGE library asset for page title here
			aboutTitle.addChild(new AboutTitle());
			
			//create tabs
			tabs = createTabStrip();
			tabs.y = titleH-tabs.height;
			tabs.x = aboutTitle.x + aboutTitle.width; 
			
			
			//display container hitbox
			Utils.drawHitBox(dc,sW,sH-titleH,0x000000,.65);
			dc.x = 0;
			dc.y = tabs.y + tabs.height;
			
			//load first sat detail slide
			/*
			GENERIC EXAMPLE:
				else if(sat == <sat_name>)
					dc.changeContent(<library_instance>)
			*/
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
		/*
		createTabStrip
			Purpose: 
				Creates the tab strip at the top next to the title.
		*/
		public function createTabStrip():MovieClip {
			var tabStrip:MovieClip = new MovieClip();
			
			for(var i:Number = 0; i<tabButtons.length;i++) {
				var sTab:SimpleButton = tabButtons[i];
				sTab.name = tabButtonNames[i];
				sTab.x = sTab.width * i;
				sTab.addEventListener(MouseEvent.CLICK,clicked,false,0,true);
				tabStrip.addChild(sTab);
			}
			tabStrip = Utils.scale(tabStrip,sW - aboutTitle.width,tabStrip.height); //resize properly
			return tabStrip;
		}
		/*
		clicked
			Purpose:
				Change slideshow based on which tab is clicked.
		*/
		public function clicked(e:MouseEvent) {
			var sat:String= e.target.name;
			//kill any flv videos playing on frame
			Utils.stopPlayback(dc.getContent());
			
			//find out which tab was clicked
			/*
			GENERIC EXAMPLE:
				if(sat == <sat_name>) 
					dc.changeContent(<library_asset>);
					//or whatever else needs to be done
			*/
			if(sat == "aqua") {
				dc.changeContent(new AquaDetails());
			}else if(sat == "aura") {
				dc.changeContent(new AuraDetails());
			}else if(sat == "terra") {
				dc.changeContent(new TerraDetails());
			}else if(sat == "trmm") {
				dc.changeContent(new TrmmSpecs());
			}else if(sat == "home") {
				dispatchEvent(new Event(Hallway.RETURNEVENT)); 
			}
		}
	}
}
