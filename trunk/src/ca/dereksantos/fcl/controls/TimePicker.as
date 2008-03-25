package ca.dereksantos.fcl.controls { 
	
	import ca.dereksantos.fcl.dateClasses.TimePickerBase;
	
	import flash.display.DisplayObject;
	
	import mx.controls.dataGridClasses.DataGridListData;
	import mx.controls.listClasses.BaseListData;
	import mx.controls.listClasses.IDropInListItemRenderer;
	import mx.controls.listClasses.IListItemRenderer;
	import mx.controls.listClasses.ListData;
	import mx.core.IDataRenderer;
	import mx.events.FlexEvent;
	import mx.managers.IFocusManagerComponent;
	
	
	/**
	 * The <code>TimePicker</code> control is used to allow the user to input a time. 
	 * 
	 * @author derek
	 * @see ca.dereksantos.fcl.controls.DateTimePicker
	 *  
	 */	
	public class TimePicker extends TimePickerBase implements IListItemRenderer,IDropInListItemRenderer,IDataRenderer,IFocusManagerComponent {
		
		//--------------------------------------------------------------
		// Implements IDataRenderer Interface
		//--------------------------------------------------------------
	    private var _data:Object;
	
	    [Bindable("dataChange")]
	    [Inspectable(environment="none")]
	    /**
	     *  The <code>data</code> property lets you pass a value
	     *  to the component when you use it in an item renderer or item editor.
	     *  You typically use data binding to bind a field of the <code>data</code>
	     *  property to a property of this component.
	     *
	     *  <p>When you use the control as a drop-in item renderer or drop-in
	     *  item editor, Flex automatically writes the current value of the item
	     *  to the <code>selectedDate</code> property of this control.</p>
	     *
	     *  @default null
	     *  @see mx.core.IDataRenderer
	     */
	    override public function get data():Object {
	        return _data;
	    }
	
	    /**
	     *  @private
	     */
	    override public function set data(value:Object):void {
	        var dataItem:Object;
			
	        _data = value;
	
	        if (_listData && _listData is DataGridListData) {
	        	dataItem = _data[DataGridListData(_listData).dataField];
	        } else if (_listData is ListData && ListData(_listData).labelField in _data) {
	            dataItem = _data[ListData(_listData).labelField];
	        } else if (_data is String) {
	            dataItem = new Date(Date.parse(data as String));	
	        } else {
	        	dataItem = _data;
	        }
	
	        if (dataItem is Date) {
	            value = dataItem as Date;
	        } else if (dataItem is String) {
	        	value = new Date(Date.parse(dataItem));
	        } else {
	        	value = new Date();
	        }
	
	        dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
	    }
		
		//--------------------------------------------------------------
		// Implements IDropInListItemRenderer Interface
		//--------------------------------------------------------------
		/**
		 * Attribute which implements the IDropInListItemRenderer Interface 
		 */
		private var _listData:BaseListData;
		
		[Bindable("dataChange")]
    	[Inspectable(environment="none")]
		/**
	     *  When a component is used as a drop-in item renderer or drop-in
	     *  item editor, Flex initializes the <code>listData</code> property
	     *  of the component with the appropriate data from the list control.
	     *  The component can then use the <code>listData</code> property
	     *  to initialize the <code>data</code> property of the drop-in
	     *  item renderer or drop-in item editor.
	     *
	     *  <p>You do not set this property in MXML or ActionScript;
	     *  Flex sets it when the component is used as a drop-in item renderer
	     *  or drop-in item editor.</p>
	     *
	     *  @default null
	     *  @see mx.controls.listClasses.IDropInListItemRenderer
	     */
	    public function get listData():BaseListData {
	        return _listData;
	    }	
	    /**
	     *  @private
	     */
	    public function set listData(value:BaseListData):void {
	        _listData = value;
	    }
		
		//-------------------------------------------------------
		// _showSeconds
		//-------------------------------------------------------
		private var _showSeconds:Boolean = false;
		
		[Bindable]
		/**
		 * The <code>showSeconds</code> property is used to hide or show the NumericInput control for seconds.
		 * 
		 * @return 
		 * 
		 */		
		public function get showSeconds( ):Boolean { return _showSeconds; }
		public function set showSeconds( value:Boolean ):void { 
			_showSeconds = value
			invalidateDisplayList();
		}
		
		//-------------------------------------------------------
		// Constructor
		//-------------------------------------------------------
		/**
		 * Constructor. 
		 */		
		public function TimePicker( ) {
			super( );
		}
		
		
		/**
		 * Adds or removes the secondsInput from the component based on the showSeconds property.
		 * 
		 */		
		protected function updateSecondsDisplay( ):void {
			if(showSeconds) 
				addSecondsInput( );
			else
				removeSecondsInput( );
		}
		
		/**
		 * Remove the secondsInput from the component.
		 * 
		 */
		protected function removeSecondsInput( ):void {
			if( owns( secondsInput ) ) {
				var childIndex:int = getChildIndex( secondsInput );
				removeChildAt( childIndex );
				removeChildAt( childIndex -1 );  //Remove the : seperator.
			}
		}
		/**
		 * Adds the secondsInput as a child of the component.
		 * 
		 */		
		protected function addSecondsInput( ):void {
			if( !owns( secondsInput ) ) {
				var childIndex:int = getChildIndex( minutesInput );//Always add seconds after minutes input.
				addChildAt( DisplayObject(createInputSeperator( )), childIndex + 1 );
				addChildAt( secondsInput, childIndex + 2 );
			}
		}
		
		/**
		 * Update the UI display.
		 * 
		 * @param unscaledWidth
		 * @param unscaledHeight
		 * 
		 */		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			super.updateDisplayList( unscaledWidth, unscaledHeight );
			
			updateSecondsDisplay( );
			
		}
		
		
	}
}