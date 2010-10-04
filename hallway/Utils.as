package  {
	import flash.display.*;
	import flash.net.*;
	import flash.events.*;
	import flash.text.*;
	import fl.transitions.*;
	import flash.media.Video;
	import flash.system.*;
	import flash.filesystem.*;
	
	public class Utils {

		public function Utils() {
			// constructor code
		}
		public static function changeDisplay(display:*,c:*,effectSpeed:Number):void {
			//hide
			var aT:Tween = new Tween(display,"alpha",null,display.alpha,0,effectSpeed,true);
			aT.addEventListener(TweenEvent.MOTION_FINISH,function(e:Event):void {//effect used to change display is done
								//change
								changeContent(display,c);
								//effect back in
								new Tween(display,"alpha",null,display.alpha,1,effectSpeed,true);
								
								});
		}
		public static function changeContent(con:*,obj:*):void { 
			while(con.numChildren) {
				con.removeChildAt(0);
			}
			con.addChild(obj);
		}
		public static function scale(tar:*,w:Number,h:Number):* {
			//scaling
			trace("util scale");
			//trace(tar.scaleX,tar.scaleY);
			//trace(tar.width,tar.height);
			trace(w,h);
			tar.width = w;
			tar.height = h;
			trace(tar.width,tar.height);
			trace(tar.scaleX,tar.scaleY);
			(tar.scaleX < tar.scaleY) ? tar.scaleY = tar.scaleX:tar.scaleX = tar.scaleY;
			
			//trace(tar.width,tar.height);
			return tar;
		}
		public static function drawHitBox(obj:*,w:Number,h:Number,color:uint = 0xFFFFFF,a:Number = 0):void {
			obj.graphics.clear();
			obj.graphics.beginFill(color,a);
			obj.graphics.drawRect(0,0,w,h);
			obj.graphics.endFill();
		}
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
	}
	
}
