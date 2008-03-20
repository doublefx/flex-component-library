/*
	Copyright (C) 2008 Derek Santos 
	
		



*/
package ca.dereksantos.fcl.dateClasses {
	
	import mx.collections.IList;
	
	/**
	 * <p>
	 * The <code>IDateRange</code> interface is used to deal with ranges of dates such as a Week or Month.
	 * </p>
	 * 
	 * @author derek
	 * 
	 */	
	public interface IDateRange extends IList {
		
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
		function get initialDate( ):Date;
		function set initialDate( value:Date ):void; 
		
		/**
		 * Returns the first Date in the <code>DateRange</code>.
		 * 
		 * @return 
		 * 
		 */		
		function get startDate( ):Date;

		/**
		 * Returns the last Date in the <code>DateRange</code>.
		 * 
		 * @return Date 
		 * 
		 */		 
		function get endDate( ):Date;
		
		/**
		 * Builds the Date Range using the value of <code>initialDate</code>.
		 * 
		 */		
		function calculate( ):void;
		
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
		function toStartEndArray( ):Array;
		
	}
}