package  {
	import flash.display.*;
	import flash.net.*;
	import flash.events.*;
	import flash.text.*;
	import fl.transitions.*;
	
	public class SlideShow2 extends MovieClip {
		//mcs
		private var dc:MovieClip;
		private var titleContainer:MovieClip;
		private var description:MovieClip;
		
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
		var sH:Number = stage.stageHeight;
		var sW:Number = stage.stageWidth;
		
		//dynamic variables
		private var loadCount:Number = 0; //number of images to be loaded
		private var currentIndex:Number; //current index of item clicked
		private var focusImage:Number = 0; //index of item being displayed
		
		//path vars
		private var imgPath:String;
		private var imgLargePath:String;
		private var imgRegularPath:String;
		private var videoPath:String;
		
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
		public function SlideShow2() {
			//init
			dc = new MovieClip();
			titleContainer = new MovieClip();
			description = new MovieClip();
			
			mediaInfo = new Array();
			mediaContent = new Array();
			temp = new Array();
			//init paths
			imgPath = "media/img";
			imgLargePath = imgPath+"/large";
			imgRegularPath = imgPath+"/reg";
			videoPath = "media/video";
						
			//event listeners
			stage.addEventListener(MouseEvent.CLICK,shiftDisplay);
			
			
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
		private function shiftDisplay(e:MouseEvent):void {
			//trace("mouse click on stage");
			var center:Number = sW/2;
			
			trace("TEMP LENGTH: " + temp.length);
			if(mouseX >= center) {//next image
				focusImage = (focusImage+1)%(temp.length);
				changeDisplay(loadImage(temp[focusImage]));
			}else if(mouseX<center ){//previous imaged
				focusImage = (focusImage>0) ? (focusImage-1)%temp.length: temp.length-1; //account for first image being zero
				changeDisplay(loadImage(temp[focusImage]));
			}
			trace("FOCUS IMAGE : " + focusImage);
			
			
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
			changeDisplay(loadImage(temp[0]));
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
			d.setTextFormat(new TextFormat("Walkway Bold",16,0xFFFFFF));
			d.autoSize = TextFieldAutoSize.CENTER;
			d.selectable = false;
			d.wordWrap = true;
			d.width = sW;
			
			d.x = 0;
			d.y = sH-d.height*1.5;
			
			changetitleContainer(t);
			changeDescriptionContainer(d);
			
		}
		private function loadProgress(e:ProgressEvent):void {
			var loadInfo:LoaderInfo = e.target as LoaderInfo;
			var percentDone:Number = loadInfo.bytesLoaded/loadInfo.bytesTotal;
			//trace(percentDone);
		}
		private function imageLoadFail(e:IOErrorEvent):void {
			trace("load failed");
		}
		//utility functions -> combine change* functions
		private function changeDisplay(obj:*):void {
			while(dc.numChildren) {
				dc.removeChildAt(0);
			}
			dc.addChild(obj);
		}
		private function changetitleContainer(obj:*):void {
			while(titleContainer.numChildren) {
				titleContainer.removeChildAt(0);
			}
			titleContainer.addChild(obj);
		}
		private function changeDescriptionContainer(obj:*):void {
			while(description.numChildren) {
				description.removeChildAt(0);
			}
			description.addChild(obj);
		}
		private function scale(tar:Object,w:Number,h:Number):Object {
			//scaling
			tar.width = w;
			tar.height = h;
			(tar.scaleX > tar.scaleY) ? tar.scaleX = tar.scaleY:tar.scaleY = tar.scaleX;
			
			return tar;
		}
	}//end class
	
}//end package
