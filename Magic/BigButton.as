package  {
	import flash.display.MovieClip;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	public class BigButton extends MovieClip{
		public var sbuttons:Array; //array of secondary buttons
		public var image:Bitmap; //icon
		public var n:String; //name
		public var picwidth:Number;
		public var picheight:Number;
		
		public function BigButton(n:String,picpath:String,pw:Number, ph:Number) {
			
			this.n = n;
			this.sbuttons = new Array();
			this.picwidth = pw;
			this.picheight = ph;
			
			drawhitbox();			
			
			loadimage(picpath);			
			
		}
		//hitbox
		private function drawhitbox():void {
			this.graphics.clear();
			this.graphics.beginFill(0xFFFFFF,0);
			this.graphics.drawRect(0,0,this.picwidth,this.picheight);
			this.graphics.endFill();
		}
		
		//image loading
		private function loadimage(path:String):void {
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,imageloaded);
			loader.load(new URLRequest(path));
		}
		private function imageloaded(e:Event):void {
			image = (Bitmap) (e.target.content);
			//size and position
			image.width = picwidth;
			image.height = picheight;
			(image.scaleX > image.scaleY) ? image.scaleX = image.scaleY: image.scaleY = image.scaleX;
			image.x = (this.width - image.width)/2;
			image.y = (this.height - image.height)/2;
			this.addChild(image);
		}
	}
	
}
