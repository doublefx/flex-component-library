/*
	(c) Copyright Derek Santos 
	www.dereksantos.ca
	
	Flex Component Library
	http://code.google.com/p/flex-component-library/
	
	



*/
package ca.dereksantos.fcl.controls {
	
	import ca.dereksantos.fcl.dateClasses.DateComparator;
	import ca.dereksantos.fcl.dateClasses.IDateRange;
	import ca.dereksantos.fcl.dateClasses.Month;
	import ca.dereksantos.fcl.dateClasses.Week;
	import ca.dereksantos.fcl.events.DateRangeChangeEvent;
	
	import mx.controls.DateChooser;
	import mx.events.CalendarLayoutChangeEvent;
	
	//---------------------------------------------------------
	// EVENTS
	//---------------------------------------------------------
	
	/**
	 *  Dispatched when the change event of the super class is dispatched and
	 *  the <code>selectedDate</code> property is changed to a date which falls in a different 
	 *  range.
	 *
	 *  @eventType ca.dereksantos.fcl.events.DateRangeChangeEvent
	 */
	[Event(name="dateRangeChange", type="ca.dereksantos.fcl.events.DateRangeChangeEvent")]
	
	/**
	 * <p>
	 * You use the <code>DateRangeChooser</code> to allow the user to select a range of dates using a DateChooser control.
	 * The range that is selected is based on the <code>rangeType</code> property. The default range type is <i>day</i> in which
	 * case the <code>DateRangeChooser</code> acts similar to the Flex DateChooser control.
	 * </p>
	 * 
	 * <p>
	 * Syntax: <br/>
	 * 
	 * <code> &lt;fcl:DateRangeChooser rangeType="<i>[rangeType]</i>" /&gt; </code>
	 * </p>
	 * 
	 * @author derek
	 * @see mx.controls.DateChooser
	 * @see ca.dereksantos.fcl.dateClasses.IDateRange
	 */	
	public class DateRangeChooser extends DateChooser {
		
		//------------------------------------------------------------------
		// Constants
		//------------------------------------------------------------------
		private static const DEFAULT_RANGE_TYPE:String = 'day';
		
		
		//------------------------------------------------------------------
		// _selectedRange property.
		//------------------------------------------------------------------
		private var _selectedRange:IDateRange;
		
		[Bindable]
		/**
		 * <p>
		 * The <code>selectedRange</code> property is used to store the range of dates that the user has selected.
		 * </p>
		 * <p>
		 * This property will also set the </code>selectedRanges</code> property of the <code>DateChooser</code>.
		 * </p>
		 * 
		 * @return IDateRange 
		 * 
		 */		
		public function get selectedRange( ):IDateRange { return _selectedRange; }
		public function set selectedRange( value:IDateRange ):void { 
			_selectedRange = value;
			
			//This will use the property of the DateChooser to select the range of dates.
			if( value != null )				
				selectedRanges = value.toStartEndArray();

		} 
		
		//------------------------------------------------------------------
		// _rangeType property.
		//------------------------------------------------------------------
		private var _rangeType:String = DEFAULT_RANGE_TYPE;
		
		[Bindable]
		[Inspectable(name='Range Type', defaultValue='day', category='Common', enumeration='day,week,month', type='String')]
		/**
		 * <p>
		 * The range type defines how the DateRangeChooser will behave when a date is selected. 
		 * </p>
		 * 
		 * <ul>
		 * 		<li><b>day</b> - One day will be selected at a time.</li>
		 * 		<li><b>week</b> - A full week will be selected at a time.</li>
		 * 		<li><b>month</b> - A full month will be selected at a time.</li>
		 * </ul>
		 * 
		 * @default day
		 * @return String
		 * 
		 */		
		public function get rangeType( ):String {return _rangeType;}
		public function set rangeType( value:String ):void {
			_rangeType = value;
			createRange( );
		}
		
		
		/**
		 * Read-only
		 * 
		 * <p>
		 * Returns true if the current value of the <code>selectedDate</code> propoerty is outside the bounds of the
		 * current value of the <code>selectedRange</code> property.
		 * </p>
		 *  
		 * @return Boolean - Whether or not the <code>selectedDate</code> is outside the <code>selectedRange</code> 
		 * 
		 */		
		public function get isOutsideRange( ):Boolean {
			var comparator:DateComparator = new DateComparator( );
			if( comparator.compare( selectedDate, selectedRange.startDate ) == -1 || comparator.compare( selectedDate, selectedRange.endDate ) 	==  1 )
			    return true;
			    
			return false;
		}
		
		/**
		 * Multiple selection should always be allowed in the DateRangeChooser.
		 * 
		 * @param value
		 * 
		 */		
		override public function set allowMultipleSelection(value:Boolean):void {
			super.allowMultipleSelection = true;
		}
		
		//----------------------------------------------------------------
		// Constructor.
		//----------------------------------------------------------------
		
		/**
		 * Constructor. 
		 * 
		 */		
		public function DateRangeChooser( ) {
			super( );
			
			//Even though the setter function for this property ensures it can never be set to false, the default value may be false.
			//Therefore it needs to be set to true in the constructor.
			this.allowMultipleSelection = true;	
			
			//The range selection is created by handling the change event of the DateChooser, this will give us an initialDate to work with when selecting the range.
			this.addEventListener( CalendarLayoutChangeEvent.CHANGE, handleChange );
			
			//Give the DateRangeChooser a default selectedDate of today.
			selectedDate = new Date( );
		}
		
		/**
		 * <p>
		 * Handles the change of event of the super class.
		 * If the new date falls outside of the current <code>selectedRange</code>,
		 * the <code>selectedRange</code> property recalculated and the 
		 * <code>dateRangeChange</code> event is dispatched.
		 * </p>
		 * 
		 * @param event CalendarLayoutChangeEvent
		 * 
		 */	
		private function handleChange( event:CalendarLayoutChangeEvent ):void {
			updateSelection( );
		}
		
		/**
		 * <p>
		 * Creates the date range using the <code>selectedDate</code> property. 
		 * </p>
		 * 
		 * <p>
		 * This function will dispatch the <code>dateRangeChange</code> event if the new <code>selectedDate</code>
		 * fallse outside the current range.
		 * </p>
		 * 
		 * 
		 */		
		protected function updateSelection( ):void {
			if( selectedRange != null ) {
				
				//Get the value of the range before creating the new range.
				var oldRange:IDateRange = selectedRange;
				//This value must be captured before creating the new range or it will always be false.
				var isChanged:Boolean = isOutsideRange;
				
				createRange( );	
				
				//Once the new range has been created, dispatch the dateRangeChange event if the range has been changed.
				if( isChanged ) {
					var event:DateRangeChangeEvent = new DateRangeChangeEvent( oldRange , selectedRange , DateRangeChangeEvent.EVENT_DATA_RANGE_CHANGE );
					dispatchEvent(event);
				}
			}
		}
		
		/**
		 * <p>
		 * Creates a new date range based on the <code>rangeType</code> property. 
		 * </p>
		 * 
		 * <p>
		 * If the rangeType is unknown or not a value which is explicity handled, the <code>clear( )</code> function will be called
		 * to remove any selectedRanges and instruct the control to act as a DateChooser.
		 * </p>
		 */		
		protected function createRange( ):void {
			switch(rangeType) {
				case Week.WEEK:
					selectedRange = new Week( selectedDate );
					break;
				case Month.MONTH:
					selectedRange = new Month( selectedDate );
					break;
				default:
					//Range type is not explicity handled or is unknown. We need to clear the selection in this case.
					clear( );
					break;
			}
		}
		
		/**
		 * <p>
		 * The <code>clear( )</code> function is used to remove any selected ranges and 
		 * set the <code>selectedDate</code> back to the original selection if applicable.
		 * </p>
		 * 
		 */ 
		protected function clear( ):void {
			if(selectedRange != null) {
				selectedDate = selectedRange.initialDate;
				selectedRange = null;
			}
		}
		
	}
}