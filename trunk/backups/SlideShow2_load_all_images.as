package  {
	import flash.display.*;
	import flash.net.*;
	import flash.events.*;
	import flash.text.*;
	import fl.transitions.*;
	
	public class SlideShow2 extends MovieClip {
		//mcs
		private var dc:MovieClip;
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
		private var slideW:Number = 600;
		private var slideH:Number = 600;
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
			-create and implement ListElement class 
				> have class variable for array index for item position in media array
				
			-what happens if someone clicks a list item before its done loading and the index changes?
			
			-animation: first image needs to move away and when thats done the second image may follow suit
			
			-remove list, use as title and show all images from feed
		*/
		public function SlideShow2() {
			//init
			dc = new MovieClip();
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
		}
		private function shiftDisplay(e:MouseEvent):void {
			//trace("mouse click on stage");
			var center:Number = sW/2;
			//trace(loadCount);
			if(mouseX >= center) {//next image
				changeDisplay(temp[focusImage]);
			}else if(mouseX<center ){//previous imaged
				changeDisplay(temp[focusImage]);
			}
			focusImage = (focusImage+1)%loadCount;
		}
		private function dataLoaded(e:Event):void {
			if(!xmlLoader.data) {
				trace("file not loaded");
				return;
			}
			
			var dataXML:XML = XML(xmlLoader.data);
			
			for each(var xmlItem:XML in dataXML.item) {
				mediaInfo.push({title:xmlItem.title, urls:xmlItem.media.url.@localpath});
				//trace(typeof(xmlItem.media.url.@localpath));
				for each(var u:String in xmlItem.media.url.@localpath){
					temp.push(u);
				}
				
			}
			
			loadTemp();
			
		}
		private function loadTemp():void {
			var url:String =temp.shift();
			if(url.search(imgRegularPath) != -1) {
				loadImage(url,dc);
				trace("LOADED: " + url);
			}else {
				trace("URL not loaded: " + url);
				loadTemp();
			}
		}
		private function loadImage(path:String,holder:MovieClip):void {
			trace("Inside loadImage: " + path);
			var loader:Loader = new Loader();
			
			holder.addChild(loader);
			
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,loadProgress);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,imageLoaded);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,imageLoadFail);
			loader.load(new URLRequest(path));

		}
		//consider removing click event listener until loading is finished
		/*private function listItemClicked(e:MouseEvent):void { 
			//load all images of clicked item into display container
			currentIndex = e.currentTarget.name;
			loadCount = 0;
			focusImage = 0;
			temp = [];
			
			//loop through and load each image
			for each(var url:String in mediaInfo[currentIndex].urls) {
				//weed out unwanted file types
				//var pat:RegExp = /\/reg\//;
				if(url.search(imgRegularPath) != -1) {
					loadCount++;
					//load
					loader = new Loader();
					loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,imageProgress);
					
					loader.load(new URLRequest(url));
					trace("LOADED: " + url);
				}else {
					trace("URL not loaded: " + url);
				}
				
			}
		}*/
		
		//image loading
		private function imageLoaded(e:Event):void {
			trace("Image loaded");
			//get loader
			var l:Loader = e.target.loader as Loader;
			l = scale(l,slideW,slideH) as Loader;
			l.x = (dc.numChildren-1) * slideW;
			
			if(temp.length>0) loadTemp();
			else 
				trace("All images loaded");
		}
		private function loadProgress(e:ProgressEvent):void {
			var loadInfo:LoaderInfo = e.target as LoaderInfo;
			var percentDone:Number = loadInfo.bytesLoaded/loadInfo.bytesTotal;
			trace(percentDone);
		}
		private function imageLoadFail(e:IOErrorEvent):void {
			trace("load failed");
		}
		//utility functions
		private function changeDisplay(mc:MovieClip):void {
			while(dc.numChildren) {
				dc.removeChildAt(0);
			}
			dc.addChild(mc);
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
