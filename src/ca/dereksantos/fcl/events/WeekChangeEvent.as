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
package ca.dereksantos.fcl.events {
	
	////////////////////////////////
	// IMPORT DEPENDANCIES
	////////////////////////////////
	import ca.dereksantos.fcl.dateClasses.WeekOld;
	
	import flash.events.Event;
	
	
	/**
	 * Event class used to dispatch weekChange events. Contains relevant information
	 * about the week. 
	 * The oldWeek property represents the value of the week before the event was dispatched.
	 * The newWeek property represents the value of the week after the event was dispatched.
	 * 
	 * @author dsantos
	 * 
	 */	
	public class WeekChangeEvent extends Event {
		
		////////////////////////////////////////////////////////////////
		// CONSTANTS
		///////////////////////////////////////////////////////////////
		
		/**
		 * Constant which defines the event type.
		 * @public
		 */
		public static const WEEK_CHANGE:String = "weekChange";
		
		
		////////////////////////////////////////////////////////////////
		// _oldWeek Property
		///////////////////////////////////////////////////////////////
		private var _oldWeek:WeekOld;
		
		/**
		 * The value of the Week object before the event was dispatched.
		 * 
		 * @param value - dslib.Week
		 * 
		 */		
		public function set oldWeek(value:WeekOld):void {
			this._oldWeek = value;
		}
		
		/**
		 * @public
		 */		
		public function get oldWeek():WeekOld {
			return this._oldWeek;
		}
		
		////////////////////////////////////////////////////////////////
		// _newWeek Property
		///////////////////////////////////////////////////////////////
		private var _newWeek:WeekOld
		
		/**
		 * The value of the Week object after the event was dispatched.
		 * 
		 * @param value
		 * 
		 */		
		public function set newWeek(value:WeekOld):void {
			this._newWeek = value;
		}
		/**
		 * @public
		 */
		public function get newWeek():WeekOld {
			return this._newWeek;
		}
				
		
		/**
		 * Constructor.
		 * @param oldWeek
		 * @param newWeek
		 * @param type
		 * 
		 */		
		public function WeekChangeEvent(oldWeek:WeekOld,newWeek:WeekOld,type:String):void {
			super(type);
			this.oldWeek = oldWeek;
			this.newWeek = newWeek;
		}
		
		/**
		 * Override the clone() method to support event bubbling.
		 */		
		override public function clone():Event {
			return new WeekChangeEvent(this.oldWeek,this.newWeek,this.type);
		}
		
	}
}