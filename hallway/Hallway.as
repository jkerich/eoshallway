package  {
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import fl.transitions.easing.Back;
	import fl.video.FLVPlayback;
	//import flash.net.*;
	//import flash.system.*;
	
	
	public class Hallway extends MovieClip {
		//mcs
		private var masterDisplay:MovieClip;
		private var slaveDisplay:Array; //an array of 4 movie clips
		private var title:MovieClip;
		private var homeRow:MovieClip;
		private var buttonRow:MovieClip;
		private var subButtonRow:MovieClip;
		private var frame:MovieClip;
		private var dc:DisplayContainer;
		
		//constants
		private const paddingH:Number = 8; //do not use decimal values
		private const paddingW:Number = 15;
		private var RETURNEVENT:String = "RETURNHOME";
		
		//arrays
		private var sats:Array = ["aqua","aura","terra"];
		private var defaultNames:Array = new Array("news","details");
		private var defaultHandlers:Array = new Array(newsClick,specsClick);
		private var aquaNames:Array = new Array("news","details","MODIS images");
		private var aquaHandlers:Array = new Array(newsClick,specsClick,modisClick);
		private var auraNames:Array = new Array("b","videos","specs","images");
		private var auraHandlers:Array = new Array(presentationsClick,videosClick,specsClick,imagesClick);
		private var terraNames:Array = new Array("news","details","MODIS images");
		private var terraHandlers:Array = new Array(newsClick,specsClick,modisClick);
		private var trmmNames:Array = new Array("d","videos","specs","images");
		private var trmmHandlers:Array = new Array(presentationsClick,videosClick,specsClick,imagesClick);
		//dynamic variables
		//cannot access stage until class is added to display list which does not occur until after all objects 
		//	already on stage are loaded -> use Event.ADDED_TO_STAGE
		private var sW:Number;
		private var sH:Number;
		private var slaveW:Number;
		private var slaveH:Number;
		private var buttonW:Number;
		private var buttonH:Number = 150;
		private var titleW:Number;
		private var titleH:Number;
		private var subButtonW:Number;
		private var subButtonH:Number = 75;
		private var homeRowButtons:Array;
		private var homeRowHandlers:Array;
		private var currentDisplay:Number = 0;
		
		//check if animating
		//private var animating:Boolean = false;
		
		/*
		TODO:
			-add frame changing effect
		*/
		
		public function Hallway() {
			//stage.displayState = StageDisplayState.FULL_SCREEN;
			addEventListener(Event.ADDED_TO_STAGE,init);
			
		}
		private function init(e:Event):void {
			//prevent flv fullscreen takeover
			stage.addEventListener(Event.ADDED,killTakeOver);
			
			homeRowButtons = [new QuickFactsBtn(),new PowerPointBtn()];
			homeRowHandlers = [factsClick,powerPointClick];

			//prevent repeats
			removeEventListener(Event.ADDED_TO_STAGE,init);
			
			//--derived vars
			//compute heights
			sW = stage.stageWidth;
			sH = stage.stageHeight;
			slaveW = sW - paddingW*2;//centered content, x2 is to apply for both sides
			slaveH = sH - paddingH*2;
			
			titleH = (new EOSTitle()).height;//title
			titleW = (new EOSTitle()).width;
			
			buttonW = slaveW/sats.length; //big buttons in middle, height is constant
			subButtonW = slaveW;
			
			//slave containers
			masterDisplay = new MovieClip();
			slaveDisplay = new Array();
			for(var a:Number = 0;a<4;a++) {  //4 displays
				//random color
				var sd:MovieClip = new MovieClip(); 
				var color:uint = Math.random()*0xFFFFFF;
				sd = new MovieClip();//----------------------------------redundant
				Utils.drawHitBox(sd,slaveW,slaveH,color,.3);
				
				slaveDisplay.push(sd);
				masterDisplay.addChild(slaveDisplay[a]);
			}
			//position slave displays
			slaveDisplay[0].x = paddingW;
			slaveDisplay[0].y = paddingH;
			slaveDisplay[1].x = slaveW + paddingW*2; //coughsWcough
			slaveDisplay[1].y = paddingH;
			slaveDisplay[2].x = paddingW;
			slaveDisplay[2].y = slaveH + paddingH*2;
			slaveDisplay[3].x = slaveW + paddingW*2;
			slaveDisplay[3].y = slaveH + paddingH*2;
			
			//add title
			title = new EOSTitle();
			slaveDisplay[0].addChild(title);
			
			//add display container
			dc= new DisplayContainer(slaveW,slaveH-buttonH-subButtonH-titleH,0x000000,.65,true);
			//dc.x = paddingW;
			dc.y = title.y + titleH;
			slaveDisplay[0].addChild(dc);
			
			//add home buttons
			homeRow = new MovieClip();
			for (var b:Number = 0;b<homeRowButtons.length;b++) {
				homeRowButtons[b].x = homeRowButtons[b].width * b;
				homeRowButtons[b].addEventListener(MouseEvent.CLICK,homeRowHandlers[b]);
				homeRow.addChild(homeRowButtons[b]);
			}
			homeRow.x = titleW + title.x;
			homeRow.y = dc.y - homeRow.height;
			slaveDisplay[0].addChild(homeRow);
			
			//add fullscreen button
			var fsb:FullscreenBtn = new FullscreenBtn();
			fsb.addEventListener(MouseEvent.CLICK,fullscreenMode);
			fsb.x = slaveW - fsb.width - 10;
			fsb.y = 10;
			slaveDisplay[0].addChild(fsb);
			
			
			//add big buttons
			buttonRow = new MovieClip();
			for(var i:Number = 0;i<sats.length;i++) {
				var btn:HallwayButton = new HallwayButton(sats[i],buttonW,buttonH);
				btn.x = btn.width * i;
				btn.addEventListener(MouseEvent.CLICK,bigButtonClicked);
				buttonRow.addChild(btn);
			}
			//buttonRow.x = paddingW;
			buttonRow.y = dc.y + dc.height;
			
			//add frame
			frame = new MovieClip();
			Utils.drawHitBox(frame,buttonW,buttonH,0x000000,.65); //generalize dc color
			//frame.x = paddingW;
			frame.y = buttonRow.y;
			
			//add sub buttons
			subButtonRow = new SubButtonRow(sats[0],subButtonW,subButtonH,aquaNames,aquaHandlers); //since aqua is first
			//subButtonRow.x = paddingW;
			subButtonRow.y = buttonRow.y + buttonH;
			slaveDisplay[0].addChild(frame);
			slaveDisplay[0].addChild(buttonRow); //add after frame so button text appears in front of frame
			slaveDisplay[0].addChild(subButtonRow);
			
			addChild(masterDisplay);
			
			//allow people to get back to home page
			stage.addEventListener(KeyboardEvent.KEY_DOWN,returnHome);
			
			//load first about content
			dc.changeContent(new AquaAboutText());
			

		}
		private function returnHome(e:Event):void {
			//trace("key down");
			new Tween(masterDisplay,"x",Back.easeOut,masterDisplay.x,0,.5,true);
			new Tween(masterDisplay,"y",Back.easeOut,masterDisplay.y,0,.5,true);
		}
		private function moveDisplay(dir:String):void {
			if(dir == "right") {
				new Tween(masterDisplay,"x",Back.easeOut,masterDisplay.x,-sW+paddingW,.5,true);
			}else if(dir == "down") {
				new Tween(masterDisplay,"y",Back.easeOut,masterDisplay.y,-sH+paddingH,.5,true);
			}else if(dir == "left") {
				new Tween(masterDisplay,"x",Back.easeOut,masterDisplay.x,0,.5,true);
			}else if(dir == "up") {
				new Tween(masterDisplay,"y",Back.easeOut,masterDisplay.y,sH-paddingH,.5,true);
			}
			
		}
		private function bigButtonClicked(e:MouseEvent):void {
			
			var tar:Object = e.currentTarget;
			new Tween(frame,"x", Back.easeIn,frame.x,tar.x+buttonRow.x,.3,true); //adjust easing
			
			//change sub row
			trace("clicked", tar.getName());
			if (tar.getName() == "aqua") {
				subButtonRow.changeSat("aqua",aquaNames,aquaHandlers); 
				dc.changeContent(new AquaAboutText());
			}else if(tar.getName() == "aura") {
				subButtonRow.changeSat("aura",defaultNames,defaultHandlers); 
				dc.changeContent(new AuraAboutText());
			}else if(tar.getName() == "terra") {
				subButtonRow.changeSat("terra",terraNames,terraHandlers); 
				dc.changeContent(new TerraAboutText());
			}else if(tar.getName() == "trmm") {
				subButtonRow.changeSat("trmm",trmmNames,trmmHandlers); 
				dc.changeContent(new TrmmAboutText());
			}
			
		}
		//homerow handlers
		private function fullscreenMode(e:MouseEvent):void {
			stage.displayState = StageDisplayState.FULL_SCREEN;
		}
		private function powerPointClick(e:MouseEvent):void {
			trace("power point clicked");
			var pp:PPTViewer = new PPTViewer(slaveW,slaveH);
			pp.addEventListener(RETURNEVENT,returnHome);
			Utils.changeContent(slaveDisplay[2],pp);
			moveDisplay("down");
		}
		private function mediaClick(e:MouseEvent):void {
			trace("media clicked");
			//load media click
			var ss:SlideShow = new SlideShow(slaveW,slaveH);
			ss.addEventListener(RETURNEVENT,returnHome);
			Utils.changeContent(slaveDisplay[3],ss);
			moveDisplay("down");
			moveDisplay("right");
		}
		private function homeClick(e:MouseEvent):void {
			trace("home clicked");
		}
		private function orbitsClick(e:MouseEvent):void {
			trace("orbits clicked");
			moveDisplay("down");
		}
		private function factsClick(e:MouseEvent):void { //this is top row Quick Facts button
			var sp:SpecsPage = new SpecsPage(slaveW,slaveH);
			sp.addEventListener(RETURNEVENT,returnHome);
			Utils.changeContent(slaveDisplay[1],sp);
			moveDisplay("right");
		}
		//sub button handlers
		private function modisClick(e:MouseEvent):void {
			trace("modis click");
			var sat:String = e.currentTarget.parent.getName();
			var mm:ModisModule = new ModisModule(slaveW,slaveH,sat);
			mm.addEventListener(RETURNEVENT,returnHome);
			Utils.changeContent(slaveDisplay[3],mm);
			moveDisplay("down");
			moveDisplay("right");
		}
		private function newsClick(e:MouseEvent):void {
			var sat:String = e.currentTarget.parent.getName();
			sat = sat.toLowerCase();
			
			if (sat == "aqua") {
				dc.changeContent(new AquaNews());
			}else if(sat == "aura") {
				dc.changeContent(new AuraNews());
			}else if(sat == "terra") {
				dc.changeContent(new TerraNews());
			}
		}
		private function aboutClick(e:MouseEvent):void {
			trace("about click");
		}
		private function presentationsClick(e:MouseEvent):void {
			trace("presentations clicked");
		}
		private function videosClick(e:MouseEvent):void {
			trace("videos clicked");
		}
		private function specsClick(e:MouseEvent):void { //this is subbutton row details button
			var sat:String = e.currentTarget.parent.getName();
			sat = sat.toLowerCase();
			var sp:SpecsPage = new SpecsPage(slaveW,slaveH,sat);
			sp.addEventListener(RETURNEVENT,returnHome);
			Utils.changeContent(slaveDisplay[1],sp);
			moveDisplay("right");
		}
		private function imagesClick(e:MouseEvent):void {
			trace("images clicked");
		}
		//silly code to fix idiot syncrasies 
		private function killTakeOver(e:Event):void {
			if (e.target is FLVPlayback) {
				e.target.fullScreenTakeOver = false;
				
			}
		}
	}//end class
	
}//end package
