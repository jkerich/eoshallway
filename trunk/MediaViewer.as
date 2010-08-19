package  {
	import flash.display.MovieClip;
	import flash.net.URLLoader;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.events.MouseEvent;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.ProgressEvent;

	/*
	<items>
		<item link="">
			<title>
			<media>
				<url localpath="">
			<shorttext>
			<fulltext>
			
	*/
	/*classes:
		Thumbnail => tn = new Thumbnail("path/img.jpg");
		
		//import and parse xml file
			//create each component
				//thumbnails
				//nav buttons
			//dynamic loading as you scroll
			//sort functionality
				//article
				//date
				//sat
	*/
	//consider bulkloader
	public class MediaViewer extends MovieClip {
		var sH:Number = stage.stageHeight;
		var sW:Number = stage.stageWidth;
		private var imgPath:String;
		private var imgLargePath:String;
		private var imgRegularPath:String;
		private var videoPath:String;
		private var dc:DisplayContainer;
		private var nb:NextBtn;
		private var pb:PrevBtn;
		private var bound:Number;
		private var currentItem:Number;
		private var currentPic:Number;
		private var imageLoader:Loader;
		//xml
		private var feed:XML;
		private var feedItems:XMLList;
		private var localPaths:Array;
		
		public function MediaViewer() {
			//init
			imgPath = "media/img";
			imgLargePath = imgPath+"/large";
			imgRegularPath = imgPath+"/reg";
			videoPath = "media/video";
			localPaths = new Array();
			bound = sW;
			currentPic = 0;
			
			
			
			//display container
			dc = new DisplayContainer(sW,sH);
			addChild(dc);
			
			//load xml file
			XML.ignoreWhitespace = true;
			var xL:URLLoader = new URLLoader();
			xL.addEventListener(Event.COMPLETE,fileLoaded);
			xL.load(new URLRequest("feedinfo.xml"));
		}
		private function changePic(e:Event):void {
			//determine direction to slide based on click location
			var middleBound:Number = bound/2;
			
			if(mouseX >= middleBound) {
				//next slide
				changeSlide(1);
			}else if(mouseX < middleBound){
				//previous slide
				changeSlide(-1);
			}
		}
		private function changeSlide(dir:Number):void {
			if(dir>0) {
				//next
				currentPic = (currentPic==localPaths.length-1) ? 0: currentPic+1;
				loadImage(localPaths[currentPic][0]);
			}else {
				//previous
			}
		}
		private function fileLoaded(e:Event):void {
			feed = new XML(e.target.data);
			feedItems = feed.item;
			
			//each item
			for each(var item:XML in feedItems) {
				//each url's localpath
				var urlLocalPaths:XMLList = item.media.url.attributes();
				localPaths.push(urlLocalPaths);
			}
			addEventListener(MouseEvent.CLICK,changePic);
		}
		private function loadImage(path:String):void {
			imageLoader = new Loader();
			imageLoader.load(new URLRequest(path));
			imageLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,imageLoading);
			imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,imageLoaded);
		}
		private function imageLoading(e:ProgressEvent):void {
			
		}
		private function imageLoaded(e:Event):void {
			var mc:MovieClip = new MovieClip();
			mc.addChild(e.target.content as Bitmap);
			
			dc.changeContent(mc);
		}
		
	}
	
}
