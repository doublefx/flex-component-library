package ca.dereksantos.fcl.controls {
	import flash.events.Event;
	
	import mx.controls.DateField;
	import mx.core.UIComponent;
	import mx.events.CalendarLayoutChangeEvent;
	
	/**
	 * The <code>DateTimePicker</code> control is used to allow the user to input a Date and Time.
	 *  
	 * @author derek
	 * @see ca.dereksantos.fcl.controls.TimePicker
	 */	
	public class DateTimePicker extends TimePicker {
		
		//----------------------------------------------------
		// _showDateField
		//----------------------------------------------------
		private var _showDateField:Boolean = true;
		
		/**
		 * Determines whether or not to display a DateField UIComponent as part of the DateTimePicker.
		 * 
		 * @return 
		 * 
		 */		
		public function get showDateField( ):Boolean { return _showDateField; }
		public function set showDateField( value:Boolean ):void {
			_showDateField = value;
			invalidateDisplayList();
		}
		
		//Attributes
		private var dateField:DateField;
		
		
		//----------------------------------------------------
		// Constructor.
		//----------------------------------------------------
		
		/**
		 * Constructor. 
		 * 
		 */		
		public function DateTimePicker( ) {
			super( );
			value = new Date();
		}
		
		
		/**
		 * Updates the UI display.
		 * 
		 * @param unscaledWidth
		 * @param unscaledHeight
		 * 
		 */		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			super.updateDisplayList( unscaledWidth, unscaledHeight );
			updateDateFieldDisplay( );
		}
		
		/**
		 * @inheritDoc
		 */		
		override protected function createChildren( ):void {
			dateField = createDateField( );
			
			super.createChildren( );
		}
		
		/**
		 * Creates a <code>DateField</code> control.
		 * 
		 * @return DateField
		 * 
		 */		
		protected function createDateField( ):DateField {
			var df:DateField = new DateField( );
			df.selectedDate = value;
			df.addEventListener(CalendarLayoutChangeEvent.CHANGE, changeHandler);
			return df;
		}
		
		/**
		 * If the <code>showDateField</code> property is true a <code>DateField</code> control will be added to the component
		 * if it does not already exist.
		 * 
		 */		
		protected function updateDateFieldDisplay( ):void {
			if(dateField) {
				if(showDateField) {
					addDateField( );
				} else {
					removeDateField( );
				}
			}
		}
		
		/**
		 * Adds the DateField control to the display list.
		 * 
		 */		
		protected function addDateField( ):void {
			if( !owns(dateField) ) {
				addChildAt( dateField, 0 );
				addChildAt( createSpacer( ), 1 );
			}
		}
		
		/**
		 * Removes the DateField control from the display list.
		 * 
		 */		
		protected function removeDateField( ):void {
			if( owns( dateField ) ) {
				removeChildAt( getChildIndex( dateField ) + 1 );
				removeChild( dateField );
			}
		}
		
		/**
		 * Creates a spacing component to seperate the DateField from the remaining controls.
		 * 
		 * @return UIComponent
		 * 
		 */		
		protected function createSpacer( ):UIComponent {
			var spacer:UIComponent = new UIComponent( );
			spacer.width = 15;
			return spacer;
		}
		
		
		/**
		 * Handles the change event of the DateField control.
		 * 
		 * @param event
		 * 
		 */		
		protected function changeHandler( event:CalendarLayoutChangeEvent ):void {
			value.setFullYear( event.newDate.getFullYear( ), event.newDate.getMonth( ), event.newDate.getDate( ) );
			dispatchEvent( new Event( Event.CHANGE ) );
		}
		
	}
}