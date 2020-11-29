package borrisEngine;

import openfl.Assets;
import openfl.display.Bitmap;
import starling.utils.AssetManager;

import starling.textures.Texture;
import starling.textures.TextureAtlas;

import starling.text.BitmapFont;
import starling.text.TextField;

/**
 * ...
 * @author Rohaan Allport
 */
class BAssets
{
	
	// Texture Atlases
	//public static var BASIC_SHAPES_ATLAS:TextureAtlas = new TextureAtlas(Texture.fromBitmapData(new BasicShapesAtlas()), XML(new AtlasXmlGame()));
	//public static var SHIP_SPRITES_ATLAS:TextureAtlas = new TextureAtlas(Texture.fromBitmapData(new ShipTextureAtlas()), XML(new ShipAtlasXML()));
	//public static var EFFECTS_ATLAS:TextureAtlas = new TextureAtlas(Texture.fromBitmapData(new EffectsTextureAtlas()), XML(new EffectsAtlasXML()));
	//public static var ENEMIES_ATLAS:TextureAtlas = new TextureAtlas(Texture.fromBitmapData(new EnemiesTextureAtlas()), XML(new EnemiesAtlasXML()));
	public static var PLAYER_ATLAS:TextureAtlas = new TextureAtlas(Texture.fromBitmapData(Assets.getBitmapData("img/Main Char sprites.png")), Xml.parse(Assets.getText("img/Main Char sprites.xml")));
	//public static var ENVIRONMENT_ATLAS:TextureAtlas = new TextureAtlas(Texture.fromBitmapData(new EnvironmentTextureAtlas()), XML(new EnvironmentAtlasXML()));
	//public static var UI_ATLAS:TextureAtlas = new TextureAtlas(Texture.fromBitmapData(new UITextureAtlas()), XML(new UIAtlasXML()));
	//public static var SHIP_PARTS_ATLAS:TextureAtlas = new TextureAtlas(Texture.fromBitmapData(new ShipPartsTextureAtlas()), XML(new ShipPartsAtlasXML()));
	
	public static var assets:AssetManager = new AssetManager();
	

	public static function initialize() 
	{
		//assets = new AssetManager();
		
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
		
		assets.addTextureAtlas("enemy", new TextureAtlas(
		Texture.fromBitmapData(Assets.getBitmapData("graphics/Enemy Sprites [FLCC]2.png"), false), 
		Xml.parse(Assets.getText("graphics/Enemy Sprites [FLCC]2.xml")).firstElement()));
		
		assets.addTextureAtlas("environment", new TextureAtlas(
		Texture.fromBitmapData(Assets.getBitmapData("graphics/Environment.png"), false), 
		Xml.parse(Assets.getText("graphics/Environment.xml")).firstElement()));
		
		assets.addTextureAtlas("UI", new TextureAtlas(
		Texture.fromBitmapData(Assets.getBitmapData("graphics/UI.png"), false), 
		Xml.parse(Assets.getText("graphics/UI.xml")).firstElement()));
		
		assets.addTextureAtlas("HUD", new TextureAtlas(
		Texture.fromBitmapData(Assets.getBitmapData("graphics/HUD.png"), false), 
		Xml.parse(Assets.getText("graphics/HUD.xml")).firstElement()));
		
		assets.addTextureAtlas("ship parts", new TextureAtlas(
		Texture.fromBitmapData(Assets.getBitmapData("graphics/Ship parts.png"), false), 
		Xml.parse(Assets.getText("graphics/Ship parts.xml")).firstElement()));
		
		assets.addTexture("BgStars1", Texture.fromBitmapData(Assets.getBitmapData("graphics/image_1_stars1.jpg"), false));
		assets.addTexture("BgStars2", Texture.fromBitmapData(Assets.getBitmapData("graphics/image_2_stars2.jpg"), false));
		assets.addTexture("BgPlanet1", Texture.fromBitmapData(Assets.getBitmapData("graphics/image_3_planet1.jpg"), false));
		assets.addTexture("BgPlanet2", Texture.fromBitmapData(Assets.getBitmapData("graphics/image_4_planet2.jpg"), false));
		assets.addTexture("BgPlanet3", Texture.fromBitmapData(Assets.getBitmapData("graphics/image_5_planet3.jpg"), false));
		assets.addTexture("BgPlanet4", Texture.fromBitmapData(Assets.getBitmapData("graphics/image_6_planet4.jpg"), false));
		assets.addTexture("BgPlanet5", Texture.fromBitmapData(Assets.getBitmapData("graphics/image_7_planet5.jpg"), false));
		assets.addTexture("BgPlanet6", Texture.fromBitmapData(Assets.getBitmapData("graphics/image_8_planet6.jpg"), false));
		
		
		// fonts
		var oCRTexture:Texture = Texture.fromBitmapData(Assets.getBitmapData("assets/fonts/font.png"), false);
		var oCRXml:Xml = Xml.parse(Assets.getText("assets/fonts/font.fnt")).firstElement();
		TextField.registerBitmapFont(new BitmapFont(oCRTexture, oCRXml));
	}
	
}