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
	
	import ca.dereksantos.fcl.events.IndexChangeEvent;
	
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	import mx.collections.Sort;
	import mx.collections.SortField;
	
	/////////////////////////////////////////////////////////////////////////////////
	// Events
	/////////////////////////////////////////////////////////////////////////////////
	
	/**
	 * <p>
	 * Dispatched when the position of an item has changed. 
	 * Typically this happens when the public methods 
	 * <code>moveUp()</code> and <code>moveDown()</code> are called either explicity
	 * or by the default keyDown handlers.
	 * </p>
	 * 
	 * @eventType dslib.events.IndexChangeEvent
	 * 
	 */	
	[Event(name="change", type="dslib.events.IndexChangeEvent")]
	
	/**
	 * <p>
	 * You use the Index utility to automatically apply a controlled
	 * index to a field in the <code>dataProvider</code> of a list based 
	 * control.
	 * </p>
	 * 
	 * <p>
	 * The general syntax of an Index is<br/>
	 * <pre>
	 * <dslib:Index target="{anyListControl}" dataField="indexfield" />
	 * </pre>
	 * <br/>
	 * This will automatically apply index values to that field even if some values
	 * are initially <code>null</code>. If you set the <code>usePlusMinusKeys</code>
	 * property to true, the user will also be able to change an items position
	 * in the index by using the Plus(+) and Minus(-) keys on the keyboard.	 * 
	 * </p>
	 * 
	 * 
	 * @author dsantos
	 * 
	 */	
	public class Index extends EventDispatcher {
		
		private const UP:String = "up";
		private const DOWN:String = "down";
		
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		// Properties		
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		//-------------------------------------------------------------------------------------------
		// _target property
		//-------------------------------------------------------------------------------------------
		
		/**
		 * Storage for the <code>target</code> property.
		 */
		private var _target:Object;
		
		[Bindable]
		/**
		 * <p>
		 * You use the <code>target</code> property to specify the control which
		 * the Index will be applied to. The control must be either a DataGrid,List or TileBase
		 * control. The Index will automatically allow the items in the control
		 * to be ordered and sorted by the specified <code>dataField</code> property.
		 * </p>
		 * 
		 * <p>
		 * Note that this is different than sorting. With the Index the user is allowed control
		 * of the items position in relation to its siblings.
		 * </p>
		 * @return Object
		 * 
		 */		
		public function get target():Object {
			return _target;
		}	
		
		/**
		 * 
		 * @param value
		 * 
		 */		
		public function set target(value:Object):void {
			if(_target) {
				//Remove the old event listener if it exists.
				if(_target.hasEventListener(KeyboardEvent.KEY_DOWN)) {
					_target.removeEventListener(KeyboardEvent.KEY_DOWN,handleKeyDown);				
				}
			}
			_target = value;
			if(usePlusMinusKeys) {
				_target.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
			}
			reIndex();
		}
		
		//-------------------------------------------------------------------------------------------
		// _dataField property
		//-------------------------------------------------------------------------------------------
		
		/**
		 * Storage for the <code>dataField</code> property. 
		 */		
		private var _dataField:String;
		
		/**
		 * <p>
		 * You use the <code>dataField</code> property to specify which field
		 * in the target's dataProvider will be used in the Index. The Index
		 * will then use the values of that field as a driver to sort and position
		 * the items in the dataProvider.
		 * </p>
		 * 
		 * @return String
		 * 
		 */		
		public function get dataField():String {
			return _dataField;
		}
		/**
		 * 
		 * @param value
		 * 
		 */		
		public function set dataField(value:String):void {
			_dataField = value;
			reIndex();
		}
		
		//-------------------------------------------------------------------------------------------
		// _usePlusMinusKeys property
		//-------------------------------------------------------------------------------------------
		
		/**
		 * Storage for the <code>usePlusMinusKeys</code> property.
		 */
		private var _usePlusMinusKeys:Boolean = true;
		
		/**
		 * You use the <code>usePlusMinusKeys</code> property to specify
		 * whether or not the Index should automatically apply
		 * keyDown event handlers which will allow the user to move the item
		 * up or down using the plus and minus keys on the keyboard.
		 * 
		 * @return Boolean
		 * 
		 */				
		public function get usePlusMinusKeys():Boolean {
			return _usePlusMinusKeys;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */		
		public function set usePlusMinusKeys(value:Boolean):void {
			_usePlusMinusKeys = value;
			if(_usePlusMinusKeys) {
				if(target) {
					if(!target.hasEventListener(KeyboardEvent.KEY_DOWN)) {
						target.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);	
					}						
				}
			}
		}
		
		//////////////////////////////////////////////////////////////////////////////////
		// Constructor
		//////////////////////////////////////////////////////////////////////////////////
		/**
		 * Constructor
		 */
		public function Index():void {
		}
		
		//////////////////////////////////////////////////////////////////////////////////
		// Private Methods
		//////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * <p>
		 * The <code>move()</code> method is used to add or subtract from the current position.
		 * It will use the item property of the targets <code>dataProvider</code> defined by the 
		 * <code>dataField</code> property. The <code>moveUp()</code> and <code>moveDown()</code>
		 * provide access to this method.
		 * </p>
		 * 
		 * @param direction:String
		 * 
		 */		
		private function move(direction:String):void {
			var items:IList;
			var item:Object;
			var nextItem:Object;
			var prevItem:Object;
				
			if((target.allowMultipleSelection && target.selectedIndices.length == 1) || target.selectedIndex > -1) {
				items = target.dataProvider as IList;
				item = (target.allowMultipleSelection) ? target.selectedItems[0] : target.selectedItem;
				
				switch(direction) {
					case UP:
						if(item[dataField] < getHighestPosition()) {
							nextItem = getItemAtPosition(item[dataField]+1);
							
							item[dataField] ++;
							if(nextItem) {
								nextItem[dataField] --;
							}
						}				
						break;
					case DOWN:
						if(item[dataField] > getLowestPosition()) {
							prevItem = getItemAtPosition(item[dataField]-1);
							
							item[dataField] --;
							if(prevItem) {
								prevItem[dataField] ++;					
							}
						}
						break;
				}
				dispatchEvent(new IndexChangeEvent(direction,item,IndexChangeEvent.CHANGE));
			}		
		}
		
			
		/**
		 * Returns an item in the targets <code>dataProvider</code> based on the value of
		 * the items property defined by the <code>dataField</code> property. If an item
		 * with the specified position could not be found, it will return a null object.
		 * 
		 * @param priority
		 * @param items
		 * @return 
		 * 
		 */		
		private function getItemAtPosition(position:int):Object {
			var items:IList = target.dataProvider as IList;
			var item:Object;
			for(var i:int = 0; i <items.length; i++) {
				if(items.getItemAt(i)[dataField] == position) {
					item = items.getItemAt(i);
					return item;
				}
			}
			return item;
		}
		
		
		/**
		 * <p>
		 * Finds the highest value of property defined by 
		 * the <code>dataField</code> property for all items 
		 * in the targets <code>dataProvider</code>. 
		 * </p>
		 * 
		 * @return int
		 * 
		 */		
		private function getHighestPosition():int {
			var items:IList = target.dataProvider as IList;
			var position:int = 0;
			for(var i:int = 0; i <items.length; i++) {
				if(items.getItemAt(i)[dataField] > position) {
					position = items.getItemAt(i)[dataField];
				}
			}
			return position;
		}
		
		/**
		 * <p>
		 * Finds the lowest value of property defined by 
		 * the <code>dataField</code> property for all items 
		 * in the targets <code>dataProvider</code>. 
		 * </p>
		 * 
		 * @return int
		 * 
		 */		
		private function getLowestPosition():int {
			var items:IList = target.dataProvider as IList;
			var position:int = items.getItemAt(0)[dataField];
			for(var i:int = 0; i <items.length; i++) {
				if(items.getItemAt(i)[dataField] < position) {
					position = items.getItemAt(i)[dataField];
				}
			}
			return position;
		}
		
		
		//////////////////////////////////////////////////////////////////////////////////
		// Public Methods
		//////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * <p>
		 * You use the <code>reIndex()</code> method to evaluate the value of the property
		 * defined by the <code>dataField</code> property for every item in the targets
		 * <code>dataProvider</code>. Essentially this method is used to clean up 
		 * holes in the position index and close gaps between positional values.
		 * </p>
		 * 
		 * <p>
		 * Example: If the <code>dataProvider</code> has 3 items whose index values
		 * are 2,4 and 7. The <code>reIndex()</code> method will result in those values
		 * being 1,2 and 3.
		 * </p>
		 * 
		 * <p>
		 * NOTE: Calling this method will not sort are modify the order of items in the targets
		 * <code>dataProvider</code>. It will only change the values of the items property defined
		 * by the <code>dataField</code> property. This is to allow sorting to be decided externally.
		 * </p>
		 * 
		 */		
		public function reIndex():void {
			if(dataField && target) {
				var items:IList = target.dataProvider as IList;
				var item:Object;
				var tempIndex:ArrayCollection = new ArrayCollection();
				var sort:Sort = new Sort();
				var sortField:SortField = new SortField("value");
				var highestPosition:int = getHighestPosition();
				var tempItem:Object;
				
				sort.fields = [sortField];
				
				for(var i:int = 0; i < items.length; i++) {
					item = items.getItemAt(i);
					if(item[dataField] == null) {
						highestPosition++;
						item[dataField] = highestPosition;
					}
					
					tempIndex.addItem({orgIndex:i,value:item[dataField]});
				}
				
				tempIndex.sort = sort;
				tempIndex.refresh();
				
				for(var j:int = 0; j < tempIndex.length; j++) {
					tempItem = tempIndex.getItemAt(j);
					items.getItemAt(tempItem.orgIndex)[dataField] = j+1;				
				}
			}
		}
		
		/**
		 * Public accessor for the private <code>move()</code> method. 
		 */		
		public function moveUp():void {
			move(UP);
		}
		
		/**
		 * Public accessor for the private <code>move()</code> method. 
		 */		
		public function moveDown():void {
			move(DOWN);
		}
		
		/**
		 * Handles the keyDown event of the <code>target</code>. If the plus key is pressed
		 * the <code>selectedItem</code> of the target will be moved up within the Index.
		 * 
		 * @param event
		 * 
		 */		
		public function handleKeyDown(event:KeyboardEvent):void {
			// Plus key was pressed
			if(event.keyCode == 187 || event.keyCode == 107) {
				moveUp();
			}
			//Minus key was pressed
			else if(event.keyCode == 189 || event.keyCode == 109) {
				moveDown();
			}
		}
		
		
	}
}