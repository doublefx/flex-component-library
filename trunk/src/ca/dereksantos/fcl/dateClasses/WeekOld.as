/*
	Copyright (C) 2007 Derek Santos

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/
package ca.dereksantos.fcl.dateClasses {
	
	import ca.dereksantos.fcl.util.DateUtil;
	[Bindable]
	/**
	 * The Week class can represent any week in a given year. 
	 * This class is generally used with the WeekChooser component.
	 * This class is dependant on the dslib.util.DateWrapper class.
	 * 
	 * @see dslib.util.DateWrapper
	 * 
	 */
	public class WeekOld {
		
		/////////////////////////////////////////////////////////////////
		// Constructor
		/////////////////////////////////////////////////////////////////
		/**
		 * Constructor.<br/>
		 * Calculates the week based on the date parameter if specified.
		 * 
		 * @param date - Optional<br/>The date to calculate the week for.
		 */
		public function WeekOld(date:Date = null) {
			
			if(date == null) {
				this.initialDate = new Date();
			} else {
				var newDate:Date = new Date();
				newDate.setTime(date.getTime());
				this.initialDate = newDate;
			}
		}
		
		/////////////////////////////////////////////////////////
		// _dateRange property
		/////////////////////////////////////////////////////////		
		private var _dateRange:Array;
		
		/**
		 * The dateRange property is an Array of dates containing a Date object
		 * for every day in the week.
		 * 
		 * @return Array - An array of dates cotaining a Date object for 
		 *  every day in the week. 
		 */
		public function get dateRange():Array {
			return this._dateRange;
		}
		
	
		/////////////////////////////////////////////////////////
		// _initialDate property
		/////////////////////////////////////////////////////////		
		private var _initialDate:Date;
		
		/**
		 * The initial date property specifies the date which was used to
		 * calculate the Week of that date.<br/><br/>
		 * <b>Example: </b> If the intial date was set to 2007/08/30 the 
		 * week number would be 35 and it would save every day in the week into
		 * the dateRange property. 
		 * 
		 * @return Date - The intialDate passed in the contructor.
		 */
		public function get initialDate():Date {
			return this._initialDate;
		}
		/**
		 * @public
		 */
		public function set initialDate(value:Date):void {
			var date:Date;
			
			this._initialDate = value;
		
			
			this._dateRange = new Array();
			for(var i:int=0;i<7;i++) {
				date = new Date();
				date.setTime(DateUtil.getWeekStartDate(this.initialDate).getTime());
				date.setDate(date.getDate() + i);				
				this._dateRange.push(date);			
			}
			this._dateRange =  this._dateRange;
		}		
		
		
		
		/**
		 * Read only property for week number of the year. 
		 * 
		 * @see sbg.util.DateWrapper
		 */
		public function get weekNumber():int {
			return DateUtil.weekNumber(this.saturday);
		}
			
		/**
		 * Read only propery for the sunday of the week. 
		 * 
		 * @return Date - An instance of the Date object representing the sunday of the current week.
		 */
		public function get sunday():Date {
			return this._dateRange[0];
		}
		
		/**
		 * Read only propery for the monday of the week.
		 * 
		 * @return Date - An instance of the Date object representing the monday of the current week.
		 */		
		public function get monday():Date {
			return this._dateRange[1];
		}
		
		/**
		 * Read only propery for the tuesday of the week.
		 * 
		 * @return Date - An instance of the Date object representing the tuesday of the current week.
		 */		
		public function get tuesday():Date {
			return this._dateRange[2];
		}

		/**
		 * Read only propery for the wednesday of the week.
		 * 
		 * @return Date - An instance of the Date object representing the wednesday of the current week.
		 */		
		public function get wednesday():Date {
			return this._dateRange[3];
		}
		
		/**
		 * Read only propery for the thursday of the week.
		 * 
		 * @return Date - An instance of the Date object representing the thursday of the current week.
		 */		
		public function get thursday():Date {
			return this._dateRange[4];
		}
		
		/**
		 * Read only propery for the friday of the week.
		 * 
		 * @return Date - An instance of the Date object representing the friday of the current week.
		 */		
		public function get friday():Date {
			return this._dateRange[5];
		}
		
		/**
		 * Read only propery for the saturday of the week.
		 * 
		 * @return Date - An instance of the Date object representing the saturday of the current week.
		 */		
		public function get saturday():Date {
			return this._dateRange[6];
		}
		
	}
}