package;

import openfl.geom.Rectangle;
import starling.events.Event;
import starling.core.Starling;
import starling.core.Starling;
import starling.core.Starling;
import borrisEngine.TestLevelCreatorEntity;
import borrisEngine.utils.BSceneParser;
import openfl.Assets;

import openfl.Vector;
import openfl.display.Sprite;
//import openfl.Lib;

import borrisEngine.core.BorrisEngine;
import borrisEngine.core.BEntity;
import borrisEngine.core.BScene;
//import borrisEngine.core.BPhysicsWrapper;
import borrisEngine.core.BGame;

import starling.core.Starling;
import starling.display.Image;
import starling.display.MovieClip;
import starling.events.Event;
import starling.text.BitmapFont;
import starling.text.TextField;
import starling.textures.RenderTexture;
import starling.textures.Texture;
import starling.textures.TextureAtlas;
import starling.utils.AssetManager;

/**
 * ...
 * @author Rohaan Allport
 */
class Main extends BorrisEngine
{
	public static var menuScene:MenuScreen;
	public static var controlsScene:ControlsScreen;
	public static var achievementsScene:AchievementsScreen;
	public static var optionsScene:OptionsScreen;
	public static var creditsScene:CreditsScreen;
	

	public function new() 
	{
		super();

		if (stage != null)
			initializeStarling();
        else 
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
	}
	
	
	/**
	 * 
	 * @param	event
	 */
	private function onAddedToStage(event:Event):Void
	{
		removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		initializeStarling(true, 1, new Rectangle());
	} // end function
	
	
	/**
	 * 
	 */
	override private function start():Void
	{
		super.start();

		showStats = true;
		//showPhysicsLayer = true;
		
		/*var scene1:BScene = new BScene();
		
        var bg = scene1.addChild(new Image(BGame.sAssets.getTexture("BgPlanet6")));
		bg.x = 500;
		
		game.addScene(scene1);*/
		//var scene2 = game.addScene(new BScene());
		
		//var charImg1:Image = new Image(BGame.sAssets.getTexture("dashing blue backwards0001"));
		//scene2.addChild(charImg1);
		
		//var charImg2:Image = new Image(BGame.sAssets.getTexture("blue_circle0000"));
		//scene2.addChild(charImg2);
		
		var playScene = _game.addScene(new TestScene());
		//var sceneXML = Xml.parse(Assets.getText("assets/scene_test1.xml"));
		//var playScene = game.addScene(BSceneParser.parseScene(sceneXML));
		
		menuScene = cast(_game.addScene(new MenuScreen()));
		controlsScene = cast(_game.addScene(new ControlsScreen()));
		achievementsScene = cast(_game.addScene(new AchievementsScreen()));
		optionsScene = cast(_game.addScene(new OptionsScreen()));
		creditsScene = cast(_game.addScene(new CreditsScreen()));
		
		_game.switchScene(menuScene);
		
		//
		//levelEdit();
		//BorrisEngine.levelEditor.game = _game;
		//BorrisEngine.levelEditor.selectedScene = playScene;
		
	} // end function

}
