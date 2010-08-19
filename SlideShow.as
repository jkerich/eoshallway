package  {
	
	import flash.display.*;
	import flash.net.*;
	import flash.events.*;
	import flash.text.*;
	
	
	public class SlideShow extends MovieClip {
		private var datasource:String = "feedinfo.xml";
		private var xmlLoader:URLLoader;
		private var queue:Array = [];
		private var loader:Loader;
		private var itemsLoaded:Number;
		private var loadedImages:Array;
		
		//mc
		private var list:MovieClip;
		private var dc:MovieClip; //display container
		
		public function SlideShow() {
			//init
			loadedImages = new Array();
			dc = new MovieClip();
			dc.graphics.clear();
			dc.graphics.beginFill(0xFFFFFF,.5);
			dc.graphics.drawRect(0,0,stage.stageWidth,stage.stageHeight);
			dc.graphics.endFill();
			addChild(dc);
			//load xml
			xmlLoader = new URLLoader(new URLRequest(datasource));
			xmlLoader.addEventListener(Event.COMPLETE,dataLoaded);
			
		}
		private function dataLoaded(e:Event):void {
			if(!xmlLoader.data) {
				trace("file not loaded");
				return;
			}
			
			var dataXML:XML = XML(xmlLoader.data);
			
			for each(var xmlItem:XML in dataXML.item) {
				queue.push({title:xmlItem.title, urls:xmlItem.media.url.@localpath});
				//trace(typeof(xmlItem.media.url.@localpath));
				//trace("END");
			}
			createList(queue);
			//loadNextItem();
		}
		private function createList(q:Array):void {
			list = new MovieClip();
			list.x = 0;
			list.y = 0;
			
			for(var i:Number = 0;i<q.length;i++) {
				var t:TextField = new TextField();
				t.text = q[i].title;
				t.selectable = false;
				t.autoSize = TextFieldAutoSize.LEFT;
				var mc:MovieClip = new MovieClip();
				mc.name = q[i].title;
				mc.graphics.beginFill(0xFFFFFF,1);
				mc.graphics.drawRect(0,0,t.width,t.height);
				mc.addChild(t);
				mc.y = t.height * i;
				mc.x = 0;
				
				mc.addEventListener(MouseEvent.CLICK,listItemClicked);
				
				list.addChild(mc);
			}
			addChild(list);
			
		}
		private function listItemClicked(e:MouseEvent):void {
			var n:String = e.currentTarget.name; //name of item clicked
			//find the item -- maybe try lastIndexOf
			for each(var item:Object in queue) {
				if (item.title == n) {
					//load item
					loadImages(item.urls);
					//return;
				}
			}
		}
		private function loadImages(u:XMLList):void {
			var c:Number = 0;
			
			loadedImages = new Array();
			for each(var url:String in u) {
				loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE,function (e:Event):void {
										c++;
										var img:Bitmap = e.target.content as Bitmap;
										loadedImages.push(img);
										
										if(c==u.length()) {
											trace("done loading");
											displayImages();
										}
											
									});
				loader.load(new URLRequest(url));
			}
		}
		private function displayImages():void {
			
			//remove children
			while(dc.numChildren) {
				dc.removeChildAt(0);
			}
			
			dc.x = list.width;
			for(var i:Number = 0;i<loadedImages.length;i++) {
				loadedImages[i] = scale(loadedImages[i],600,600);
				loadedImages[i].x = 20*i;
				dc.addChild(loadedImages[i]);
				
			}
			trace(dc.numChildren);
		}
		
		private function scale(tar:Object,w:Number,h:Number):Object {
			//scaling
			tar.width = w;
			tar.height = h;
			(tar.scaleX > tar.scaleY) ? tar.scaleX = tar.scaleY:tar.scaleY = tar.scaleX;
			
			return tar;
		}
		
	}
	
}
