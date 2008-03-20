package ca.dereksantos.fcl.events{
	import ca.dereksantos.fcl.dateClasses.AbstractDateRange;
	import ca.dereksantos.fcl.dateClasses.IDateRange;
	
	import flash.events.Event;
	
	
	/**
	 * Event class used to dispatch dateRangeChange events. 
	 * 
	 * @author derek
	 * 
	 */	
	public class DateRangeChangeEvent extends Event {
		
		public static const EVENT_DATA_RANGE_CHANGE:String = "dateRangeChange";
		
		/**
		 * Holds the previous date range.
		 */		
		public var oldRange:IDateRange;
		
		/**
		 * Holds the new date range.
		 */		
		public var newRange:IDateRange;
		
		/**
		 * Constructor.
		 * 
		 * @param pOldRange
		 * @param pNewRange
		 * @param type
		 * 
		 */		
		public function DateRangeChangeEvent( pOldRange:IDateRange, pNewRange:IDateRange, type:String ) {
			super( type );
			
			oldRange = pOldRange;
			newRange = pNewRange;
		}
		
		/**
		 * Override the clone method to support event bubbling.
		 * 
		 * @return Event 
		 * 
		 */		
		override public function clone():Event {
			return new DateRangeChangeEvent( oldRange, newRange, type );
		}
			
	}
}