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
package ca.dereksantos.fcl.controls {
	
	//////////////////////////////////////////////////
	//Import declarations.
	//////////////////////////////////////////////////
	import ca.dereksantos.fcl.dateClasses.WeekOld;
	import ca.dereksantos.fcl.events.WeekChangeEvent;
	
	import mx.controls.DateChooser;
	import mx.events.CalendarLayoutChangeEvent;
	
	////////////////////////////////////////////////
	//Events
	////////////////////////////////////////////////
	/**
	 *  Dispatched when the change event of the super class is dispatched and
	 *  the <code>selectedDate</code> property is changed to a date which falls in a different 
	 *  week the currently set week.
	 *
	 *  @eventType dslib.events.WeekChangeEvent
	 */
	[Event(name="weekChange",type="dslib.events.WeekChangeEvent")]
	
	
	/**
	 * The WeekChooser control extends the funcionality of the DateChooser control to allow 
	 * a week to be chosen rather than a single day. When a date is chosen the entire week 
	 * will be highlited and the week number as well as a date reference for every day of the 
	 * week will be stored.
	 * 
	 **/
	public class WeekChooser extends DateChooser {
		
		////////////////////////////////////////////////////////////////////
		// _selectedWeek Property
		////////////////////////////////////////////////////////////////////
		private var _selectedWeek:WeekOld;		
		
		[Bindable]
		/**
		 * The current selected week. 
		 * The selectedWeek cannot be deselected and defaults to the current week.
		 * Defaults to the current week.
		 * 
		 * @return Week - An instance of the Week object representing the selected week.
		 * 
		 */		
		public function get selectedWeek():WeekOld {
			return this._selectedWeek;
		}
			
		/**
		 * @public
		 */
		public function set selectedWeek(value:WeekOld):void {
			this._selectedWeek = value;
			setRange();
		}
		
		/**
		 * Constructor
		 * 
		 */		
		public function WeekChooser( ) {
			this.allowMultipleSelection = true;	
			this.allowDisjointSelection = false;
			this.addEventListener( CalendarLayoutChangeEvent.CHANGE, handleChange );	
			
			super( );
			this.selectedDate = new Date( );
			this.selectedWeek = new WeekOld( this.selectedDate );	
		}
		
			
		
		/**
		 * Handles the change of event of the super class.
		 * If the new date falls outside of the current selected week,
		 * the selectedWeek property is set to the week relative to the new
		 * value of the selectedDate property and the weekChange event is 
		 * dispatched.
		 * 
		 * @param event CalendarLayoutChangeEvent
		 * 
		 */		 
		private function handleChange(event:CalendarLayoutChangeEvent):void {
			if(this.selectedWeek != null && (this.selectedDate > this.selectedWeek.saturday || this.selectedDate < this.selectedWeek.sunday)) {
				var e:WeekChangeEvent = new WeekChangeEvent(this.selectedWeek,new WeekOld(this.selectedDate),WeekChangeEvent.WEEK_CHANGE);
				this.selectedWeek = new WeekOld(this.selectedDate);
				dispatchEvent(e);
			} else {
				this.selectedWeek = new WeekOld(this.selectedDate);
			}				
		}
		
		/**
		 * Sets the selectedRange property of the super class 
		 * to an array containing all the days in the selected week.
		 */
		private function setRange():void {
			this.selectedRanges = [{rangeStart: this.selectedWeek.sunday,rangeEnd: this.selectedWeek.saturday}];
		}
				
		
	}
}