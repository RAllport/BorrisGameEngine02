package borrisEngine.entities.paricles;

import openfl.Assets;
import openfl.display.*;

import borrisEngine.entities.*;
import borrisEngine.textures.*;

/**
 * ...
 * @author Rohaan Allport
 */
class ExplosionCore extends BEulerEntity
{

	public function new() 
	{
		super();
		
		//var image = addChild(BTexture.createBitmap(Textures.EFFECTS_TA.getTexture("explosion 01 core 010000")));
		var image = addChild(new Bitmap(Assets.getBitmapData("img/Effects/explosion 01 core 01.png")));
		//var image = addChild(BTexture.createTilemap(Assets.getBitmapData("img/Effects/explosion 01 core 01.png")));
		image.x = -Math.ceil(image.width/2);
		image.y = -Math.ceil(image.height / 2);
	}
	
	
	//**************************************** HANDLERS *********************************************
	
	
	//**************************************** FUNCTIONS ********************************************
	
	
	/**
	 * @inheritDoc
	 */
	override public function update():Void
	{
		super.update();
		
		
	} // end function update
	
	
	//**************************************** SET AND GET ******************************************
	
	
	
}