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
	
	import flash.events.Event;
	import flash.events.FocusEvent;
	
	import mx.controls.TextInput;
	import mx.controls.dataGridClasses.DataGridListData;
	import mx.controls.listClasses.ListData;
		
	///////////////////////////////////////////
	// Events
	///////////////////////////////////////////
	/**
	 * Dispatches when the focusOut and change events are dispatched and
	 * the value is set to a valid value.
	 * This event is also dispatched when the minValue or maxValue 
	 * properties are changed and the value property needs to changed accordingly.
	 * 
	 * @eventType flash.events.Event
	 * 
	 */
	[Event(name="valueChange", type="flash.events.Event")]


	/**
	 * Allows user to input numbers into a text field. Minumum and Maximum
	 * values can be specified.
	 * 
	 * @author dsantos
	 * @see mx.controls.TextInput
	 * 
	 */	 
	public class NumericInput extends TextInput {
		
		/**
		 * Defines the name of the valueChange event.
		 */		
		public static const VALUE_CHANGE:String = "valueChange";

		/////////////////////////////////////////////////
		// _value Property
		////////////////////////////////////////////////
		private var _value:Number = 0;		
		
		[Bindable]
		/**
		 * Returns the current value of the <code>value</code> property. The <code>value</code>
		 * property represents the number which has been set either by 
		 * the user or dynamically with actionscript.
		 * @return Number
		 * 
		 */		
		public function get value():Number {
			return this._value;
		}
		
		/**
		 * @public 
		 */		
		public function set value(pValue:Number):void {
			trace('NumericInput.value( pValue = ' + pValue + ' )');
			if(isValid(pValue)) {
				this._value = pValue;
				addZeros( );
			}
		}
		
		/////////////////////////////////////////////////////////////
		// _minValue Property
		/////////////////////////////////////////////////////////////
		private var _minValue:Number = 1;
		
		[Bindable]
		/**
		 * Returns the current value of the <code>minValue</code> property.
		 * The <code>minValue</code> property will validate the <code>value</code> property 
		 * so that it is always greater than or equal to the <code>minValue</code>.
		 * 
		 * @return Number
		 * 
		 */		
		public function get minValue():Number {
			return this._minValue;
		}
		/**
		 * @public
		 */	
		public function set minValue(pMinValue:Number):void {
			this._minValue = pMinValue;
			if(minValue > Number(text)) {
				text = minValue.toString();
				value = minValue;
				dispatchEvent(new Event(NumericInput.VALUE_CHANGE));
			}
		}
		
		/////////////////////////////////////////////////////////////
		// _maxValue Property
		/////////////////////////////////////////////////////////////
		private var _maxValue:Number = 100;
		
		/**
		 * Returns the current value of the <code>maxValue</code> property.
		 * The <code>maxValue</code> property will validate the <code>value</code> property 
		 * so that it is always less than or equal to the <code>maxValue</code>.
		 * @return Number
		 * 
		 */		
		public function get maxValue():Number {
			return this._maxValue;
		}
		/**
		 * @public
		 */		
		public function set maxValue(pMaxValue:Number):void {
			this._maxValue = pMaxValue;
			if(maxValue < Number(text)) {
				value = maxValue;
				dispatchEvent(new Event(NumericInput.VALUE_CHANGE));
			}
		}
		
		
		/////////////////////////////////////////////////////////////
		// _showLeadingZeros Property
		/////////////////////////////////////////////////////////////
		private var _showLeadingZeros:Boolean = false;		
		
		/**
		 * You can specify whether or not to show leading zeros 
		 * in the input by setting the value of this property to true.
		 * The number of leading zeros is dependant on the number
		 * of digits in the <code>maxValue</code> property.
		 * 
		 * @default false
		 * @return Boolean
		 * 
		 */		
		public function get showLeadingZeros():Boolean {
			return this._showLeadingZeros;
		}
		public function set showLeadingZeros(pValue:Boolean):void {
			this._showLeadingZeros = pValue;
			value = value;//This will update the current display.
		}
		
		
		override public function set data(value:Object):void {
			 super.data = value;
			 
			 var dataItem:Object;
			
	        if (listData && listData is DataGridListData) {
	        	dataItem = data[DataGridListData(listData).dataField];
	        } else if (listData is ListData && ListData(listData).labelField in data) {
	            dataItem = data[ListData(listData).labelField];
	        } else {
	            dataItem = data;	
	        }
			
			trace('dataItem = ' +dataItem );
			
			if(	isValid( dataItem ) ) {
				_value = Number(dataItem);
			} else {
				_value = minValue;
			}
		}
		
		
		
		
		
		
		/////////////////////////////////////////////////////////////
		// Constructor
		/////////////////////////////////////////////////////////////
		
		/**
		 * Default constructor
		 */
		public function NumericInput():void {
			super();
			this.restrict = "0-9";
			this.maxChars = this.maxValue.toString().length;
			addEventListener(FocusEvent.FOCUS_OUT,handleFocusOut);
			addEventListener(Event.CHANGE,handleChange);
			text = (minValue > 0) ? minValue.toString() : '0';
		}
		
		///////////////////////////////////////////////////////
		// EVENT HANDLERS
		//////////////////////////////////////////////////////
		/**
		 * Handles the focusOut event invoked by the superclass(TextInput).
		 * @param event
		 * 
		 */		
		private function handleFocusOut(event:Event):void {
			if(!isValid(text)) {
				if(Number(text) < minValue) {
					text = minValue.toString();
				} else {
					text = maxValue.toString();
				}
			}
			value = Number(text);
			dispatchEvent(new Event(NumericInput.VALUE_CHANGE));
		}
		
		/**
		 * Handles the change event invoked by the super class(TextInput).
		 * If the text property is valid, the <code>value</code> property
		 * will be updated and the valueChange event will be dispatched.
		 * 
		 * @param event
		 * 
		 */		
		private function handleChange(event:Event):void {
			if(isValid(text)) {
				value = Number(text);
				dispatchEvent(new Event(NumericInput.VALUE_CHANGE));
			}
		}
		
		/**
		 * Returns true if the <code>value</code> property is in between the <code>minValue</code> and
		 * <code>maxValue</code> properties. 
		 * 
		 * @param value:Object Any object which can be converted to a Number
		 * 
		 * @return Boolean
		 * 
		 */		
		private function isValid(value:Object):Boolean {
			return (Number(value) >= minValue && Number(value) <= maxValue);
		}
		
		
		protected function addZeros( ):void {
			if(showLeadingZeros) {
				text = "";
				var length:int;
				length = maxValue.toString().split('.')[0].toString().length - value.toString().split('.')[0].toString().length;
				if(length > 0) {
					for(var i:int = 0; i < length; i++) {
						text += '0';	
					}						
				}
				text += (text != null) ? value.toString() : "0";
			} else {
				text = value.toString();
			}
		}
		
		/**
		 *  
		 * @param unscaledWidth
		 * @param unscaledHeight
		 * 
		 */		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			super.updateDisplayList( unscaledWidth, unscaledHeight );
			
			addZeros( );
			
		}
			
	}
}