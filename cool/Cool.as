package  {
	import flash.display.*;
	import flash.net.*;
	import flash.events.*;
	import flash.text.*;
	import fl.transitions.*;
	import fl.transitions.easing.*;
	
	public class Cool extends MovieClip {
		//mcs
		private var masterDisplay:MovieClip;
		private var slaveDisplay:MovieClip;
		private var title:MovieClip;
		private var homeRow:MovieClip;
		private var buttonRow:MovieClip;
		private var subButtonRow:MovieClip;
		private var frame:MovieClip;
		
		//constants
		private var paddingH:Number = 8; //do not use decimal values
		private var paddingW:Number = 15;
		
		//arrays
		private var sats:Array = ["aqua","aura","terra","trmm"];
		var defaultNames:Array = new Array("about","presentations","videos","specs","images");
		var defaultHandlers:Array = new Array(aboutClick,presentationsClick,videosClick,specsClick,imagesClick);
		var slimNames:Array = new Array("poot","minatuar","videos","specs","images");
		var slimHandlers:Array = new Array(aboutClick,presentationsClick,videosClick,specsClick,imagesClick);
		
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
		
		/*
		TODO:
			-consider scaling buttonH and buttonW
			-automate positioning of homeRow
			-add subbutton row
			-add frame changing effect
			
			
			-figure out liquid heights
		*/
		
		public function Cool() {
			addEventListener(Event.ADDED_TO_STAGE,init);
		}
		private function init(e:Event):void {
			homeRowButtons = [new HomeBtn(), new MediaBtn(), new OrbitsBtn() ,new QuickFactsBtn()];
			homeRowHandlers = [homeClick, mediaClick, orbitsClick ,factsClick];
			
			//prevent repeats
			removeEventListener(Event.ADDED_TO_STAGE,init);
			
			//derived vars
			
			//compute heights
			sW = stage.stageWidth;
			sH = stage.stageHeight;
			slaveW = sW - paddingW*2;//centered content, x2 is to apply for both sides
			slaveH = sH - paddingH*2;
			
			titleH = (new EOSTitle()).height;//title
			titleW = (new EOSTitle()).width;
			
			buttonW = slaveW/sats.length; //big buttons in middle, height is constant
			subButtonW = slaveW;
			
			//add title
			title = new EOSTitle();
			title.x = paddingW;
			title.y = paddingH;
			addChild(title);
			
			//add display container
			var dc:DisplayContainer = new DisplayContainer(slaveW,slaveH-buttonH-subButtonH-titleH);  //need to change slaveH to val specific to dc
			dc.x = paddingW;
			dc.y = title.y + titleH;
			addChild(dc);
			
			//add home buttons
			homeRow = new MovieClip();
			for (var b:Number = 0;b<homeRowButtons.length;b++) {
				homeRowButtons[b].x = homeRowButtons[b].width * b;
				homeRowButtons[b].addEventListener(MouseEvent.CLICK,homeRowHandlers[b]);
				homeRow.addChild(homeRowButtons[b]);
			}
			homeRow.x = titleW + title.x;
			homeRow.y = dc.y - homeRow.height;
			addChild(homeRow);
			
			
			//add big buttons
			buttonRow = new MovieClip();
			for(var i:Number = 0;i<sats.length;i++) {
				var btn:CoolButton = new CoolButton(sats[i],buttonW,buttonH);
				btn.x = btn.width * i;
				btn.addEventListener(MouseEvent.CLICK,bigButtonClicked);
				buttonRow.addChild(btn);
			}
			buttonRow.x = paddingW;
			buttonRow.y = dc.y + dc.height;
			
			//add frame
			frame = new MovieClip();
			drawHitBox(frame,buttonW,buttonH,0x000000,.65); //generalize dc color
			frame.x = paddingW;
			frame.y = buttonRow.y;
			
			//add sub buttons
			subButtonRow = new SubButtonRow(sats[0],subButtonW,subButtonH,defaultNames,defaultHandlers);
			subButtonRow.x = paddingW;
			subButtonRow.y = buttonRow.y + buttonH;
			
			addChild(frame);
			addChild(buttonRow); //add after frame so button text appears in front of frame
			addChild(subButtonRow);

		}
		private function bigButtonClicked(e:MouseEvent):void {
			var tar:Object = e.currentTarget;
			new Tween(frame,"x", Back.easeOut,frame.x,tar.x+buttonRow.x,.3,true); //adjust easing
			
			//change sub row
			subButtonRow.changeSat(tar.getName(),slimNames,slimHandlers); //make specific to each sat
		}
		//homerow handlers
		private function mediaClick(e:MouseEvent):void {
			trace("media clicked");
		}
		private function homeClick(e:MouseEvent):void {
			trace("home clicked");
		}
		private function orbitsClick(e:MouseEvent):void {
			trace("orbits clicked");
		}
		private function factsClick(e:MouseEvent):void {
			trace("facts clicked");
		}
		//sub button handlers
		private function aboutClick(e:MouseEvent):void {
			trace("about clicked");
		}
		private function presentationsClick(e:MouseEvent):void {
			trace("presentations clicked");
		}
		private function videosClick(e:MouseEvent):void {
			trace("videos clicked");
		}
		private function specsClick(e:MouseEvent):void {
			trace("specs clicked");
		}
		private function imagesClick(e:MouseEvent):void {
			trace("images clicked");
		}
		
		
		//utility functions
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
	}//end class
	
}//end package
