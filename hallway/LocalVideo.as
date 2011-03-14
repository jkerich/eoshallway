package  {
	
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.events.AsyncErrorEvent;
	import flash.filesystem.File;
	import flash.media.Video;
	//import flash.text.*;
	//import fl.transitions.*;
	//import flash.system.*;
	
	//import flash.display.MovieClip;
	public class LocalVideo extends Video{
		//net streams
		private var nc:NetConnection;
		private var ns:NetStream;
		
		//vars
		private var vidPath:String; //not really necessary
		
		public function LocalVideo(path:String) {
			//init vars
			vidPath = path;
			
			//create net connection
			nc = new NetConnection();
			nc.connect(null);
			nc.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			//create net stream
			ns = new NetStream(nc);
			ns.client = new Object();
			ns.addEventListener(AsyncErrorEvent.ASYNC_ERROR,asyncError);
			trace("local video set up");
			
			//load video
			loadVideo(path);
			
		}
		//this function is meant to list all the videos in a given folder, move it to a new class or make it a
		//static function
		private function playLocalVideo(e:MouseEvent):void {
			var arr:Array = listFiles("localVideos/general");
			
			for (var i:Number = 0;i<arr.length;i++) {
				trace(arr[i].nativePath);
			}
		}
		private function loadVideo(p:String):void {
			this.smoothing = true;
			//localVideo = scale(localVideo,sW,sH) as Video; -> this should be put in other file
			this.attachNetStream(ns);
			ns.play(p);
			
		}
		//handlers
		function netStatusHandler(event:NetStatusEvent):void {
			// handles net status events
			switch (event.info.code) {
				// trace a messeage when the stream is not found
				case "NetStream.Play.StreamNotFound":
					//trace("Stream not found: " + strSource);
				break;
				
				// when the video reaches its end, we stop the player
				case "NetStream.Play.Stop":
					trace("play time is over");
				break;
			}
		}
		private function asyncError(e:AsyncErrorEvent):void {
			trace(e.toString());
		}
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
	}
	
}
