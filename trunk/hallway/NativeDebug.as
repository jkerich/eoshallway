package  {
	import flash.display.*;
	import flash.filesystem.*;
	import flash.system.*;
	import flash.desktop.*;	
	import flash.events.*;
	import flash.events.ProgressEvent;
	import flash.utils.ByteArray;
	import flash.text.*;
	
	/*
	This file should be used to debug the launchApp() function in Utils.as should it fail. The only difference
	is this version contains a bunch of event listeners. 
	
	As with Utils.as the AIR application has to be 2.0 and use only the "ExtendedDesktop" profile.
	
	Notes about script file (under windows, untested in other environments):
	-It has to be cmd. Flash filters bat files.
	-The function passes the file name argument broken up by spaces. This is because Flash does some weird escaping 
	 when passing an argument with spaces that the cmd file cannot understand. So the script file has to deal with 
	 that.
	-When debugging it is ESSENTIAL to remove the "@echo off" statement from the script file or modify it to 
	 "@echo on". Otherwise commandline output is hidden and will not trigger the event listeners.
	*/
	public class NativeDebug extends MovieClip {
		
		public function NativeDebug() {
			//trace(launchApp("test.ppt"));
			
			//process.addEventListener(ProgressEvent.STANDARD_OUTPUT_DATA,dataIncoming);
			var ar:Array = Utils.listFiles("PowerPoints");
			var btnAr:Array = new Array();
			
			for (var i=0;i<ar.length;i++) {
				btnAr.push(createButton(ar[i].name));
				btnAr[i].y = i * btnAr[i].height;
				btnAr[i].addEventListener(MouseEvent.CLICK,clicked);
				addChild(btnAr[i]);
				
			}			
			
		}	
		private function clicked(e:MouseEvent):void {
			//trace(e.currentTarget.name);
			launchApp(e.currentTarget.name,"PowerPoints");
		}
		private function createButton(labelText:String):MovieClip {
			var t:TextField = new TextField();
			t.autoSize = TextFieldAutoSize.LEFT;
			t.text = labelText;
			t.selectable = false;
			t.setTextFormat(new TextFormat("Walkway Bold",14,0x000000));
			var btn:MovieClip = new MovieClip();
			btn.graphics.beginFill(0xcccccc,1);
			btn.graphics.drawRect(0,0,t.width+10,t.textHeight+10);
			btn.graphics.endFill();
			btn.name = labelText;
			btn.addChild(t);
			return btn;
		}
		//requires run.cmd
		private function launchApp(fileName:String,workingDir:String):Boolean {//working dir limited to app directory
			
			if(NativeProcess.isSupported) {			
				trace("Launching app: " + fileName);
				//arguments
				var args:Vector.<String> = new Vector.<String>();
				
				//split filename up by spaces and let script handle merging them to a workable state
				var ar:Array = fileName.split(" ");
				for each(var word:String in ar) {
					args.push(word);
				}
			
				//access cmd file
				var file:File = File.applicationDirectory.resolvePath("run.cmd");
				
				//info about the file
				var startInfo:NativeProcessStartupInfo = new NativeProcessStartupInfo();
				startInfo.workingDirectory = File.applicationDirectory.resolvePath(workingDir);
				startInfo.executable = file;
				startInfo.arguments = args;
				
				
				//create and start process
				var process:NativeProcess = new NativeProcess();
				//add a bunch of event listeners
				process.addEventListener(ProgressEvent.STANDARD_ERROR_DATA,err);
				process.addEventListener(ProgressEvent.STANDARD_OUTPUT_DATA,dataIncoming);
				process.addEventListener(ProgressEvent.STANDARD_INPUT_PROGRESS,inputProg);
				process.addEventListener(Event.STANDARD_ERROR_CLOSE,errClose);
				process.addEventListener(Event.STANDARD_INPUT_CLOSE,inputClose);
				process.addEventListener(Event.STANDARD_OUTPUT_CLOSE,outputClose);
				process.addEventListener(IOErrorEvent.STANDARD_ERROR_IO_ERROR,ioerr);
				process.addEventListener(IOErrorEvent.STANDARD_ERROR_IO_ERROR, ioerr);
				
				//start process
				process.start(startInfo);
				//process.closeInput();
				//process.exit();//this could be a problem point (and it was, prevented events from triggers)
				
				return true;
				
			}else {
				trace("Error: Native process appears to not be supported");
				return false;
			}
		}
		private function ioerr(e:IOErrorEvent):void {
			trace("IO Error");
		}
		private function inputProg(e:ProgressEvent):void {
			trace("progress");
		}
		private function errClose(e:Event):void {
			trace("error stream closed");
		}
		private function inputClose(e:Event):void {
			trace("input stream closed");
		}
		private function outputClose(e:Event):void {
			trace("output stream closed");
		}
		private function dataIncoming(e:ProgressEvent):void {
			trace("triggered");
			var b:ByteArray = new ByteArray();
			e.target.standardOutput.readBytes(b);
			trace(b);
		}
		private function err(e:ProgressEvent):void {
			trace("error occured");
			var b:ByteArray = new ByteArray();
			e.target.standardError.readBytes(b);
			trace(b);
		}
	}
	
}
