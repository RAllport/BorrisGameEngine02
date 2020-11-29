package borrisEngine.core;

import starling.display.*;
import starling.events.*;


/**
 * ...
 * @author Rohaan Allport
 */
class BLayer extends Sprite
{
	/**
	 * The Z-indext position of the layer.
	 * This is how close or far the layer is to the camera.
	 */
	// TODO Implement setter
	public var zIndex(get, set):UInt;
	
	/**
	 * 
	 */
	//public var tx(get, set):UInt;
	
	/**
	 * 
	 */
	//public var ty(get, set):UInt;
	
	//public var scale(get, set):Float;
	
	/**
	 * 
	 */
	public var offsetX(get, set):Int;
	
	/**
	 * 
	 */
	public var offsetY(get, set):Int;
	
	/**
	 * 
	 */
	public var paralaxX(get, set):Float;
	
	/**
	 * 
	 */
	public var paralaxY(get, set):Float;
	
	/**
	 * 
	 */
	public var numEntities(get, never):Int;
	
	/**
	 * 
	 */
	public var entities(get, set):Array<BEntity>;
	
	
	public var rows(get, never):UInt;
	
	
	public var columns(get, never):UInt;
	
	
	
	// set and get
	private var _zIndex:UInt;				// 
	//private var _tx:UInt;					// 
	//private var _ty:UInt;					// 
	private var _scale:Float;				// 
	private var _offsetX:Int;				// 
	private var _offsetY:Int;				// 
	private var _paralaxX:Float;			// 
	private var _paralaxY:Float;			// 
	
	private var _entities:Array<BEntity>;
	private var _rows:UInt;	
	private var _columns:UInt;
	
	@:allow(borrisEngine.core.BScene)
	private var _scene:BScene;				
	
	
	public function new() 
	{
		super();
		
		_zIndex = 0;
		//_tx = 0;
		//_ty = 0;
		_scale = 0;
		_offsetX = 0;
		_offsetY = 0;
		_paralaxX = 0;
		_paralaxY = 0;
		
		_entities = [];
		_rows = 0;
		_columns = 0;
		
		addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		
	}
	
	
	//**************************************** HANDLERS *********************************************
	
	
	/**
	 * 
	 * @param	event
	 */
	private function onAddedToStage(event:Event):Void
	{
		removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		
		if(Type.getClass(parent) == BScene)
		{
			_scene = cast(parent, BScene);
		}
		else
		{
			// BUG send errors
			//throw new Error("A BMapLayer can only be added to a BScene.");
			//this.parent.removeChild(this);
		}
		
		
	} // end function
	
	
	//**************************************** FUNCTIONS ********************************************
	
	
	public function addEntity(entity:BEntity):BEntity
	{
		entity._scene = _scene;
		_entities.push(entity);
		_scene._entities.push(entity);
		addChild(entity);
		//addEntityAt(entity, _entities.length);
		
		return entity;
	} // end function 
	
	
	// BUG doesn't work properly yet
	/*public function addEntityAt(entity:BEntity, index:Int):BEntity
	{
		entity._scene = _scene;
		_entities.insert(index, entity);
		_scene._entities.push(entity);
		addChildAt(entity, index);
		
		return entity;
	} // end function */
	
	
	public function getEntityAt(index:Int):BEntity
	{
		return _entities[index];
	} // end function 
	
	
	public function getEntityByName(name:String):BEntity
	{
		for (entity in _entities)
		{
			if (entity.name == name)
			{
				return entity;
			} // end if
		}// end for
		
		return null;
	} // end function 
	
	
	public function removeEntity(entity:BEntity):BEntity
	{
		entity._scene = null;
		entity.active = false;
		_entities.remove(entity);
		_scene._entities.remove(entity);
		entity.parent.removeChild(entity);
		
		return entity;
	} // end function 
	
	
	/*public function removeEntityAt(index:Int):BEntity
	{
		return entity;
	} // end function 
	
	
	public function removeEntityByName(name:String):BEntity
	{
		return entity;
	} // end function 
	
	
	public function containsEntity(entity:BEntity):BEntity
	{
		return entity;
	} // end function */
	
	
	//**************************************** SET AND GET ******************************************
	
	
	private function get_zIndex():UInt
	{
		return _zIndex;
	}
	
	private function set_zIndex(value:UInt):UInt
	{
		//throw new Error("zIndex must be and integer greater than 1");
		/*if(_bmap)
		{
			if(_bmap.numChildren > value + 1)
			{
				_bmap.addChildAt(this, value);
			}
			else 
			{
				_bmap.addChildAt(this, _bmap.numChildren - 1);
			}
			
		}*/
		return _zIndex = value;
	}
	
	
	/*private function get_tx():UInt
	{
		return _tx;
	}
	
	private function set_tx(value:UInt):UInt
	{
		return _tx = value;
	}
	
	
	private function get_ty():UInt
	{
		return _ty;
	}
	
	private function set_ty(value:UInt):UInt
	{
		return _ty = value;
	}*/
	
	
	/*private function set_scale(value:Float):Float
	{
		value = Math.abs(value);
		scaleX = scaleY = value;
		_scale = value;
	}
	
	private function get_scale():Float
	{
		return _scale;
	}*/
	
	
	private function get_offsetX():Int
	{
		return _offsetX;
	}
	
	private function set_offsetX(value:UInt):Int
	{
		return _offsetX = value;
	}
	
	
	private function get_offsetY():Int
	{
		return _offsetY;
	}
	
	private function set_offsetY(value:UInt):Int
	{
		return _offsetY = value;
	}
	
	
	private function get_paralaxX():Float
	{
		return _paralaxX;
	}
	
	private function set_paralaxX(value:Float):Float
	{
		return _paralaxX = value;
	}
	
	
	private function get_paralaxY():Float
	{
		return _paralaxY;
	}
	
	private function set_paralaxY(value:Float):Float
	{
		return _paralaxY = value;
	}
	
	
	private function get_entities():Array<BEntity>
	{
		return _entities;
	}
	
	private function set_entities(value:Array<BEntity>):Array<BEntity>
	{
		/*var i:int = 0;
		for(i = 0; i < value.length; i++)
		{
			//rows = Math.floor(tiles[i].x/_bmap.tileWidth) > rows ? Math.floor(tiles[i].x/_bmap.tileWidth) : rows;
			//columns = Math.floor(tiles[i].y/_bmap.tileHeight) > rows ? Math.floor(tiles[i].x/_bmap.tileHeight) : columns;
			if(this)
			{
				
			}
			
		} // end for*/
		
		return _entities = value;
	}
	
	
	private function get_rows():UInt
	{
		return _rows;
	}
	
	
	private function get_columns():UInt
	{
		return _columns;
	}
	
	
	private function get_scene():BScene
	{
		return _scene;
	}
	
	
	/*override private function set_scaleX(value:Float):Void
	{
		//throw new Error("Cannot set the scaleX and scaleY properties of a BMapLayer. use the scale property instead.");
		//return;
	}
	
	override private function set_scaleY(value:Float):Void
	{
		//throw new Error("Cannot set the scaleX and scaleY properties of a BMapLayer. use the scale property instead.");
		//return;
	}*/
	
	
	// numTiles
	private function get_numEntities():Int
	{
		return _entities.length;
	}
	
	
	
}