package  {
	import flash.display.MovieClip;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.text.*;
	
	public class CoolButton extends MovieClip{
		public var sButtons:Array; //array of secondary buttons
		public var image:Bitmap; //icon
		public var n:String; //name -> may not be necessary
		public var picW:Number;
		public var picH:Number;
		
		public function CoolButton(n:String,pW:Number, pH:Number,picPath:String = "") {
			
			this.n = n;
			this.sButtons = new Array();
			this.picW = pW;
			this.picH = pH;
			
			drawHitBox();			
			addTitle();
			
			//loadImage(picPath);			
			
		}
		//title
		private function addTitle():void {
			var t:TextField = new TextField();
			t.text = this.n;
			t.setTextFormat(new TextFormat("Walkway Bold",32,0xFFFFFF));
			t.autoSize = TextFieldAutoSize.CENTER;
			t.selectable = false;
			t.x = this.width/2 - t.width/2;
			t.y = this.height/2 - t.height/2;
			this.addChild(t);
		}
		//image loading
		private function loadImage(path:String):void {
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,imageloaded);
			loader.load(new URLRequest(path));
		}
		private function imageloaded(e:Event):void {
			image = (Bitmap) (e.target.content);
			//size and position
			image.width = picW;
			image.height = picH;
			(image.scaleX > image.scaleY) ? image.scaleX = image.scaleY: image.scaleY = image.scaleX;
			image.x = (this.width - image.width)/2;
			image.y = (this.height - image.height)/2;
			this.addChild(image);
		}
		public function getName():String {
			return this.n;
		}
		//hitbox
		private function drawHitBox():void {
			this.graphics.clear();
			this.graphics.beginFill(0xFFFFFF,.5);
			this.graphics.drawRect(0,0,this.picW,this.picH);
			this.graphics.endFill();
		}
	}
	
}
