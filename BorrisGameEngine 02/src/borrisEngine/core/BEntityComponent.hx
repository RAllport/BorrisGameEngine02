package borrisEngine.core;

import starling.events.EventDispatcher;

import borrisEngine.events.BEntityComponentEvent;

/**
 * ...
 * @author Rohaan Allport
 */
class BEntityComponent extends EventDispatcher
{
	public var destroyed(get, null):Bool;
	
	public var name:String; 
	
	@:allow(borrisEngine.core.BEntity)
	private var _owner:BEntity;
	private var _destroyed:Bool = false;
	@:allow(borrisEngine.core.BEntity)
	private var _removeded:Bool = false;
	
	
	public function new() 
	{
		super();
		
		addEventListener(BEntityComponentEvent.ADDED, entityAddedHandler);
		// TODO use this somehow
		//addEventListener(BEntityComponentEvent.REMOVED, entityAddedHandler);
	}
	
	
	//**************************************** HANDLERS *********************************************
		
	/**
	 * 
	 * @param	event
	 */
	private function entityAddedHandler(event:BEntityComponentEvent):Void
	{
		
	} // end function entityAddedHandler
	
	
	//**************************************** FUNCTIONS ********************************************
	
	
	/**
	 * Updates the game component.
	 * Override this function in it's subclasses.
	 * Called in BEntity.update().
	 */
	public function update():Void
	{
		//if (_owner == null && !_removeded)
		if (_owner == null)
			return;
			
	} // end function update
	
	
	/**
	 * Destroys this game component.
	 * Override this function.
	 */
	public function destroy():Void
	{
		//trace("destroying component!");
		
		if (!_destroyed)
		{
			_destroyed = true;
			var event = new BEntityComponentEvent(BEntityComponentEvent.DESTROYED);
			dispatchEvent(event);
		} // end if
	} // end function destroy
	
	
	//**************************************** SET AND GET ******************************************
	
	
	private function get_destroyed():Bool 
	{
		return _destroyed;
	}
	
}