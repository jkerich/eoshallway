package  {
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.events.*;
	import flash.display.MovieClip;
	import flash.errors.*;
	/*
	Based on code by Jay Kim
	
	HOW TO USE:
	Call getLatestImage() function with either "terra" or "aqua" as satellite name. This will retrieve and load the latest image
	to class instance.
	
	
	INFO:	
	Call loadImage() with a url formatted for the current timestamp
	The program will check if the url exists if not, it will move backwards in time until it finds one that does.
	
	To refresh, simply call the loadImage() function again with a fresh url formatted for the current timestamp using createImageURL()
	
	EXAMPLE URL(days are julian days):
		------------------base----------------------|year|day|-terra or aqua id--|year|day|time|---|year|day|time|----------
		http://rapidfire.sci.gsfc.nasa.gov/realtime/ 2011 025 /crefl1_143.A       2011 025 1625 00- 2011 025 1630 00.2km.jpg
	
		TERRA MODIS -> crefl1_143.A 
		AQUA MODIS  -> crefl2_143.A
		
	POSSIBLE BUGS:
	-calling prev image too much could result in infinite loop
	
	TODO (by priority):
	-array that holds validated urls
	-different zoom levels other than 2km.jpg
	-implement count that prevents the program from looping back ininitely
	*/
	public class ModisGrab extends Loader{
		private var currentURL:String;
		private var urlObj:Object;
		private var latestURL:Object;
		private var movingBack:Boolean = true;
		private var gettingLatestURL:Boolean = false; //flag to see if the class is trying to get latest url
		public function ModisGrab() {
		}
		public function getLatestImage(sat:String):Boolean {
			urlObj = generateURLObject(sat);
			if(urlObj) {
				currentURL = createImageURL(urlObj.base,urlObj.year,urlObj.doy,urlObj.hours,urlObj.mins);
				loadImage(currentURL);
				gettingLatestURL = true;
				return true;
			}else {
				return false;
			}
		}
		public function prevImage():Boolean {
			movingBack = true;
			
			if(urlObj == null)
				return false;
			getOlderURL();
			return true;
		}
		public function nextImage():Boolean {
			movingBack = false;
			
			//ugly object compare
			if(urlObj.mins == latestURL.mins && urlObj.hours == latestURL.hours &&
			   	urlObj.year == latestURL.year && urlObj.doy == latestURL.doy)
				return false;
			
			if(currentURL == null) 
				return false;
				
			getNewerURL();
			return true;
		}
		
		private function loadImage(url:String):void {
			this.load(new URLRequest(url));
			this.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,noImage);
			this.contentLoaderInfo.addEventListener(Event.COMPLETE,imageFound);
		}
		private function imageFound(e:Event):void {
			trace("Success");
			if(gettingLatestURL) {
				//ugly object copy
				latestURL = new Object();
				latestURL.modisURL = urlObj.modisURL;
				latestURL.mins = urlObj.mins;
				latestURL.hours = urlObj.hours;
				latestURL.doy = urlObj.doy;
				latestURL.year = urlObj.year;
				
				gettingLatestURL = false;
			}
		}
		private function noImage(e:IOErrorEvent):void {
			trace("URL not valid");
			if(movingBack)
				getOlderURL();
			else 
				getNewerURL();
		}
		private function getNewerURL():void {
			var firstDay:Date = new Date(urlObj.year,1,null,0,0,0,0);//jan of current year
			firstDay.setDate(1);
			var lastDay:Date = new Date(urlObj.year,1,null,0,0,0,0);//jan of current year
			lastDay.setDate(0); //last day of dec
			var totalDays:Number = Math.ceil((lastDay.valueOf() - firstDay.valueOf())/(1000 * 60 * 60 * 24));
			var currentYear:Number = (new Date()).getUTCFullYear();
			var currentDOY:Number =  Math.ceil(((new Date()).valueOf() - firstDay.valueOf())/(1000 * 60 * 60 * 24));
			
			if(urlObj.mins < 55){
				urlObj.mins += 5;
			}else if(urlObj.hours <23) {
				urlObj.mins = 0;
				urlObj.hours += 1;
			}else if(urlObj.doy < totalDays) {
				urlObj.mins = 0;
				urlObj.hours = 0;
				urlObj.doy += 1;
			}else if(urlObj.year < currentYear){
				urlObj.mins = 0;
				urlObj.hours = 0;
				urlObj.doy = 1;
				urlObj.year += 1;
			}
			
			currentURL = createImageURL(urlObj.modisURL,urlObj.year,urlObj.doy,urlObj.hours,urlObj.mins);
			loadImage(currentURL);
		}
		private function getOlderURL():void {
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
				var firstDay:Date = new Date(urlObj.year-1,1,null,0,0,0,0);//jan of previous year
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
			currentURL = createImageURL(urlObj.modisURL,urlObj.year,urlObj.doy,urlObj.hours,urlObj.mins);
			loadImage(currentURL);
		}
		private function generateURLObject(satName:String):Object {
			//pick which modis to get images from
			var modisURL:String = "";
			satName = satName.toUpperCase();
			if(satName == "TERRA")
				modisURL = "/crefl1_143.A";
			else if(satName == "AQUA") 
				modisURL = "/crefl2_143.A";
			else {
				trace("Sat name error");
				return null;
			}

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

			//construct url object
			return {modisURL:modisURL,
					year:year,
					doy:doy,
					hours:hours,
					mins:mins};
		}
		private function createImageURL(modisURL:String,year:Number,doy:Number,hours:Number,mins:Number):String {
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
			
			return "http://rapidfire.sci.gsfc.nasa.gov/realtime/"+
					year+
					padDOY(doy)+
					modisURL+
					year+
					padDOY(doy)+
					padTime(hours)+
					padTime(mins)+
					"00-"+
					year+
					padDOY(doy)+
					padTime(endHours)+
					padTime(endMins)+
					"00.2km.jpg";
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
