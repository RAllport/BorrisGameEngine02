package borrisEngine.core;

import openfl.geom.Rectangle;
import openfl.utils.Timer;

import starling.display.*;
import starling.events.Event;

import borrisEngine.events.BEntityEvent;
import borrisEngine.events.BEntityComponentEvent;


/**
 * ...
 * @author Rohaan Allport
 */
class BEntity extends Sprite
{
	public var numComponents(get, never):Int;
	public var scene(get, never):BScene;
	
	/**
	 * Used to deactivate the entity if it is not within the bounderies.
	 */
	// TODO change a private boundies based on the position of the camera(Camera2D))
	public static var boundries:Rectangle;
	
	/**
	 * Indicates whether or not the entity is active and should be updated.
	 */
	public var active:Bool;
	
	/**
	 * Force the entity to stay active even when the alpha is 0 or scale is < 0 or if it is no longer in the bounderies.
	 * This is used for entityes that need to allways be active such and a player.
	 */
	public var forceActive:Bool = false;
	
	/**
	 * 
	 */
	public var destroyed(get, null):Bool;
	
	/**
	 * The type of Eniity.
	 */
	public var type:Class<Dynamic>;
	
	
	private var _components:Array<BEntityComponent>;
	
	@:allow(borrisEngine.core.BScene)
	@:allow(borrisEngine.core.BLayer)
	private var _scene:BScene;
	private var _destroyed:Bool = false;
	
	
	/**
	 * 
	 */
	public function new() 
	{
		super();
		
		_components = new Array<BEntityComponent>();
		type = Type.getClass(this);
		
		// event handling
		addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
	}
	
	
	//**************************************** HANDLERS *********************************************
	
	
	/**
	 * Sets the scene.
	 * Called when the entity is added to a scene.
	 * Call super.onAddedToStage() when overriding this function.
	 * 
	 * @param	event
	 */
	private function onAddedToStage(event:Event):Void 
	{
		active = true;
		
	} // end function onAddedToStage
		
	
	//**************************************** FUNCTIONS ********************************************
	
	
	/**
	 * Updates the entity.
	 * Called in Scene.update().
	 */
	public function update():Void
	{
		
		for (component in _components)
		{
			component.update();
		} // end for 
		
	} // end function update
	
	
	/**
	 * Returns the first occurance of a BEntityComponent of class type.
	 * 
	 * @param	type The class of BEntityComponent to search for.
	 * @return
	 */
	public function getComponent(type:Class<BEntityComponent>):BEntityComponent
	{
		for (component in _components)
		{
			if (Std.is(component, type))
			{
				return component;
			}
		}
		
		return null;
	}
	
	
	/**
	 * 
	 * @param	component
	 * @return
	 */
	public function addComponent(component:BEntityComponent):BEntityComponent
	{
		component._owner = this;
		_components.push(component);
		component.dispatchEvent(new BEntityComponentEvent(BEntityComponentEvent.ADDED));
		//_components.push(component);
		
		return component;
	} // end 
	
	
	/**
	 * 
	 * @param	component
	 * @return
	 */
	public function removeComponent(component:BEntityComponent):BEntityComponent
	{
		component._owner = null;
		_components.remove(component);
		
		var event = new BEntityComponentEvent(BEntityComponentEvent.REMOVED);
		component.dispatchEvent(event);
		
		return component;
	} // end 
	
	
	/**
	 * 
	 * @param	index
	 * @return
	 */
	public function getComponentAt(index:Int):BEntityComponent
	{
		return _components[index];
	} // end function 
	
	
	/**
	 * 
	 * @param	name
	 * @return
	 */
	public function getComponentByName(name:String):BEntityComponent
	{
		for (component in _components)
		{
			if (component.name != null && component.name == name)
			{
				return component;
			} // end if
		} // end for 
		
		return null;
		
	} // end function 
	
	
	/**
	 * 
	 */
	public function removeComponents():Void
	{
		for (component in _components)
		{
			component._owner = null;
		} //end for 
		
		_components = [];
		
	} // end 
	
	
	/**
	 * 
	 * @param	component
	 * @return
	 */
	public function destroyComponent(component:BEntityComponent):BEntityComponent
	{
		component.destroy();
		//component._owner = null;
		//_components.splice(_components.indexOf(component), 1);
		
		//component.destroy();
		//removeComponent(component);
		
		return component;
	} // end 
	
	
	/**
	 * 
	 */
	public function destroyComponents():Void
	{
		for (component in _components)
		{
			component.destroy();
			component._owner = null;
			//_components.pop();
			
			//destroyComponent(component);
		} //end for
		
		_components = [];
		
	} // end function 
	
	
	/**
	 * 
	 * @param	component
	 * @return
	 */
	public function hasComponent(component:BEntityComponent):Bool
	{
		return _components.indexOf(component) >= 0;
	} // end function
	
	
	/**
	 * Destroys this BEntity instance.
	 * Deactivates this <code>BEntity</code> instance.
	 * Destroys all its components.
	 * Sets <code>scene</code> to null.
	 * Dispatches a new <code>BEntityEvent.DESTROYED</code> <code>Event</code>;
	 * 
	 * Override this function.
	 * 
	 * @return
	 */
	public function destroy():BEntity
	{
		
		if (!_destroyed)
		{
			active = false;
			destroyComponents();
			_destroyed =  true;
			
			if (_scene != null) 
			{
				_scene.removeEntity(this);
			} // end if
			
			var event = new BEntityEvent(BEntityEvent.DESTROYED);
			dispatchEvent(event);
		} // end if
		
		return this;
	} // end 
		
		
	
	//**************************************** SET AND GET ******************************************
	
	
	private function get_numComponents():Int
	{
		return _components.length;
	}
		
	
	private function get_scene():BScene
	{
		return _scene;
	}
	
	
	private function get_destroyed():Bool 
	{
		return _destroyed;
	}
	
}