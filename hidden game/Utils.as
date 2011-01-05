package  {
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Point;
	/* Utils for hidden game */
	public class Utils {
		private var fol:MovieClip;
		private var speed:Number = 2.5;
		public function Utils() {
		}
		public static function follow(e:Event):void {
			e.target.x = mouseX;
			e.target.y = mouseY;
		}
		public static function drawTriangle(h:Number):MovieClip {
			var con:MovieClip = new MovieClip();
			var tri:Shape = new Shape();
			tri.graphics.lineStyle(1,0xffffff,1);
			tri.graphics.lineTo(-h/2,h);
			tri.graphics.lineTo(h/2,h);
			tri.graphics.lineTo(0,0);
			tri.graphics.lineStyle(1,0x00ff00,1);
			tri.graphics.moveTo(-h/2,0);
			tri.graphics.lineTo(h/2,0);
			con.addChild(tri);
			return con;
		}
		public static function drawHitBox(obj:*,w:Number,h:Number,color:uint = 0xFFFFFF,a:Number = 0):void {
			obj.graphics.clear();
			obj.graphics.beginFill(color,a);
			obj.graphics.drawRect(0,0,w,h);
			obj.graphics.endFill();
		}
	}
	
}
