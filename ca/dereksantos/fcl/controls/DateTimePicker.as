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
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.text.StyleSheet;
	
	import mx.containers.HBox;
	import mx.containers.VBox;
	import mx.controls.Alert;
	import mx.controls.Button;
	import mx.controls.ComboBox;
	import mx.controls.DateField;
	import mx.controls.Label;
	import mx.controls.NumericStepper;
	import mx.controls.TextInput;
	import mx.controls.dataGridClasses.DataGridListData;
	import mx.controls.listClasses.BaseListData;
	import mx.controls.listClasses.IDropInListItemRenderer;
	import mx.controls.listClasses.IListItemRenderer;
	import mx.controls.listClasses.ListData;
	import mx.core.IDataRenderer;
	import mx.events.CalendarLayoutChangeEvent;
	import mx.events.FlexEvent;
	import mx.events.ListEvent;
	import mx.events.NumericStepperEvent;
	import mx.managers.FocusManager;
	import mx.managers.IFocusManagerComponent;

	/////////////////////////////////////////////////
	// EVENTS
	/////////////////////////////////////////////////
	/**
	 * Dispatched when the <code>selectedDate</code> is changed by the user. More specifically
	 * when the <code>update()</code> function is called to set the value of the <code>selectedDate</code>
	 * property to the values of the UI controls. This event is <b>not</b> dispatched when
	 * the <code>selectedDate</code> property is changed programatically.
	 *  
	 * @eventType flash.events.Event
	 */
	[Event(name="change",type="flash.events.Event")]
	
	/**
	 * <p>
	 * Allows user to input a time and date. Used in conjuction with the Date object.
	 * The relevant property for this control is the <code>selectedDate</b> property.
	 * In this version, you can hide the seconds control by setting the 
	 * <code>showSeconds</code> property to false. 
	 * </p>
	 * 
	 * <p>
	 * This control can be used as a drop-in itemEditor or itemRenderer.
	 * </p>
	 *
	 * @see dslib.controls.NumericInput
	 */
	public class DateTimePicker 
		extends HBox 
		implements IListItemRenderer,IDropInListItemRenderer,IDataRenderer,IFocusManagerComponent {
		
		///////////////////////////////
		// CONSTANTS
		///////////////////////////////
		/**
		 * Contains constants for meridians (AM, PM)
		 */
		private const meridians:Array = [{text:"am"},{text:"pm"}];
		
		//////////////////////////////
		// ATTRIBUTES
		//////////////////////////////
		
			
		//Date Controls
		/**
		 * Controls the calendar date.
		 */
		private var dateField:DateField;
		
		//Time Controls		
		/**
		 * Controls the hour in the day.
		 */
		private var hoursInput:NumericInput;
		/**
		 * Controls the minute in the day.
		 */
		private var minutesInput:NumericInput;
		/**
		 * Controls the second in the day.
		 */
		private var secondsInput:NumericInput;
		/**
		 * Controls the meridian of the day.
		 */
		private var meridianInput:TextInput;
		/**
		 * The HBox which contains the time controls.
		 */
		private var timeHBox:HBox;
		
		/**
		 * NumericStepper which controls the values of the of time controls.
		 */
		private var stepper:NumericStepper;
		/**
		 * The control which current has focus.
		 */
		private var currentFocus:Object;
	
		////////////////////////////////////////////////////
		// _selectedDate
		////////////////////////////////////////////////////
		private var _selectedDate:Date;
		
		[Bindable]
		/**
		 * Read/Write property of the selectedDate attribute.
		 * This property contains the time values of the controls
		 * as well as the date.
		 * 
		 */
		public function get selectedDate():Date {
			return this._selectedDate;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */		
		public function set selectedDate(value:Date):void {
			this._selectedDate = value;
			refresh();
		}
		
		
		////////////////////////////////////////////////////
		// _showSeconds
		////////////////////////////////////////////////////
		/**
		 * Whether not to show the input for seconds.
		 */
		private var _showSeconds:Boolean = false;
		
		[Bindable]
		/**
		 * You define whether or not to allow the user to control the seconds 
		 * by setting this property to true or false.
		 * 
		 * @return Boolean
		 * 
		 */
		public function get showSeconds():Boolean {
			return this._showSeconds;
		}
		
		/**
		 *
		 * @public
		 *  
		 */		
		public function set showSeconds(value:Boolean):void {
			
			this._showSeconds = value;
			if(value) {
				
				if(!timeHBox.owns(secondsInput)) {
					
					var label:Label = new Label();
					label.setStyle("paddingRight", 0);
					label.setStyle("paddingTop", 0);
					label.setStyle("paddingLeft", 0);
					label.setStyle("paddingBottom", 0);
					label.text = ":";
					label.width = 10;
					label.percentHeight = 100;
					timeHBox.addChildAt(label,3);
					timeHBox.addChildAt(secondsInput,4);
					
				}
			} else {
				
				if(timeHBox.getChildIndex(secondsInput)	> -1) {
					timeHBox.removeChild(secondsInput);
					timeHBox.removeChildAt(3);
				}
				
			}
		}
		
		///////////////////////////////////////////////////
		// Implements IDataRenderer Interface
		///////////////////////////////////////////////////
	
	    /**
	     *  @private
	     *  Storage for the data property
	     */
	    private var _data:Object;
	
	    [Bindable("dataChange")]
	    [Inspectable(environment="none")]
	
	    /**
	     *  The <code>data</code> property lets you pass a value
	     *  to the component when you use it in an item renderer or item editor.
	     *  You typically use data binding to bind a field of the <code>data</code>
	     *  property to a property of this component.
	     *
	     *  <p>When you use the control as a drop-in item renderer or drop-in
	     *  item editor, Flex automatically writes the current value of the item
	     *  to the <code>selectedDate</code> property of this control.</p>
	     *
	     *  @default null
	     *  @see mx.core.IDataRenderer
	     */
	    override public function get data():Object {
	        return _data;
	    }
	
	    /**
	     *  @private
	     */
	    override public function set data(value:Object):void {
	        var dataItem:Object;
			
	        _data = value;
	
	        if (_listData && _listData is DataGridListData) {
	        	dataItem = _data[DataGridListData(_listData).dataField];
	        } else if (_listData is ListData && ListData(_listData).labelField in _data) {
	            dataItem = _data[ListData(_listData).labelField];
	        } else if (_data is String) {
	            dataItem = new Date(Date.parse(data as String));	
	        } else {
	        	dataItem = _data;
	        }
	
	        if (dataItem is Date) {
	            selectedDate = dataItem as Date;
	        } else if (dataItem is String) {
	        	selectedDate = new Date(Date.parse(dataItem));
	        } else {
	        	selectedDate = new Date();
	        }
	
	        dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
	    }
		
		///////////////////////////////////////////////////
		// Implements IDropInListItemRenderer Interface
		///////////////////////////////////////////////////
		/**
		 * Attribute which implements the IDropInListItemRenderer Interface 
		 */
		private var _listData:BaseListData;
		
		[Bindable("dataChange")]
    	[Inspectable(environment="none")]
		/**
	     *  When a component is used as a drop-in item renderer or drop-in
	     *  item editor, Flex initializes the <code>listData</code> property
	     *  of the component with the appropriate data from the list control.
	     *  The component can then use the <code>listData</code> property
	     *  to initialize the <code>data</code> property of the drop-in
	     *  item renderer or drop-in item editor.
	     *
	     *  <p>You do not set this property in MXML or ActionScript;
	     *  Flex sets it when the component is used as a drop-in item renderer
	     *  or drop-in item editor.</p>
	     *
	     *  @default null
	     *  @see mx.controls.listClasses.IDropInListItemRenderer
	     */
	    public function get listData():BaseListData {
	        return _listData;
	    }	
	    /**
	     *  @private
	     */
	    public function set listData(value:BaseListData):void {
	        _listData = value;
	    }
		
		///////////////////////////////////////////
		// Constructor
		///////////////////////////////////////////
		/**
		 * Default constructor.
		 * Adds child controls to the instance of the DateTimePicker control.
		 */
		public function DateTimePicker() {
			super();
			this.horizontalScrollPolicy = "off";
			setStyle("horizontalGap",0);
			createControls();
			selectedDate = new Date();
		}
		
		
		/////////////////////////////////////////////////////////////////////////////
		// PUBLIC FUNCTIONS
		/////////////////////////////////////////////////////////////////////////////
		
		/**
		 * <p>
		 * Updates the UI controls using the current value of the selectedDate property.
		 * </p>
		 * <p>
		 * NOTE: This is simply used to update the date and time values visually for the user. 
		 * This function does not update the underlying date value. See update() function.
		 * </p>
		 */
		public function refresh( ):void {
			this.dateField.selectedDate = this.selectedDate;
			if(this.selectedDate.getHours( ) > 12) {
				this.hoursInput.value  = this.selectedDate.getHours() - 12;
			} else {
				this.hoursInput.value = (this.selectedDate.getHours() == 0) ? 12 : this.selectedDate.getHours();
			}
			this.minutesInput.value   = this.selectedDate.getMinutes();
			this.secondsInput.value   = this.selectedDate.getSeconds();
			this.meridianInput.text = (this.selectedDate.getHours() < 12) ? meridians[0].text : meridians[1].text;
		}
		
		
		/////////////////////////////////////////////////////////////////////////
		// PRIVATE FUNCTIONS
		/////////////////////////////////////////////////////////////////////////
		/**
		 * <p>
		 * Updates the current value of the selectedDate property using the
		 * values of the UI controls.
		 * </p>
		 * <p>
		 * This function is an event handler for the change event of all the controls
		 * in the DateTimePicker control.
		 * </p>
		 * <p>
		 * NOTE: This function is used to parse the user selected date & time into 
		 * the selectedDate property. It it not used to update the visual controls.
		 * See refresh() function.
		 * </p>
		 * 
		 * @param event flash.events.Event
		 * 
		 * @public
		 */
		private function update(event:Event):void {
			var hour:int = (meridianInput.text == meridians[0].text) ? hoursInput.value : hoursInput.value + 12;
			if(hour == 12 || hour == 24) {
				hour = hour - 12;
			}
			var newDate:Date = new Date();
			newDate.setTime(dateField.selectedDate.getTime());
			newDate.setHours(hour, minutesInput.value,secondsInput.value);
			this.selectedDate = newDate;			
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		
		/**
		 * Creates new instances of the NumericInput, DateField and ComboBox 
		 * and uses them as controls for the current instance of the DateTimePicker 
		 * control.
		 * 
		 * @public
		 */
		private function createControls():void {
			
			////////////////////////////////////////
			//Refactoring needed here badly!!!
			////////////////////////////////////////
			var label:Label = new Label();
			label.setStyle("paddingRight", 0);
			label.setStyle("paddingTop", 0);
			label.setStyle("paddingLeft", 0);
			label.setStyle("paddingBottom", 0);
			label.text = ":";
			label.width = 10;
			label.percentHeight = 100;
			var label2:Label = new Label();
			label2.setStyle("paddingRight", 0);
			label2.setStyle("paddingTop", 0);
			label2.setStyle("paddingLeft", 0);
			label2.setStyle("paddingBottom", 0);
			label2.text = ":";
			label2.width = 10;
			label2.percentHeight = 100;
			
			dateField = new DateField();
			dateField.selectedDate = new Date();
			dateField.percentHeight = 100;
			addChild(dateField);
			dateField.addEventListener(CalendarLayoutChangeEvent.CHANGE,update);
			
			
			timeHBox = new HBox();
			timeHBox.setStyle("horizontalGap",0);
			timeHBox.setStyle("backgroundColor",0xFFFFFF);
			timeHBox.setStyle("borderStyle",'inset');
			timeHBox.setStyle("borderThickness",2);
			timeHBox.setStyle("cornerRadius",10);
			
			timeHBox.height = 20;
			
			addChild(timeHBox);
			
			hoursInput = new NumericInput();
			hoursInput.minValue = 1;
			hoursInput.maxValue = 12;
			hoursInput.setStyle("backgroundAlpha",0);
			hoursInput.setStyle("borderThickness ",0);
			hoursInput.setStyle("borderStyle",'none');
			hoursInput.setStyle("borderSides",'');
			hoursInput.setStyle("textAlign",'right');
			hoursInput.setStyle("paddingRight", 0);
			hoursInput.setStyle("paddingTop", 0);
			hoursInput.setStyle("paddingLeft", 0);
			hoursInput.setStyle("paddingBottom", 0);
			hoursInput.width = 20;
			hoursInput.percentHeight = 100;
			hoursInput.addEventListener(NumericInput.VALUE_CHANGE,update);
			hoursInput.addEventListener(FocusEvent.FOCUS_IN,selectText);
			timeHBox.addChild(hoursInput);
			
			timeHBox.addChild(label);
			
			minutesInput = new NumericInput();
			minutesInput.minValue = 0;
			minutesInput.maxValue = 59;
			minutesInput.showLeadingZeros = true;
			minutesInput.setStyle("backgroundAlpha",0);
			minutesInput.setStyle("borderThickness ",0);
			minutesInput.setStyle("borderStyle",'none');
			minutesInput.setStyle("borderSides",'');
			minutesInput.setStyle("textAlign",'right');
			minutesInput.setStyle("paddingRight", 0);
			minutesInput.setStyle("paddingTop", 0);
			minutesInput.setStyle("paddingLeft", 0);
			minutesInput.setStyle("paddingBottom", 0);
			minutesInput.width = 20;
			minutesInput.percentHeight = 100;
			minutesInput.addEventListener(NumericInput.VALUE_CHANGE,update);
			minutesInput.addEventListener(FocusEvent.FOCUS_IN,selectText);
			timeHBox.addChild(minutesInput);
			
			if(showSeconds) {
				timeHBox.addChild(label2);
			}
			
			secondsInput = new NumericInput();
			secondsInput.minValue = 0;
			secondsInput.maxValue = 59;
			secondsInput.showLeadingZeros = true;
			secondsInput.setStyle("backgroundAlpha",0);
			secondsInput.setStyle("borderThickness ",0);
			secondsInput.setStyle("borderStyle","none");
			secondsInput.setStyle("borderSides",'');
			secondsInput.setStyle("textAlign",'right');
			secondsInput.setStyle("paddingRight", 0);
			secondsInput.setStyle("paddingTop", 0);
			secondsInput.setStyle("paddingLeft", 0);
			secondsInput.setStyle("paddingBottom", 0);
			secondsInput.width = 20;
			secondsInput.percentHeight = 100;
			secondsInput.addEventListener(NumericInput.VALUE_CHANGE,update);
			secondsInput.addEventListener(FocusEvent.FOCUS_IN,selectText);
			if(showSeconds) {
				timeHBox.addChild(secondsInput);
			}
						
			meridianInput = new TextInput();
			meridianInput.editable = false;
			meridianInput.setStyle("backgroundAlpha",0);
			meridianInput.setStyle("borderThickness ",0);
			meridianInput.setStyle("borderStyle","none");
			meridianInput.setStyle("borderSides",'');
			meridianInput.setStyle("textAlign",'right');
			meridianInput.width = 25;
			meridianInput.percentHeight = 100;
			meridianInput.addEventListener(FocusEvent.FOCUS_IN,selectText);
			meridianInput.addEventListener(FlexEvent.VALUE_COMMIT,update);
			timeHBox.addChild(meridianInput);
			
			stepper = new NumericStepper();
			stepper.minimum = 100;
			stepper.maximum = 100;
			stepper.width = 19;
			stepper.addEventListener(NumericStepperEvent.CHANGE,handleStepperChange);
				
			addChild(stepper);
			
		}
		
		/**
		 * Selects the text inside the controls and sets the currentFocus property
		 * to the events currentTarget property.
		 * If the target is not the meridianInput property the stepper property value, 
		 * minimum and maximum are set to the targets respective values.
		 * @param event - flash.events.Event
		 * 
		 * @public
		 */		
		private function selectText(event:Event):void {
			var input:Object = event.currentTarget;
			input.setSelection(0,input.text.length);
			currentFocus = event.currentTarget;
			if(currentFocus != meridianInput) {
				stepper.value = currentFocus.value;
				stepper.minimum = currentFocus.minValue;
				stepper.maximum = currentFocus.maxValue;
			} else {
				stepper.value = 0;
				stepper.minimum = -10;
				stepper.maximum = 10;
			}
		}
		
	
		/**
		 * Handles the change event of the stepper component. When a time component
		 * gets the focus. The min,max and value properties of the NumericStepper
		 * are set to the respective values of the componenet with focus.
		 * When the value of the NumericStepper changes, the value will reflect
		 * the next or previous value of the component with focus, and the value
		 * of that componenet will be changed to the value of the NumericStepper
		 * and the component will broadcast its own change event.
		 * 
		 * @param event:NumericStepperEvent
		 * 
		 * @public
		 */		
		private function handleStepperChange(event:NumericStepperEvent):void {
			if(currentFocus != meridianInput) {
				currentFocus.value = stepper.value;
				currentFocus.dispatchEvent(new Event(NumericInput.VALUE_CHANGE));
			} else {
				currentFocus.text = (currentFocus.text == meridians[0].text) ? meridians[1].text : meridians[0].text;
				stepper.value = 0;
			}
		}
		
	}
}