package  {
	import flash.display.*;
	import flash.net.*;
	import flash.events.*;
	import flash.text.*;
	import fl.transitions.*;
	
	public class SlideShow2 extends MovieClip {
		//mcs
		private var dc:MovieClip;
		private var list:MovieClip;
		
		//loaders
		private var loader:Loader;
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
		*/
		public function SlideShow2() {
			//init
			dc = new MovieClip();
			list = new MovieClip();
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
		}
		private function shiftDisplay(e:MouseEvent):void {
			//trace("mouse click on stage");
			var center:Number = (sW - list.width)/2 + list.width;
			trace(loadCount);
			if(mouseX >= center && focusImage != loadCount-1) {//next image
				focusImage++;
				new Tween(dc, "x",null,dc.x,dc.x-slideW,.3,true);
			}else if(mouseX>list.width && mouseX<center && focusImage != 0){//previous image
				focusImage--;
				new Tween(dc, "x",null,dc.x,dc.x+slideW,.3,true);
			}
			
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
			}
			
			//create list of items
			createList(mediaInfo);
			
			//add display container to stage
			dc.x =list.width;
			dc.y = 0;
			addChild(dc);
		}
		private function createList(q:Array):void {
			list.x = 0;
			list.y = 0;
			
			for(var i:Number = 0;i<q.length;i++) {
				var t:TextField = new TextField();
				t.text = q[i].title;
				t.selectable = false;
				t.autoSize = TextFieldAutoSize.LEFT;
				var mc:MovieClip = new MovieClip(); //wrap text field in movie clip for easier manipulation
				mc.name = i+""; //contains array index where urls maybe found->destroy when using custom list element
				mc.graphics.beginFill(0xFFFFFF,1);
				mc.graphics.drawRect(0,0,t.width,t.height+10);
				mc.addChild(t);
				mc.y = t.height * i;
				mc.x = 0;
				
				mc.addEventListener(MouseEvent.CLICK,listItemClicked);
				
				list.addChild(mc);
			}
			addChild(list);
		}
		//consider removing click event listener until loading is finished
		private function listItemClicked(e:MouseEvent):void { 
			//load all images of clicked item into display container
			currentIndex = e.currentTarget.name;
			loadCount = 0;
			focusImage = 0;
			
			//loop through and load each image
			for each(var url:String in mediaInfo[currentIndex].urls) {
				//weed out unwanted file types
				//var pat:RegExp = /\/reg\//;
				if(url.search(imgRegularPath) != -1) {
					loadCount++;
					//load
					loader = new Loader();
					loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,imageProgress);
					loader.contentLoaderInfo.addEventListener(Event.COMPLETE,imageLoaded);
					loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,imageLoadFail);
					loader.load(new URLRequest(url));
					trace("LOADED: " + url);
				}else {
					trace("URL not loaded: " + url);
				}
				
			}
		}
		private function imageProgress(e:ProgressEvent):void {
			var loadInfo:LoaderInfo = e.target as LoaderInfo;
			var percentDone:Number = loadInfo.bytesLoaded/loadInfo.bytesTotal;
			
			
			
		}
		//NEED TO FIX LOAD CRASH
		private function imageLoadFail(e:IOErrorEvent):void {
			trace("load failed");
		}
		private function imageLoaded(e:Event):void {
			//trace("inside imageLoaded");
			//wrap media in movieclip
			var tar:MovieClip = new MovieClip();
			tar.addChild(e.target.content);
			
			tar = scale(tar,slideW,slideH) as MovieClip;
			tar.x = slideW * temp.length;
			
			temp.push(tar);
			
			if(temp.length == loadCount) {
				mediaContent.push({title:mediaInfo[currentIndex].title,images:temp});
				
				//add items to stage
				while(dc.numChildren) {
					dc.removeChildAt(0);
				}
				while(temp.length > 0) {
					dc.addChild(temp.shift());
				}
			}
		}
		
		
		//utility functions
		private function scale(tar:Object,w:Number,h:Number):Object {
			//scaling
			tar.width = w;
			tar.height = h;
			(tar.scaleX > tar.scaleY) ? tar.scaleX = tar.scaleY:tar.scaleY = tar.scaleX;
			
			return tar;
		}
	}//end class
	
}//end package
