package  {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.Loader;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	
	public class ModisModule extends MovieClip {
		private var mg:ModisGrab;
		private var sW:Number;
		private var sH:Number;
		private var sat:String;
		private var RETURNEVENT:String = "RETURNHOME";
		private var date:TextField;
		private var zoomLevel:TextField;
		private var locImageContainer:MovieClip;
		private var infoBox:MovieClip;
		private var loadingImage:LoadingSign;
	
		public function ModisModule(w:Number,h:Number,satName:String) {
			sW = w;
			sH = h;
			sat = satName;
			//fill out object
			Utils.drawHitBox(this,sW,sH,0x000000,.65);
			
			//add and hide loading image
			loadingImage = new LoadingSign();
			loadingImage.x = (sW - loadingImage.width)/2;
			loadingImage.y = (sH - loadingImage.height)/2;
			//loadingImage.alpha = 0;
			addChild(loadingImage);
			
			//create title
			var satTitle = new MovieClip();
			var t:TextField = new TextField();
			t.text = sat.toUpperCase() + " MODIS Imagery";
			t.setTextFormat(new TextFormat("Walkway Bold",26,0xFFFFFF));
			t.autoSize = TextFieldAutoSize.LEFT;
			t.selectable = false;
			Utils.drawHitBox(satTitle,t.width+20,t.textHeight+40);
			t.x = (satTitle.width - t.width)/2;
			t.y = (satTitle.height - t.textHeight)/2;
			satTitle.addChild(t);
			addChild(satTitle);
			
			
			//create home button
			var home:* = new HomeBtn();
			home.addEventListener(MouseEvent.CLICK,homeClick,false,0,true);
			home.x = satTitle.width + satTitle.x;
			home.y = satTitle.height - home.height;
			
			//init modis grab loader
			mg = new ModisGrab(sW,sH-satTitle.height);
			mg.getLatestImage(sat);
			//center content
			mg.contentLoaderInfo.addEventListener(Event.COMPLETE,function() { 
												  //hide loader
												  loadingImage.alpha = 0;
												  //center main image
												  mg.x = (sW - mg.width)/2;
												  //update date and location text
												  updateInfo();
												  },false,0,true);
			mg.locImage.contentLoaderInfo.addEventListener(Event.COMPLETE,function() {
												//grab location image
												(locImageContainer.numChildren) ? locImageContainer.removeChildAt(0):null;
												 locImageContainer.addChild(mg.locImage);
												 locImageContainer.x = date.x;
												 locImageContainer.y = date.y + date.textHeight + 10;
												},false,0,true);
			//loading image event
			mg.contentLoaderInfo.addEventListener(Event.INIT,function() {
												  loadingImage.gotoAndPlay(1);
												  loadingImage.alpha = 1;
												  },false,0,true);
			
			mg.y = satTitle.height + satTitle.y;
			
			//create info box
			infoBox = new MovieClip();
			infoBox.x = satTitle.x + 10;
			infoBox.y = satTitle.y + satTitle.height;
			//title
			var infoBoxTitle:TextField = new TextField();
			infoBoxTitle.autoSize = TextFieldAutoSize.LEFT;
			infoBoxTitle.selectable = false;
			infoBoxTitle.text = "INFO:";
			infoBoxTitle.setTextFormat(new TextFormat("Walkway Bold",24,0xFFFFFF));
			
			//location image
			locImageContainer = new MovieClip();
			//date of image
			date = new TextField();
			date.x = infoBoxTitle.x;
			date.y = infoBoxTitle.y + infoBoxTitle.textHeight + 10;
			date.autoSize = TextFieldAutoSize.LEFT;
			date.selectable = false;
			
			infoBox.addChild(infoBoxTitle);
			infoBox.addChild(locImageContainer);
			infoBox.addChild(date);
			
			
			//create next and prev button
			var n:MovieClip = new MovieClip();
			Utils.drawHitBox(n,sW/2,sH);
			n.addEventListener(MouseEvent.CLICK,nextPic,false,0,true);
			n.x = sW/2;
			
			var p:MovieClip = new MovieClip();
			Utils.drawHitBox(p,sW/2,sH);
			p.addEventListener(MouseEvent.CLICK,prevPic,false,0,true);
			
			addChild(mg);
			addChild(infoBox);
			addChild(p);
			addChild(n);
			addChild(home);
		}
		private function updateInfo():void {
			date.text = mg.padTime(mg.urlObj.hours) + ":" + mg.padTime(mg.urlObj.mins) + " " + mg.padDOY(mg.urlObj.doy)
									+ "/" + mg.urlObj.year;
			date.setTextFormat(new TextFormat("Walkway Bold",20,0xFFFFFF));
		}
		private function nextPic(e:MouseEvent):void {
			mg.nextImage();
		}
		private function prevPic(e:MouseEvent):void {
			mg.prevImage();
		}
		private function homeClick(e:MouseEvent):void {
			dispatchEvent(new Event(RETURNEVENT));
		}
	}
	
}
