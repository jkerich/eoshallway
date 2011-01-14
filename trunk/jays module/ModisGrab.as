package  {
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.display.MovieClip;
	
	public class ModisGrab extends MovieClip{

		public function ModisGrab() {
			//load image from internet on click
			var loader:Loader = new Loader();
			
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,imageLoaded);
			loader.load(new URLRequest("http://rapidfire.sci.gsfc.nasa.gov/realtime/2011012/crefl1_143.A2011012145000-2011012145500.2km.jpg"));
			
			addChild(loader);
		}
		private function imageLoaded(e:Event):void {
			//stuff
			generateURL();
		}
		private function generateURL():void {
			//base url
			var terraModisUrl:String = "http://rapidfire.sci.gsfc.nasa.gov/realtime/";

			//today's date
			var today:Date = new Date();
			//get year
			var year:Number = today.getUTCFullYear();
			
			//first day of year
			var firstDay:Date = new Date(year,1,null,0,0,0,0);//jan of current year
			firstDay.setDate(1);
			
			//get day of year
			var diff:Number = today.valueOf() - firstDay.valueOf();
			var doy:Number = Math.ceil(diff/(1000 * 60 * 60 * 24)); //rounding errors could occur here
			
			//get utc time
			var hours:Number = today.getUTCHours();
			var mins:Number = roundDownByValue(today.getUTCMinutes(),5);
					
			//construct url
			trace(createImageUrl(terraModisUrl,year,doy,hours,mins))
		}
		private function createImageUrl(base:String,year:Number,doy:Number,hours:Number,mins:Number):String {
			//get utc time + five mins
			var endMins:Number = mins+5; //don't need to round because mins is already rounded
			var endHours:Number = hours;
			if(endMins >=60) {
				//rotate the minutes
				endMins = endMins - 60;
				//need to change the hour too
				endHours++;
				if(endHours > 24)
					endHours = 0;
			}
			
			return base+year+padDOY(doy)+"/crefl1_143.A"+year+padDOY(doy)+padTime(hours)+padTime(mins)+"00-"+year+padDOY(doy)+padTime(endHours)+padTime(endMins)+"00.2km.jpg";
		}
		//utility
		private function padTime(num:Number):String {
			if(num.toString().length < 2) {
				return "0"+num;
			}else {
				return num+"";
			}
		}
		private function padDOY(day:Number):String {
			if(day.toString().length < 2) 
				return "00"+day;
			else if(day.toString().length < 3) 
				return "0"+day;
			else 
				return ""+day;
		}
		//rounds numbers by a specified number
		private function roundUpByValue(num:Number,roundBy:Number):Number {
			return Math.round(num/roundBy)*roundBy;
		}
		private function roundDownByValue(num:Number,roundBy:Number):Number {
			return Math.floor(num/roundBy)*roundBy;
		}
	}
	
}
