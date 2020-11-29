package borrisEngine.entities;

import borrisEngine.core.BEntity;

import openfl.Assets;
import openfl.display.*;
import openfl.events.Event;

/**
 * ...
 * @author Rohaan Allport
 */
class BVerletEntity extends BEntity
{
	public var vx(get, set):Float;
	public var vy(get, set):Float;
	public var setX(never, set):Float;
	public var setY(never, set):Float;
	
	public var xPos:Float = 0;
	public var yPos:Float = 0;
	
	private var _previousX:Float = 0;
	private var _previousY:Float = 0;
	private var _tempX:Float = 0;
	private var _tempY:Float = 0;
	

	public function new() 
	{
		super();
		
		
		// testing
		addChild(new Bitmap(Assets.getBitmapData("img/particle circle flat.png")));
		
	}
	
	
	//**************************************** HANDLERS *********************************************
	
	
	
	//**************************************** FUNCTIONS ********************************************
	
	
	/**
	 * @inheritDoc
	 */
	override public function update():Void
	{
		super.update();
		
		//Verlet integration
		//1. Temporarily store the current x and y positions 
		_tempX = xPos;
		_tempY = yPos;
		
		//2. Move the object 
		xPos += vx; 
		yPos += vy; 
		
		//3. The position before the object was moved becomes the 
		//previous position, which is used calculate velocity
		_previousX = _tempX; 
		_previousY = _tempY;
		
		
		// testing
		x = xPos;
		y = yPos;
		
		if(x < 0 || x > stage.stageWidth || y < 0 || y > stage.stageHeight) 
		{
			_scene.removeEntity(this);
		}
		
	} // end function update
	
	
	/**
	 * @inheritDoc
	 */
	override public function destroy():BEntity
	{
		//trace("destroyed!");
		//_lifeSpanTimer.stop();
		//_lifeSpanTimer.removeEventListener(TimerEvent.TIMER, timerHandler);
		
		active = false;
		visible = false;
		
		/*if(parent != null)
		{
			parent.removeChild(this);
			//trace("Entity die() at: " + getTimer() + " type: " + type);
		}*/
		
		return super.destroy();
		
	} // end function destroy
	
	
	//**************************************** SET AND GET ******************************************
	
	
	/**
	 * Gets or sets the horizontal component of velocuty
	 */
	private function get_vx():Float
	{
		return xPos - _previousX;
	}
	
	private function set_vx(value:Float):Float
	{
		_previousX = xPos - value;
		return value;
	}
	
	
	/**
	 * Gets or sets the vertical component of velocuty
	 */
	private function get_vy():Float
	{
		return yPos - _previousY;
	}
	
	private function set_vy(value:Float):Float
	{
		_previousY = yPos - value;
		return value;
	}
	
	
	/**
	 * physics x
	 */
	private function set_setX(value:Float):Float
	{
		_previousX = value - vx;
		xPos = value;
		return value;
	}
	
	
	/**
	 * physics y
	 */
	private function set_setY(value:Float):Float
	{
		_previousY = value - vy;
		yPos = value;
		return value;
	}
	
	
}