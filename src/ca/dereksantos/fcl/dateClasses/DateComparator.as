package ca.dereksantos.fcl.dateClasses {
	
	import ca.dereksantos.fcl.core.IComparator;

	public class DateComparator implements IComparator {
		
		/**
		 * @inheritDoc 
		 * @param obj1
		 * @param obj2
		 * @return 
		 * 
		 */		
		public function equals(obj1:Object, obj2:Object):Boolean {
			var day1:Date = obj1 as Date;
			var day2:Date = obj2 as Date;
			
			if(	day1.getFullYear( ) == day2.getFullYear( ) 	&& 
			   	day1.getMonth( ) 	== day2.getMonth( ) 	&& 
				day1.getDate( ) 	== day2.getDate( ) ) {
				return true;
			}  
			return false;			
		}
		
		/**
		 * @inheritDoc 
		 * @param obj1
		 * @param obj2
		 * @return int
		 * 
		 */		
		public function compare(obj1:Object, obj2:Object):int {
			var day1:Date = obj1 as Date;
			var day2:Date = obj2 as Date;
			
			if(	day1 < day2 ) {
				return -1;
			} else if ( day1 > day2 ) {
				return 1;	
			} 
			return 0;
		}
		
	}
}