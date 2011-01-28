package  {
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.events.*;
	import flash.display.MovieClip;
	import flash.errors.*;
	/*
	HOW MAKE WORK:
	
	Call loadImage() with a url formatted for the current timestamp
	The program will check if the url exists if not, it will move backwards in time until it finds one that does.
	
	To refresh, simply call the loadImage() function again with a fresh url formatted for the current timestamp using createImageURL()
	
	TODO (by priority):
	-add aqua modis base
	-array that holds validated urls
	-implement count that prevents the program from looping back ininitely
	*/
	public class ModisGrab extends MovieClip{
		private var imageLoader:Loader;
		private var currentURL:String;
		private var urlObj:Object;
		public function ModisGrab() {
			urlObj = generateURLObject();
			currentURL = createImageURL(urlObj.base,urlObj.year,urlObj.doy,urlObj.hours,urlObj.mins);
			loadImage(currentURL);
			
		}
		private function loadImage(url:String):void {
			imageLoader = new Loader();
			imageLoader.load(new URLRequest(url));
			imageLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,noImage);
			imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,imageFound);
		}
		private function imageFound(e:Event):void {
			trace("Success");
			addChild(imageLoader);
		}
		private function noImage(e:IOErrorEvent):void {
			trace("Url not valid");
			//The year flip is untested
			if(urlObj.mins > 0) {//only flip mins
				urlObj.mins -= 5;
			}else if(urlObj.hours > 1){//flip the hour
				urlObj.hours -= 1;
				urlObj.mins = 55;
			}else if(urlObj.doy > 0){ //hours and mins are zero (00:00), flip day
				urlObj.hours = 23;
				urlObj.mins = 55;
				urlObj.doy -= 1;
			}else if(urlObj.year > 0){ //not really necessary but just in case
				//first day of previous year
				var firstDay:Date = new Date(urlObj.year-1,1,null,0,0,0,0);//jan of current year
				firstDay.setDate(1);
				//last day of previous year
				var lastDay:Date = new Date(urlObj.year,1,null,0,0,0,0);//jan of current year
				lastDay.setDate(0); //last day of dec
				var diff:Number = lastDay.valueOf() - firstDay.valueOf();
				urlObj.doy = Math.ceil(diff/(1000 * 60 * 60 * 24)); //rounding errors could occur here
				urlObj.mins = 55;
				urlObj.hours = 23;
				urlObj.year -= 1;
			}
			currentURL = createImageURL(urlObj.base,urlObj.year,urlObj.doy,urlObj.hours,urlObj.mins);
			loadImage(currentURL);
		}
		private function generateURLObject():Object {
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
			return {base:terraModisUrl,
					year:year,
					doy:doy,
					hours:hours,
					mins:mins};
		}
		private function createImageURL(base:String,year:Number,doy:Number,hours:Number,mins:Number):String {
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
		//http://rapidfire.sci.gsfc.nasa.gov/realtime/2011025/crefl1_143.A2011025162500-2011025163000.2km.jpg
	}
	
}
