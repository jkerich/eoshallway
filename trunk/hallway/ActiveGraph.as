/**
 * ActiveGraph 1.4: an overthought shot in the dark
 * by Jeremy Sachs June 2, 2007
 *
 * I have no blog, yet. When I have one, visit it. 
 * Maybe by then I'll have a new ActiveGraph.
 *
 * You may distribute this class freely, provided it is not modified in any way (including
 * removing this header or changing the package path).
 *
 * rezmason@mac.com
 */


/* parameters of ActiveGraph (all are optional):
 * interval- the length of time (in milliseconds) between memory checks.
 * (NOTE: a memory check does not always make a point on the graph, only when there's relevant data.)
 * verbose- when set to true, this traces data to your Output menu.
 * visible- when set to false, this keeps Activegraph from drawing to the screen.
 * degree- sets the number of sawtooth patterns to compensate for. (Default is 2)
 */


package 
{
	// import statements
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.system.System;
	/**
	 * ActiveGraph class
	 * Graphs and displays or outputs memory usage,
	 * measured in pages- 4-kilobyte chunks
	 */
	public class ActiveGraph extends Sprite
	{
		private const WIDTH:Number = 50, HEIGHT:Number = 15;
		private const MEGABYTES:Number = 1/1048576, PAGE:Number = 4096;
		private var verboseMode:Boolean, returnVal:Boolean;
		private var lastPlot1:int, lastPlot2:int, plot:int, plotLength:int;
		private var high:Number, low:Number, itr:Number;
		private var history:Array;
		private var output:String, sign:String;
		private var timer:Timer;
		// display-related properties
		private var textBox:TextField;
		private var textFormat:TextFormat;
		private var graphBackground:Sprite;
		private var plotLine:Shape;
		private var backX:Number, backY:Number;
		private var numerator:Number, denominator:Number, average:int, old:int;
		private var caught2:Boolean = false;
		private var fn:Function;
		public function ActiveGraph(interval:Number=0, verbose:Boolean=false, drawData:Boolean=true, degree:int=2):void
		{
			degree = Math.min(degree, 2);
			lastPlot1 = lastPlot2 = plot = plotLength = 0;
			history = new Array();
			numerator = denominator = average = 0;
			timer = new Timer(interval);
			verboseMode = verbose;
			switch (degree) {
				case 0 :
					fn = test0;
					break;
				case 2 :
					fn = test2;
					break;
				default :
					fn = test1;
					break;
			}
			if (drawData) {
				// instantiate drawing objects
				textBox = new TextField();
				textFormat = new TextFormat();
				graphBackground = new Sprite();
				plotLine = new Shape();
				// format textBox
				textFormat.size = 9;
				textFormat.font = "Monaco";
				textFormat.color = 0xFFFFFF;
				textBox.selectable = false;
				textBox.autoSize = TextFieldAutoSize.LEFT;
				textBox.x = WIDTH + 5;
				textBox.height = HEIGHT;
				// draw graphBackground
				graphBackground.graphics.beginFill(0);
				graphBackground.graphics.drawRect(0,0,WIDTH + 85,HEIGHT);
				graphBackground.graphics.endFill();

				graphBackground.graphics.lineStyle(0.5,0xFFFFFF);
				graphBackground.graphics.drawRect(0,0,WIDTH,HEIGHT-1);
				// add to display list
				this.addChild(graphBackground);
				this.addChild(plotLine);
				this.addChild(textBox);

				timer.addEventListener(TimerEvent.TIMER, drawMem, false, 0, true);

				// implements clicking and dragging behavior
				textBox.mouseEnabled = false;
				backX = x, backY = y;
				graphBackground.addEventListener(MouseEvent.MOUSE_DOWN, handleDrag, false, 0, true);
				graphBackground.addEventListener(MouseEvent.MOUSE_UP, handleDrag, false, 0, true);
				this.addEventListener(Event.ADDED_TO_STAGE, loadDrag, false, 0, true);
			} else {
				trace("ActiveGraph Running.");
				timer.addEventListener(TimerEvent.TIMER, trackMem, false, 0, true);
			}
			timer.start();
		}
		// trackMem- determines whether the GC has run, outputs active memory
		private function trackMem(e:TimerEvent = null):Boolean
		{
			returnVal = false;
			plot = System.totalMemory/PAGE;
			old = average;
			numerator += plot;
			denominator++;
			average = numerator/denominator;
			// if the plot is relevant...
			if (fn() && verboseMode) {
				trace(plot);
			}
			return returnVal;

		}
		// test0: doesn't clean up sawteeth
		private function test0():Boolean
		{
			if (lastPlot1 != plot) {
				returnVal = true;
				lastPlot1 = plot;
			}
			return returnVal;
		}
		// test1: cleans up DRC sawteeth
		private function test1():Boolean
		{
			returnVal = (!lastPlot1 || lastPlot1 > plot);
			lastPlot1 = plot;
			return returnVal;
		}
		// test2: cleans up mark'n'sweep sawteeth
		private function test2():Boolean
		{
			if (lastPlot1 > plot || !lastPlot1) {
				if (lastPlot2 > plot || !lastPlot2) {
					caught2 = true;
				}
				lastPlot2 = plot;
			} else if (lastPlot1 < plot && caught2) {
				plot = lastPlot2;
				returnVal = true;
				caught2 = false;
			}
			lastPlot1 = plot;

			return returnVal;
		}
		// drawMem- updates graph and textbox
		private function drawMem(e:TimerEvent = null):void
		{
			if (trackMem()) {
				plotLine.graphics.clear();
				// history array never exceeds a certain length
				if (plotLength == 21) {
					history.shift();
					plotLength--;
				}
				// determines whether to display +/- for memory increase/decrease
				if (plot > history[int(plotLength-1)]) {
					sign = "+ , ";
				} else if (plot < history[int(plotLength-1)]) {
					sign = "- , ";
				} else {
					sign = "  , ";
				}
				// add plot to data set
				history.push(plot);
				plotLength = history.length;
				// If the graph's long enough,
				if (plotLength > 1) {
					plotLine.graphics.lineStyle(2.5,0xFF0000);
					high = 0, low = Infinity;
					// find the top and bottom extrema,
					for (itr = 0; itr < plotLength; itr++) {
						high = Math.max(history[itr], high);
						low = Math.min(history[itr], low);
					}
					// then plot the graph.
					plotLine.graphics.moveTo(0, HEIGHT*(1-(history[0]-low)/(high-low)));
					for (itr = 1; itr < plotLength; itr++) {
						// I hate the math. I hate writing it out.
						plotLine.graphics.lineTo(WIDTH*itr/(plotLength-1), 
						HEIGHT*(1-(history[itr]-low)/(high-low)));
					}
				}
				// put output text in textBox
				output = plot+sign;
				textBox.text = String(output)+String(average);
				textBox.setTextFormat(textFormat);
			}
		}
		private function handleDrag(e:Event):void
		{
			// based on the event type,
			switch (e.type) {
				case MouseEvent.MOUSE_DOWN :
					// start dragging,
					backX = x, backY = y;
					startDrag();
					break;
				case MouseEvent.MOUSE_UP :
					// stop dragging,
					stopDrag();
					break;
				case Event.MOUSE_LEAVE :
					// or reset the positiong, in case it's been dragged off the Stage
					stopDrag();
					x = backX, y = backY;
					break;
			}
		}
		private function loadDrag(e:Event):void
		{
			this.stage.addEventListener(Event.MOUSE_LEAVE, handleDrag, false, 0, true);
		}
		public function get data():Number
		{
			return plot;
		}
	}
}