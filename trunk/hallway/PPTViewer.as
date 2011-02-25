package {
	import flash.display.*;
	import flash.filesystem.File;
	import flash.events.*;
	import fl.controls.List;
	import flash.text.*;

	public class PPTViewer extends MovieClip {

		private var pptDir:String;
		private var acceptedFileTypes:Array = ["ppt","ppsx"];
		private var pptFiles:Array;
		private var scrollBox:List;
		private var selectedPPT:TextField;

		public function PPTViewer(powerPointDir:String = "PowerPoints") {
			pptDir = powerPointDir;
			pptFiles = new Array();
			
			
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
			
			
			
			//create scroll box
			scrollBox = new List();
			scrollBox.setSize(300,600);//slaveW,slaveH
			for(var i=0;i<pptFiles.length;i++) {
				scrollBox.addItem({label:pptFiles[i].name,data:pptFiles[i].name});
			}
			scrollBox.addEventListener(Event.CHANGE,listItemChanged);
			addChild(scrollBox);
			
			//create text field
			selectedPPT = new TextField();
			selectedPPT.defaultTextFormat = new TextFormat("Walkway SemiBold",26,0xFFFFFF);
			selectedPPT.autoSize = TextFieldAutoSize.LEFT;
			selectedPPT.text = "No power point selected";
			selectedPPT.x = scrollBox.width + 10;
			selectedPPT.y = 10;
			addChild(selectedPPT);
			
			//create launch button
			var launch:MovieClip = new MovieClip();
			Utils.drawHitBox(launch,150,50,0xFF1111,1);
			launch.x = scrollBox.width + 10;
			launch.y = selectedPPT.y + selectedPPT.height + 10;
			launch.addEventListener(MouseEvent.CLICK,launchClick);
			
			addChild(launch);
		}
		private function launchClick(e:MouseEvent):void {
			if(scrollBox.selectedItem == null) {
				trace("No item selected");
				return;
			}
			Utils.launchApp(scrollBox.selectedItem.label,"PowerPoints");
			
		}
		private function listItemChanged(e:Event):void {
			selectedPPT.text = scrollBox.selectedItem.label;
		}

	}

}