package  {
	import flash.display.*;
	import flash.net.*;
	import flash.events.*;
	import flash.text.*;
	import fl.transitions.*;
	import flash.media.Video;
	
	public class SlideShow extends MovieClip {
		//mcs
		private var dc:MovieClip;
		private var titleContainer:MovieClip;
		private var description:MovieClip;
		private var largeImageContainer:MovieClip;
		
		//loaders
		//private var loader:Loader;
		private var xmlLoader:URLLoader;
		
		//arrays
		private var mediaInfo:Array; //contains paths
		private var mediaContent:Array; //contains loaded bitmaps/videos
		private var temp:Array; //contains loaded images for item clicked
		
		//constants
		private var datasource:String = "feedinfo.xml";
		private var slideW:Number = 800;
		private var slideH:Number = 700;
		var sH:Number;
		var sW:Number;
		
		//dynamic variables
		private var loadCount:Number = 0; //number of images to be loaded
		private var currentIndex:Number; //current index of item clicked
		private var focusImage:Number = 0; //index of item being displayed
		
		//path vars
		private var imgPath:String;
		private var imgLargePath:String;
		private var imgRegularPath:String;
		private var videoPath:String;
		
		//net streams
		private var nc:NetConnection;
		private var ns:NetStream;
		
		/*
		TODO: 
			-push content into mediaContent array as an object
			-properly place images into display container based on width
				> consider using Array.shift() on a temp array of the urls to loop and use its length as the counter
			-animate display container to change on click
			
			-animation: first image needs to move away and when thats done the second image may follow suit
			
			-remove list, use as title and show all images from feed
			
			-add view large image
			
			-make sure xml is reloaded every once in a while
		*/
		public function SlideShow(w:Number,h:Number) {
			//init
			sW = w;
			sH = h;
			dc = new MovieClip();
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
			//addEventListener(MouseEvent.CLICK,shiftDisplay);
			
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
			
			var t:TextField = new TextField();
			t.autoSize = TextFieldAutoSize.NONE;
			t.text = "V";
			t.selectable = false;
			t.setTextFormat(new TextFormat("Walkway Bold",20,0xffffff));
			
			var mc:MovieClip = new MovieClip();
			drawHitBox(mc,50,50,0x000000,.65);
			mc.addChild(t);
			mc.addEventListener(MouseEvent.CLICK,loadVideos);
			mc.x = sW-50;
			mc.y = sH/2 - mc.height/2;
			addChild(mc);
			
		}
		private function loadVideos(e:MouseEvent):void {
			trace("load button clicked");
			/*var vid:Video = new Video(sW,sH);
			
			nc = new NetConnection();
			nc.connect(null);
			nc.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			
			ns = new NetStream(nc);
			ns.client = new Object();
			ns.addEventListener(AsyncErrorEvent.ASYNC_ERROR,asyncError);
			
			vid.attachNetStream(ns);
			ns.play(videoPath+"/flare_stereoa_2010213-214_sm.mov");
			
			changeContent(dc,vid);*/
			
			//list files
			var v:URLVariables = new URLVariables();
			v.path = "/";
			var r:URLRequest = new URLRequest("listDir.php");
			r.method = URLRequestMethod.POST;
			r.data = v;
			
			var loader:URLLoader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.VARIABLES;
			loader.addEventListener(Event.COMPLETE,phpLoaded);
			loader.load(r);
			
		}
		function phpLoaded(e:Event):void {
			trace("hi");
			var res:URLVariables = new URLVariables(e.target.data);
			trace(res.output);//------------------------------------------start here
			
		}
		function netStatusHandler(event:NetStatusEvent):void {
			// handles net status events
			switch (event.info.code) {
				// trace a messeage when the stream is not found
				case "NetStream.Play.StreamNotFound":
					//trace("Stream not found: " + strSource);
				break;
				
				// when the video reaches its end, we stop the player
				case "NetStream.Play.Stop":
					//stopVideoPlayer();
				break;
			}
		}

		private function asyncError(e:AsyncErrorEvent):void {
			
			trace(e.toString());
		}
		//----video support end
		
		
		private function shiftDisplay(e:MouseEvent):void {
			//trace("mouse click on stage");
			var center:Number = sW/2;
			
			//trace("TEMP LENGTH: " + temp.length);
			if(mouseX >= center) {//next image
				focusImage = (focusImage+1)%(temp.length);
				changeContent(dc,loadImage(temp[focusImage]));
			}else if(mouseX<center ){//previous imaged
				focusImage = (focusImage>0) ? (focusImage-1)%temp.length: temp.length-1; //account for first image being zero
				changeContent(dc,loadImage(temp[focusImage]));
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
						trace("ADDED: " + u);
					}else {
						trace("URL not added: " + u);
					}
				}
			}
			changeContent(dc,loadImage(temp[0]));
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
			
			changeContent(titleContainer,t);
			changeContent(description,d);
			
		}
		private function loadProgress(e:ProgressEvent):void {
			var loadInfo:LoaderInfo = e.target as LoaderInfo;
			var percentDone:Number = loadInfo.bytesLoaded/loadInfo.bytesTotal;
			//trace(percentDone);
		}
		private function imageLoadFail(e:IOErrorEvent):void {
			trace("load failed");
		}
		//utility functions
		private function changeContent(con:*,obj:*):void { 
			while(con.numChildren) {
				con.removeChildAt(0);
			}
			con.addChild(obj);
		}
		private function scale(tar:Object,w:Number,h:Number):Object {
			//scaling
			tar.width = w;
			tar.height = h;
			(tar.scaleX > tar.scaleY) ? tar.scaleX = tar.scaleY:tar.scaleY = tar.scaleX;
			
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
