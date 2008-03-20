package ca.dereksantos.fcl.dateClasses {
	
	import ca.dereksantos.fcl.util.DateUtil;
	
	/**
	 * <p>
	 * The Week class is used to represent a week in the year. You can use the Week object to get 
	 * the week number of the year, as well as a Date object for every day of the week.
	 * </p>
	 *  
	 * @author derek
	 * 
	 */	
	public class Week extends AbstractDateRange {
		
		public static const WEEK:String = "week";
		
		
		/**
		 * Read-only calculated property.
		 * 
		 * Returns a Date object reperesenting the sunday of the week.
		 * 
		 * @return Date
		 * 
		 */
		override public function get startDate():Date {
			var date:Date = DateUtil.cloneDate( initialDate );
			date.setDate( date.getDate( ) - date.getDay( ) );
			return date;
		}

		/**
		 * Read-only calculated property.
		 * 
		 * Returns a Date object representing the saturday of the week.
		 * 
		 * @return Date 
		 * 
		 */		
		override public function get endDate():Date {
			var date:Date = DateUtil.cloneDate( initialDate );
			date.setDate( date.getDate( ) + ( 6 - date.getDay( ) ) );
			return date;
		}
		
		/**
		 * Constructor.
		 * 
		 * @param date - The date to calculate the week for.
		 * 
		 */		
		public function Week( date:Date ) {
			super( );
			initialDate = DateUtil.cloneDate( date );
		}
		
		
		
		
		
		/**
		 * @inheritDoc
		 */		
		override public function calculate( ):void {
			super.calculate( );
			
			var date:Date;
			for( var i:int = 0; i < 7; i++ ) {
				date = DateUtil.cloneDate( startDate );
				date.setDate(date.getDate() + i);				
				addItem(date);			
			}
			
		}
		
		
		/**
		 * Returns the week number of the year.
		 * 
		 * @return int - The calculated week number.
		 */
		public function weekNumber( ):int {
			var yearStart:Date = new Date( );
			var difference:Number; 
			var week:Number;
			var date:Date = getItemAt( length - 1 ) as Date;

			yearStart.setFullYear( date.getFullYear( ) ,0 ,1 );
			yearStart.setTime( yearStart.getTime( ) - DateUtil.DAY_IN_MILLESECONDS );
			
			difference = ( date.getTime( ) + DateUtil.DAY_IN_MILLESECONDS ) - yearStart.getTime( );
			week = Math.ceil( difference / DateUtil.WEEK_IN_MILLESECONDS );
			
			return week;
		}
		
		
						
	}

}