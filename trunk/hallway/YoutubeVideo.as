package  {
	import flash.display.*;
	import flash.net.*;
	import flash.events.*;
	import flash.text.*;
	import fl.transitions.*;
	import flash.media.Video;
	import flash.system.*;
	import flash.filesystem.*;
	public class YoutubeVideo extends MovieClip{
		private var vl:Loader;
		private var w:Number;
		private var h:Number;
		private var t:TextField;
		private var player:Object;
		private var url:String;
		private var id:String;
		
		
		//http://www.youtube.com/watch?v=R8kDsM0M-vg
		public function YoutubeVideo(w:Number,h:Number,url:String="",id:String="") {
			Security.allowDomain("http://www.youtube.com");
			vl = new Loader();
			vl.contentLoaderInfo.addEventListener(Event.COMPLETE,vidLoaded);
			
			this.w = w;
			this.h = h;
			
			t = new TextField();
			t.text = "NULLO";
			t.setTextFormat(new TextFormat("Walkway Bold",26,0xFFFFFF));
			t.autoSize = TextFieldAutoSize.LEFT;
			t.selectable = false;
			t.x = w +100;
			t.y = h + 100;
			addChild(t);
			
			
			
			loadYouTubeVideo(url,id);
				
			this.addChild(vl);
		}

		public function loadYouTubeVideo(url:String="",id:String=""):void {
			vl.load(new URLRequest("http://www.youtube.com/apiplayer?version=3"));

			this.url = url;
			this.id = id;
			
		}
		
		function vidLoaded(e:Event):void {
			vl.content.addEventListener("onReady", playerReady);
			vl.content.addEventListener("onError", playerError);
			vl.content.addEventListener("onStateChange", onPlayerStateChange);
		}
		function playerReady(e:Event):void {
			player = vl.content;
			player.loadVideoById(id);
			player.setSize(w,h);
			//t.text = player.width+ " - " + player.height;
		}
		function playerError(e:Event):void {
			trace(e);
		}
		function onPlayerStateChange(e:Event):void {
			// Event.data contains the event parameter, which is the new player state
			trace("player state:", Object(e).data);
		}
		private function asyncError(e:AsyncErrorEvent):void {
			trace(e.toString());
		}
		//utility
		private function scale(tar:*,w:Number,h:Number):* {
			//scaling
			//trace(tar.width,tar.height);
			tar.width = w;
			tar.height = h;
			(tar.scaleX > tar.scaleY) ? tar.scaleX = tar.scaleY:tar.scaleY = tar.scaleX;
			//trace(tar.width,tar.height);
			return tar;
		}
		private function drawHitBox(w:Number,h:Number,color:uint = 0xFFFFFF,a:Number = 0):void {
			this.graphics.clear();
			this.graphics.beginFill(color,a);
			this.graphics.drawRect(0,0,w,h);
			this.graphics.endFill();
		}
	}
	
}
