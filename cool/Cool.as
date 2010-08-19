package  {
	import flash.display.*;
	import flash.net.*;
	import flash.events.*;
	import flash.text.*;
	import fl.transitions.*;
	
	public class Cool extends MovieClip {
		//mcs
		private var masterDisplay:MovieClip;
		private var slaveDisplay:MovieClip;
		private var title:MovieClip;
		private var homeRow:MovieClip;
		private var buttonRow:MovieClip;
		private var subButtonRow:MovieClip;
		
		//constants
		private var sats:Array = ["aqua","aura","terra","trmm"];
		private var paddingH:Number = 15;
		private var paddingW:Number = 35;
		
		
		
		//dynamic variables
		//cannot access stage until class is added to display list which does not occur until after all objects 
		//	already on stage are loaded -> use Event.ADDED_TO_STAGE
		private var sW:Number;
		private var sH:Number;
		private var slaveW:Number;
		private var slaveH:Number;
		private var buttonW:Number;
		private var buttonH:Number;
		private var titleW:Number;
		private var titleH:Number;
		private var subButtonW:Number;
		private var subButtonH:Number;
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
			sW = stage.stageWidth;
			sH = stage.stageHeight;
			titleH = (new EOSTitle()).height;
			
			titleW = (new EOSTitle()).width;
			
			slaveW = sW - paddingW;
			slaveH = sH - paddingH;
			
			subButtonH = 60;
			
			buttonW = slaveW/sats.length;
			buttonH = 200;
			
			//add title
			title = new EOSTitle();
			title.x = (sW-slaveW)/2;
			title.y = paddingH;
			addChild(title);
			
			//add display container
			var dc:DisplayContainer = new DisplayContainer(slaveW,slaveH-buttonH);  //need to change slaveH to val specific to dc
			dc.x = (sW-slaveW)/2;
			dc.y = 75;
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
			buttonRow.x = (sW - buttonRow.width)/2;
			buttonRow.y = dc.y + dc.height;
			addChild(buttonRow);
			
		}
		
		private function bigButtonClicked(e:MouseEvent):void {
			trace(e.currentTarget.getName());
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
		//utility functions
		
	}//end class
	
}//end package
