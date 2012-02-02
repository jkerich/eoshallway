package  {
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.events.IOErrorEvent;
	import flash.events.Event;
	import flash.display.MovieClip;
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
		
		
	DIFFERENCE BETWEEN LOCATION IMAGE URL AND IMAGE URL:
		Location Image:
			http://rapidfire.sci.gsfc.nasa.gov/realtime/2011068/geoinfo1.A2011068122000-2011068122500.jpg
		Actual Image:
			http://rapidfire.sci.gsfc.nasa.gov/realtime/2011068/crefl1_143.A2011068221000-2011068221500.2km.jpg
	
	POSSIBLE BUGS:
	-calling prev image too much could result in infinite loop
	
	TODO (by priority):
	-array that holds validated urls
	-different zoom levels other than 2km.jpg
	-implement count that prevents the program from looping back ininitely
	*/
	
	public class ModisGrab extends Loader{
		public var currentURL:String;
		private var locURL:String;
		public var urlObj:Object;
		public var latestURLObj:Object;
		private var movingBack:Boolean = true;
		private var gettingLatestURL:Boolean = false; //flag to see if the class is trying to get latest url
		private var maxWidth:Number;
		private var maxHeight:Number;
		public var locImage:Loader; //tiny image of location of sat
		private var currentSat:String;
		private var loadingImage:LoadingSign;
		
		/*
		Constructor 
			
			Parameters: 
				w: the maximum width of the instance
				h: the maximum height of the intstance
		*/
		public function ModisGrab(w:Number = 0,h:Number = 0) {
			maxWidth = w;
			maxHeight = h;
			locImage = new Loader();
					
		}
		/*
		getLatestImage
			Purpose: Retrieves the most current image from MODIS and loads it directly into the instance
			
			Parameters:
				sat: the name of the satellite to pull MODIS information from, can be ONLY "aqua" or "terra"
		*/
		public function getLatestImage(sat:String):Boolean {
			currentSat = sat;
			urlObj = generateURLObject(sat);
			if(urlObj) {
				//get main image
				currentURL = createImageURL(urlObj.base,urlObj.year,urlObj.doy,urlObj.hours,urlObj.mins);
				loadImage(currentURL);
				gettingLatestURL = true;
				
				return true;
			}else {
				return false;
			}
		}
		/*
		prevImage
			Purpose: 
				Generate older URLs until an image is found
		*/
		public function prevImage():Boolean {
			movingBack = true;
			
			if(urlObj == null)
				return false;
			getOlderURL();
			return true;
		}
		/*
		nextImage
			Purpose: 
				Generate newer URLs until an image is found. Only goes as far as the current time.
		*/
		public function nextImage():Boolean {
			movingBack = false;
			
			//ugly object compare
			if(urlObj.mins == latestURLObj.mins && urlObj.hours == latestURLObj.hours &&
			   	urlObj.year == latestURLObj.year && urlObj.doy == latestURLObj.doy)
				return false;
			
			if(currentURL == null) 
				return false;
				
			getNewerURL();
			return true;
		}
		/*
		loadImage
			Purpose:
				Attempts to load an image from the specified URL. If it fails to find an image then
				depending on whether the user was headed backwards or forwards, it will call prevImage 
				or nextImage. 
			Parameters:
				url: URL of the image
		*/
		private function loadImage(url:String):void {
			trace(url);
			this.load(new URLRequest(url));
			this.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,noImage,false,0,true);
			this.contentLoaderInfo.addEventListener(Event.COMPLETE,imageFound,false,0,true);
		}
		private function noImage(e:IOErrorEvent):void {
			//trace("URL not valid");
			if(movingBack)
				getOlderURL();
			else 
				getNewerURL();
		}
		private function imageFound(e:Event):void {
			//trace("Success");
			//trace(currentURL);
						
			//resize image
			this.width = maxWidth;
			this.height = maxHeight;
			
			(this.scaleX < this.scaleY) ? this.scaleY = this.scaleX:this.scaleX = this.scaleY;
			
			//get location image
			locURL = createLocImageURL(currentSat,urlObj.base,urlObj.year,urlObj.doy,urlObj.hours,urlObj.mins);
			loadLocImage(locURL);
			
			if(gettingLatestURL) {
				//ugly object copy
				latestURLObj = new Object();
				latestURLObj.modisURL = urlObj.modisURL;
				latestURLObj.mins = urlObj.mins;
				latestURLObj.hours = urlObj.hours;
				latestURLObj.doy = urlObj.doy;
				latestURLObj.year = urlObj.year;
				
				gettingLatestURL = false;
			}
		}
		/*
		loadLocImage
			Purpose:				
				Attempts to load the miniture location image of the earth that corresponds with the 
				loaded MODIS image. If it fails, no image is loaded and an error message is traced.
				
			Parameter: 
				url: URL for the location image 
		*/
		private function loadLocImage(url:String):void {
			locImage.load(new URLRequest(url));
			locImage.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,noLocImage,false,0,true);
		}
		private function noLocImage(e:IOErrorEvent):void {
			trace("No location image available");
		}
		/*
		getNewerUrl 
			Purpose:
				Loads an image using a URL +5 mins of the current URL.
		*/
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
			
			//main image
			currentURL = createImageURL(urlObj.modisURL,urlObj.year,urlObj.doy,urlObj.hours,urlObj.mins);
			loadImage(currentURL);
			
		}
		/*
		getOlderURL
			Purpose:
				Loads an image using a URL -5 mins of the current URL.

		*/
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
			trace(currentURL);
			loadImage(currentURL);
		}
		/*
		generateURLObject
			Purpose: 
				Generates an object whose members are each of the significant pieces of the URL.
			Parameters:
				satName: the name of the satellite to generate the url object for, only can be "TERRA" or "AQUA"
		*/
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
			//trace(hours,mins);
			//construct url object
			return {modisURL:modisURL,
					year:year,
					doy:doy,
					hours:hours,
					mins:mins};
		}
		/*
		createImageURL
			Purpose:
				Generates a MODIS image URL with the specifed parameters, usually taken from a url object.
			Parameters:
				modisURL: the part of the URL signifying the satellite
				    year: the year of the image URL
				     doy: the day of year of the image URL
				   hours: the hour of the image URL
				    mins: the minutes of the image URL
		*/
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
			
			return "http://lance-modis.eosdis.nasa.gov/imagery/realtime/"+
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
		/*
		createLocImageURL
			Purpose:
				Create a URL for the location image corresponding to the MODIS image. Most parameters taken from
				the url object.
			Parameters:
				 satName: name of the satellite the MODIS image is from
				modisURL: the part of the URL signifying the satellite
				    year: the year (same as MODIS) 
				     doy: the day of year (same as MODIS image)
				   hours: the hour (same as MODIS image)
				    mins: the minute (same as MODIS image)
		*/
		private function createLocImageURL(satName:String,modisURL:String,year:Number,doy:Number,hours:Number,mins:Number):String {
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
			var locModisURL:String = "";
			satName = satName.toUpperCase();
			if(satName == "TERRA")
				locModisURL = "/geoinfo1.A";
			else if(satName == "AQUA") 
				locModisURL = "/geoinfo2.A";
			else {
				trace("Sat name error");
				return null;
			}
			
			return "http://lance-modis.eosdis.nasa.gov/imagery/realtime/"+
					year+
					padDOY(doy)+
					locModisURL+
					year+
					padDOY(doy)+
					padTime(hours)+
					padTime(mins)+
					"00-"+
					year+
					padDOY(doy)+
					padTime(endHours)+
					padTime(endMins)+
					"00.jpg";
		}
		/*
		padTime
			Purpose:
				Add a leading zero to a single digit number
			Parameter:
				num: number to pad
		*/
		public function padTime(num:Number):String {
			if(num.toString().length < 2) {
				return "0"+num;
			}else {
				return num+"";
			}
		}
		/*
		padDOY
			Purpose:
				Add leading zeros to a day of year number creating a three digit number
			Parameter:
				day: day of year number to pad
		*/
		public function padDOY(day:Number):String {
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
