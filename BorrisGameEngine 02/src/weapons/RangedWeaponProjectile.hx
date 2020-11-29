package weapons;

import openfl.events.TimerEvent;
import openfl.utils.Timer;
import openfl.media.Sound;

import starling.events.Event;

import borris.managers.BSoundHandler;
import borrisEngine.components.BRigidBody2D;
import borrisEngine.core.BEntity;
import borrisEngine.core.BScene;

/**
 * ...
 * @author Rohaan Allport
 */
// BUG somewhere. projectiles falling in frist rect of scene
class RangedWeaponProjectile extends BEntity
{
	public var speed(get, set):Float;
	public var angle(get, set):Float;
	public var lifeSpan(get, set):Float;
	public var damage(get, set):Float;
	public var destroyOnContacts(get, set):Bool;
	public var autoRotate(get, set):Bool;
	public var hitFX(get, set):Class<BEntity>;
	public var hitSFX(get, set):Sound;
	
	
	private var _speed:Float = 10;
	private var _angle:Float = 0;
	private var _lifeSpan:Float;
	private var _damage:Float = 5;
	private var _destroyOnContacts:Bool = true;
	private var _autoRotate:Bool = false;
	private var _hitFX:Class<BEntity>;
	private var _hitSFX:Sound;
	// TODO implement these
	//private var _moves:Bool;
	//private var _doesExplode:Bool;
	//private var _applyGravity:Bool;
	//private var _gravityScale:Float;
	//private var _adhere:bool;
	//private var _follow:Bool;
	
	
	private var _body:BRigidBody2D;
	
	private var _lifeSpanTimer:Timer;
	
	
	public function new() 
	{
		super();
		
		_body = cast(addComponent(new BRigidBody2D()), BRigidBody2D);
		//_body.setShapeType("circle");
		//_body.setSize(10, 10);
		//_body.applyGravity = false;
		//_body.gravityScale = 0;
		//_body.type = "kinematic";
		_body.density = 4;
		_body.restitution = 1;
		//_body.friction = 0;
		_body.isSensor = true;
		_body.realBody.getUserData().name = "rangedWeaponProjectile";
		
		_body.groupIndex = -2;
		_body.bullet = true;
		//body.onContact = function():Void { destroy; };
		
		_lifeSpan = 1000;
		_lifeSpanTimer = new Timer(lifeSpan);
	}
	
	//**************************************** HANDLERS *********************************************
	
	
	/**
	 * @inheritDoc
	 * 
	 * @param	event
	 */
	override private function onAddedToStage(event:Event):Void 
	{
		super.onAddedToStage(event);
		
		//if (_speed == 0) _body.type = "kinematic";
		_body.linearVelocityX = Math.cos(_angle) * _speed;
		_body.linearVelocityY = Math.sin(_angle) * _speed;
		
		_lifeSpanTimer.reset();
		_lifeSpanTimer.start();
		
		_lifeSpanTimer.addEventListener(TimerEvent.TIMER, timerHandler);
		
	} // end function onAddedToStage
	
	
	/**
	 * 
	 * @param	event
	 */
	private function timerHandler(event:TimerEvent):Void
	{
		_lifeSpanTimer.removeEventListener(TimerEvent.TIMER, timerHandler);
		//_scene.removeEntity(this);
		destroy();
	}
	
	
	//**************************************** FUNCTIONS ********************************************
	
	
	/**
	 * @inheritDoc
	 */
	override public function update():Void
	{
		super.update();
		
		/*trace(body.numContacts);
		if (body.numContacts > 0)
		{
			//trace(body.numContacts);
			destroy;
		} // end if*/
		
		
		// TODO make a numContacts getter for the userdata contacts. see above
		if(Std.int(_body.realBody.getUserData().contacts) > 0)
		{
			if (_hitFX != null) _scene.addEntity(BScene.pool.getEntity(_hitFX));
			if (_hitSFX != null) BSoundHandler.playSound(_hitSFX);
			if (_destroyOnContacts) { destroy(); return; };
			
		} // end if
		
		if(x < BEntity.boundries.left || x > BEntity.boundries.right || y < BEntity.boundries.top || y > BEntity.boundries.bottom) 
		{
			if(!forceActive)
			{
				//trace("destroying reanged weapon projectile");
				destroy();
				return;
			}
		} // end if
		
		if(_autoRotate)
		{
			_body.angle = Math.atan2(_body.linearVelocityY, _body.linearVelocityX);// - Math.PI / 2;
		}
		
	} // end function update
	
	
	//**************************************** SET AND GET ******************************************
	
	
	private function get_speed():Float 
	{
		return _speed;
	}
	
	private function set_speed(value:Float):Float 
	{
		return _speed = value;
	}
	
	
	private function get_angle():Float 
	{
		return _angle;
	}
	
	private function set_angle(value:Float):Float 
	{
		return _angle = value;
	}
	
	
	private function get_lifeSpan():Float 
	{
		return _lifeSpan;
	}
	
	private function set_lifeSpan(value:Float):Float 
	{
		return _lifeSpan = _lifeSpanTimer.delay = value;
	}
	
	
	private function get_damage():Float 
	{
		return _damage;
	}
	
	private function set_damage(value:Float):Float 
	{
		return _damage = value;
	}
	
	
	private function get_destroyOnContacts():Bool 
	{
		return _destroyOnContacts;
	}
	
	private function set_destroyOnContacts(value:Bool):Bool 
	{
		if (_destroyOnContacts == value)
			return value;
		/*else
		{
			body.onContact = if (value) function():Void { destroy; } else function():Void {};
		}*/
		else
		{
			_destroyOnContacts = _body.isSensor = value;
		} // end else
		
		return _destroyOnContacts;
	}
	
	
	private function get_autoRotate():Bool 
	{
		return _autoRotate;
	}
	
	private function set_autoRotate(value:Bool):Bool 
	{
		return _autoRotate = _body.fixedRotation = value;
	}
	
	
	private function get_hitFX():Class<BEntity> 
	{
		return _hitFX;
	}
	
	private function set_hitFX(value:Class<BEntity>):Class<BEntity> 
	{
		return _hitFX = value;
	}
	
	
	private function get_hitSFX():Sound 
	{
		return _hitSFX;
	}
	
	private function set_hitSFX(value:Sound):Sound 
	{
		return _hitSFX = value;
	}
	
	
	
}