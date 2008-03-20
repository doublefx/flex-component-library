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
package ca.dereksantos.fcl.calendarClasses {
	
	import ca.dereksantos.fcl.events.CalendarItemDeleteEvent;
	
	import flash.events.MouseEvent;
	
	import mx.containers.HBox;
	import mx.controls.Button;
	import mx.controls.Label;
	
	
	////////////////////////////////////////////////////////////////
	// Events
	////////////////////////////////////////////////////////////////
	
	/**
	 * The <code>delete</code> event is dispatched when the delete button of a 
	 * <code>CalendarItem</code> button is clicked. This event is used to signal 
	 * the calendar to remove the related item from its <code>dataProvider</code>
	 * 
	 * @eventType dslib.events.CalendarItemDeleteEvent
	 * 
	 */	
	[Event(alias="itemDelete", type="dslib.events.CalendarItemDeleteEvent")]
	
	
	/////////////////////////////////////////////////////////////////
	// Styles
	////////////////////////////////////////////////////////////////
	
	/**
	 * The name of the CSS Style declaration used to change the appearance
	 * of the delete button for <code>CalendarItem</code> objects.
	 * 	 * 
	 */	
	[Style(name="deleteButtonStyleName", type="String", inherit="no")]
	
	
	/**
	 * The <code>CalendarItem</code> class is used by the <code>MonthDayRenderer</code>
	 * to display items in the parent calendars dataProvider. The <code>CalendarItem</code>
	 * will automatically add a delete button to allow items to be removed from the calendar.
	 * 		
 	 * @author dsantos
	 * 
	 */	
	public class CalendarItem extends HBox {
		
		//------------------------------------------------------------------------------
		// _item Property
		//------------------------------------------------------------------------------
		
		/**
		 * Storage for the <code>item</code> property. 
		 */		
		private var _item:Object;
				
		/**
		 * The <code>item</code> property is used to store a reference to the data
		 * which is being displayed in the Calendar.
		 * 
		 * @return Object
		 * 
		 */		
		public function get item():Object {
			return _item;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */		
		public function set item(value:Object):void {
			_item = value;
		}
		
		//------------------------------------------------------------------------------
		// _text Property		
		//------------------------------------------------------------------------------
		/**
		 * Storage for the <code>text</code> property. 
		 */		
		private var _text:String;
		
		/**
		 * The <code>text</code> property defines what text to show
		 * visually in the calendar item. 
		 * 
		 * @return String
		 * 
		 */		
		public function get text():String {
			return _text;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */		
		public function set text(value:String):void {
			_text = value;
			itemLabel.text = value;
		}
		
		
		/**
		 * A reference to the label which contains the text to display to visually
		 * show the <code>CalendarItem</code>.
		 * 
		 */		
		private var itemLabel:Label;
		
		/**
		 * A reference to the button which will delete the item from the 
		 * parent calendars dataProvider.
		 * 
		 */		
		private var closeButton:Button;
		
		/**
		 * Constructor
		 * 
		 * @return 
		 * 
		 */		
		public function CalendarItem() {
			super();
		}
		
		/**
		 * Calls the <code>createChildren()</code> method of the superclass and
		 * adds the child display objects to visually display the 
		 * <code>CalendarItem</code>.
		 * 
		 */		
		override protected function createChildren():void {
			super.createChildren();
			
			if(!itemLabel) {
				itemLabel = new Label();
				
				addChild(itemLabel);
				
				itemLabel.text = (text) ? text : "";
				itemLabel.percentWidth = 100;
			}
			
			if(!closeButton) {
				closeButton = new Button();
				
				addChild(closeButton);
				if(getStyle("deleteButtonStyleName") != null) {
					closeButton.styleName = getStyle("deleteButtonStyleName");
				} else {
					closeButton.setStyle("cornerRadius", 0);
					closeButton.setStyle("borderColor",0x9999DD);
					closeButton.setStyle("paddingLeft",0);
					closeButton.setStyle("paddingRight",0);
					closeButton.setStyle("paddingTop",0);
					closeButton.setStyle("paddingBottom",0);
					closeButton.height = 20;
					closeButton.width = 20;
				}
				closeButton.label = "X";
				closeButton.addEventListener(MouseEvent.CLICK, handleCloseButtonClick);
			}
			
			invalidateDisplayList();
		}
		
		/**
		 * Event handle for the <code>click</code> event of the close button.
		 * This will dispatch an <code>itemDelete</code> to signal
		 * the <code>Calendar</code> to delete the item from its <code>dataProvider</code>.
		 * 
		 * @param event:MouseEvent
		 * 
		 */		
		private function handleCloseButtonClick(event:MouseEvent):void {
			var itemDeleteEvent:CalendarItemDeleteEvent
				= new CalendarItemDeleteEvent(item,CalendarItemDeleteEvent.ITEM_DELETE);
				
			dispatchEvent(itemDeleteEvent);
		}
		
		
	}
}