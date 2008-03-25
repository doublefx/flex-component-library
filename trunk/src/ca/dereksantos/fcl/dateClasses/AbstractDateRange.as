package ca.dereksantos.fcl.dateClasses {
	
	import ca.dereksantos.fcl.util.DateUtil;
	
	import mx.collections.ArrayCollection;

	/**
	 * 
	 * @author derek
	 * 
	 */	
	internal class AbstractDateRange extends ArrayCollection implements IDateRange {
		
		//------------------------------------------------------------------------------
		// _initialDate attribute
		//------------------------------------------------------------------------------
		private var _initialDate:Date;
		
		/**
		 * <p>
	 	 * The <code>initialDate</code> property is used to provide the <code>IDateRange<code> with a date to calculate the range with.
	 	 * If for example the range represents a week, then the <code>initialDate</code> would be used to determine the sunday and saturday of 
	 	 * the week. 
	 	 * </p>
	 	 *  
		 * @param value
		 * 
		 */	
		public function get initialDate():Date { return _initialDate; }
		public function set initialDate(value:Date):void {
			_initialDate = value;
			calculate( );
		}
		
		/**
		 * Read-only
		 * 
		 * <p>
		 * The <code>startDate</code> property will return the first date in the range.
		 * </p>
		 * 
		 * @return Date 
		 * 
		 */		
		public function get startDate( ):Date {return getItemAt(0) as Date;}
		
		/**
		 * Read-only
		 * 
		 * <p>
		 * The <code>endDate</code> property will return the last date in the range.
		 * </p>
		 * 
		 * @return Date 
		 * 
		 */		
		public function get endDate( ):Date {return getItemAt( length - 1 ) as Date;}
		
		//------------------------------------------------------------------------------
		//	Constructor.
		//------------------------------------------------------------------------------
		
		/**
		 * Constructor.
		 */
		public function AbstractDateRange( date:Date ) {
			initialDate = DateUtil.cloneDate( date );
		}
	
		/**
		 * Determines the Dates in the range using the <code>initialDate</code> property. 
		 * 
		 */
		public function calculate( ):void { }
		
		/**
		 * <p>
		 * Returns an associative array in the format <br/> 
		 * <code> [ { rangeStart : Date , rangeEnd : Date } ] </code>
		 * </p>
		 * 
		 * <p> This function is used to create an array that complies with the <code>selectedRanges</code> 
		 * property of the <code>DateChooser</code> control.
		 * </p>
		 * 
		 * @return Array
		 * 
		 */		
		public function toStartEndArray( ):Array {
			return [ { rangeStart: getItemAt( 0 ) as Date, rangeEnd : getItemAt( length -1 ) as Date } ];
		}
	}
}