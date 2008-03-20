/*
	Copyright (C) 2007 Derek Santos

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/
package ca.dereksantos.fcl.calendarClasses {
	
	import ca.dereksantos.fcl.events.CalendarItemDeleteEvent;
	import ca.dereksantos.fcl.events.CalendarItemDropEvent;
	
	import mx.containers.VBox;
	import mx.controls.Label;
	import mx.events.DragEvent;
	import mx.managers.DragManager;
	
	
	
	///////////////////////////////////////////////////////////////////////////
	// Events
	///////////////////////////////////////////////////////////////////////////
	
	/**
	 * Dispatched when the <code>itemDelete</code> event is dispacthed
	 * from a <code>CalenderItem</code>. This is used to alert the 
	 * <code>Calendar</code> to delete the item from its <code>dataProvider</code>
	 * 
	 * @eventType dslib.events.CalendarItemDeleteEvent
	 * 
	 */	
	[Event(alias="itemDelete", type="dslib.events.CalendarItemDeleteEvent")]
	
	/**
	 * The <code>itemDrop</code> event is dispatched when an item 
	 * from an external source is dropped on to a <code>MonthDayRenderer</code>
	 * control. The event will then be dispatched from the <code>Calendar</code>
	 * control to allow the application to handle the event.
	 * 
	 * @eventType dslib.events.CalendarItemDropEvent
	 */	
	[Event(alias="itemDrop", type="dslib.events.CalendarItemDropEvent")]
	
	///////////////////////////////////////////////////
	// Styles
	///////////////////////////////////////////////////
	
	/**
	 * The name of the CSS Style Declaration used to change the apppearance
	 * of the CalendarItem controls in the Calendar.
	 * 
	 */	
	[Style(name="calendarItemStyleName", type="String", inherit="no")]
	
	/**
	 * The <code>MonthDayRenderer</code> class is used by the <code>Calendar</code> to 
	 * visually render a day of the month and display <code>CalendarItem</code> objects
	 * based on the <code>dataProvider</code> of the <code>Calendar</code>. A reference
	 * to the Date for the month day can be accessed through the <code>date</code> property.
	 * 
	 * 
	 * @author dsantos
	 * 
	 */	
	public class MonthDayRenderer extends VBox {
		
		/////////////////////////////////////////////////////////////////////////
		// Properties
		/////////////////////////////////////////////////////////////////////////
		
		
		//----------------------------------------------------------
		// _header property.
		//----------------------------------------------------------
		/**
		 * Storage for the <code>header</code> property.
		 */
		private var _header:Label;
				
		/**
		 * You use the <code>header</code> property to modify
		 * the properties of the label which displays the day number.
		 * 
		 * @return Label 
		 * 
		 */		
		public function get header():Label {
			return _header;
		}
		/**
		 * @param value:Label
		 * 
		 */		
		public function set header(value:Label):void {
			_header = value;
		}
		
		//----------------------------------------------------------
		// _body property.
		//----------------------------------------------------------
		private var _body:VBox;
		
		/**
		 * You use the <code>body</code> property to modify the properties 
		 * of the VBox componenet in which calendar items are displayed.
		 * 
		 * @return 
		 * 
		 */		
		public function get body():VBox {
			return _body;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */		
		public function set body(value:VBox):void {
			_body = value;
		}
		
				
		//----------------------------------------------------------
		// _date property.
		//----------------------------------------------------------
		/**
		 * Storage for the <code>date</code> property. 
		 */		
		private var _date:Date;
		
		/**
		 * You use the <code>date</code> property to set the date
		 * which the instance of the MonthDayRenderer is applied too.
		 * 
		 * @return 
		 * 
		 */		
		public function get date():Date {
			return _date;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */		
		public function set date(value:Date):void {
			_date = value;
		}
		
		
		//----------------------------------------------------------------
		// _dataField property.
		//----------------------------------------------------------------
		/**
		 * Storage for the <code>dateField</code> property.
		 */
		private var _dateField:String;
		
		[Bindable]
		/**
		 * You use the <code>dateField</code> property to specify which
		 * field in the dataProvider will be used to provide the days
		 * in the month with calendar items.
		 * 
		 * @return IList
		 * 
		 */		
		public function get dateField():String {
			return _dateField;
		}
		/**
		 * @param value:IList
		 * 
		 */		
		public function set dateField(value:String):void {
			_dateField = value;
		}
		
		//----------------------------------------------------------------
		// _labelField property.
		//----------------------------------------------------------------
		/**
		 * Storage for the <code>labelField</code> property.
		 */
		private var _labelField:String;
		
		[Bindable]
		/**
		 * You use the <code>dateField</code> property to specify which
		 * field in the dataProvider will be used to visually display
		 * calendar items.
		 * 
		 * @return IList
		 * 
		 */		
		public function get labelField():String {
			return _labelField;
		}
		/**
		 * @param value:IList
		 * 
		 */		
		public function set labelField(value:String):void {
			_labelField = value;
		}
		
		
		
		//----------------------------------------------------------
		// _items property.
		//----------------------------------------------------------
		/**
		 * Storage for the <code>items</code> property. 
		 */		
		private var _items:Array;
		
		/**
		 * <p>
		 * You use the <code>items</code> property to add calendar
		 * events/items to the day the of the month in which the 
		 * instance of the MonthDayRenderer is applied too.
		 * </p>
		 * 
		 * <p>
		 * When the <code>items</code> property is set it will update 
		 * the display and show the calendar items.
		 * </p>
		 * @return 
		 * 
		 */		
		public function get items():Array {
			return _items;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */		
		public function set items(value:Array):void {
			_items = value;
			
			showItems();
		}
		
		
		
		
		/////////////////////////////////////////////////////////////////////////
		// Constructor
		/////////////////////////////////////////////////////////////////////////
		/**
		 * Constructor method
		 */
		public function MonthDayRenderer():void {
			date = new Date();
			
			addEventListener(DragEvent.DRAG_DROP,handleDragDrop);
			addEventListener(DragEvent.DRAG_ENTER,handleDragEnter);
		}
		
		
		/**
		 * Renders the <code>items</code> using the <code>CalendarItem</code> class.
		 * You can use the <code>calendarItemStyleName</code> style to change the 
		 * appearance of the <code>CalendarItem</code> objects.
		 *  
		 */		
		private function showItems():void {
			var calendarItem:CalendarItem;
			body.removeAllChildren();
			
			for(var i:int = 0; i < items.length; i++) {
				
				calendarItem = new CalendarItem();
				body.addChild(calendarItem);
				
				calendarItem.item = items[i];
				calendarItem.text = (items[i])[labelField];
				calendarItem.percentWidth = 100;
				
				calendarItem.addEventListener(CalendarItemDeleteEvent.ITEM_DELETE,handleCalendarItemDelete);
				
				if(getStyle("calendarItemStyleName") != null) {
					calendarItem.styleName = getStyle("calendarItemStyleName");
				} else {
					calendarItem.setStyle("backgroundColor", 0xC1CDFF);
					calendarItem.setStyle("color",0x222299);
					calendarItem.setStyle("backgroundAlpha", 1);
				}
				
			}
			
			body.invalidateDisplayList();
		}
		
		
		/////////////////////////////////////////////////////////////////////////
		// Protected methods
		/////////////////////////////////////////////////////////////////////////
		
		/**
		 * Calls the <code>createChildren()</code> method of the superclass and
		 * adds the child display objects to visually display the 
		 * <code>MonthDayRenderer</code>.
		 * 
		 */		
		override protected function createChildren():void {
			super.createChildren();
			
			if(!header) {
				header = new Label();
				header.setStyle("textAlign","left");
				header.percentWidth = 100;
				header.percentHeight = 10;
				header.minHeight = 15;
				header.maxHeight = 25;
			
				addChild(header);
			}
			
			if(!body) {
				body = new VBox();
				body.percentWidth = 100;
				body.percentHeight = 90;
				
				addChild(body);
			}
			
							
		}
		
		
		
		//////////////////////////////////////////////////////////////////////////////
		// Event Listeners
		//////////////////////////////////////////////////////////////////////////////
		/**
		 * Handles the <code>itemDelete</code> event of the child <code>CalendarItem</code>
		 * objects and dispatched the event to the parent <code>Calendar</code> object.
		 * This will signal the <code>Calendar</code> to delete the item from
		 * its <code>dataProvider</code>.
		 * 
		 * @param event:CalendarItemDeleteEvent
		 * 
		 */		
		private function handleCalendarItemDelete(event:CalendarItemDeleteEvent):void {
			dispatchEvent(event);
		}
		
		/**
		 * Handles the <code>dragDrop</code> event.
		 * A new <code>CalendarItemDropEvent</code> will be created a dispatched.
		 * The <code>CalendarItemDropEvent</code> will have a reference to the dropped item
		 * and the date that item was dropped on.
		 * 
		 * @param event:DragEvent
		 * @see dslib.events.CalendarItemDropEvent
		 * 
		 */		
		private function handleDragDrop(event:DragEvent):void {
			var items:Array = new Array();
			var calendarItemDropEvent:CalendarItemDropEvent;
			for each ( var format:String in event.dragSource.formats) {
				items.push(event.dragSource.dataForFormat(format)[0]);
			}
			calendarItemDropEvent = new CalendarItemDropEvent(items,date,CalendarItemDropEvent.ITEM_DROP);
			dispatchEvent(calendarItemDropEvent);
			
		}
		
		/**
		 * Handles the <code>dragEnter</code> event. This is used
		 * to call the <code>acceptDragDrop()</code> method 
		 * of the <code>DragManager</code> and allow the <code>MonthDayRenderer</code>
		 * to have items dropped on it.
		 * 
		 * @param event:DragEvent
		 * 
		 */		
		private function handleDragEnter(event:DragEvent):void {
			DragManager.acceptDragDrop(event.target as MonthDayRenderer);
		}
	}
}