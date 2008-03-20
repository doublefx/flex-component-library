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
	 * <p>
	 * This event is dispatched buy the Index class. 
	 * You use it to retrieve information about the changed item
	 * in the Index.
	 * </p>
	 * 
	 *  
	 * @author dsantos
	 * 
	 */	
	public class IndexChangeEvent extends Event {
		
		////////////////////////////////////////////////////////////////
		// CONSTANTS
		///////////////////////////////////////////////////////////////
		
		/**
		 * Constant which defines the event type.
		 * @public
		 */
		public static const CHANGE:String = "change";
		
		
		////////////////////////////////////////////////////////////////
		// _direction Property
		///////////////////////////////////////////////////////////////
		private var _direction:String;
		
		/**
		 * <p>
		 * The direction which the item was moved in. 
		 * </p>
		 * 
		 * <p>
		 * You use the <code>direction</code> property if you
		 * want to know which way the item was moved. The
		 * <code>direction</code> property can have to values;
		 * "up" or "down" which are defined as constants in the 
		 * Index class.
		 * </p>
		 * @param value:String
		 * 
		 */		
		public function set direction(value:String):void {
			this._direction = value;
		}
		/**
		 * @public
		 */		
		public function get direction():String {
			return this._direction;
		}
		
		////////////////////////////////////////////////////////////////
		// _item Property
		///////////////////////////////////////////////////////////////
		private var _item:Object;
		
		/**
		 * <p>
		 * A reference to the item which was changed.
		 * </p>
		 * <p>
		 * The item will come from the dataProvider of the Indexes target.
		 * </p>
		 * 
		 * @param value:Object
		 * 
		 */		
		public function set item(value:Object):void {
			this._item = value;
		}
		/**
		 * @public
		 */
		public function get item():Object {
			return this._item;
		}
				
		
		/**
		 * Constructor.
		 * @param direction
		 * @param item
		 * @param type
		 * 
		 */		
		public function IndexChangeEvent(direction:String,item:Object,type:String):void {
			super(type);
			this.direction = direction;
			this.item = item;
		}
		
		/**
		 * Override the clone() method to support event bubbling.
		 */		
		override public function clone():Event {
			return new IndexChangeEvent(this.direction,this.item,this.type);
		}
	}
}