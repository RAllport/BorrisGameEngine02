package borrisEngine.core;

import openfl.errors.Error;
import starling.utils.RectangleUtil;
import borrisEngine.borrisPhysics.*;
import haxe.Timer;

import openfl.Assets;
import openfl.display.Sprite;
import openfl.display.*;
import openfl.display3D.Context3DRenderMode;
import openfl.geom.Rectangle;
import openfl.system.Capabilities;
import openfl.ui.Mouse;

import starling.core.Starling;
import starling.display.Image;
import starling.events.Event;
import starling.events.ResizeEvent;
import starling.text.BitmapFont;
import starling.text.TextField;
import starling.textures.RenderTexture;
import starling.textures.Texture;
import starling.textures.TextureAtlas;
import starling.utils.AssetManager;

/**
 * The Engine wrapper. Your app should extend this class.
 * The main OpenFL Sprite containing the Starling object.
 *
 * In your main class, run the initializeStarling() function.
 * Override the start() function if needed.
 * 
 * @author Rohaan Allport
 */
class BorrisEngine extends Sprite
{
    /**
    * Tne frame rate of the game.
    */
    public var frameRate(get, set):Float;

    /**
    * The physics engine the game is using.
    * Nape or Box2D
    */
    public var physicsEngineType(get, null):String;

    /**
    * For debugging purposes. Shows the Physics layer(s)
    */
    public var showPhysicsLayer(get, set):Bool;

    /**
    * For debugging purposes. Shows the Starling stats.
    */
    public var showStats(get, set):Bool;


    /**
    * The Sprite to draw the physics layer on.
    */
    private static var _physicsRenderSprite:Sprite;
    //public static var bDraw:BPhysicsDraw;

    /**
    * The main Starling object
    */
    private var _starling:Starling;

    /**
    * The Starling viewport. The resolution of the game.
    */
    private var _viewport:Rectangle;

    //private var _game:BSimulation;
    private var _physicsEngineType:String;
    private var _showStats:Bool;
    //private var _statsPanel:BGameStats;

    /**
    * The top level Starling Sprite.
    */
    private var _game:BGame;


    /**
    * Creates a new BorrisEngine object.
    *
    * This initializes the physics engine and the physicsRenderSprite to draw the physics engine on.
    */
    public function new(physicsEngineType:String = "nape")
    {
        super();


        _physicsRenderSprite = new Sprite();
        addChild(_physicsRenderSprite);
        BBasePhysicsWrapper.renderSprite = _physicsRenderSprite;
        BBasePhysicsWrapper.debugDrawing = false;

        // TODO accomodate for nape
        switch(_physicsEngineType)
        {
            case "nape":
                trace("Using Nape Physics.");

            case "box2d":
                trace("Using Box2D Physics.");

            case "borrisSimplePhysics":
                trace("Using Borris Simple Physics.");

            default:
                trace("Using Nape Physics.");
        } // end switch

    }


    //**************************************** HANDLERS *********************************************


    /**
	 *  Readjust the viewport of the window size changes.
	 *  NOTE do more R&D on this functionality.
	 *
	 * @param	event
	 */
    private function resizeHandler(event:ResizeEvent):Void
    {
        // set rectangle dimensions for viewPort:
        //var viewPortRectangle:Rectangle = new Rectangle(0, 0, event.width, event.height);
        var viewPortRectangle:Rectangle = new Rectangle(0, 0, 1920, 1080);

        // resize the viewport:
        //Starling.current.viewPort = viewPortRectangle;

        var viewPort:Rectangle = RectangleUtil.fit(viewPortRectangle, new Rectangle(0, 0, stage.stageWidth, stage.stageHeight));
        try
        {
            this._starling.viewPort = viewPort;
        }
        catch(error:Error) {}
    } // end function resizeHandler


    //**************************************** FUNCTIONS ********************************************


    public function initializeStarling(showStats:Bool = false, antiAliasing:UInt = 4, viewPort:Rectangle = null, stage3D:Stage3D = null):Void
    {
        stage.scaleMode = StageScaleMode.NO_SCALE;

        _showStats = showStats;
        //_starling.showStatsAt("left", "bottom", 1.5);

        // initialize starling
        //Starling.multitouchEnabled = true;

        _starling = new Starling(BGame, stage, viewPort, stage3D, Context3DRenderMode.AUTO, "auto");
        _starling.antiAliasing = antiAliasing;
        // BUG viewport gets offset when changed
        // FIXME fix the offset.
        _starling.stage.stageWidth = 1920;
        _starling.stage.stageHeight = 1080;
        _starling.enableErrorChecking = Capabilities.isDebugger;
        _starling.skipUnchangedFrames = true;
        _starling.simulateMultitouch = true;
        _starling.addEventListener(Event.ROOT_CREATED, function():Void
        {
            loadAssets(startGame);
        });

        //this.stage.addEventListener(Event.RESIZE, onResize, false, Max.INT_MAX_VALUE, true);
        //_starling.stage.addEventListener(starling.events.Event.RESIZE, handleStarlingStageResize);
        _starling.stage.addEventListener(ResizeEvent.RESIZE, resizeHandler);

        _starling.start();

    } // end function


    /**
	 *  Loads the game assets.
	 *  Runs the onComplete() function when done.
	 *
	 * @param	onComplete
	 */
    // TODO Look at new method in StarlingDemo
    private function loadAssets(onComplete:AssetManager -> Void):Void
    {
        var assets:AssetManager = new AssetManager();

        assets.verbose = Capabilities.isDebugger;

        Timer.delay(function()
        {
            /*#if flash
            assets.addSound("wing_flap", Assets.getSound("assets/audio/wing_flap.mp3"));
            #else
            assets.addSound("wing_flap", Assets.getSound("assets/audio/wing_flap.ogg"));
            #end*/

            //var mainCharTexture:Texture = Texture.fromBitmapData(Assets.getBitmapData("graphics/Main Char sprites.png"));
            var mainCharTexture:Texture = Texture.fromBitmapData(Assets.getBitmapData("graphics/Main Char sprites.png"), false);
            var mainCharXml:Xml = Xml.parse(Assets.getText("graphics/Main Char sprites.xml")).firstElement();
            assets.addTextureAtlas("main char", new TextureAtlas(mainCharTexture, mainCharXml));

            var BASIC_SHAPES_ATLAS:TextureAtlas = new TextureAtlas(
            Texture.fromBitmapData(Assets.getBitmapData("graphics/basic_shapes.png"), false),
            Xml.parse(Assets.getText("graphics/basic_shapes.xml")).firstElement());
            assets.addTextureAtlas("basic shapes", BASIC_SHAPES_ATLAS);

            assets.addTextureAtlas("effects", new TextureAtlas(
            Texture.fromBitmapData(Assets.getBitmapData("graphics/Effects.png"), false),
            Xml.parse(Assets.getText("graphics/Effects.xml")).firstElement()));

            /*assets.addTextureAtlas("enemy", new TextureAtlas(
			Texture.fromBitmapData(Assets.getBitmapData("graphics/Enemy Sprites [FLCC]2.png"), false), 
			Xml.parse(Assets.getText("graphics/Enemy Sprites [FLCC]2.xml")).firstElement()));*/

            assets.addTextureAtlas("environment", new TextureAtlas(
            Texture.fromBitmapData(Assets.getBitmapData("graphics/Environment.png"), false),
            Xml.parse(Assets.getText("graphics/Environment.xml")).firstElement()));

            assets.addTextureAtlas("UI", new TextureAtlas(
            Texture.fromBitmapData(Assets.getBitmapData("graphics/UI.png"), false),
            Xml.parse(Assets.getText("graphics/UI.xml")).firstElement()));

            assets.addTextureAtlas("HUD", new TextureAtlas(
            Texture.fromBitmapData(Assets.getBitmapData("graphics/HUD.png"), false),
            Xml.parse(Assets.getText("graphics/HUD.xml")).firstElement()));

            assets.addTextureAtlas("Enemy spider unit01", new TextureAtlas(
            Texture.fromBitmapData(Assets.getBitmapData("graphics/Enemy spider unit01.png"), false),
            Xml.parse(Assets.getText("graphics/Enemy spider unit01.xml")).firstElement()));

            assets.addTextureAtlas("Enemy standing robot unit 01", new TextureAtlas(
            Texture.fromBitmapData(Assets.getBitmapData("graphics/Enemy standing robot unit 01.png"), false),
            Xml.parse(Assets.getText("graphics/Enemy standing robot unit 01.xml")).firstElement()));


            /*assets.addTexture("BgStars1", Texture.fromBitmapData(Assets.getBitmapData("graphics/image_1_stars1.jpg"), false));
			assets.addTexture("BgStars2", Texture.fromBitmapData(Assets.getBitmapData("graphics/image_2_stars2.jpg"), false));
			assets.addTexture("BgPlanet1", Texture.fromBitmapData(Assets.getBitmapData("graphics/image_3_planet1.jpg"), false));
			assets.addTexture("BgPlanet2", Texture.fromBitmapData(Assets.getBitmapData("graphics/image_4_planet2.jpg"), false));
			assets.addTexture("BgPlanet3", Texture.fromBitmapData(Assets.getBitmapData("graphics/image_5_planet3.jpg"), false));
			assets.addTexture("BgPlanet4", Texture.fromBitmapData(Assets.getBitmapData("graphics/image_6_planet4.jpg"), false));
			assets.addTexture("BgPlanet5", Texture.fromBitmapData(Assets.getBitmapData("graphics/image_7_planet5.jpg"), false));
			assets.addTexture("BgPlanet6", Texture.fromBitmapData(Assets.getBitmapData("graphics/image_8_planet6.jpg"), false));
			*/

            // fonts
            var oCRTexture:Texture = Texture.fromBitmapData(Assets.getBitmapData("assets/fonts/font.png"), false);
            var oCRXml:Xml = Xml.parse(Assets.getText("assets/fonts/font.fnt")).firstElement();
            //TextField.registerCompositor(oCRTexture, oCRXml);

            onComplete(assets);
        }, 0);

    }


    /**
	 * Gets the BGame object (root Starling Sprite) and runs its BGame.start() function
	 *
	 * @param	assets
	 */
    // TODO Remove assets perameter and find a different way to load assets
    private function startGame(assets:AssetManager):Void
    {
        _game = cast(_starling.root, BGame);
        _game.start(assets);

        start();

    } // end function


    /**
	 * Override this function in your main class
	 */
    private function start():Void
    {

    } // end function


    public static var levelEditor:LevelEditor;
    /**
	 * 
	 */
    private function levelEdit():Void
    {
        var levelEditor:LevelEditor = BorrisEngine.levelEditor = new LevelEditor(this);
        BorrisEngine.levelEditor.renderSprite = cast(addChild(new Sprite()), Sprite);
        Timer.delay(function():Void
        { Mouse.show(); }, 3000);
    } // end function



    //**************************************** SET AND GET ******************************************

    private function get_frameRate():Float
    {
        return stage.frameRate;
    }

    private function set_frameRate(value:Float):Float
    {
        stage.frameRate = value;
        return stage.frameRate;
    }


    private function get_physicsEngineType():String
    {
        return _physicsEngineType;
    }


    private function get_showPhysicsLayer():Bool
    {
        return _physicsRenderSprite.visible;
    }

    private function set_showPhysicsLayer(value:Bool):Bool
    {
        _physicsRenderSprite.visible = value;
        return _physicsRenderSprite.visible;
    }


    private function get_showStats():Bool
    {
        return _starling.showStats;
    }

    private function set_showStats(value:Bool):Bool
    {
        _starling.showStats = value;
        _starling.showStatsAt("left", "bottom", (value ? 1.5 : 0));
        return _starling.showStats;
    }


}