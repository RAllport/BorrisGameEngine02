package borrisEngine.core;

import borrisEngine.borrisPhysics.*;
import haxe.Timer;

import openfl.geom.*;
import openfl.ui.Keyboard;

import starling.core.Starling;
import starling.display.Sprite;
import starling.display.*;
import starling.events.*;
import starling.utils.*;
//import starling.extensions.fluocode.*;
import starling.filters.*;
import starling.textures.*;
import starling.text.*;

import borris.managers.BSoundHandler;
import borrisEngine.ui.BStarlingInput;
import borrisEngine.utils.createPhysics.CreateShape;

/**
 * The Starling root class.
 * 
 * @author Rohaan Allport
 */
class BGame extends Sprite
{
    // NOTE May actually be able to change many of these to (default, null)
    /**
    * The total number of BScene object in this BGame
    */
	public var numScenes(get, never):Int;
	//public var numScenes(default, null):Int;

    /**
    * The current active BScene (visiable, rendering, and updating)
    */
	public var currentScene(get, null):BScene;

    // NOTE May not need the following 3 properties.#else
    // @see Starling.events.EnterFrameEvent
    /**
    * Ummm...
    */
	public static var currentTime(get, null):Float;

    /**
    * Ummm...
    */
	public static var previousTime(get, null):Float;

    /**
    * Ummm...
    */
	public static var deltaTime(get, null):Float;
	
	//public static var gameLevelsXMLs:Array = new Array();
		
	// simulation state variables
	//private var _new:Bool;
	//private var _started:Bool;
	//private var _paused:Bool;
	//private var _over:Bool;
	
	
	// New Engine vars
	private var _scenes:Array<BScene>;
	private var _currentScene:BScene;
	private static var _currentTime:Float = 0;
	private static var _previousTime:Float = 0;
	private static var _deltaTime:Float = 0;
	
	public static var sAssets:AssetManager;
	
	// for testing and debugging
	public var showStats:Bool = false;
	public var sceneSwitching:Bool = false;
	

	public function new() 
	{
		super();

		name = "Game";

        // NOTE optimization technique to reduce draws.
		this.alpha = 0.999;

		_scenes = new Array<BScene>();
		
		
		// event handling
		addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

	}
	
	
	//**************************************** HANDLERS *********************************************

    /**
	* Initialize the BStarlingInput and BEntity.boundries
    */
	private function onAddedToStage(event:starling.events.Event):Void
	{
		BStarlingInput.initialize(this.stage);
		BEntity.boundries = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
		
		removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		addEventListener(EnterFrameEvent.ENTER_FRAME, enterFrameHandler);

        // TODO create this
		//addEventListener(GameNavigationEvent.START_GAME, startGame);
		//addEventListener(GameNavigationEvent.START_GAME, initializeGame);
		
	} //  end function onAddedToStage
	
	
	/**
	 * Main game loop. Called every frame.
	 * 
	 * @param event
	 */
	private function enterFrameHandler(event:EnterFrameEvent):Void
	{
		// for testing and debugging
		/*if (debugDraw)
		{
			
		}
		if (testing)
		{
			
		}
		if (flyMode)
		{
			
		}
		if(showStats)
		{
			// update counter and limit framerate
			Main.fpsCounter.update();
			//FRateLimiter.limitFrame(30);
		}
		*/
		/*if (sceneSwitching)
		{
			if (BStarlingInput.keyPressed(Keyboard.RIGHT) || BStarlingInput.keyPressed(Keyboard.SHIFT))
			{
				trace("Switching BScene!: " + (_scenes.indexOf(_currentScene) + 1));
				//switchScene(getSceneAt(_scenes.indexOf(_currentScene + 1)));
			}
			
			if (BStarlingInput.keyPressed(Keyboard.LEFT) || BStarlingInput.keyPressed(Keyboard.SHIFT))
			{
				trace("Switching BScene!: " + (_scenes.indexOf(_currentScene) - 1));
				//switchScene(getSceneAt_scenes.indexOf(_currentScene + 1)));
			}
		}*/
		
		if(BorrisEngine.levelEditor != null)
			BorrisEngine.levelEditor.update();
		
		// call update function
		update();
		//BorrisEngine.bDraw.update();
		
		// update Starling input.
		// this should always be called last in the game loop.
		BStarlingInput.update();
		
	} // end function
	
	
	
	//**************************************** FUNCTIONS ********************************************
	
	/**
	 * Starts the BGame.
	 * NOTE Currently has no purpose
	 * @param	assets
	 */
	public function start(assets:AssetManager):Void
    {
        sAssets = assets;
    } // end function
	
	
	/**
	 * Updates the game object
	 * Called in the main game loop.
	 */
	public function update():Void
	{
		_currentTime = Timer.stamp();
		_deltaTime = (_currentTime - _previousTime);
		
		if (_currentScene != null)
		{
			_currentScene.update();
		} // end if
		
		//_previousTime = Timer.stamp();
		_previousTime = _currentTime;
		
		// update Starling input.
		// this should always be called last in the game loop.
		//BStarlingInput.update();
		
	} // end function update
	
	
	/**
	 * Adds a BScene to the list of BScene objects.
	 *
	 * @param scene
	 */
	public function addScene(scene:BScene):BScene
	{
        scene.name = scene.name == null ? "Scene " + _scenes.length : scene.name;
		
		_scenes.push(scene);
		addChild(scene);
		
		if (_scenes.length == 1)
		{
			switchScene(scene);
		}
		
		return scene;
	} // end function
	
	
	/**
	 * Removes a BScene from the list of BScene objects.
	 *
	 * If the scene  being removed is the current scene, the current scene is automatically switch to the scene
	 * 1 index placement below.
	 * If the scene being removed is at index 0, then the current scene is switched to the scene 1 index above.
	 *
	 * @param scene
	 */
	public function removeScene(scene:BScene):BScene
	{
		if (scene == _currentScene && _scenes.indexOf(scene) != 0)
		{
			switchScene(getSceneAt(_scenes.indexOf(scene) - 1));
		}
        else
        {
            switchScene(getSceneAt(_scenes.indexOf(scene) + 1));
        }
		
		_scenes.remove(scene);
		removeChild(scene);
		
		return scene;
	} // end 
	
	
	/**
	 * Retrieves the BScene at the specified index.
	 *
	 * @param index The index of the BScene to be retrieved.
	 *
	 * @return The BScene at the specified index location.
	 */
	public function getSceneAt(index:Int):BScene
	{
		return _scenes[index];
	} // end function
	
	
	
	// TODO implement daylay (milliseconds)
	// TODO dispatch a scene switch event
	// TODO rename Game to BSimulation?
	/**
	 * Switches the scene to the scene object specified. If a delay is required, use the delay parameter.
	 * 
	 * @param	scene
	 * @param	delay
	 */
	public function switchScene(scene:BScene, delay:Int = 0):BScene
	{
		var tempScene:BScene = null;
		
		Timer.delay(function()
		{
			for (i in 0..._scenes.length)
			{
				tempScene = _scenes[i];
				tempScene.visible = false;
				
				if (scene == tempScene)
				{
					scene.visible = true;
					_currentScene = scene;
				}
				
			} // end for
			
			BEntity.boundries = new Rectangle(0, 0, stage.stageWidth * 2, stage.stageHeight * 2); // working sort of
			CreateShape.world = scene.physics.world;
		
		}, delay);
		
		return scene;
	} // end function
	
	
	//**************************************** SET AND GET ******************************************
	
	
	private function get_numScenes():Int
	{
		return _scenes.length;
	}
	
	
	private function get_currentScene():BScene 
	{
		return _currentScene;
	}
	
	
	private static function get_currentTime():Float 
	{
		return _currentTime;
	}
	
	
	private static function get_previousTime():Float 
	{
		return _previousTime;
	}
	
	
	private static function get_deltaTime():Float 
	{
		return _deltaTime;
	}
	
	
}