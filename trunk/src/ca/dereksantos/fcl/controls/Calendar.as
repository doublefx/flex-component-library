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
package ca.dereksantos.fcl.controls {
	
	import ca.dereksantos.fcl.calendarClasses.MonthDayRenderer;
	import ca.dereksantos.fcl.events.CalendarItemDeleteEvent;
	import ca.dereksantos.fcl.events.CalendarItemDropEvent;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.IList;
	import mx.containers.Box;
	import mx.containers.HBox;
	import mx.controls.Button;
	import mx.controls.Label;
	import mx.skins.ProgrammaticSkin;
	import mx.styles.CSSStyleDeclaration;
	import mx.styles.StyleManager;
	
	//////////////////////////////////////////////
	// Styles
	//////////////////////////////////////////////
	
	
	/**
	 * <p>
	 * The name of the CSS Style Declaration used to modify the appearance
	 * of the MonthDayRenderer for days in the month. The style has no default 
	 * value. If this style has no value, the style will be as follows:
	 * </p>
	 * <br/>
	 * <code>
	 * borderColor: #8899DD;<br/>
	 * color: #222299;<br/>
	 * borderStyle: solid;<br/>
	 * backgroundAlpha: 0;<br/>
	 * </code>
	 * <br/>
	 * <p>
	 * In addition to this, 
	 * the backgroundColor will be set to the value of 
	 * the <code>selectedDayColor</code> style.
	 * </p>
 	 */
	[Style(name="dayClassName",type="String",inherit="no")]
	
	/**
	 * The name of the CSS Style Declaration used to modify the appearance
	 * of the CalendarEvent for events in a month day.
	 * 
	 */	
	[Style(name="itemClassName",type="String",inherit="no")]
	
	
	/**
	 * The color used to set the background color of the MonthDayRenderer when
	 * the user selects a date. 
	 * 
	 * @default #AABBFF
	 * 
	 */	
	[Style(name="selectedDayColor", type="uint", format="Color", inherit="no")]
	
	/**
	 * The name of the CSS Style Declaration used ot modify the appearance of
	 * the day names in the calendar header.
	 * 
	 */	
	[Style(name="dayNamesStyleName", type="String", inherit="no")]
	
	//////////////////////////////////////////////
	// Events
	//////////////////////////////////////////////
	
	/**
	 * <p>
	 * Dispatched when a day in the month is clicked. You can use the
	 * <code>selectedDate</code> property of the <code>Calendar</code> to
	 * retrieve the date the user selected when this event is dispatched.
	 * </p>
	 * 
	 * <br/>
	 * NOTE:This event
	 * is not dispatched when the selectedDay property is set 
	 * programmatically.
	 * 
	 * @eventType flash.events.Event
	 */
	[Event(name="change",type="flash.events.Event")]
	
	/**
	 * Dispatched when the <code>month</code> property is changed.
	 * 
	 * @eventType flash.events.Event 
	 */	
	[Event(name="monthChange", tytpe="flash.events.Event")]
	
	/**
	 * Dispatched when an item from an external source is dropped
	 * on to a day in the month. 
	 * 
	 * @eventType dslib.events.CalendarItemDropEvent 
	 */	
	[Event(name="itemDrop", type="dslib.events.CalendarItemDropEvent")]
	
	/**
	 * Dispatched when the delete button of an item is clicked and the item
	 * is removed from the <code>dataProvider</code>.
	 * 
	 * @eventType dslib.events.CalendarItemDropEvent 
	 */	
	[Event(name="itemDelete", type="dslib.events.CalendarItemDropEvent")]

	
	/**
	 * <p>
	 * You use the calendar control to allow users to choose a day in the month
	 * and add events to it. The <code>dataProvider</code> property can be binded
	 * to your list of data in order to display items on the calendar. 
	 * </p>
	 * 
	 * <p>
	 * NOTE:<br/>
	 * In order to display data, the items in your dataProvider must have a <code>date</code> property. 
	 * If they do not, then you must set the <code>dateField</code> property to the property
	 * you wish to use as the reference to the date which the calendar event should appear in.
	 * Your items must also have a property called <code>label</code>. If they do not,
	 * you must set the <code>labelField</code> property to the property in your items
	 * you wish to use to visually display the items in the calendar.
	 * </p>
	 * <br/>
	 * See the properties <code>dateField</code> and <code>labelField</code> for more information.
	 * <br/>
	 * 
	 * Syntax:<br/>
	 * 
	 * <code>
	 * <dslib:Calendar
	 * 		dataProvider="{myArrayCollection}"
	 * 		dateField="dateField"
	 * 		labelField="labelField
	 * 		/> 		
	 * </code>
	 * 
	 * @author dsantos
	 * 
	 */	
	public class Calendar extends Box {
		
		// Define a static variable.
        private static var classConstructed:Boolean = classConstruct();
    
        // Define a static method.
        private static function classConstruct():Boolean {
            if (!StyleManager.getStyleDeclaration("Calendar")) {
                // If there is no CSS definition for Calendar, 
                // then create one and set the default value.
                var newStyleDeclaration:CSSStyleDeclaration = 
                    new CSSStyleDeclaration();
                newStyleDeclaration.setStyle("selectedDayColor", 0xAABBFF);
                StyleManager.setStyleDeclaration("Calendar", newStyleDeclaration, true);
            }
            return true;
        }

		///////////////////////////////////////////////////////////////////////////
		// Constants
		///////////////////////////////////////////////////////////////////////////
		
		/**
		 * Constant defining the name of the <code>change</code> event.
		 */		
		public static const CHANGE:String = "change";
		
		
		
		///////////////////////////////////////////////////////////////////////////
		// Properties
		///////////////////////////////////////////////////////////////////////////
		
		
		//----------------------------------------------------------------
		// _dataProvider property.
		//----------------------------------------------------------------
		/**
		 * Storage for the dataProvider property.
		 */
		private var _dataProvider:IList;
		
		[Bindable]
		/**
		 * You use the <code>dataProvider</code> property to populate 
		 * the Calendar component with event data. The Calendar will
		 * use the values of the <code>dateField</code> and <code>labelField</code>
		 * properties to display the data.
		 * 
		 * @return IList
		 * 
		 */		
		public function get dataProvider():IList {
			return _dataProvider;
		}
		/**
		 * @public
		 * @param value:IList
		 * 
		 */		
		public function set dataProvider(value:IList):void {
			_dataProvider = value;
			displayData();
		}
		
		//----------------------------------------------------------------
		// _dataField property.
		//----------------------------------------------------------------
		/**
		 * Storage for the <code>dateField</code> property.
		 */
		private var _dateField:String = "date";
		
		[Bindable]
		/**
		 * You use the <code>dateField</code> property to specify which
		 * field in the <code>dataProvider</code> will be used to provide the days
		 * in the month with calendar items. If you do not set this value, the default value
		 * of <i>date</i> will be used meaning your items must have a date property defined.
		 * If your items do not have a date property defined, then you must specify which
		 * property the Calendar should use as a date reference to display the item
		 * correctly in the Calendar.
		 * 
		 * @default date
		 * @return IList
		 * 
		 */		
		public function get dateField():String {
			return _dateField;
		}
		
		/**
		 * @public
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
		private var _labelField:String = "label";
		
		[Bindable]
		/**
		 * You use the <code>labelField</code> property to specify which
		 * field in the dataProvider will be used to visually display
		 * calendar items. The default value is <i>label</i> meaning the items
		 * in your dataProvider must have a label property defined. If they do not,
		 * you can specify which field you want the Calendar to use as the String value
		 * to visually render the item.
		 * 
		 * @default label
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
		
		//----------------------------------------------------------------
		// _selectedDate property.
		//----------------------------------------------------------------
		
		/**
		 * Storage for the <code>selected</code> property.
		 */
		private var _selectedDate:Date = new Date();
		
		/**
		 * You use the <code>selectedDate</code> property to retrieve which date
		 * the user has chosen in the Calendar. This will default to the current date.
		 * 
		 * @return Date
		 * 
		 */		
		public function get selectedDate():Date {
			return _selectedDate;	
		}		
		/**
		 * @public
		 */
		public function set selectedDate(value:Date):void {
			_selectedDate = value;
		}		
		
		
		//----------------------------------------------------------------
		// _dayNames property.
		//----------------------------------------------------------------
		/**
		 * Storage for the dayNames property.
		 */
		private var _dayNames:Array = ['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Satruday'];
		
		/**
		 * You use the <code>dayNames</code> to override or return the default names 
		 * for the days of the week.
		 * @default ['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Satruday']
		 * @return Array
		 * 
		 */		
		public function get dayNames():Array {
			return _dayNames;
		}
		/**
		 * @public
		 * @param value:Array
		 * 
		 */		
		public function set dayNames(value:Array):void {
			_dayNames = value;
			
			/**
			 * 
			 * TO DO: Dispatch dayNamesChange event. updateLayout() on dayNamesChange
			 * 
			 */
		}
	
		
		//----------------------------------------------------------------
		// _monthNames property.
		//----------------------------------------------------------------
		/**
		 * Storage for the monthNames property.
		 */
		private var _monthNames:Array = ['January','February','March','April','May','June','July','August','September','October','November','December'];
		
		/**
		 * You use the <code>monthNames</code> to override or return the default names 
		 * for months.
		 * @default ['January','February','March','April','May','June','July','August','September','October','November','December']
		 * @return Array
		 * 
		 */		
		public function get monthNames():Array {
			return _monthNames;
		}
		/**
		 * @public
		 * @param value:Array
		 * 
		 */		
		public function set monthNames(value:Array):void {
			_monthNames = value;
			
			/**
			 * 
			 * TO DO: Dispatch monthNamesChange event. updateLayout() on monthNamesChange
			 * 
			 */
		}
		
		
		//----------------------------------------------------------------
		// _month property.
		//----------------------------------------------------------------
		/**
		 * Storage for the month property.
		 */
		private var _month:Date = new Date();
		
		/**
		 * <p>
		 * You use the <code>month</code> property to set the month
		 * the Calendar should display. If you want to navigate to
		 * a specific month in a year it is ideal to set this property
		 * to that particular month and year. If you want
		 * to navigate to the next or previous month, it is easier to 
		 * use the <code>goToPreviousMonth()</code> or <code>goToNextMonth()</code> 
		 * methods.
		 * </p>
		 *  
		 * @return Date
		 * 
		 */		
		public function get month():Date {
			return _month;
		}
		
		/**
		 * 
		 * 
		 * @param value
		 * 
		 */		
		public function set month(value:Date):void {
			//What the heck does this do?????
			if( ( value.getMonth( ) != _month.getMilliseconds( ) && value.getFullYear( ) == _month.getFullYear( ) ) || 
				( value.getMonth( ) == _month.getMilliseconds( ) && value.getFullYear( ) != _month.getFullYear( ) ) ) {
				_month = value;
				dispatchEvent( new Event( "monthChange" ) );
			} else {
				_month = value;
			}
		}
		
		
		
		
		/**
		 * Storage for the dayNames header components. 
		 */		
		private var headers:Array;
		
		/**
		 * Contains MonthDayRenderer objects for every day in the month. 
		 * The <code>days</code> property is used to add events to the days in the month. 
		 */
		private var days:Array;
		
		/**
		 * A reference to the DisplayObject used to render the month name as well as the month
		 * navigation buttons.
		 */				
		private var monthHeader:Label;
		/**
		 * A reference the Button instance used to navigate to the next month.
		 */		
		private var nextMonthButton:Button;
		/**
		 * A reference the Button instance used to navigate to the previous month.
		 */		
		private var prevMonthButton:Button;
		/**
		 * A reference to the MonthDayRenderer instance used to display the day the user has selected.
		 * 
		 */		
		private var selectedDay:MonthDayRenderer;
	
		
		//----------------------------------------------------------------
		// Constructor
		//----------------------------------------------------------------
		
		/**
		 * Constructor<br/>
		 * Adds an event listener for the <code>monthChange</code> event.
  		 * @return 
		 * 
		 */		
		public function Calendar( ) {
			addEventListener("monthChange",handleMonthChange);
			setStyle("backgroundColor", 0xFFFFFF);
			setStyle("backgroundAlpha", 1);
		}
		
		
		////////////////////////////////////////////////////////////////////
		// Public methods
		////////////////////////////////////////////////////////////////////
		
		/**
		 * Moves to the next month. 
		 *
 		 */		
		public function goToNextMonth( ):void {
			//This statment does NOT call the setter method, therefore we must set the month property to itself
			//in order to invoke the monthChange event and update the calendar layout.
			month.setMonth(month.getMonth() + 1);
			month = month;
		}	
		
		/**
		 * Moves to the previous month. 
		 *  
		 */			
		public function goToPreviousMonth():void {
			month.setMonth(month.getMonth() - 1);
			month = month;
		}
		
		/**
		 * You can use the <code>refresh()</code> method to tell the 
		 * Calendar to re-evaluate its dataProvider. This is useful
		 * when items are being added to your dataProvider programmtically.
		 * 
		 */		
		public function refresh():void {
			displayData( );
		}
		
		////////////////////////////////////////////////////////////////////
		// Protected methods
		////////////////////////////////////////////////////////////////////
		
		/**
		 * Calls the createChildren method of the superclass and
		 * calls <code>updateLayout()</code> to create the inital 
		 * calendar layout.
		 * 
		 */		
		override protected function createChildren():void {
			super.createChildren( );
			updateLayout( );			
		}
		
	
		
		////////////////////////////////////////////////////////////////////
		// Private methods
		////////////////////////////////////////////////////////////////////
		
		/**
		 * <p>
		 * Creates the child display objects for the current selected month.
		 * This functions only purpose is to layout the calendar visually,
		 * and to supply containers in the calendar for data.
		 * </p>
		 * 
		 * <p>
		 * This function is typically called when the month has changed,
		 * or when the visual properties of the calendar have been dramatically changed. 
		 * </p>
		 */		
		protected function updateLayout():void {
			var date:Date = new Date(month.getTime());
			var initialMonth:int = date.getMonth();
			var column:int = 0;
			var row:int = 0;
			var component:MonthDayRenderer;
			var rowBox:HBox;
			var gridEnd:Boolean = false;
			var headerLabel:Label;
			var headerBox:Box;
			
			removeAllChildren( );
		
			
			/*
				This section creates the header & navigation.			
			*/
			//Create navigation and month header.
			rowBox = new HBox( );
			rowBox.minHeight = 25;
			rowBox.percentWidth = 100;
			
			addChild( rowBox );
			
			prevMonthButton = new Button( );
			
			rowBox.addChild( prevMonthButton );
			prevMonthButton.percentHeight = 100;
			prevMonthButton.addEventListener( MouseEvent.CLICK,handlePrevMonthButtonClick );		
			prevMonthButton.label = "<<";
			
			monthHeader = new Label( );
					
			rowBox.addChild( monthHeader );
			monthHeader.setStyle("textAlign","center");
			monthHeader.text = monthNames[date.getMonth( )] + " " + month.getFullYear( ).toString( );
			monthHeader.percentWidth = 100;
			monthHeader.percentHeight = 100;
			
			nextMonthButton = new Button( );
			
			rowBox.addChild(nextMonthButton);			
			nextMonthButton.percentHeight = 100;
			nextMonthButton.addEventListener(MouseEvent.CLICK,handleNextMonthButtonClick);
			nextMonthButton.label = ">>";
			
			 
			//Create Day Headers
			rowBox = new HBox();
			rowBox.minHeight = 25;
			rowBox.percentWidth = 100;
			addChild(rowBox);			
			for(var i:int = 0; i < 7; i++) {

				headerBox = new Box();
				rowBox.addChild(headerBox);
				headerBox.percentWidth = 100;
				
				if(getStyle("dayNamesStyleName") != null) {
					headerBox.styleName = getStyle("dayNamesStyleName");	
				} else {
					headerBox.setStyle("backgroundColor", 0xCCDDFF);
					headerBox.setStyle("borderColor", 0x8899DD);
					headerBox.setStyle("borderStyle", "solid");
					headerBox.setStyle("borderSides", "bottom");
					headerBox.setStyle("color",0x222299);
				}
				
				headerLabel = new Label();
				
				headerBox.addChild(headerLabel);
				headerLabel.text = dayNames[i];
				headerLabel.percentHeight = 100;
				headerLabel.percentWidth = Math.round(100/7);
			}
			 
			
			/*
			  This section draws the month grid. Each day has a 
			  MonthDayRenderer component inside of it which can be 
			  used to render calendar events.			 
			 */ 
			date.setDate(1);
			days = new Array();
			
			rowBox = new HBox();
			addChild(rowBox);
			rowBox.percentWidth = 100;
			rowBox.percentHeight = 20;
						
			while(!gridEnd) {
				
				component = new MonthDayRenderer();
				rowBox.addChild(component);			
				days[date.getDate()-1] = component;

				if(column < date.getDay() || initialMonth != date.getMonth()) {
					component.enabled = false;
					component.visible = false;
				} else {
					
					component.header.text = date.getDate().toString();
					component.date.setTime(date.getTime());
										
					component.addEventListener(MouseEvent.CLICK, handleDayClick);
					component.addEventListener(MouseEvent.MOUSE_OVER, handleMouseOver);
					component.addEventListener(MouseEvent.MOUSE_OUT,handleMouseOut);
					component.addEventListener(CalendarItemDeleteEvent.ITEM_DELETE, handleCalendarItemDelete);
					component.addEventListener(CalendarItemDropEvent.ITEM_DROP, handleCalendarItemDrop);
					
					if(getStyle("dayClassName") != null) {
						component.styleName = getStyle("dayClassName");
					} else {
						component.setStyle("borderColor", 0x8899DD);
						component.setStyle("color",0x222299);
						component.setStyle("borderStyle","solid");
						component.setStyle("backgroundColor",getStyle("selectedDayColor"));
						component.setStyle("backgroundAlpha",0);
					}
					
					
					if(selectedDay) {
						if(selectedDay.date.getTime() == date.getTime()) {
							component.setStyle("backgroundAlpha", 0.5);
							selectedDay = component;
						}
					}
					date.setTime(date.getTime() + 1000*60*60*24);
					
					component.labelField = labelField;
					
				}
								
				component.percentWidth = Math.ceil(100/7);
				component.percentHeight = 100;
				
				column++;
				if(column == 7) {
					if(initialMonth != date.getMonth()) {
						gridEnd = true;
					} else {
						column = 0;
						row++;
						rowBox = new HBox();
						rowBox.percentWidth = 100;
						rowBox.percentHeight = 20;
						addChild(rowBox);
					}		
				}						
			}
		}
		
		
		/**
		 * The <code>displayData()</code> method is used to display 
		 * events in the Calendar based on the <code>dataProvider</code>.
		 * You can use the <code>refresh()</code> method to call this method publically.
		 * 
		 */		
		protected function displayData():void {
			var day:MonthDayRenderer;
			var item:Object;
			var itemDate:Date;
			var tempItems:Array;
			
			for(var i:int = 0; i < days.length; i++) {
				day = days[i] as MonthDayRenderer;
				tempItems = new Array();
				
				for(var j:int = 0; j < dataProvider.length; j++) {
					item = dataProvider.getItemAt(j);
					if(item[dateField] is Date) {
						itemDate = item[dateField] as Date;
					} else {
						itemDate = new Date(Date.parse(String(item[dateField])));
					}					
					
					
					if(itemDate.getFullYear() == day.date.getFullYear() && 
					   itemDate.getMonth() == day.date.getMonth() &&
					   itemDate.getDate() == day.date.getDate()) {
						 tempItems.push(item);
					}
				}	
				
				day.items = tempItems;
			}
		}
		
		
			
		///////////////////////////////////////////////////////////////////////////////
		// Event Handlers
		///////////////////////////////////////////////////////////////////////////////
		
		
		
		/**
		 * Handles the click event of the nextMonthButton, 
		 * calls the goToNextMonth() method.
		 */		
		private function handleNextMonthButtonClick(event:Event):void {
			goToNextMonth();
		}
		
		/**
		 * Handles the click event of the prevMonthButton,
		 * calls the goToPrevMonth() method. 
		 */		
		private function handlePrevMonthButtonClick(event:Event):void {
			goToPreviousMonth();
		}
		
		/**
		 * Handles the click event of the days in the displayed month.
		 * Sets the selectedDay property
		 * @param event:Event
		 * 
		 */		
		private function handleDayClick(event:Event):void {
			//Unhighlight the old selected day first before setting the new one.
			if(selectedDay) {
				selectedDay.setStyle("backgroundAlpha",0);
			}
			
			selectedDay = event.currentTarget as MonthDayRenderer;
			selectedDay.setStyle("backgroundAlpha", 0.5);
			
			dispatchEvent(new Event(Calendar.CHANGE));
		}
		
		/**
		 * Handles the mouseOver event for the calendar days and
		 * highlights the day. 
		 * 
		 * @param event:Event
		 * 
		 */		
		private function handleMouseOver(event:Event):void {
			event.currentTarget.setStyle("backgroundAlpha",0.3);
		}
		
		/**
		 * Handles the mouseOut event for the calendar days and 
		 * unhighlits the days.
		 *  
		 * @param event:Event
		 * 
		 */		
		private function handleMouseOut(event:Event):void {
			
			if(event.currentTarget == selectedDay) {
				event.currentTarget.setStyle("backgroundAlpha",0.5);
			} else {
				event.currentTarget.setStyle("backgroundAlpha",0);				
			}
		}
		
		/**
		 * Handles the monthChange event of the Calendar component.
		 * 
		 * @param event:Event
		 * 
		 */		
		private function handleMonthChange(event:Event):void {
			updateLayout();
			displayData();
		}
		
		/**
		 * Handles the <code>itemDelete</code> event of the MonthDayRenderer objects.
		 * This will remove the item from the dataProvider.
		 * 
		 * @param event:CalendarItemDeleteEvent
		 * @see dslib.events.CalendarItemDeleteEvent
		 * 
		 */		
		private function handleCalendarItemDelete(event:CalendarItemDeleteEvent):void {
			dataProvider.removeItemAt(dataProvider.getItemIndex(event.deletedItem));
			displayData();
				
		}
		
		/**
		 * Handles <code>itemDrop</code> event of the MonthDayRenderer objects.
		 * This will dispatch the event from the Calendar allowing items to be
		 * added from an external source.
		 * 
		 * @param event
		 * @see dslib.events.CalendarItemDropEvent
		 */		
		private function handleCalendarItemDrop(event:CalendarItemDropEvent):void {
			dispatchEvent(event);
			var skin:ProgrammaticSkin = new ProgrammaticSkin();
		}
		
		
		
	}
}