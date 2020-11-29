package weapons;

import borris.managers.BSoundHandler;
import borrisEngine.components.BParticleEmitter;
import borrisEngine.components.BRigidBody2D;
import borrisEngine.core.BEntity;
import borrisEngine.core.BEntityComponent;
import borrisEngine.core.BScene;
import borrisEngine.core.BGame;
import borrisEngine.entities.paricles.BCustomizableParticle;
import borrisEngine.events.BEntityComponentEvent;
import openfl.Assets;

import box2D.common.math.B2Vec2;

import haxe.Timer;

import openfl.media.Sound;
import openfl.geom.Point;

/**
 * ...
 * @author Rohaan Allport
 */
class RangedWeapon extends BEntityComponent
{
	/**
	 * The accuracy of the weapon. A value from 0 t0 1.
	 * 1 for 100% accuracy.
	 */
	public var accuracy(get, set):Float;
	
	/**
	 * The current ammunition of the weapon.
	 * Set to -1 for infinite ammo.
	 */
	public var ammo(get, set):Int;
	
	/**
	 * The maximum ammo.
	 */
	public var maxAmmo(get, set):Int;
	
	/**
	 * The delay before the weapon starts firing for the first time.
	 */
	public var startDelay(get, set):Float;
	
	/**
	 * 
	 */
	public var attackSpeed(get, set):Float;
	
	/**
	 * 
	 */
	public var shootDelay(get, set):Float;
	
	/**
	 * 
	 */
	//public var startAngle(get, set):Float;
	
	/**
	 * 
	 */
	public var barrelLength(get, set):Float;
	
	/**
	 * 
	 */
	public var barrelPivot(get, set):Point;
	
	/**
	 * 
	 */
	//public var barrelPivot(get, set):Point;
	
	/**
	 * 
	 */
	public var projectileType(get, set):Class<RangedWeaponProjectile>;
	
	/**
	 * 
	 */
	//public var useRotation(get, set):Bool;
	
	/**
	 * 
	 */
	//public var clickToShoot(get, set):Bool;
	
	/**
	 * 
	 */
	public var numberOfProjectiles(get, set):Int;
	
	/**
	 * 
	 */
	public var spread(get, set):Float;
	
	/**
	 * 
	 */
	public var angle(get, set):Float;
	
	/**
	 * 
	 */
	public var fireFX(get, set):Class<BEntity>;
	
	/**
	 * 
	 */
	public var fireSFX(get, set):Sound;
	
	
	
	private var _accuracy:Float = 1;
	private var _accuracyOpposite:Float = 1;
	private var _ammo:Int = -1;
	private var _maxAmmo:Int = 100;
	private var _startDelay:Float = 0;
	private var _attackSpeed:Float = 1;
	private var _shootDelay:Float;
	//private var _startAngle:Float = 0;
	private var _barrelLength:Float = 10;
	private var _barrelPivot:Point = new Point(0, 0);
	private var _projectileType:Class<RangedWeaponProjectile>;
	//private var _useRotation:Bool = true;
	//private var _clickToShoot:Bool = false;
	private var _numberOfProjectiles:Int = 1;
	private var _spread:Float = 30;
	private var _angle:Float = 0;
	private var _fireFX:Class<BEntity>;
	private var _fireSFX:Sound;
	// TODO implement these
	//private var _projectileFollow:Bool;		// follows the barrel of the weapon. like a continuous blast would.
	//private var _projectileContinuous:Bool;	// the projecile stays active till some given senario is met. it won't <code>destroy()</code> automatically.
	// eg. like holding down the mouse keeps it active, and the senario to destory it in when the mouse is released. might need to be a prop of projectile instead.
	//private var numConsecutiveShots:Int;		// Do i really need a fucking explanation for this?
	// side by projectiles: such as a weapon that would fire 2 shots at a time but in the same direction.
	// positionSpread and angularSpread (current spread is angular spread)
	
	
	public var autoFire:Bool = false;
	public var startAngle:Float = 0;
	
	private var _attackCounter:Float = 0;
	private var _delayCounter:Float = 0;
	private var _canShoot:Bool = false;
	
	private var _activateShoot:Bool = false;
	private var _shootDelayCounter:Float = 0;
	
	private var _muzzleFlash:BParticleEmitter;
	

	public function new() 
	{
		super();
		
		_angle = startAngle;
		
		// TODO implement some shot of muzzle flash property
		/*_muzzleFlash = new BParticleEmitter();
		_muzzleFlash.autoUpdate = false;
		_muzzleFlash.type = BCustomizableParticle;
		//_muzzleFlash.bitmapData = Assets.getBitmapData("img/Effects/particle circle blur2 glow6 red.png");
		//_muzzleFlash.createParticles(1000);
		_muzzleFlash.numParticles = 30;
		_muzzleFlash.numParticles = 5;
		_muzzleFlash.radius = 10;
		_muzzleFlash.width = 50;
		_muzzleFlash.height = 50;
		_muzzleFlash.size = 0.5;
		_muzzleFlash.speed = 3;
		_muzzleFlash.alpha = 1;
		//_muzzleFlash.color = 0x0066ff;
		_muzzleFlash.shape = BParticleEmitter.CIRCLE;
		//_muzzleFlash.upperAngle = 180;
		//_muzzleFlash.lowerAngle = -180;
		
		//_muzzleFlash.gravity = -0.1;
		//_muzzleFlash.acceleration = 0;
		//_muzzleFlash.friction = 0;
		//_muzzleFlash.autoRotate = false;
		//_muzzleFlash.spin = 0;
		_muzzleFlash.fadeSpeed = -0.04;
		_muzzleFlash.growSpeed = -0.02;
		//_muzzleFlash.angle = -Math.PI/2;
		//_muzzleFlash.rotation = -90;
		//_muzzleFlash.emitionMode = BParticleEmitter.BURST;
		//_muzzleFlash.burstDelay = 2;*/
	}
	
	
	
	//**************************************** HANDLERS *********************************************
	
	
	/**
	 * 
	 */
	override private function entityAddedHandler(event:BEntityComponentEvent):Void
	{
		//_owner.addComponent(_muzzleFlash);
	} // end function entityAddedHandler
	
	
	//**************************************** FUNCTIONS ********************************************
	
	
	/**
	 * @inheritDoc
	 */
	override public function update():Void
	{
		//if (_canShoot) return;
		
		super.update();
		
		// shooting
		if (_delayCounter < _startDelay)
		{
			_delayCounter += BGame.deltaTime;
			/*if (_delayCounter >= _startDelay)
			{
				_canShoot = (_ammo > 0 || _ammo == -1);
			}*/
		}
		else
		{
			_attackCounter += BGame.deltaTime;
		} // end else
		
		// 
		if (_attackCounter >= _attackSpeed)
		{
			_attackCounter = 0;
			_canShoot = (_ammo > 0 || _ammo == -1);
		} // end if
		
		// if auto fire
		if (autoFire) shoot();
		
		
		
		// testing
		if (_activateShoot)
		{
			_shootDelayCounter += BGame.deltaTime;
			if (_shootDelayCounter >= _shootDelay)
			{
				_shootDelayCounter = 0;
				_activateShoot = false;
				realShoot();
			} // end if
		} // end if
		// end testing
		
	} // end function update
	
	
	/**
	 * 
	 */
	public function shoot():Void
	{
		//realShoot();
		_activateShoot = true;
		
	} // end function shoot
	
	
	/**
	 * 
	 */
	private function realShoot():Void
	{
		if (_canShoot)
		{
			var bullet:RangedWeaponProjectile;
			var barrelPivot = new Point(_owner.x + _barrelPivot.x, _owner.y + _barrelPivot.y);
			var xDistance = Math.cos(_angle) * _barrelLength;
			var yDistance = Math.sin(_angle) * _barrelLength;
			var projectilePosition = new Point(barrelPivot.x + xDistance, barrelPivot.y + yDistance);
			
			for (i in 0..._numberOfProjectiles)
			{
				//bullet = cast(BScene.pool.getEntity(Pulser), RangedWeaponProjectile);
				bullet = cast(BScene.pool.getEntity(_projectileType), RangedWeaponProjectile);
				//bullet = cast(new Pulser(), RangedWeaponProjectile);
				var bulletBody = cast(bullet.getComponent(BRigidBody2D), BRigidBody2D);
				bulletBody.x = projectilePosition.x;
				bulletBody.y = projectilePosition.y;
				
				// testing
				var ca = (1 - _accuracy) * Math.random();
				if(ca == 0)
					bulletBody.angle = bullet.angle = if(_numberOfProjectiles == 1) _angle else _angle + ((-spread/2 + i * (_spread/(_numberOfProjectiles - 1))) * (Math.PI/180));
				else
					bulletBody.angle = bullet.angle = Math.random() * (_spread * ca) * (Math.PI / 180) - (_spread/2 * ca) * (Math.PI / 180) + _angle;
					
				_owner.scene.addEntity(bullet);
				
			} // end for
			
			if (_ammo > 0) _ammo--;
			_canShoot = false;
			
			// extra
			if (_fireFX != null)
			{
				var fX:BEntity = cast(BScene.pool.getEntity(Pulser), RangedWeaponProjectile);
				_owner.scene.addEntity(fX);
			} // end if
			
			if (_fireSFX != null)
			{
				BSoundHandler.playSound(_fireSFX);
			} // end if
			
			
			/*_muzzleFlash.x = _barrelPivot.x + xDistance;
			_muzzleFlash.y = _barrelPivot.y + yDistance;
			_muzzleFlash.upperAngle = Math.PI*2 - _angle * (180/Math.PI) - 30;
			_muzzleFlash.lowerAngle = Math.PI*2 - _angle * (180/Math.PI) + 30;
			_muzzleFlash.emitNow();
			*/
		} // end if
		
	} // end function
	
	
	//**************************************** SET AND GET ******************************************
	
	
	private function get_accuracy():Float 
	{
		return _accuracy;
	}
	
	private function set_accuracy(value:Float):Float 
	{
		_accuracy = if (value > 1) 1 else if (value < 0) 0 else value;
		_accuracyOpposite = 1 - _accuracy;
		return _accuracy;
	}
	
	
	private function get_ammo():Int 
	{
		return _ammo;
	}
	
	private function set_ammo(value:Int):Int 
	{
		return _ammo = if (_ammo > _maxAmmo) _maxAmmo else value;
	}
	
	
	private function get_maxAmmo():Int 
	{
		return _maxAmmo;
	}
	
	private function set_maxAmmo(value:Int):Int 
	{
		_ammo = if (_ammo > value) value else _ammo;
		return _maxAmmo = value;
	}
	
	
	private function get_startDelay():Float 
	{
		return _startDelay;
	}
	
	private function set_startDelay(value:Float):Float 
	{
		return _startDelay = value;
	}
	
	
	private function get_attackSpeed():Float 
	{
		return _attackSpeed;
	}
	
	private function set_attackSpeed(value:Float):Float 
	{
		return _attackSpeed = value;
	}
	
	
	private function get_shootDelay():Float 
	{
		return _shootDelay;
	}
	
	private function set_shootDelay(value:Float):Float 
	{
		return _shootDelay = value;
	}
	
	
	private function get_barrelLength():Float 
	{
		return _barrelLength;
	}
	
	private function set_barrelLength(value:Float):Float 
	{
		return _barrelLength = value;
	}
	
	
	private function get_barrelPivot():Point 
	{
		return _barrelPivot;
	}
	
	private function set_barrelPivot(value:Point):Point 
	{
		return _barrelPivot = value;
	}
	
	
	private function get_projectileType():Class<RangedWeaponProjectile> 
	{
		return _projectileType;
	}
	
	private function set_projectileType(value:Class<RangedWeaponProjectile>):Class<RangedWeaponProjectile> 
	{
		return _projectileType = value;
	}
	
	
	private function get_numberOfProjectiles():Int 
	{
		return _numberOfProjectiles;
	}
	
	private function set_numberOfProjectiles(value:Int):Int 
	{
		return _numberOfProjectiles = value;
	}
	
	
	private function get_spread():Float 
	{
		return _spread;
	}
	
	private function set_spread(value:Float):Float 
	{
		return _spread = value;
	}
	
	
	private function get_angle():Float 
	{
		return _angle;
	}
	
	private function set_angle(value:Float):Float 
	{
		return _angle = value;
	}
	
	
	private function get_fireFX():Class<BEntity> 
	{
		return _fireFX;
	}
	
	private function set_fireFX(value:Class<BEntity>):Class<BEntity> 
	{
		return _fireFX = value;
	}
	
	
	private function get_fireSFX():Sound 
	{
		return _fireSFX;
	}
	
	private function set_fireSFX(value:Sound):Sound 
	{
		return _fireSFX = value;
	}
	
	
	
}