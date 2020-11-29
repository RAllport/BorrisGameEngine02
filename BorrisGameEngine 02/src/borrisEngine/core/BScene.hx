package borrisEngine.core;

import borrisEngine.borrisPhysics.BBox2DPhysicsWrapper;
import openfl.Assets;

import starling.core.Starling;
import starling.display.*;
import starling.events.*;
import starling.geom.*;

import borrisEngine.entities.BCamera2D;
import borrisEngine.components.*;


/**
 * ...
 * @author Rohaan Allport
 */
class BScene extends Sprite
{
	public static var pool:BEntityPool = new BEntityPool();
	
	/**
	 * Gets the main default BCamera2D of the scene.
	 */
	public var mainCamera(get, never):BCamera2D;
	
	/**
	 * Gets the total number of entities in the scene.
	 */
	public var numEntitys(get, never):Int;
	
	/**
	 * Gets the total number of entities in the scene.
	 */
	public var numLayers(get, never):Int;
	
	/**
	 * The currently selected layer that entities are added to.
	 */
	public var currentLayer(get, set):BLayer;
	
	
	@:allow(borrisEngine.core.BLayer)
	//@:allow(borrisEngine.utils.BSceneParser)
	private var _entities:Array<BEntity>;
	//@:allow(borrisEngine.utils.BSceneParser)
	private var _layers:Array<BLayer>;
	private var _currentLayer:BLayer;
	private var _mainCamera:BCamera2D;
	
	
	// TODO make read-only
	public var physics:BBox2DPhysicsWrapper;
	//public var physics:Dynamic;
	
	private var _game:BGame;
	
	private var _sOriginX:Float = 0;
	private var _sOriginY:Float = 0;
	
	
	/**
	 * 
	 */
	public function new() 
	{
		super();
		
		_entities = new Array<BEntity>();
		_layers = new Array<BLayer>();
		
		// make at least one layer
		_currentLayer = addLayer(new BLayer());
		
		// make the main camera
		_mainCamera = cast(addEntity(new BCamera2D(this, 1280, 720, true, null, false)), BCamera2D);
		_mainCamera.name = "main camera";
		
		// make the physics
		physics = new BBox2DPhysicsWrapper();
		
		visible = false;
		
		// TODO figure out why th second methed won't work
		//pool = new BEntityPool();
		//pool = BEntityManager.createPoolByName(name + " Pool", new Rectangle(0, 0, stage.stageWidth, stage.stageHeight));
		//trace("Pool name: " + pool.name);
		
		
		// event handling
		addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		
	}
	
	
	//**************************************** HANDLERS *********************************************
	
	
	/**
	 * 
	 * @param	event
	 */
	private function onAddedToStage(event:Event):Void
	{
		_game = cast(parent, BGame);
		
		// make the physics
		//physics = new BPhysicsWrapper();
		
		initialize();
		removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
	} // end function
	
	
	//**************************************** FUNCTIONS ********************************************
	
	
	/**
	 * Override this function.
	 */
	private function initialize():Void
	{
		
	} // end function initialize
	
	
	/**
	 * Updates the scene.
	 * Called in Game.update().
	 */
	public function update():Void
	{
		// NOTE this may fuck you up later. Either validate to make sure the camera has a default target or find another
		// way to change the entity boundries.
		BEntity.boundries.x = _mainCamera.targetCam.x - stage.stageWidth / 2;
		BEntity.boundries.y = _mainCamera.targetCam.y - stage.stageHeight / 2;
		
		//trace("Bounds: " + BEntity.boundries);
		
		//trace("Scene Updating: " + name);
		for (entity in _entities)
		{
			//entity.update();
			
			//if (entity.active)
			if (entity.forceActive)
			{
				entity.update();
			}
			else if (entity.active && entity.x >= BEntity.boundries.left && entity.x <= BEntity.boundries.right && entity.y >= BEntity.boundries.top && entity.y <= BEntity.boundries.bottom)
			{
				entity.update();
			}
			
			/*if(!entity.forceActive && (entity.x < _minX || entity.x > _maxX || entity.y < _minY || entity.y > _maxY))
			{
				//entity.destroy();
				entity.scene.removeEntity(entity);
			}
			else
				entity.update();*/
			
		} // end for 
		//pool.updateEntities();
		
		// update the physics
		physics.update();
		
		
		// testing layer paralxing
		for (layer in _layers)
		{
			
			if(_mainCamera.targetCam != null)
			{
				layer.x = - _sOriginX + _mainCamera.targetCam.x * layer.paralaxX;
				layer.y = - _sOriginY + _mainCamera.targetCam.y * layer.paralaxY;
			} // end if
			
		} // end for
		
	} // end function update
	
	
	/**
	 * 
	 * @param	entity
	 * @return
	 */
	// TODO add index
	public function addEntity(entity:BEntity):BEntity
	{
		/*entity._scene = this;
		_entities.push(entity);
		_currentLayer.addChild(entity);
		_currentLayer.entities.push(entity);
		*/
		_currentLayer.addEntity(entity);
		
		return entity;
	} // end function 
	
	
	/**
	 * 
	 * @param	entity
	 * @param	index
	 * @return
	 */
	/*public function addEntityAt(entity:BEntity, index:Int):BEntity
	{
		return entity;
	} // end function*/
	
	
	/**
	 * Removes a BEntity instance from this BScene.
	 * 
	 * 
	 * @param	entity The BEntity instance to be removed from this BScene.
	 * @return
	 */
	public function removeEntity(entity:BEntity):BEntity
	{
		/*entity._scene = null;
		entity.active = false;
		_entities.remove(entity);
		entity.parent.removeChild(entity);
		/*for ()
		{
			
		} // end for */
		
		_currentLayer.removeEntity(entity);
		
		return entity;
	} // end function 
	
	
	/**
	 * 
	 * @param	index
	 * @return
	 */
	public function getEntityAt(index:Int):BEntity
	{
		return _entities[index];
	} // end function
	
	
	/**
	 * 
	 * @return
	 */
	public function getEntityByName(name:String):BEntity
	{
		for (entity in _entities)
		{
			if (entity.name == name)
			{
				return entity;
			} // end if
		} // end for
		
		return null;
	} // end function
	
	/**
	 * 
	 * @param	name
	 * @return
	 */
	public function addLayer(layer:BLayer, name:String = null, ?zIndex:UInt):BLayer
	{
		if (layer.name == null)
		{
			layer.name = name != null ? name : "layer " + (_layers.length + 1);
		} // end if
		layer._scene = this;
		//zIndex = zIndex == null ? _layers.length - 1 : zIndex;
		zIndex = zIndex == null ? 0 : zIndex;
		//zIndex = zIndex == null ? layers.length : zIndex;
		zIndex = zIndex > (_layers.length + 1) ? (_layers.length + 1) : zIndex;
		_layers.insert(zIndex, layer);
		layer.zIndex = zIndex;
		
		addChildAt(layer, zIndex);
		//addChild(layer);
		
		return layer;
	} // end function
	
	
	/**
	 * 
	 * @param	layer
	 * @return
	 */
	public function removeLayer(layer:BLayer):BLayer
	{
		_currentLayer = if (_layers.indexOf(layer) - 1 >= 0) _layers[_layers.indexOf(layer) - 1]; else if(_layers.indexOf(layer) + 1 < _layers.length) _layers[_layers.indexOf(layer) + 1]; else null;
		
		layer._scene = null;
		for (entity in layer.entities)
		{
			_entities.remove(entity);
		} // end for
		//_layers.splice(_layers.indexOf(layer), 1);
		_layers.remove(layer);
		removeChild(layer);
		
		return layer;
	} // end function 
	
	
	/**
	 * 
	 * @param	index
	 * @return
	 */
	public function removeLayerAt(index:Int):BLayer
	{
		var layer:BLayer = _layers[index];
		_currentLayer = if (_layers.indexOf(layer) - 1 >= 0) _layers[_layers.indexOf(layer) - 1]; else if (_layers.indexOf(layer) + 1 < _layers.length) _layers[_layers.indexOf(layer) + 1]; else null;
		
		//var layer:BLayer = _layers.splice(index, 1)[0];
		_layers.remove(layer);
		for (entity in layer.entities)
		{
			_entities.remove(entity);
		} // end for
		removeChildAt(index);
		layer._scene = null;
		
		return layer;
	} // end function 
	
	
	/**
	 * 
	 * @param	index
	 * @return
	 */
	public function getLayerAt(index:Int):BLayer
	{
		return _layers[index];
	} // end function 
	
	
	// TODO create switchLayer function
	/*public function switchLayer():Void
	{
		
	} // end function*/
	
	
	//**************************************** SET AND GET ******************************************
	
	
	private function get_mainCamera():BCamera2D
	{
		return _mainCamera;
	}
	
	
	private function get_numEntitys():Int
	{
		return _entities.length;
	}
	
	
	private function get_numLayers():Int
	{
		return _layers.length;
	}
	
	
	private function get_currentLayer():BLayer
	{
		return _currentLayer;
	}
	
	private function set_currentLayer(value:BLayer):BLayer
	{
		if (_layers.indexOf(value) >= 0)
		{
			_currentLayer = value;
		}
		
		return _currentLayer;
	}
	
	
}