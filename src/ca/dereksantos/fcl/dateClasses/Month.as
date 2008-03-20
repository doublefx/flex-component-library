package ca.dereksantos.fcl.dateClasses {
	import ca.dereksantos.fcl.util.DateUtil;
	
	
	public class Month extends AbstractDateRange {
		
		public static const MONTH:String = "month";
		
		private var numDays:Number = 0;
		
		override public function set initialDate(value:Date):void {
			var date:Date = DateUtil.cloneDate( value );
			date.setMonth( date.getMonth( ) + 1, 1 );
			date.setHours( 0, 0, 0, 0 );
			date.setTime( date.getTime( ) - DateUtil.DAY_IN_MILLESECONDS );
			numDays = date.getDate( );

			super.initialDate = value;
		}
		
		
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
			date.setDate( numDays ); 
			return date;
		}
		
		
		/**
		 * Constructor.
		 * 
		 * @param date - The date to calculate the month for.
		 * 
		 */		
		public function Month( date:Date ) {
			super();
			initialDate = DateUtil.cloneDate( date );
		}
		
		
		
		
		/**
		 * @inheritDoc
		 */		
		override public function calculate( ):void {
			super.calculate( );
			
			var date:Date;
			for( var i:int = 0; i < numDays; i++ ) {
				date = DateUtil.cloneDate( startDate );
				date.setDate(date.getDate( ) + i);				
				addItem(date);			
			}
			
		}
		
		
	}
}