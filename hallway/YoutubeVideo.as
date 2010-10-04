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
			Utils.drawHitBox(w,h,0x000000,1.0);
			
			loadYouTubeVideo(url,id);
				
			this.addChild(vl);
		}

		public function loadYouTubeVideo(url:String="",id:String=""):void {
			player = new Object();
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
			
			if(id) 
				player.loadVideoById(id);
			else if(url) 
				player.loadVideoByUrl(url);
			else
				trace("error no id or url for youtube feed");
				
			player.setSize(w,h);
			t.text = this.parent+ " - ";
			t.setTextFormat(new TextFormat("Walkway Bold",26,0xFFFFFF));
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
	}
	
}
