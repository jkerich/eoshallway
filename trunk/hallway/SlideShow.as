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
		private var desc:MovieClip;
		private var descContainer:MovieClip;
		private var largeImageContainer:MovieClip;
		private var player:Object;
		private var localVideo:Video;
		private var toolBar:MovieClip;
		
		//loaders
		//private var loader:Loader;
		private var xmlLoader:URLLoader;
		private var vl:Loader; //video loader
		
		//arrays
		private var mediaInfo:Array; //contains paths
		private var mediaContent:Array; //contains loaded bitmaps/videos
		private var temp:Array; //contains loaded images for item clicked
		private var toolBarNames:Array;
		private var toolBarHandlers:Array;
		
		//constants
		private var datasource:String = "feedinfo.xml";
		private var slideW:Number;
		private var slideH:Number;
		var sH:Number;
		var sW:Number;
		private var effectSpeed:Number = .3;
		private var RETURNEVENT:String = "RETURNHOME";
		
		//dynamic variables
		private var loadCount:Number = 0; //number of images to be loaded
		private var currentIndex:Number; //current index of item clicked
		private var focusImage:Number = 0; //index of item being displayed
		private var animating:Boolean = false;
		
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
			-animation: first image needs to move away and when thats done the second image may follow suit
			
			-add view large image
			
			-make sure xml is reloaded every once in a while
			
			-add function for when video finishes playing 
				perhaps a replay function
				
			-make class for slide description
			-make class for tool bar
		*/
		public function SlideShow(w:Number,h:Number,imagePath:String = "") {
			//init
			sW = w;
			sH = h;
			slideW = sW * .625;
			slideH = sH * .80;
			dc = new DisplayContainer(slideW,slideH);
			titleContainer = new MovieClip();
			desc = new MovieClip();
			descContainer = new MovieClip();
			largeImageContainer = new MovieClip();
			toolBar = new MovieClip();
			
			mediaInfo = new Array();
			mediaContent = new Array();
			temp = new Array();
			//init paths
			imgPath = "media/img";
			imgLargePath = imgPath+"/large";
			imgRegularPath = imgPath+"/reg";
			videoPath = "media/video";
						
			//arrays
			toolBarNames = ["Home","Youtube","IotD","TERRA","AQUA","AURA","General"];
			toolBarHandlers = [homeClick,loadYouTubeVideos,iotdClick,playLocalVideo,aquaImages,auraImages,generalClick];
			
			//hit box
			drawHitBox(this,sW,sH);
			
			//event listeners
			addEventListener(MouseEvent.CLICK,shiftDisplay);
			
			//add tool bar
			createToolBar();
			
			//parse relevant xml info into array
			xmlLoader = new URLLoader(new URLRequest(datasource));
			xmlLoader.addEventListener(Event.COMPLETE,dataLoaded);
			
			//set up slide description container
			descContainer.addChild(desc);
			
			//add display container to stage
			addChild(dc);
			//add titleContainer
			addChild(titleContainer);
			//add desc 
			addChild(descContainer);
			
			
		}
		//toolbar
		private function createToolBar():void {
			for (var i:Number = 0;i<toolBarNames.length;i++) {
				var b:MovieClip = createToolBarButton(toolBarNames[i],toolBarHandlers[i]);
				b.y = b.height * i;
				toolBar.addChild(b);
			}
			toolBar.x = sW-toolBar.width;
			toolBar.y = (sH - toolBar.height)/2;
			addChild(toolBar);
		}
		private function createToolBarButton(s:String,h:Function):MovieClip{
			var pad:Number = 5;//padding
			//text
			var t:TextField = new TextField();
			t.autoSize = TextFieldAutoSize.CENTER;
			t.text = s;
			t.selectable = false;
			t.setTextFormat(new TextFormat("Walkway Bold",20,0xffffff));
			t.x = t.y = pad/2;
			
			//button
			var button:MovieClip = new MovieClip();
			drawHitBox(button,t.width+pad,t.height+pad,0x000000,.65);
			button.addChild(t);
			button.addEventListener(MouseEvent.CLICK,h);
			
			return button;
		}
		//toolBarHandlers = [homeClick,youtubeClick,terraImages,aquaImages,auraImages,iotdClick,generalClick];
		private function homeClick(e:MouseEvent):void {
			dispatchEvent(new Event(RETURNEVENT));
		}
		private function terraImages(e:MouseEvent):void {
			var lv:LocalVideo = new LocalVideo(localVideoPath+"/terra/Terra.mp4");
			dc.changeContent(lv);
			trace("terra images clicked");
		}
		private function aquaImages(e:MouseEvent):void {
			trace("aqua imagese clicked");
		}
		private function auraImages(e:MouseEvent):void {
			trace("aura images clicked");
		}
		private function iotdClick(e:MouseEvent):void {
			//trace("iotd clicked");
			focusImage = 0;
			dc.changeContent(loadImage(temp[0]));
			addEventListener(MouseEvent.CLICK,shiftDisplay);
		}
		private function generalClick(e:MouseEvent):void {
			trace("general images clicked");
		}
		
		//------video support
		//http://www.youtube.com/watch?v=R8kDsM0M-vg
		//how get youtube videos from a feed
		private function loadYouTubeVideos(e:MouseEvent):void {
			//disable slide show
			removeEventListener(MouseEvent.CLICK,shiftDisplay);
			changeContent(descContainer,new MovieClip());
			changeContent(titleContainer,new MovieClip());
			
			
			Security.allowDomain("www.youtube.com");
			vl =  new Loader();
			vl.contentLoaderInfo.addEventListener(Event.COMPLETE,vidLoaded);
			var vidID:String = "2xaRotYad1o";
			vl.load(new URLRequest("http://www.youtube.com/v/"+vidID+"?version=3"));
			
			dc.changeContent(vl);
		}
		function vidLoaded(e:Event):void {
			vl.content.addEventListener("onReady", playerReady);
			vl.content.addEventListener("onError", playerError);
			vl.content.addEventListener("onStateChange", onPlayerStateChange);

		}
		function playerReady(e:Event):void {
			player = vl.content;
			player.setSize(sW-toolBar.width,sH);
		}
		function playerError(e:Event):void {
			trace(e);
		}
		function onPlayerStateChange(event:Event):void {
			// Event.data contains the event parameter, which is the new player state
			trace("player state:", Object(event).data);
		}
		private function asyncError(e:AsyncErrorEvent):void {
			trace(e.toString());
		}
		//local videos
		private function playLocalVideo(e:MouseEvent):void {
			//disable slide show
			removeEventListener(MouseEvent.CLICK,shiftDisplay);
			var arr:Array = listFiles("localVideos/general");
			for (var i:Number = 0;i<arr.length;i++) {
				trace(arr[i].nativePath);
			}
		}
		
		//----video support end
		
		
		private function shiftDisplay(e:MouseEvent):void {
			//trace("mouse click on stage");
			var center:Number = sW/2 - toolBar.width;
			
			//trace("TEMP LENGTH: " + temp.length);
			if(mouseX >= center && mouseX < sW-toolBar.width) {//next image
				focusImage = (focusImage+1)%(temp.length);
				dc.changeContent(loadImage(temp[focusImage]));
			}else if(mouseX<center ){//previous imaged
				focusImage = (focusImage>0) ? (focusImage-1)%temp.length: temp.length-1; //account for first image being zero
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
			//trace("Loading image: " + path);
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
			
			//add titleContainer and desc
			var t:TextField = new TextField();
			var dText:String = "";
			//find which mediaInfo element the url comes from
			var focusURL:String = temp[focusImage];
			for each (var obj:Object in mediaInfo) {
				for each( var u:String in obj.urls) {
					if(u == focusURL) {
						t.text = obj.title;
						dText = obj.desc;
					}
				}
			}
			t.setTextFormat(new TextFormat("Walkway Bold",26,0xFFFFFF));
			t.autoSize = TextFieldAutoSize.LEFT;
			t.selectable = false;
			
			var desc:MovieClip = createSlideDescContainer(dText);
			desc.x = 0;
			desc.y = sH-desc.height*1.5;
			
			changeDisplay(titleContainer,t);
			changeDisplay(descContainer,desc);
			
		}
		private function createSlideDescContainer(t:String=""):MovieClip {
			var pad:Number = 5; //padding for the label
			var info:TextField = new TextField(); //the label
			info.text = "Info:";
			info.setTextFormat(new TextFormat("Walkway Bold",16,0xFFFFFF));
			info.autoSize = TextFieldAutoSize.CENTER;
			info.selectable = false;
			info.x = info.y = pad/2;
			
			var d:TextField = new TextField();
			d.text = t;
			d.setTextFormat(new TextFormat("Helvetica",16,0xFFFFFF));
			d.autoSize = TextFieldAutoSize.CENTER;
			d.selectable = false;
			d.wordWrap = true;
			d.width = sW;
			var dbg:MovieClip = new MovieClip(); //description text background (which also includes the text)
			drawHitBox(dbg,d.width,d.height,0x000000,.65);
			dbg.y = info.height;
			dbg.addChild(d);
			
			var container:MovieClip = new MovieClip();
			drawHitBox(container,info.width+pad,info.height+pad,0x000000,.65);//make alphas consistent across all classes
			container.addChild(info);
			container.addChild(dbg);
			return container;
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
		private function scale(tar:*,w:Number,h:Number):* {
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
