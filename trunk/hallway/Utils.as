package  {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.NativeProcessExitEvent;
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import flash.media.Video;
	import fl.video.FLVPlayback;
	import flash.media.SoundMixer;
	import flash.filesystem.File;
	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.system.System;
	
	//import flash.text.*;
	//import flash.net.*;
	//import flash.system.*;
	
	//main one
	public class Utils {
		private var temp:Object;
		public function Utils() {
			// constructor code
		}
		public static function changeDisplay(display:*,c:*,effectSpeed:Number):void {
			//hide
			var aT:Tween = new Tween(display,"alpha",null,display.alpha,0,effectSpeed,true);
			aT.addEventListener(TweenEvent.MOTION_FINISH,function(e:Event):void {//effect used to change display is done
								//change
								changeContent(display,c);
								//effect back in
								new Tween(display,"alpha",null,display.alpha,1,effectSpeed,true);
								
								},false,0,true);
		}
		public static function changeContent(con:*,obj:*):void { 
			while(con.numChildren) {
				con.removeChildAt(0);
			}
			con.addChild(obj);
		}
		public static function scale(tar:*,w:Number,h:Number):* {
			//scaling
			//trace("util scale");
			//trace(tar.scaleX,tar.scaleY);
			//trace(tar.width,tar.height);
			//trace(w,h);
			tar.width = w;
			tar.height = h;
			//trace(tar.width,tar.height);
			//trace(tar.scaleX,tar.scaleY);
			(tar.scaleX < tar.scaleY) ? tar.scaleY = tar.scaleX:tar.scaleX = tar.scaleY;
			
			//trace(tar.width,tar.height);
			return tar;
		}
		//draws directly into mc, alpha is zero(invisible) by default
		//this is primarily used to instantiate container mcs with a set size
		public static function drawHitBox(obj:*,w:Number,h:Number,color:uint = 0xFFFFFF,a:Number = 0):void {
			obj.graphics.clear();
			obj.graphics.beginFill(color,a);
			obj.graphics.drawRect(0,0,w,h);
			obj.graphics.endFill();
		}
		//os file manipulation
		//requires run.cmd, use extendedDesktop profile in AIR 2.0, in descriptor file make sure extendedDesktop appears 
		//before desktop
		public static function launchApp(fileName:String,workingDir:String,exitListener:Function = null):Boolean {//working dir limited to app directory
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
				if(exitListener != null) 
					process.addEventListener(NativeProcessExitEvent.EXIT,exitListener,false,0,true);
				//start process
				process.start(startInfo);
				return true;
				
			}else {
				trace("Error: Native process appears to not be supported");
				return false;
			}
		}
		//returns array of files
		public static function listFiles(path:String):Array{
			var dir:File = File.applicationDirectory.resolvePath(path);
			var files:Array = dir.getDirectoryListing();
			//get rid of hidden directories
			var cleanFiles:Array = [];
			for (var i:Number =0; i<files.length;i++) {
				if(!files[i].isDirectory) {
					cleanFiles.push(files[i]);
				}
			}
			return cleanFiles;
		}
		//flvplayback compent nuisance fixes
		public static function stopPlayback(tar:Object):void {
			//kill sounds
			SoundMixer.stopAll();
			//stop video playback
			for(var i=0;i<tar.numChildren;i++)
				if(tar.getChildAt(i) is FLVPlayback) {
					tar.getChildAt(i).stop();
					
				}
		}
		//force start garbage collection
		public static function startGC():void {
			//total memory allocated to app 
			trace(flash.system.System.privateMemory);
			//total memory currently in use
			trace(flash.system.System.totalMemoryNumber);
			
			//run twice to delete all marks
			flash.system.System.gc();
			flash.system.System.gc();
		}

	}
	
}
