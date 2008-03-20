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
	import ca.dereksantos.fcl.dateClasses.RangeType;
	import ca.dereksantos.fcl.dateClasses.Week;
	import ca.dereksantos.fcl.events.DateRangeChangeEvent;
	
	import mx.controls.Button;
	import mx.controls.DateChooser;
	import mx.core.UIComponent;
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
		 * @default day
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
			if( comparator.compare( selectedDate, selectedRange.startDate ) == -1 || comparator.compare( selectedDate, selectedRange.endDate ) 	==  1 ) {
			    return true;
			}
			return false;
		}
		
		
		
		//----------------------------------------------------------------
		// Constructor.
		//----------------------------------------------------------------
		
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
				//This value must be captured before creating the new range or it will not be accurate.
				var isChanged:Boolean = isOutsideRange;
					
				switch(rangeType) {
					case Week.WEEK:
						selectedRange = new Week( selectedDate );
						break;
					case Month.MONTH:
						selectedRange = new Month( selectedDate );
						break;
				}
				//Once the new range has been created, dispatch the dateRangeChange event if the range has been changed.
				if( isChanged ) {
					var event:DateRangeChangeEvent = new DateRangeChangeEvent( oldRange , selectedRange , DateRangeChangeEvent.EVENT_DATA_RANGE_CHANGE );
					dispatchEvent(event);
				}
			}
		}
		
		
		
		
		override protected function createChildren( ):void {
			super.createChildren( );
			
			graphics.beginFill( 0xFF0000 );
			graphics.drawRect( x , y , 300, 300);

//			var comp:UIComponent = new UIComponent();
//			comp.width = width;
//			comp.height = height;
//			comp.x = 0;
//			comp.y = 0;
//			comp.graphics.beginFill( 0x000000, 1 );
//			comp.graphics.drawRect( comp.x, comp.y, comp.width, comp.height );
//			
//			addChild( new Button( ) );
//			
//			invalidateDisplayList( );
//			updateDisplayList( unscaledWidth, unscaledHeight );
//			
		}
		
		
		
		
		
		
		
		
		
		
		
		
	}
}