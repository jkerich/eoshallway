package  {
	import flash.display.*;
	import flash.net.*;
	import flash.events.*;
	import flash.text.*;
	import fl.transitions.*;
	import flash.media.Video;
	import flash.system.*;
	import flash.filesystem.*;
	
	public class SlideShow extends MovieClip {
		//mcs
		private var dc:DisplayContainer;
		private var titleContainer:MovieClip;
		private var description:MovieClip;
		private var largeImageContainer:MovieClip;
		private var player:Object;
		private var localVideo:Video;
		
		//loaders
		//private var loader:Loader;
		private var xmlLoader:URLLoader;
		private var vl:Loader; //video loader
		
		//arrays
		private var mediaInfo:Array; //contains paths
		private var mediaContent:Array; //contains loaded bitmaps/videos
		private var temp:Array; //contains loaded images for item clicked
		
		//constants
		private var datasource:String = "feedinfo.xml";
		private var slideW:Number;
		private var slideH:Number;
		var sH:Number;
		var sW:Number;
		private var effectSpeed:Number = .3;
		
		//dynamic variables
		private var loadCount:Number = 0; //number of images to be loaded
		private var currentIndex:Number; //current index of item clicked
		private var focusImage:Number = 0; //index of item being displayed
		
		//path vars
		private var imgPath:String;
		private var imgLargePath:String;
		private var imgRegularPath:String;
		private var videoPath:String;
		private var localVideoPath:String = "localVideos";
		private var localImagePath:String = "localImages";
		
		//net streams
		private var nc:NetConnection;
		private var ns:NetStream;
		
		//Tweens
		private var aT:Tween;
		/*
		TODO: 
			-properly place images into display container based on width
				> consider using Array.shift() on a temp array of the urls to loop and use its length as the counter
			-animate display container to change on click
			
			-animation: first image needs to move away and when thats done the second image may follow suit
			
			-remove list, use as title and show all images from feed
			
			-add view large image
			
			-make sure xml is reloaded every once in a while
			
			-add function for when video finishes playing 
				perhaps a replay function
		*/
		public function SlideShow(w:Number,h:Number,imagePath:String = "") {
			//init
			sW = w;
			sH = h;
			slideW = sW * .625;
			slideH = sH * .94;
			dc = new DisplayContainer(slideW,slideH);
			titleContainer = new MovieClip();
			description = new MovieClip();
			largeImageContainer = new MovieClip();
			
			mediaInfo = new Array();
			mediaContent = new Array();
			temp = new Array();
			//init paths
			imgPath = "media/img";
			imgLargePath = imgPath+"/large";
			imgRegularPath = imgPath+"/reg";
			videoPath = "media/video";
						
			
			//hit box
			drawHitBox(this,sW,sH);
			
			//event listeners
			addEventListener(MouseEvent.CLICK,shiftDisplay);
			
			//add tool bar
			createToolBar();
			
			//parse relevant xml info into array
			xmlLoader = new URLLoader(new URLRequest(datasource));
			xmlLoader.addEventListener(Event.COMPLETE,dataLoaded);
			
			//add display container to stage
			addChild(dc);
			//add titleContainer
			addChild(titleContainer);
			//add description 
			addChild(description);
			
			
		}
		
		
		//------video support
		private function createToolBar():void {
			//video
			var t:TextField = new TextField();
			t.autoSize = TextFieldAutoSize.NONE;
			t.text = "V";
			t.selectable = false;
			t.setTextFormat(new TextFormat("Walkway Bold",20,0xffffff));
			
			var mc:MovieClip = new MovieClip();
			drawHitBox(mc,50,50,0x000000,.65);
			mc.addChild(t);
			mc.addEventListener(MouseEvent.CLICK,playLocalVideo);
			mc.x = sW-50;
			mc.y = sH/2 - mc.height/2;
			addChild(mc);
			
		}
		//http://www.youtube.com/watch?v=R8kDsM0M-vg
		//how get youtube videos from a feed
		private function loadYouTubeVideos(e:MouseEvent):void {
			//disable slide show
			removeEventListener(MouseEvent.CLICK,shiftDisplay);
			
			Security.allowDomain("www.youtube.com");
			vl =  new Loader();
			vl.contentLoaderInfo.addEventListener(Event.COMPLETE,vidLoaded);
			var vidID:String = "2xaRotYad1o";
			vl.load(new URLRequest("http://www.youtube.com/v/"+vidID+"?version=3"));
			
			changeContent(dc,vl);
		}
		function vidLoaded(e:Event):void {
			vl.content.addEventListener("onReady", playerReady);
			vl.content.addEventListener("onError", playerError);
		}
		function playerReady(e:Event):void {
			player = vl.content;
			player.setSize(sW,sH);
		}
		function playerError(e:Event):void {
			trace(e);
		}
		function netStatusHandler(event:NetStatusEvent):void {
			trace("HI");
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
		//local videos
		private function playLocalVideo(e:MouseEvent):void {
			//disable slide show
			removeEventListener(MouseEvent.CLICK,shiftDisplay);
			//changeContent(dc,loadVideo("video/"+"Polar Plot.flv"));
			var arr:Array = listFiles("localVideos/general");
			
			for (var i:Number = 0;i<arr.length;i++) {
				trace(arr[i].nativePath);
			}
		}
		private function setupLocalVideo():void {
			//disable slide show
			removeEventListener(MouseEvent.CLICK,shiftDisplay);
			//create net connection
			nc = new NetConnection();
			nc.connect(null);
			nc.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			//create net stream
			ns = new NetStream(nc);
			ns.client = new Object();
			ns.addEventListener(AsyncErrorEvent.ASYNC_ERROR,asyncError);
			
			trace("local video set up");
		}
		
		private function loadVideo(path:String):Video {
			if(nc == null)
				setupLocalVideo();
			
			var localVideo:Video = new Video();
			localVideo.smoothing = true;
			localVideo = scale(localVideo,sW,sH) as Video;
			localVideo.x = (sW-localVideo.width)/2;
			localVideo.y = (sH-localVideo.height)/2;
			//trace(localVideo.width,localVideo.height);
			localVideo.attachNetStream(ns);
			ns.play(path);
			
			return localVideo;
		}
		//----video support end
		
		
		private function shiftDisplay(e:MouseEvent):void {
			//trace("mouse click on stage");
			var center:Number = sW/2;
			
			//trace("TEMP LENGTH: " + temp.length);
			if(mouseX >= center) {//next image
				focusImage = (focusImage+1)%(temp.length);
				//changeDisplay(dc,loadImage(temp[focusImage]));
				dc.changeContent(loadImage(temp[focusImage]));
			}else if(mouseX<center ){//previous imaged
				focusImage = (focusImage>0) ? (focusImage-1)%temp.length: temp.length-1; //account for first image being zero
				//changeDisplay(dc,loadImage(temp[focusImage]));
				dc.changeContent(loadImage(temp[focusImage]));
			}
			//trace("FOCUS IMAGE : " + focusImage);
			
			
		}
		private function dataLoaded(e:Event):void {
			if(!xmlLoader.data) {
				trace("file not loaded");
				return;
			}
			
			var dataXML:XML = XML(xmlLoader.data);
			
			for each(var xmlItem:XML in dataXML.item) {
				mediaInfo.push({title:xmlItem.title, 
							   urls:xmlItem.media.url.@localpath,
							   desc:xmlItem.shorttext});
				
				//trace(typeof(xmlItem.media.url.@localpath));
				//trace("TITLE ADDED: " + xmlItem.title);
				for each(var u:String in xmlItem.media.url.@localpath){
					if(u.search(imgRegularPath) != -1) {
						temp.push(u);
						//trace("ADDED: " + u);
					}else {
						//trace("URL not added: " + u);
					}
				}
			}
			
			//changeContent(dc,loadImage(temp[0]));
			dc.changeContent(loadImage(temp[0]));
		}
		private function loadImage(path:String):Loader {
			trace("Loading image: " + path);
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,loadProgress);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,imageLoaded);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,imageLoadFail);
			loader.load(new URLRequest(path));
			
			return loader;

		}
		//image loading
		private function imageLoaded(e:Event):void {
			trace("Image loaded");
			//get loader
			var l:Loader = e.target.loader as Loader;
			l = scale(l,slideW,slideH) as Loader;
			l.x = (sW-l.width)/2;
			l.y = (sH-l.height)/2; // remember to subtract out the bottom bar's height
			
			//add titleContainer and description
			var t:TextField = new TextField();
			var d:TextField = new TextField();
			//find which mediaInfo element the url comes from
			var focusURL:String = temp[focusImage];
			for each (var obj:Object in mediaInfo) {
				for each( var u:String in obj.urls) {
					if(u == focusURL) {
						t.text = obj.title;
						d.text = obj.desc;
					}
				}
			}
			t.setTextFormat(new TextFormat("Walkway Bold",26,0xFFFFFF));
			t.autoSize = TextFieldAutoSize.LEFT;
			t.selectable = false;
			d.setTextFormat(new TextFormat("Helvetica",16,0xFFFFFF));
			d.autoSize = TextFieldAutoSize.CENTER;
			d.selectable = false;
			d.wordWrap = true;
			d.width = sW;
			
			d.x = 0;
			d.y = sH-d.height*1.5;
			
			changeDisplay(titleContainer,t);
			changeDisplay(description,d);
			
		}
		private function loadProgress(e:ProgressEvent):void {
			var loadInfo:LoaderInfo = e.target as LoaderInfo;
			var percentDone:Number = loadInfo.bytesLoaded/loadInfo.bytesTotal;
			//trace(percentDone);
		}
		private function imageLoadFail(e:IOErrorEvent):void {
			trace("load failed");
		}
		//utility functions------------------------------------------------------\\
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
		public function changeDisplay(display:*,c:*):void {
			//hide
			aT = new Tween(display,"alpha",null,display.alpha,0,effectSpeed,true);
			aT.addEventListener(TweenEvent.MOTION_FINISH,function(e:Event):void {//effect used to change display is done
								//change
								changeContent(display,c);
								//effect back in
								new Tween(display,"alpha",null,display.alpha,1,effectSpeed,true);
								
								});
		}
		private function changeContent(con:*,obj:*):void { 
			while(con.numChildren) {
				con.removeChildAt(0);
			}
			con.addChild(obj);
		}
		private function scale(tar:Object,w:Number,h:Number):Object {
			//scaling
			//trace(tar.width,tar.height);
			tar.width = w;
			tar.height = h;
			(tar.scaleX > tar.scaleY) ? tar.scaleX = tar.scaleY:tar.scaleY = tar.scaleX;
			//trace(tar.width,tar.height);
			return tar;
		}
		private function drawHitBox(obj:*,w:Number,h:Number,color:uint = 0xFFFFFF,a:Number = 0):void {
			obj.graphics.clear();
			obj.graphics.beginFill(color,a);
			obj.graphics.drawRect(0,0,w,h);
			obj.graphics.endFill();
		}
	}//end class
	
}//end package
