package ;

import openfl.display.Bitmap;
import openfl.display.Sprite;
import openfl.display3D.Context3DRenderMode;
import openfl.errors.Error;
import openfl.geom.Rectangle;
import openfl.system.Capabilities;
import openfl.system.System;
import openfl.display.StageScaleMode;
import openfl.utils.ByteArray;

import haxe.Timer;

import openfl.Assets;
import openfl.Vector;

import starling.core.Starling;
import starling.display.Stage;
import starling.events.Event;
import starling.text.BitmapFont;
import starling.text.TextField;
import starling.textures.Texture;
import starling.textures.TextureAtlas;
import starling.utils.AssetManager;
import starling.utils.Max;
import starling.utils.RectangleUtil;
import starling.utils.StringUtil;

import starling.events.Event;

/**
 * ...
 * @author Rohaan Allport
 */
class MainNew extends Sprite
{

	public function new() 
	{
		super();
		// TODO : remove this shit in final
		var s:Sprite = new Sprite();
		s.graphics.clear();
		s.graphics.beginFill(0xFFFFFF, 1);
		s.graphics.drawCircle(0, 0, 50);
		s.graphics.endFill();
		addChild(s);
		

	}
	
	


}
