// http://code.google.com/p/flex-comp-lib/

package ca.dereksantos.fcl.controls {
	
	import ca.dereksantos.fcl.dateClasses.DateComparator;
	import ca.dereksantos.fcl.dateClasses.IDateRange;
	import ca.dereksantos.fcl.dateClasses.Month;
	import ca.dereksantos.fcl.dateClasses.RangeType;
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
	 * TODO:
	 * 
	 *  
	 * @author derek
	 * 
	 */	
	public class DateRangeChooser extends DateChooser {
		
		
		
		
		//------------------------------------------------------------------
		// _selectedRange property.
		//------------------------------------------------------------------
		private var _selectedRange:IDateRange;
		
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
			selectedRanges = value.toStartEndArray();
		} 
		
		//------------------------------------------------------------------
		// _rangeType property.
		//------------------------------------------------------------------
		private var _rangeType:String = RangeType.DAY;
		
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
		 * @return String
		 * 
		 */		
		public function get rangeType( ):String {return _rangeType;}
		public function set rangeType( value:String ):void {
			if(value != _rangeType) {
				switch( value ) {
					case RangeType.WEEK:
						selectedRange = new Week( selectedDate );
						break;
					case RangeType.MONTH:
						selectedRange = new Month( selectedDate );
						break;
				}
			}
			_rangeType = value;
		}
		
		/**
		 * Constructor. 
		 * 
		 */		
		public function DateRangeChooser( ) {
			this.allowMultipleSelection = true;	
			this.allowDisjointSelection = false;
			this.addEventListener( CalendarLayoutChangeEvent.CHANGE, handleChange );
			
			super( );
			
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
		 * 
		 * 
		 */		
		protected function updateSelection( ):void {
			var comparator:DateComparator = new DateComparator( );
			
			if( selectedRange != null ) {
				if( comparator.compare( selectedDate, selectedRange.startDate ) == -1 ||
					comparator.compare( selectedDate, selectedRange.endDate ) == 1 ) {
					
					var oldRange:IDateRange = selectedRange;
					var event:DateRangeChangeEvent;
					
					switch(rangeType) {
						
						case Week.WEEK:
							selectedRange = new Week( selectedDate );
							event = new DateRangeChangeEvent( oldRange , selectedRange , DateRangeChangeEvent.EVENT_DATA_RANGE_CHANGE );
							dispatchEvent(event);
							break;
						case Month.MONTH:
							selectedRange = new Month( selectedDate );
							event = new DateRangeChangeEvent( oldRange , selectedRange , DateRangeChangeEvent.EVENT_DATA_RANGE_CHANGE );
							dispatchEvent(event);
							break;
						default:
							//do nothing if the event type is day.
							break; 
					}
				}
			}
		}
		
		
	}
}