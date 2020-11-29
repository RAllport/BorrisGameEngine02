package borrisEngine.entities.paricles;

import openfl.Assets;
import openfl.display.*;

import borrisEngine.entities.*;
import borrisEngine.textures.*;

/**
 * ...
 * @author Rohaan Allport
 */
class ExplosionArms extends BEulerEntity
{

	public function new() 
	{
		super();
		
		var image = addChild(new Bitmap(Assets.getBitmapData("img/Effects/explosion 01 core 03.png")));
		image.x = -Math.ceil(image.width/2);
		image.y = -Math.ceil(image.height/2);
		
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