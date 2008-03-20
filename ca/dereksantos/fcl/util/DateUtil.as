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
package ca.dereksantos.fcl.util {
	
	
	/***
	 * <p>
	 * General utility methods which can be used in conjuction with the Date 
	 * object. This class is typically used statically. 
	 * </p>
	 */
	public class DateUtil {
			
		/**
		 * The number of milleseconds in a full day. 
		 */
		public static const DAY_IN_MILLESECONDS:Number = (1000 * 60 * 60 * 24); //86400000 milliseconds
		/**
		 * The number of milleseconds in a full week. 
		 */
		public static const WEEK_IN_MILLESECONDS:Number = (1000 * 60 * 60 * 24 * 7); //604800000 milliseconds
		
		/**
		 * Constructor
		 */
		public function DateUtil() {
		}
		
		
		public static function weekNumber( date:Date ):int {
			return 0;
		}
		/**
		 * Returns an new instance of the Date object which is set to the
		 * sunday relative to the week the specified date is in. This is useful
		 * when you need to produce a range between dates for a week. You would
		 * typically use this method in conjuction with getWeekEndDate(pDate:Date). 
		 * 
		 * @param pDate - The desired date to get the first day in the week for.
		 * 
		 * @return Date - The sunday relative to the week the specified date is in.
		 */
		public static function getWeekStartDate(pDate:Date):Date {
			var date:Date = new Date();
			date.setTime(pDate.getTime());
			date.setDate(date.getDate() - date.getDay());
			return date;
		}
		
		/**
		 * Returns an new instance of the Date object which is set to the
		 * saturday relative to the week the specified date is in.
		 * You would typically use this method in conjuction with
		 * getWeekStartDate(pDate:Date)
		 * 
		 * @param pDate - The desired date to get the last day in the week for.
		 * 
		 * @return Date - The saturday relative to the week the specified date is in.
		 */		
		public static function getWeekEndDate(pDate:Date):Date {
			var date:Date = new Date();
			date.setTime(pDate.getTime());
			date.setDate(date.getDate() + (6 - date.getDay()));
			return date;
		}
		
		
		/**
		 * The <code>cloneDate</code> method is used to copy the timestamp of a Date into a new instance of the <code>Date</code> object.
		 *  
		 * @param date
		 * @return Date 
		 * 
		 */		
		public static function cloneDate( date:Date ):Date {
			return new Date( date.getTime( ) )
		}
		
	}
}