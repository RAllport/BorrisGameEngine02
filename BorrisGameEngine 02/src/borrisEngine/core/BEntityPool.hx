package borrisEngine.core;

import openfl.geom.Point;
import openfl.geom.Rectangle;

import starling.display.Stage;
import starling.display.DisplayObjectContainer;
//import starling.geom.Rectangle;

import borrisEngine.core.BEntity;

/**
 * ...
 * @author Rohaan Allport
 */
class BEntityPool
{
	public var numActiveEntities(get, never):Int;
	public var numInactiveEntities(get, never):Int;
	public var totalEntities(get, never):Int;
	
	
	public var name:String;
	
	// for statistics
    public var numCreated:Int = 0;
    public var numReused:Int = 0;
		
	
	private var _activeEntities:Array<BEntity>;
	private var _inactiveEntities:Array<BEntity>;
	
	private var _maxX:Float;
	private var _minX:Float;
	private var _maxY:Float;
	private var _minY:Float;
	

	public function new() 
	{
		_activeEntities = new Array<BEntity>();
		_inactiveEntities = new Array<BEntity>();
        //setPosition(bouderies);  
	}
	
	
	//**************************************** FUNCTIONS ********************************************
	
	
	/**
	 * 
	 * @param	bouderies
	 */
	public function setPosition(bouderies:Rectangle):Void
	{
		_maxX = bouderies.width;
		_minX = bouderies.x;
		_maxY = bouderies.height;
		_minY = bouderies.y;
	} // end function setPosition
	
	
	/**
	 * Search the entity pool for unused entities and reuse one
	 * If they are all in use, create a brand new one.
	 * 
	 * @param	type
	 * @return
	 */
	public function getEntity(type:Class<Dynamic>):BEntity
	{
		//trace("getting entity");
		// search for an inactive entity
		for(entity in _activeEntities) 
		{
			// BUG made a quick fix for destroyed entities. need to make it better.
			//if(entity.active == false && (entity.type == type))
			if(entity.active == false && (entity.type == type) && !entity.destroyed)
			{
				//trace('Reusing Entity #' + _activeEntities.indexOf(entity));
				entity.active = true;
				entity.alpha = 1;
				//entity.scaleX = entity.scaleY = 1;
				//numReused++;
				return entity;
				//return Type.createInstance(type, []);
			}
		}
		
		
		var entity:BEntity = Type.createInstance(type, []);
		entity.active = true;
		//entity.visible = true;
		entity.alpha = 1;
		_activeEntities.push(entity);
		//numCreated++;
		
		return entity;
		
	} // end function respawn
	
	
	/**
	 * 
	 * 
	 * @param	type
	 * @param	amount
	 */
	public function addEntities(type:Class<Dynamic>, amount:UInt = 10):Void
	{
		var entity:BEntity;
		
		for(i in 0...amount)
		{
			entity = Type.createInstance(type, []);
			entity.active = false;
			_activeEntities.push(entity);
			numCreated++;
		}
		
	} // end function addEntity
	
	
	/**
	 * 
	 */
	public function updateEntities():Void
	{
		
		for(entity in _activeEntities)
		{
			if(entity.active /*&& entity.parent*/)
			{
				if(entity.x < _minX || entity.x > _maxX || entity.y < _minY || entity.y > _maxY)
				{
					//entity.destroy();
					entity.scene.removeEntity(entity);
				}
				else
					entity.update();
			}
			
		} // end for
		
	} // end function updateEntities
		
	
	//**************************************** SET AND GET ******************************************
	
	
	/**
	 * 
	 */
	private function get_numActiveEntities():Int
	{
		return _activeEntities.length;
	}
	
	
	/**
	 * 
	 */
	private function get_numInactiveEntities():Int
	{
		return _inactiveEntities.length;
	}
	
	
	/**
	 * 
	 */
	private function get_totalEntities():Int
	{
		return _activeEntities.length + _inactiveEntities.length;
	}
	
}