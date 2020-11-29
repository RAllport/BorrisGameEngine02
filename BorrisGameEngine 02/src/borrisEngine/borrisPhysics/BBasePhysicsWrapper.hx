package borrisEngine.borrisPhysics;

import openfl.display.*;

import borrisEngine.ui.BStarlingInput;


/**
 * A wrapper to manage the physics of the application.
 * 
 * @author Rohaan Allport
 */
class BBasePhysicsWrapper
{
	
	// for testing
	// Sprite to draw into (debug draw)
	public static var renderSprite:Sprite;
	public static var debugDrawing:Bool = false; // TODO debug draw causes major performance issues on certain targets. Make a warning!
	
	
	// world mouse position
	static public var mouseXWorldPhys:Float;
	static public var mouseYWorldPhys:Float;
	static public var mouseXWorld:Float;
	static public var mouseYWorld:Float;
	
	
	private static var _factoriesInitialized:Bool = false;
	
	
	/**
	 * Contructs a new BPhysicsWrapper object.
	 */
	public function new() 
	{
		
	}
	
	
	//**************************************** HANDLERS *********************************************
	
	
	
	//**************************************** FUNCTIONS ********************************************
	
	
	/**
	 * 
	 */
	public function update():Void 
	{
		
	} // end function update
	
	
	/**
	 * for flash display objects
	 * 
	 * @param	bodyToFollow
	 * @param	renderSprite
	 * @param	following
	 * @param	physScale
	 * @param	mouseNudge
	 */
	/*public function updateCamera(bodyToFollow:B2Body, renderSprite:flash.display.Sprite, following:Bool = true, physScale:Float = 40, mouseNudge:Bool = false):Void
	{
		var posX:Float = 0;
		var posY:Float = 0;
		
		if(following) 
		{
			posX = bodyToFollow.getWorldCenter().x * physScale;
			posY = bodyToFollow.getWorldCenter().y * physScale;
			
		}
		
		
		//renderSprite.x = renderSprite.stage.stageWidth/2 - posX;
		//renderSprite.y = renderSprite.stage.stageHeight/2 - posY;
		//trace("render sprite X: " + renderSprite.x);
		//trace("render sprite Y: " + renderSprite.y);
		
	} // end function*/
	
	
	/**
	 * 
	 */
	public function updateMouseWorld():Void
	{
		
	}  // end function
	
	
	/**
	 * 
	 */
	public function mouseDrag():Void
	{
		
	} // end function
	
	
	/**
	 * 
	 */
	public function mouseDestroy():Void
	{
		
	} // end function
	
	
	/**
	 * 
	 * @param	includeStatic
	 * @return
	 */
	/*public function getBodyAtMouse(includeStatic:Bool = false):B2Body 
	{
		
	} // end function*/
	
	
	//**************************************** SET AND GET ******************************************
	
	
}