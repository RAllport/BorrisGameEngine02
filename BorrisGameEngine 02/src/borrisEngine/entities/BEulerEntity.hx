package borrisEngine.entities;

import openfl.Assets;
import openfl.events.TimerEvent;
import openfl.utils.Timer;
import openfl.geom.Point;

import starling.display.*;
import starling.events.*;
import starling.geom.Rectangle;
import starling.textures.Texture;

import borrisEngine.core.BEntity;

/**
 * ...
 * @author Rohaan Allport
 */
class BEulerEntity extends BEntity
{
	/**
	 * How long the entity has before it is removed in milliseconds.
	 */
	public var lifeSpan(get, set):Float;
	
	/**
	 * The speed of the entity.
	 */
	public var speed:Float;
	
	/**
	 * Horizontal component of speed.
	 */
	public var xVelocity:Float;
	
	/**
	 * Vertical component of speed.
	 */
	public var yVelocity:Float;
	
	/**
	 * The rate of change of yVelocity.
	 */
	public var gravity:Float;
	
	/**
	 *  The rate at which the particle should speed up.
	 */
	public var acceleration:Float;
	
	/**
	 * The the rate a whcih the entity will slow down.
	 */
	public var friction:Float;
	
	/**
	 * Allow the entity to point in the direction it is traveling.
	 */
	public var autoRotate:Bool;
	
	/**
	 * The rate at which the entity will spin (in degrees).
	 */
	public var spin:Float;
	
	/**
	 * The rate at whitch the entity's alpha property drops per update call.
	 */
	public var fadeSpeed:Float; 
	
	/**
	 * The rate at which the entity will spin.
	 * Negative value allow the entity to shrink.
	 */
	public var growSpeed:Float;
	
	/**
	 * The angle at which the entity will travel. (in degrees)
	 */
	public var angle:Float;
	
	
	private var _lifeSpanTimer:Timer;
	private var _lifeSpan:Float = Math.POSITIVE_INFINITY;
	
	
	/**
	 * 
	 */
	// TODO make EulerEnemy class and give it aiFunctions and collisionFunctions
	public function new() 
	{
		super();
		
		speed = 0;
		xVelocity = 0;
		yVelocity = 0;
		gravity = 0.5;
		acceleration = 0;
		friction = 0;
		autoRotate = false;
		spin = 0;
		fadeSpeed = 0;
		growSpeed = 0;
		angle = 0;
		
		active = true;
		
		lifeSpan = 2000;
		
		//color = 0xffffff;
		
		// testing
		/*graphics.beginFill(0xffffff, 1);
		graphics.drawCircle(0, 0, 5);
		graphics.endFill();*/
		//addChild(new Bitmap(Assets.getBitmapData("img/particle circle flat.png")));
		//var image = BTexture.createBitmap(Textures.EFFECTS_TA.getTexture("particle circle blur2 glow6 yellow0000"));
		//var image = addChild(BTexture.createBitmap(Textures.INDUSTRIAL_TA.getTexture("industrial platforn 1-1-10000")));
		//image.x = -Math.ceil(image.width/2);
		//image.y = -Math.ceil(image.height/2);
		//addChild(image);
		
	}
	
	//**************************************** HANDLERS *********************************************
	
	
	/**
	 * 
	 * @param	event
	 */
	override private function onAddedToStage(event:Event):Void 
	{
		super.onAddedToStage(event);
		
		// calculate the angle of the particle in radians
		//angle = this.rotation * (Math.PI / 180);
		yVelocity = Math.sin(angle) * speed;
		xVelocity = Math.cos(angle) * speed;
		if (Math.isFinite(_lifeSpan))
		{
			_lifeSpanTimer.reset();
			_lifeSpanTimer.start();
			_lifeSpanTimer.addEventListener(TimerEvent.TIMER, timerHandler);
		} // end if
		
	} // end function onAddedToStage
		
	
	/**
	 * 
	 * @param	event
	 */
	private function timerHandler(event:TimerEvent):Void
	{
		_lifeSpanTimer.removeEventListener(TimerEvent.TIMER, timerHandler);
		_scene.removeEntity(this);
	}
	
	
	//**************************************** FUNCTIONS ********************************************
	
	
	/**
	 * @inheritDoc
	 */
	override public function update():Void 
	{
		//super.update();
		
		/*
		 * 
		 */
		// BUG fix alpha and scale update
		if(x < BEntity.boundries.left || x > BEntity.boundries.right || y < BEntity.boundries.top || y > BEntity.boundries.bottom || alpha <= 0 || scaleX <= 0 || scaleY <= 0) 
		//if(x < BEntity.boundries.left || x > BEntity.boundries.right || y < BEntity.boundries.top || y > BEntity.boundries.bottom) 
		{
			if(!forceActive)
			{
				//destroy();
				_lifeSpanTimer.removeEventListener(TimerEvent.TIMER, timerHandler);
				_scene.removeEntity(this);
				active = false;
				return;
			}
		} // end if
		
		// if speed is equal to 0 then set autoRotate to false
		if(speed == 0)
		{
			autoRotate = false;
		}
	
		speed = Math.sqrt(xVelocity * xVelocity + yVelocity * yVelocity);
		angle = Math.atan2(yVelocity, xVelocity);
		
		// increase friction 
		if(speed > friction)
		{
			speed -= friction;
		}
		else
		{
			speed = 0;
		}
		
		// recalculate x and y velocities
		yVelocity = Math.sin(angle) * speed;
		xVelocity = Math.cos(angle) * speed;
		
		yVelocity += gravity; // add gravity to y velocity
		
		this.x += xVelocity;
		this.y += yVelocity;
		this.rotation += spin;
		this.alpha -= Math.abs(fadeSpeed);
		this.scaleX += growSpeed;
		this.scaleY += growSpeed;
		
		// allow the particle to point in the direction it is traveling
		if(autoRotate)
		{
			this.rotation = Math.atan2(yVelocity, xVelocity);
		}
		
		//trace(speed);
		//trace(xVelocity);
	} // end function update
	
	
	/**
	 * 
	 */
	private function removeListeners():Void
	{
		_lifeSpanTimer.stop();
		_lifeSpanTimer.removeEventListener(TimerEvent.TIMER, timerHandler);
	}
	
	
	/**
	 * @inheritDoc
	 */
	override public function destroy():BEntity
	{
		//trace("destroyed!");
		_lifeSpanTimer.stop();
		_lifeSpanTimer.removeEventListener(TimerEvent.TIMER, timerHandler);
		
		return super.destroy();
		
	} // end function destroy
	
	
	//**************************************** SET AND GET ******************************************
	
	
	private function get_lifeSpan():Float 
	{
		return _lifeSpan;
	}
	
	private function set_lifeSpan(value:Float):Float 
	{
		_lifeSpan = value;
		
		if (_lifeSpan > 0 && Math.isFinite(_lifeSpan))
		{
			if (_lifeSpanTimer == null)
			{
				_lifeSpanTimer = new Timer(_lifeSpan);
			}
			
			//if (!hasEventListener(TimerEvent.TIMER_COMPLETE))
			//{
				//_lifeSpanTimer.addEventListener(TimerEvent.TIMER, timerHandler);
			//}
		} // end if
		else
		{
			_lifeSpanTimer.removeEventListener(TimerEvent.TIMER, timerHandler);
			trace("");
		} // end else
		
		return _lifeSpan;
	}
	
}