package {
	import flash.display.MovieClip;
	import flash.filesystem.File;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NativeProcessExitEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	//import fl.managers.StyleManager;

	public class PPTViewer extends MovieClip {

		private var sW:Number;
		private var sH:Number;
		private var pptDir:String;
		private var acceptedFileTypes:Array = ["ppt","ppsx","pptx","pps","odp"];
		private var pptFiles:Array;
		private var scrollBox:ListNoKeyboard;
		private var selectedPPT:TextField;
		private var fileOpen:Boolean = false;
		private var touchTimer:Timer;
		private var container:MovieClip; //container to contain all inner elements
		
		//TODO: consider scaling container
		public function PPTViewer(stageWidth:Number,stageHeight:Number,powerPointDir:String = "PowerPoints") {
			sW = stageWidth;
			sH = stageHeight;
			pptDir = powerPointDir;
			pptFiles = new Array();
			container = new MovieClip();
			
			//fill out
			Utils.drawHitBox(this,sW,sH);
			
			//list files
			var files:Array = Utils.listFiles(pptDir);
			
			for each (var f:File in files) {
				//check extension against accepted file types
				for each(var type:String in acceptedFileTypes) {
					if(f.extension.search(type) != -1) {
						pptFiles.push(f);
						break;
					}
				}
			}
			//create title and home button
			var pTitle:MovieClip = new PowerPointTitle();
			var home:* = new HomeBtn();
			home.x = pTitle.width;
			home.y = (pTitle.height - home.height);
			home.addEventListener(MouseEvent.CLICK,goHome,false,0,true);
			
			
			//create scroll box
			scrollBox = new ListNoKeyboard();
			//change style -requires more work
			/*var tf:TextFormat = new TextFormat();
			tf.font = "Times New Roman";
			tf.bold = true;
			tf.size = 20;
			tf.color = 0x000000;
			StyleManager.setStyle('embedFonts',true);
			StyleManager.setStyle('textFormat',tf);*/
			
			scrollBox.setSize(sW/3,(sH*(2/3)) - pTitle.height-10);//slaveW,slaveH
			scrollBox.y = pTitle.y + pTitle.height + 10;
			scrollBox.x = 10;
			for(var i=0;i<pptFiles.length;i++) {
				scrollBox.addItem({label:pptFiles[i].name,data:pptFiles[i].name});
			}
			
			scrollBox.addEventListener(Event.CHANGE,listItemChanged,false,0,true);
			
			
			//create text field
			selectedPPT = new TextField();
			selectedPPT.defaultTextFormat = new TextFormat("Walkway SemiBold",26,0xFFFFFF);
			selectedPPT.autoSize = TextFieldAutoSize.LEFT;
			selectedPPT.text = "No power point selected";
			selectedPPT.x = scrollBox.x + scrollBox.width + 10;
			selectedPPT.y = pTitle.y + pTitle.height + 10;
			
			
			//create launch button
			var launch:MovieClip = new MovieClip();
			var t:TextField = new TextField();
			t.defaultTextFormat = new TextFormat("Walkway SemiBold",24,0xFFFFFF);
			t.autoSize = TextFieldAutoSize.LEFT;
			t.text = "Launch";
			t.selectable = false;
			Utils.drawHitBox(launch,150,50,0xFF1111,1);
			t.x = (launch.width - t.width)/2;
			t.y = (launch.height - t.textHeight)/2;
			launch.addChild(t);
			launch.x = scrollBox.x + scrollBox.width + 10;
			launch.y = selectedPPT.y + selectedPPT.height + 10;
			launch.addEventListener(MouseEvent.CLICK,launchClick,false,0,true);
			
			//add timer
			//touchTimer = new Timer(1000,);
			//timer.addEventListener(TimerEvent.TIMER,disableTouch); 
			
			container.addChild(pTitle);
			container.addChild(home);
			container.addChild(scrollBox);
			container.addChild(selectedPPT);
			container.addChild(launch);
			Utils.drawHitBox(container,container.width+10,sH*(2/3)+10,0x000000,.65);
			//center and place container
			container.x = (sW - container.width)/2;
			container.y = (sH - container.height)/2;
			addChild(container);
		}
		private function pEnd(e:NativeProcessExitEvent):void {
			trace("process exited");
			//fileOpen = false;
			
		}
		private function goHome(e:MouseEvent):void {
			dispatchEvent(new Event(Hallway.RETURNEVENT));
		}
		private function disableTouch(e:TimerEvent) {
			
		}
		private function launchClick(e:MouseEvent):void {
			//make sure a ppt isn't already being opened
			//if(fileOpen) 
				//return;
			
			if(touchTimer.running) {
				return;
			}
			
			//make sure a ppt has been selected
			if(scrollBox.selectedItem == null) {
				trace("No item selected");
				return;
			}
			
			//launch
			//trace(scrollBox.selectedItem.label);
			Utils.launchApp(scrollBox.selectedItem.label,"PowerPoints",pEnd);
			fileOpen = true;
			
		}
		private function listItemChanged(e:Event):void {
			selectedPPT.text = scrollBox.selectedItem.label;
		}

	}

}
