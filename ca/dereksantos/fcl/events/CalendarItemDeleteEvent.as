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
	
	
	import flash.events.Event;
	
	/**
	 * The <code>CalendarItemDeleteEvent</code> is dispatched from
	 * the <code>CalendarItem</code> class when the delete button of 
	 * the <code>CalendarItem</code> is clicked. 
	 * This will singal its parent Calendar to delete the item from its
	 * <code>dataProvide</code>.
	 * 
	 * @see dslib.components.Calendar
	 * @see dslib.components.MonthDayRenderer.
	 * @author dsantos
	 * 
	 */	
	public class CalendarItemDeleteEvent extends Event {

		////////////////////////////////////////////////////////////////
		// CONSTANTS
		///////////////////////////////////////////////////////////////
		
		/**
		 * Constant which defines the event type.
		 * @public
		 */
		public static const ITEM_DELETE:String = "itemDelete";
		
		
		////////////////////////////////////////////////////////////////
		// _deletedItem Property
		///////////////////////////////////////////////////////////////
		
		/**
		 * Storage for the <code>deletedItem</code> property. 
		 */
		private var _deletedItem:Object;
		
		/**
		 * The item which was deleted from the calendar.
		 * 
		 * @param value - dslib.Week
		 * 
		 */		
		public function get deletedItem():Object {
			return this._deletedItem;
		}
		
		/**
		 * @public
		 */		
		public function set deletedItem(value:Object):void {
			this._deletedItem = value;
		}
		
				
		
		/**
		 * Constructor.
		 * @param oldWeek
		 * @param newWeek
		 * @param type
		 * 
		 */		
		public function CalendarItemDeleteEvent(deletedItem:Object,type:String):void {
			super(type);
			this.deletedItem = deletedItem;
		}
		
		/**
		 * Override the clone() method to support event bubbling.
		 */		
		override public function clone():Event {
			return new CalendarItemDeleteEvent(this.deletedItem,this.type);
		}
		
	

	}
}