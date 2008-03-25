package ca.dereksantos.fcl.dateClasses {
	import ca.dereksantos.fcl.util.DateUtil;
	
	
	public class Month extends AbstractDateRange {
		
		public static const MONTH:String = "month";
		
		/**
		 * Read-only calculated property.
		 * 
		 * Returns a Date object reperesenting the first day of the month.
		 * 
		 * @return Date
		 * 
		 */		
		override public function get startDate():Date {
			var date:Date = DateUtil.cloneDate( initialDate );
			date.setDate( 1 );
			return date;
		}

		/**
		 * Read-only calculated property.
		 * 
		 * Returns a Date object representing the last day of the month.
		 * 
		 * @return Date 
		 * 
		 */		
		override public function get endDate():Date {
			var date:Date = DateUtil.cloneDate( initialDate );
			date.setDate( numberOfDays ); 
			return date;
		}
		
		/**
		 * Read-only
		 * 
		 * Returns the number of days in the month.
		 * 
		 * @return int 
		 * 
		 */		
		public function get numberOfDays( ):int {
			var date:Date = DateUtil.cloneDate( initialDate );
			date.setMonth( date.getMonth( ) + 1, 1 );
			date.setHours( 0, 0, 0, 0 );
			date.setTime( date.getTime( ) - DateUtil.DAY_IN_MILLESECONDS );
			return date.getDate( );
		}
		
		
		/**
		 * Constructor.
		 * 
		 * @param date - The date to calculate the month for.
		 * 
		 */		
		public function Month( date:Date ) {
			super( date );
		}
		
		
		
		
		/**
		 * @inheritDoc
		 */		
		override public function calculate( ):void {
			super.calculate( );
			
			var date:Date;
			for( var i:int = 0; i < numberOfDays; i++ ) {
				date = DateUtil.cloneDate( startDate );
				date.setDate(date.getDate( ) + i);				
				addItem(date);			
			}
		}
		
		
	}
}