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
	 * The <code>CalendarItemDropEvent</code> is dispatched by the Calendar when
	 * an item is dragged on dropped on to it from an external source.
	 * You can use the <code>CalendarItemDropEvent</code> to retrieve the dropped item
	 * as well as the date the item was dropped in.
	 * 
	 * @author Derek
	 * 
	 */	
	public class CalendarItemDropEvent extends Event {
		
		////////////////////////////////////////////////////////////////
		// CONSTANTS
		///////////////////////////////////////////////////////////////
		
		/**
		 * Constant which defines the event type.
		 * @public
		 */
		public static const ITEM_DROP:String = "itemDrop";
		
		
		////////////////////////////////////////////////////////////////
		// _droppedData Property
		///////////////////////////////////////////////////////////////
		
		/**
		 * Storage for the <code>droppedData</code> property. 
		 */
		private var _droppedData:Object;
		
		/**
		 * The <code>droppedData</code> property contains a reference to the data
		 * which was dropped on the <code>MonthDayRenderer</code> control.
		 * 
		 * @returns Object
		 */		
		public function get droppedData():Object {
			return this._droppedData;
		}	
			
		/**
		 * 
		 * @param value
		 * 
		 */				
		public function set droppedData(value:Object):void {
			this._droppedData = value;
		}
		
		////////////////////////////////////////////////////////////////
		// _date Property
		///////////////////////////////////////////////////////////////
		
		/**
		 * Storage for the <code>date</code> property. 
		 */
		private var _date:Date;
		
		/**
		 * The <code>date</code> property is used to retrieve the 
		 * date in the month which the <code>droppedItem</code> was dropped on.
		 * This is useful for setting the items relevant date property 
		 * when scheduling an activity for a specific day in the month.
		 * 
		 * @returns Date
		 */		
		public function get date():Date {
			return this._date;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */				
		public function set date(value:Date):void {
			this._date = value;
		}	
		
		/**
		 * Constructor.
		 * @param droppedData
		 * @param date
		 * @param type
		 * 
		 */		
		public function CalendarItemDropEvent(droppedData:Object, date:Date, type:String):void {
			super(type);
			this.droppedData = droppedData;
			this.date = date;
		}
		
		/**
		 * Override the clone() method to support event bubbling.
		 */		
		override public function clone():Event {
			return new CalendarItemDropEvent(this.droppedData,this.date,this.type);
		}
	}
}