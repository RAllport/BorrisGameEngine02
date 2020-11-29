package borrisEngine.entities.paricles;

import starling.display.Image;
import starling.textures.Texture;

import borrisEngine.core.BGame;
import borrisEngine.entities.*;

/**
 * ...
 * @author Rohaan Allport
 */
class BCustomizableParticle extends BEulerEntity
{
	public var texture(get, set):Texture;
	
	private var _texture:Texture = BGame.sAssets.getTexture("particle round grad0000");
	
	
	public function new() 
	{
		super();
		
		//bitmapData = _texture;
		var image = addChild(new Image(_texture));
		image.x = -Math.ceil(image.width/2);
		image.y = -Math.ceil(image.height/2);
	}
	
	
	//**************************************** HANDLERS *********************************************
	
	
	//**************************************** FUNCTIONS ********************************************
	
	
	
	//**************************************** SET AND GET ******************************************
	
	private function get_texture():Texture 
	{
		return _texture;
	}
	
	private function set_texture(value:Texture):Texture 
	{
		if (_texture == value)
		{
			return _texture;
		}
		
		_texture = value;
		
		removeChildren();
		var image = addChild(new Image(_texture));
		image.x = -Math.ceil(image.width/2);
		image.y = -Math.ceil(image.height/2);
		
		return _texture;
	}
	
}