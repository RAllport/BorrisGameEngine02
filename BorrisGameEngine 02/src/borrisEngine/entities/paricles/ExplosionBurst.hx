package borrisEngine.entities.paricles;

import flash.filters.GlowFilter;
import openfl.Assets;
import openfl.display.*;
import openfl.geom.Point;
import openfl.geom.Rectangle;

import borrisEngine.entities.*;
import borrisEngine.textures.*;

/**
 * ...
 * @author Rohaan Allport
 */
class ExplosionBurst extends BEulerEntity
{

	public function new() 
	{
		super();
		
		var bitmapData = Assets.getBitmapData("img/Effects/explosion 01 core 02.png");
		//bitmapData.applyFilter(bitmapData, new Rectangle(0, 0, bitmapData.width, bitmapData.height), new Point(), 
		//new GlowFilter(0x0000ff, 1, 8, 8, 3, 1));
		
		var image = addChild(new Bitmap(bitmapData));
		image.x = -Math.ceil(image.width/2);
		image.y = -Math.ceil(image.height/2);
		
		//image.filters = [new GlowFilter(0x0000ff, 1, 8, 8, 3, 1)];
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