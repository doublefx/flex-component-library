package ca.dereksantos.fcl.dateClasses {
	
	
	import ca.dereksantos.fcl.controls.NumericInput;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.FocusEvent;
	
	import mx.containers.HBox;
	import mx.controls.Label;
	import mx.controls.NumericStepper;
	import mx.controls.TextInput;
	import mx.core.IUIComponent;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.events.NumericStepperEvent;
	import mx.styles.CSSStyleDeclaration;
	import mx.styles.StyleManager;
	
	//-------------------------------------------------------
	// Events	
	//-------------------------------------------------------
	
	/**
     * Dispatched when the <code>value</code> property is updated through the UI by the user.
     * Setting the <code>value</code> property programatically will not dispatch this event.
     * 
     * @type flash.events.Event
     *  
	 */	
	[Event(name="change", type="flash.events.Event")]
	
	
	//-------------------------------------------------------
	// Styles	
	//-------------------------------------------------------
	
	/**
	 * The selectedBackgroundColor is applied to the Input control which is currently in focus.
	 * 
	 * @default 0x7FCDFE
	 * @type uint
	 */
	[Style(name="selectedBackgroundColor", type="uint", format="Color", inherit="no")]
	
	
	/**
	 * The <code>TimePickerBase</code> servers as a component which should be subclassed to create TimePicker controls.
	 * The <code>TimePickerBase</code> is subclassed by the <code>TimePicker</code> control.
	 * 
	 * @see ca.dereksantos.fcl.control.TimePicker
	 * @see ca.dereksantos.fcl.control.DateTimePicker
	 * 
	 * @author derek
	 * 
	 */	
	public class TimePickerBase extends HBox {
		
		//----------------------------------------------------------------
		//Constants
		//----------------------------------------------------------------
		
		//Holds the labels for the AM and PM meridians.
		private static const MERIDIANS:Array = [{label:"am"},{label:"pm"}];

		/**
		 * Returns the label for the AM meridian.
		 *  
		 * @return String
		 */		
		public function get am( ):String { return MERIDIANS[0].label; }
		/**
		 * Returns the label for the PM meridian.
		 *  
		 * @return String
		 */		
		public function get pm( ):String { return MERIDIANS[1].label; }
		
		//----------------------------------------------------------------
		//Attributes
		//----------------------------------------------------------------
		protected var hoursInput:NumericInput;		//Holds the NumericInput control for selecting the hour.
		protected var minutesInput:NumericInput;	//Holds the NumericInput control for selecting the minute.
		protected var secondsInput:NumericInput;	//Holds the NumericInput control for selecting the second.
		protected var meridianInput:TextInput;		//Holds the TextInput control for selecting the minute.
		protected var stepper:NumericStepper;		//Holds the NumericStepper control for incrementing the value of hours,minutes,seconds or meridians.
		
		
		//----------------------------------------------------------------
		// classContruct 
		//----------------------------------------------------------------
		private var backgroundColor:uint;
		private var selectedBackgroundColor:uint;
		
        private static var classConstructed:Boolean = classConstruct( );
    	
        /**
         * The classConstruct method is used to apply default style values to the Component.
         * The classConstruct will be called only once the first time the class is instantiated.
         * 
         * @return Boolean 
         * 
         */    	
        private static function classConstruct( ):Boolean {
            if (!StyleManager.getStyleDeclaration("TimePickerBase"))
            {
                // If there is no CSS definition for TimePicker, 
                // then create one and set the default value.
                var defaultStyle:CSSStyleDeclaration = new CSSStyleDeclaration();
                defaultStyle.defaultFactory = function():void
                {
                    this.backgroundColor = 0xFFFFFF;
                    this.selectedBackgroundColor = 0x7FCDFE;
                }
                StyleManager.setStyleDeclaration("TimePickerBase", defaultStyle, true);
            }
            return true;
        }
		
				
		//-------------------------------------------------------------------
		// _value property
		//-------------------------------------------------------------------
		private var _value:Date;
		
		[Bindable]
		/**
		 * Returns the current Date and Time value of the control.  
		 * 
		 * @return Date
		 * 
		 */		
		public function get value( ):Date {	return _value; }
		public function set value( pValue:Date ):void {
			_value = pValue;
			invalidateDisplayList( );
		}
		
		//--------------------------------------------------------------------
		// _currentInputFocus property.
		//--------------------------------------------------------------------
		private var _currentInputFocus:Object;
		
		/**
		 * Returns the current control that has focus. Used to give the stepper a control to act upon,
		 * and to apply selection styling.
		 * 
		 * @return Object 
		 * 
		 */		
		protected function getCurrentInputFocus( ):Object { return _currentInputFocus; }
		protected function setCurrentInputFocus( value:Object ):void { 
			_currentInputFocus = value; 
			invalidateDisplayList( );
		}
		
		
		
		//--------------------------------------------------------------------
		// Constructor.
		//--------------------------------------------------------------------
		public function TimePickerBase() {
			super( );
			setStyle("horizontalGap", 0);
		}
		
		
		
		
		/**
		 * <p>
		 * The <code>commitProperties()</code> method will update the neccessary properties
		 * with the values from the UI.
		 * </p>
		 * <p>
		 * This will get called by the Flex Invalidation system by queueing it with the <code>invalidateProperties( )</code> method.
		 * </p>
		 */		
		override protected function commitProperties( ):void {
			super.commitProperties( );
			
			//Make sure the value property is not null.
			if(!value)
				value = new Date( );
				
			var hour:Number = hoursInput.value;
			
			if(hour == 12 && meridianInput.text == am) { 
				hour = 0;
			} else if ( hour >= 1 && hour < 12 && meridianInput.text == pm ) {
				hour = hour + 12;
			}
			
			value.setHours( hour, minutesInput.value, secondsInput.value );
			
		 	dispatchEvent( new Event( Event.CHANGE ) );
				
		}
		
		/**
		 * <p>
		 * The <code>updateDisplayList( )</code> will update the UI with the current values of the component.
		 * </p>
		 * 
		 * <p>
		 * The <code>updateDisplayList( )</code> method will be called by the Flex invalidation system by queueing it with the 
		 * <code>invalidateDisplayList( )</code> method.
		 * </p>
		 * 
		 * @param unscaledWidth
		 * @param unscaledHeight
		 * 
		 */		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			super.updateDisplayList( unscaledWidth, unscaledHeight );
			
			applyStyles( );
			
			if(value) {
					
				/*
					hour = 0
						12:00 AM
					hour > 0 and < 12
						AM Time
					hour >= 12 and < 24
						PM Time
				*/
				var hour:Number = value.getHours( );
				var meridian:String = am;
				if(hour == 0) {
					hour = 12; //12:00 AM
					meridian = am; 
				} else if ( hour > 0 && hour < 12 ) {
					meridian = am; 
				} else if ( hour >= 12 && hour < 24 ) {
					hour -= 12;	
					meridian = pm; 
				}
				
				hoursInput.value = hour;
				minutesInput.value = value.getMinutes( );
				secondsInput.value = value.getSeconds( );
				meridianInput.text = meridian;
			}
			
		}


		/**
		 * <p>
		 * Creates the controls for selecting the hours, minutes, seconds and meridian. A stepper control is also created to control the values
		 * of the component.
		 * </p>
		 * 
		 * <p>
		 * The <code>createChildren()</code> is automatically called by Flex when the <code>addChild( )</code> is called on the component.
		 * </p>
		 * 
		 */				
		override protected function createChildren( ):void {
		
			if(!hoursInput) {
				hoursInput 		= createTimeInput( 1, 12 ) as NumericInput;
			}
			
			if(!minutesInput) {
				minutesInput 	= createTimeInput( 0, 59 ) as NumericInput;
				minutesInput.showLeadingZeros = true;
			}
			
			if(!secondsInput) {
				secondsInput	= createTimeInput( 0, 59 ) as NumericInput;
				secondsInput.showLeadingZeros = true;
			}	
			
			if(!meridianInput)
				meridianInput 	= createMeridianInput( ) as TextInput;
			
			if(!stepper)
				stepper 		= createStepper( );
			
			
			addChild( DisplayObject( hoursInput ) );
			addChild( DisplayObject( createInputSeperator( ) ) );
			addChild( DisplayObject( minutesInput ) );
			addChild( DisplayObject( createInputSeperator( ) ) );
			addChild( DisplayObject( secondsInput ) );
			addChild( DisplayObject( meridianInput ) );
			addChild( DisplayObject( stepper ) );
			
			
			//After creating children, call createChildren( ) of the superclass to invalidate.
			super.createChildren( );
			
		}
		
			
			
		
		
		/**
		 * This method will create a label with the text ":" to denote a delimiter in the Time. 
		 * 
		 * @return 
		 * 
		 */		
		protected function createInputSeperator( ):IUIComponent {
			var label:Label = new Label();
			label.setStyle("paddingRight", 0);
			label.setStyle("paddingTop", 0);
			label.setStyle("paddingLeft", 0);
			label.setStyle("paddingBottom", 0);
			label.text = ":";
			label.width = 10;
			label.percentHeight = 100;
			return label;
		}
		
		/**
		 * The <code>createTimeInput( )</code> method will create a <code>NumericInput</code> control
		 * for modifying the value of the hours, minutes or seconds in the time.
		 * 
		 * @param min
		 * @param max
		 * @return IUIComponent
		 * 
		 */		
		protected function createTimeInput( min:int, max:int ):IUIComponent {
			var input:NumericInput = new NumericInput();

			input.minValue = min;
			input.maxValue = max;
			input.setStyle("borderThickness ",0);
			input.setStyle("borderStyle",'none');
			input.setStyle("borderSides",'');
			input.setStyle("focusAlpha",0);
			input.setStyle("textAlign",'right');
			input.setStyle("paddingRight", 0);
			input.setStyle("paddingTop", 0);
			input.setStyle("paddingLeft", 0);
			input.setStyle("paddingBottom", 0);
			input.width = 20;
			input.percentHeight = 100;
						
			input.addEventListener(NumericInput.VALUE_CHANGE, valueChangeHandler);
			input.addEventListener(FocusEvent.FOCUS_IN,selectText);
			
			return input;
		}
		
		
		
		/**
		 * The meridian allows the user to toggle between AM or PM.
		 * 
		 * @return TextInput
		 * 
		 */		
		protected function createMeridianInput( ):TextInput {
			var meridianInput:TextInput = new TextInput();
			meridianInput.editable = false;
			meridianInput.setStyle("borderThickness ",0);
			meridianInput.setStyle("borderStyle","none");
			meridianInput.setStyle("borderSides",'');
			meridianInput.setStyle("textAlign",'right');
			meridianInput.width = 25;
			meridianInput.percentHeight = 100;
			meridianInput.addEventListener(FocusEvent.FOCUS_IN,selectText);
			meridianInput.addEventListener(FlexEvent.VALUE_COMMIT, valueChangeHandler);
			return meridianInput;
		}
		
		/**
		 * Creates the stepper control which allows the user to modify the value of a control in the time picker.
		 *  
		 * @return NumericStepper
		 * 
		 */		
		protected function createStepper( ):NumericStepper {
			var stepper:NumericStepper = new NumericStepper();
			stepper.minimum = 100;
			stepper.maximum = 100;
			stepper.width = 18;
			stepper.addEventListener(NumericStepperEvent.CHANGE,handleStepperChange);
			return stepper;
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
			if(getCurrentInputFocus( ) != meridianInput) {
				getCurrentInputFocus( ).value = stepper.value;
				getCurrentInputFocus( ).dispatchEvent(new Event(NumericInput.VALUE_CHANGE));
			} else {
				getCurrentInputFocus( ).text = (getCurrentInputFocus( ).text == am) ? pm : am;
				stepper.value = 0;
			}
		}
		
		/**
		 * Selects the text inside the controls and sets the <code>currentInputFocus</code> property
		 * to the events currentTarget property.
		 * If the target is not the meridianInput property the stepper property value, 
		 * minimum and maximum are set to the targets respective values.
		 * 
		 * @param event - flash.events.Event
		 * 
		 */		
		protected function selectText(event:Event):void {
			var input:Object = event.currentTarget;
			input.setSelection(0,input.text.length);
			setCurrentInputFocus( event.currentTarget );
			if(getCurrentInputFocus( ) != meridianInput) {
				stepper.value = getCurrentInputFocus( ).value;
				stepper.minimum = getCurrentInputFocus( ).minValue;
				stepper.maximum = getCurrentInputFocus( ).maxValue;
			} else {
				stepper.value = 0;
				stepper.minimum = -10;
				stepper.maximum = 10;
			}
		}
		
		
		/**
		 * Handles the <code>valueChange</code> event of an input control.
		 * 
		 * @param event
		 * 
		 */		
		private function valueChangeHandler( event:Event ):void {
			invalidateProperties( );
		}
		
		
		/**
		 * Applies all styling attributes to the children of the TimePickerBase control. 
		 * 
		 */		
		protected function applyStyles( ):void {
			applyInputBackground( hoursInput );
			applyInputBackground( minutesInput );
			applyInputBackground( secondsInput );	
			applyInputBackground( meridianInput	);
			
			if( getCurrentInputFocus( ) )
				applySelectionBackground( getCurrentInputFocus( ) as UIComponent );
		}	
		
		/**
		 * Applies the <code>inputBackgroundColor</code> style to a component.
		 *   
		 * @param target - The UIComponent to apply the background too.
		 * 
		 */	
		protected function applyInputBackground( target:UIComponent ):void {
			target.setStyle( "backgroundColor", getStyle("inputBackgroundColor") );
		}
		
		/**
		 * Applies the <code>selectedBackgroundColor</code> style to a component.
		 *   
		 * @param target - The UIComponent to apply the background too.
		 * 
		 */		
		protected function applySelectionBackground( target:UIComponent):void {
			target.setStyle( "backgroundColor", getStyle("selectedBackgroundColor") );
		}
		
	}
}