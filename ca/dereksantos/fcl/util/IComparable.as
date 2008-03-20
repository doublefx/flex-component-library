package ca.dereksantos.fcl.util {
	
	public interface IComparable {
		
		/**
		 * Returns true if the objects are equal and false otherwise.
		 * 
		 * @param obj
		 * @return Boolean 
		 * 
		 */		
		function equals( obj:Object ):Boolean;
		
		/**
		 * <p>
		 * Compares the parameterized object to the current object.
		 * </p>
		 * 
		 * Return Values: <br/>
		 * <ul>
		 * 		<li>-1 - The parameterized object is less than the current object</li>
		 * 		<li>0 - The parameterized object is equal to the current object</li>
		 * 		<li>1 - The parameterized object is greater than the current object</li>
		 * </ul>
		 * 
		 * @param obj
		 * @return int
		 */
		function compare( obj:Object ):int;
		
		
	}
}