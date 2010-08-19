package  {
	import flash.display.MovieClip;
	import flash.net.URLLoader;
	import flash.events.Event;
	import flash.net.URLRequest;
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
			
			//add buttons
			nb = new NextBtn();
			pb = new PrevBtn();
			nb.x = sW/2;
			nb.y = sH - nb.height;
			pb.x = sW/2 - pb.width;
			pb.y = sH - pb.height;
			addChild(nb);
			addChild(pb);
			
			//display container
			dc = new DisplayContainer(sW,sH-nb.height);
			addChild(dc);
			
			//load xml file
			XML.ignoreWhitespace = true;
			var xL:URLLoader = new URLLoader();
			xL.addEventListener(Event.COMPLETE,fileLoaded);
			xL.load(new URLRequest("feedinfo.xml"));
		}
		private function fileLoaded(e:Event):void {
			feed = new XML(e.target.data);
			feedItems = feed.item;
			
			//each item
			for each(var item:XML in feedItems) {
				//each url's localpath
				var urlLocalPaths:XMLList = item.media.url.attributes();
				localPaths.push(urlLocalPaths);
				trace(urlLocalPaths);
			}
		}
	}
	
}
