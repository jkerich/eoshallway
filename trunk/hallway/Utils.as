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
	
	/*
	Utils.as
		This class contains several functions used throughout the application frequently.
	
	*/
	public class Utils {
		public function Utils() {
		}
		/*
		changeDisplay
			Purpose:
				This function takes an object, fades it out, replaces the content (children) with specified content and fades the object back in.
			
			Parameters:
				    display: Container object to fade and whose content will be changed
				          c: Content to replace content in display object
				effectSpeed: Animation speed in seconds
		*/
		public static function changeDisplay(display:*,c:*,effectSpeed:Number):void {
			var aT:Tween = new Tween(display,"alpha",null,display.alpha,0,effectSpeed,true); //fade object
			aT.addEventListener(TweenEvent.MOTION_FINISH,function(e:Event):void { //when object is faded out
								this.changeContent(display,c);//change the content
								new Tween(display,"alpha",null,display.alpha,1,effectSpeed,true);//fade the object back
								},false,0,true);
		}
		/*
		changeContent
			Purpose:
				Remove all children from specified object and add a new object as child.
			
			Parameters:
				con: Container object whose children will be removed
				obj: Object to be added as child to container object
		*/
		public static function changeContent(con:*,obj:*):void { 
			while(con.numChildren) { //loop through all children
				con.removeChildAt(0); //remove each child
			}
			con.addChild(obj);//add replacment object
		}
		/*
		scale
			Purpose:
				This function proportionally scales an object to the specified size. Note that 
				this function will NOT work on video files with metadata  that flash can't 
				understand such as .mov files.
			
			Parameters:
				tar: The object to be scaled
				  w: The maximum width to be scaled to
				  h: The maximum height to be scaled to
		
		*/
		public static function scale(tar:*,w:Number,h:Number):* {
			//trace("util scale");
			tar.width = w; //set target object's width and height (it is stretched at this point)
			tar.height = h;
			(tar.scaleX < tar.scaleY) ? tar.scaleY = tar.scaleX:tar.scaleX = tar.scaleY; //change the scale based on which axis was stretched the least
			return tar;
		}
		/*
		drawHitBox
			Purpose:
				This function draws a box of the specified size directly into an object using the object's own
				graphics properties. The default values draw an invisible box of the specified size. 
				This is primarily used to instantiate container objects with a set size.
				
			Parameters:
				  obj: Object to draw box into 
				    w: Width of box
				    h: Height of box
				color: Color of the box between 0x000000(black) and 0xFFFFFF(white), by default white 
				    a: The alpha value of the box between 0 and 1.0, by default 0 (invisible)
		*/
		public static function drawHitBox(obj:*,w:Number,h:Number,color:uint = 0xFFFFFF,a:Number = 0):void {
			obj.graphics.clear();
			obj.graphics.beginFill(color,a);
			obj.graphics.drawRect(0,0,w,h);
			obj.graphics.endFill();
		}
		/*
		launchApp
			Purpose:
				This function launches an external application. It works by calling an external script file
				which is passed the name of the file to launch as a parameter. The script then launches the 
				file.
				
			Restrictions:
				-This function currently only works under windows. However a script can be easily written for
				UNIX based systems.
				-This function requires the script file "run.cmd" to be in the application directory.
				-If another script file is to be used under windows, it has to be a "cmd" NOT a "bat" file becuase
				Flash prevents "bat" files from executing.
				-The application has to be using AIR 2.0 or greater
				-The application descriptor file MUST have the "extendedDesktop" profile and it MUST appear
				BEFORE the "desktop" profile. 
				
			Parameters:
				    fileName: Name of file to execute. When making a script, note the file name is split up by spaces 
							  before being passed to the script.
				  workingDir: The directory the file is in, this directory MUST be in the application directory
				  			  By default it is empty, which means the application directory is the working directory
				exitListener: A function specifying what to do once the external application has finished exectuting.
							  By default this is null. Note the script file has been tailored to wait until the application
							  it calls has finished exectuting before killing itself. Otherwise the exitListener would
							  execute almost immediately, before the external application has finished executing.
			
			Returns:
				Boolean value true if process has started.
		*/
		public static function launchApp(fileName:String,workingDir:String = "",exitListener:Function = null):Boolean {//working dir limited to app directory
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
				
				//info about the cmd file
				var startInfo:NativeProcessStartupInfo = new NativeProcessStartupInfo();
				if(workingDir != "") 
					startInfo.workingDirectory = File.applicationDirectory.resolvePath(workingDir);
				else
					startInfo.workingDirectory = File.applicationDirectory;
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
		/*
		listFiles
			Purpose:
				Returns an array of file objects in the specified directory path. Ignores
				subfolders.
			
			Parameters:
				path: Path to directory with files. MUST be in application directory.
			
			Returns:
				An array of file objects that were in the specified directory.
		
		*/
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
		/*
		stopPlayback
			Purpose:
				This function stops playback from a FLVPlayBack component instance.
				
			Parameters:
				tar: Object containing FLVPlayBackInstance
		*/
		public static function stopPlayback(tar:Object):void {
			//kill sounds
			SoundMixer.stopAll();
			//stop video playback
			for(var i=0;i<tar.numChildren;i++)
				if(tar.getChildAt(i) is FLVPlayback) {
					tar.getChildAt(i).stop();
					
				}
		}
		/*
		startGC
			Purpose:
				This function force starts the garbage collector to clear the memory of unused objects and references.
		*/
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
