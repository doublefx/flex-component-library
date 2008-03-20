package ca.dereksantos.fcl.util{
	
	public interface IComparator {
		
		/**
		 * Returns true if obj1 is equal to obj2/
		 * 
		 * @param obj
		 * @return Boolean 
		 * 
		 */	
		function equals( obj1:Object, obj2:Object ):Boolean;
		
		/**
		 * <p>
		 * Compares the obj1 to obj2.
		 * </p>
		 * 
		 * Return Values: <br/>
		 * <ul>
		 * 		<li>-1 - obj1 is less than the obj2</li>
		 * 		<li>0 - obj1 is equal to obj2</li>
		 * 		<li>1 - obj1 is greater than obj2</li>
		 * </ul>
		 * 
		 * @param obj
		 * @return int
		 */
		function compare( obj1:Object, obj2:Object ):int;

		
	}
}