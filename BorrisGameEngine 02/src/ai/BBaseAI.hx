package ai;

import borrisEngine.components.BAnimator;
import borrisEngine.components.BJoint;
import borrisEngine.components.BRigidBody2D;
import borrisEngine.components.BWeldJoint;
import borrisEngine.core.BEntity;
import borrisEngine.core.BEntityComponent;
import borrisEngine.events.BEntityComponentEvent;
import box2D.common.math.B2Vec2;
import haxe.Timer;
import weapons.RangedWeaponProjectile;

/**
 * ...
 * @author Rohaan Allport
 */
class BBaseAI extends BEntityComponent
{
	//still, moving, walking, crawling, flying, hovering, jumping, ducking, stunned
	public static inline var STILL = "still";
	public static inline var MOVING = "moving";
	public static inline var WALKING = "walking";
	public static inline var CRAWLING = "crawling";
	public static inline var FLYING = "flying";
	public static inline var HOVERING = "hovering";
	public static inline var JUMPING = "jumping";
	public static inline var DUCKING = "ducking";
	public static inline var STUNNED = "stunned";
	//public static inline var  = "";
	
	
	public var movementState(get, never):String;
	public var movementType(get, set):String;
	
	
	//
	//private var _animator:BAnimator;
	private var _bodies:Array<BRigidBody2D> = [];
	private var _joints:Array<BJoint> = [];
	private var _sensors:Array<BRigidBody2D> = [];
	//private var _sensors2:Map<String, BRigidBody2D>;
	
	private var _mainBody:BRigidBody2D;
	private var _groundSenor:BRigidBody2D;
	private var _topSenor:BRigidBody2D;
	private var _bottomSenor:BRigidBody2D;
	private var _leftSensor:BRigidBody2D;
	private var _rightSensor:BRigidBody2D;
	
	
	// Enemy
	public var target:BEntity;
	public var damage:Float;
	public var doesExplode:Bool;
	
	// AI shit
	public var speed:Float; 				// the speed of the enemy
	//private var _movingSpeed:Float; 		// the speed at which the enemy is moving
	public var maxSpeed:Float; 				// the maximum speed that the can move
	
	
	//private var _isAttacking:Bool; 			// if the enemy is attacking or not
	//private var _isOnFloor:Bool; 			// whether th enemy is on the floor or not
	//private var _isTouchingWall:Bool; 		// whether the enemy is toching a wall or not
	//private var _isMoving:Bool; 			// weathr the enemy is moving or not
	//private var _canJump:Bool;
	private var _movementState:String = STILL; // still, moving, walking, crawling, flying, hovering, jumping, ducking, stunned
	
	public var seeingDistance:Int; 			// the distance the enemy need to be from the player to notice the player
	//public var attackingDistance:Int; 		// the distance the enemy needs to be to attack
	//public var attackPower:Float; 			// the strength of the enemy's attack
	public var defence:Float = 1; 			// the defence of the enemy
	public var hitPoints:Float = 10;		// the Hit Points (HP) of the enemy
	// TODO should prob be in or float
	//private var _scaleRate:Float; 		// a value to change the size of an enemy when it is created
	//private var _attackRate:Timer; 			// how fast the enemy will attack
	private var _isShootingEnemy:Bool; 		// whether or not the enemy is an enemy that shoots
	
	private var _movementType:String = "walk";//:BEntityMovement; // stationary, walk, crawl, fly, hover, rotate to (look at),
	
	//private var _hasAHead:Bool; 			// whether or ot the enemy has a head (used for head shots)
	public var waypoints:Array<Array<Int>> = [];
	private var _currentWaypointIndex:Int = 0;
	
	public var jumpForce:Float = -20;
	private var _direction:Float;
	private var _distance:Float;			// [read-only]
	private var _followTarget:Bool = true;
	
	
	private var _easing:Float = 0.2; 		// the easing amount to get to the target rotation
	private var _targetRotation:Int = 0; 	// the angle the enemy easies to when it is not on the floor
	
	
	private var _move:Dynamic;
	

	public function new(target:BEntity = null) 
	{
		super();
		
		this.target = target;
		
		speed = 10;
		maxSpeed = 2;
		seeingDistance = 500;
		//_jumpForce = -80;
		
		_groundSenor = new BRigidBody2D(false);
		_topSenor = new BRigidBody2D(false);
		_bottomSenor = new BRigidBody2D(false);
		_leftSensor = new BRigidBody2D(false);
		_rightSensor = new BRigidBody2D(false);
		
		_groundSenor.name = "ground";
		_topSenor.name = "top";
		_bottomSenor.name = "bottom";
		_leftSensor.name = "left";
		_rightSensor.name = "right";
		
		
		/*addSensor(_groundSenor, "ground sensor");
		addSensor(_topSenor, "top sensor");
		addSensor(_bottomSenor, "bottom sensor");
		addSensor(_LeftSensor, "left sensor");
		addSensor(_rightSensor, "right sensor");*/
		
		/*_groundSenor = addSensor(new BRigidBody2D(false), "ground sensor");
		_topSenor = addSensor(new BRigidBody2D(false), "top sensor");
		_bottomSenor = addSensor(new BRigidBody2D(false), "bottom sensor");
		_LeftSensor = addSensor(new BRigidBody2D(false), "left sensor");
		_rightSensor = addSensor(new BRigidBody2D(false), "right sensor");*/
		
		_sensors = [_groundSenor, _topSenor, _bottomSenor, _leftSensor, _rightSensor];
		
		movementType = _movementType;
		
	}
	
	//**************************************** HANDLERS *********************************************
		
	
	/**
	 * @inheritDoc
	 */
	override private function entityAddedHandler(event:BEntityComponentEvent):Void
	{
		super.entityAddedHandler(event);
		
		for (body in _bodies)
		{
			if (!_owner.hasComponent(body))
			{
				_owner.addComponent(body);
				body.groupIndex = -3;
			} // end if
			
		} // end for
		
		_mainBody.fixedRotation = true;
		
		for (sensor in _sensors)
		{
			if (!_owner.hasComponent(sensor))
			{
				_owner.addComponent(sensor);
				sensor.groupIndex = -3;
				sensor.isSensor = true;
				sensor.gravityScale = 0;
			} // end if
			
		} // end for
		
		
		if (_movementType == "fly")
		{
			
			for (body in _bodies)
			{
				body.gravityScale = 0;
			} // end for
			
		} // end if
		
		
		_groundSenor.x = 0;
		_groundSenor.y += 40;
		_groundSenor.setSize(50, 10);
		
		_topSenor.x = 0;
		_topSenor.y -= 50;
		_topSenor.setSize(50, 10);
		
		_bottomSenor.x = 0;
		_bottomSenor.y += 50;
		_bottomSenor.setSize(50, 10);
		
		_leftSensor.x -= 50;
		_leftSensor.y += 0;
		_leftSensor.setSize(10, 50);
		
		_rightSensor.x += 50;
		_rightSensor.y += 0;
		_rightSensor.setSize(10, 50);
		
		
		// weld all sensors to main body
		/*for (sensor in _sensors)
		{
			_owner.addComponent(new BWeldJoint(sensor, _mainBody, sensor.realBody.getPosition()));
		} // end for*/
		
	} // end function
	
	//**************************************** FUNCTIONS ********************************************
	
	
	/**
	 * @inheritDoc
	 */
	override public function update():Void
	{
		super.update();
		
		_move();
		
		handleContact();
		
		die();
		
	} // end function
	
	
	/**
	 * 
	 */
	private function handleContact():Void
	{
		var contactEntity = _mainBody.isContacting4(RangedWeaponProjectile);
		if (contactEntity != null)
		{
			recieveDamage(cast(contactEntity, RangedWeaponProjectile).damage);
		}  // end if
		
		/*for (body in _bodies)
		{
			var contactEntity = body.isContacting4(RangedWeaponProjectile);
			if (contactEntity != null)
			{
				recieveDamage(cast(contactEntity, RangedWeaponProjectile).damage);
			} // end if
		} // end for*/
		
		
	} // end function
	
	
	/**
	 * 
	 */
	private function recieveDamage(damage:Float = 0):Float
	{
		var newDamage = damage / (1 / defence);
		hitPoints -= newDamage;
		return newDamage;
	} // end function
	
	
	/**
	 * 
	 */
	private function die():Void
	{
		if (hitPoints <= 0)
		{
			// die animation
			// delay
			// add dying assets to scene
			_owner.destroy();
			
		} // end if
	} // end function
	
	
	
	private function walkFollow():Void
	{
		if (target != null)
		{
			var xDistance:Float = target.x - _owner.x; // positive if this to the right, negative of to the left
			var yDistance:Float = target.y - _owner.y; // 
			_distance = Math.sqrt(xDistance * xDistance + yDistance * yDistance);
			
			var _angleInRad = Math.atan2(target.y - _owner.y, target.x - _owner.x);
			
			// simple follow walking code
			if (_distance < seeingDistance)
			{
				// walk left
				if (xDistance < - target.width/2 - _owner.width/2)
				{
					_movementState = WALKING;
					
					_mainBody.applyImpulse(new B2Vec2( -speed, 0));
					// set max speed
					if (_mainBody.linearVelocityX < -maxSpeed)
					{
						_mainBody.linearVelocityX = -maxSpeed;
					} // end if
					
					// jump
					if (_leftSensor.numContacts > 0 && _groundSenor.numContacts > 0)
					{
						_mainBody.applyImpulse(new B2Vec2(0, -Math.abs(jumpForce)));
						_movementState = JUMPING;
					} // end if
					
				}
				// walk right
				else if(xDistance > target.width/2 + _owner.width/2)
				{
					_movementState = WALKING;
					
					_mainBody.applyImpulse(new B2Vec2(speed, 0));
					// set max speed
					if (_mainBody.linearVelocityX > maxSpeed)
					{
						_mainBody.linearVelocityX = maxSpeed;
					} // end if
					
					// jump 
					if (_rightSensor.numContacts > 0 && _groundSenor.numContacts > 0)
					{
						_mainBody.applyImpulse(new B2Vec2(0, -Math.abs(jumpForce)));
						_movementState = JUMPING;
					} // end if 
				} // end else if
				else
				{
					_movementState = STILL;
				}
				
			} // end if
			
			
		} // end if
		
	} // end function
	
	
	private function walkWaypoint():Void
	{
		// waypoint walking
		if (waypoints.length != 0)
		{
			
			// make the enemy face the direction of the waypoint
			
			// get distance between waypoint and enemy
			// wpxd: waypoint x distance | wpyd: waypoint y distance
			var wpxd = waypoints[_currentWaypointIndex][0] - _owner.x;
			var wpyd = waypoints[_currentWaypointIndex][1] - _owner.y;
			
			// if the enemy is close enough to waypoint, make it's new target the next waypoint
			if (Math.abs(wpxd) <= 5)
			{
				
				// stop
				_mainBody.linearVelocityX = 0;
				//_mainBody.linearVelocityY = 0;
				
				_currentWaypointIndex++;
				
				if (_currentWaypointIndex >= waypoints.length)
				{
					_currentWaypointIndex = 0;
				} // end if
			} // end if
			else
			{
				_movementState = WALKING;
				
				var waypointDir:Float = wpxd / Math.abs(wpxd);
				_mainBody.applyImpulse(new B2Vec2(speed * waypointDir, 0));
				
				if (Math.abs(_mainBody.linearVelocityX) > maxSpeed)
				{
					_mainBody.linearVelocityX = maxSpeed * (_mainBody.linearVelocityX / Math.abs(_mainBody.linearVelocityX));
				} // end if
				
				// jump
				if (_leftSensor.numContacts > 0 && _groundSenor.numContacts > 0)
				{
					_mainBody.applyImpulse(new B2Vec2(0, -Math.abs(jumpForce)));
					_movementState = JUMPING;
				} // end if
			} // end else
			
		} // end if
		
	} // end function
	
	
	private function flyFollow():Void
	{
		if (target != null)
		{
			var xDistance:Float = target.x - _owner.x; // positive if this to the right, negative of to the left
			var yDistance:Float = target.y - _owner.y; // 
			_distance = Math.sqrt(xDistance * xDistance + yDistance * yDistance);
			
			var _angleInRad = Math.atan2(target.y - _owner.y, target.x - _owner.x);
		
			// simple follow flying code
			if (_distance < seeingDistance)
			{
				_movementState = FLYING;
				
				_mainBody.applyImpulse(new B2Vec2(Math.cos(_angleInRad) * speed, Math.sin(_angleInRad) * speed));
				
				if (Math.abs(_mainBody.linearVelocityX) > Math.abs(Math.cos(_angleInRad) * maxSpeed))
				{
					_mainBody.linearVelocityX = Math.cos(_angleInRad) * maxSpeed;
				} // end if
				if (Math.abs(_mainBody.linearVelocityY) > Math.abs(Math.sin(_angleInRad) * maxSpeed))
				{
					_mainBody.linearVelocityY = Math.sin(_angleInRad) * maxSpeed;
				} // end if
				
				// direaction
				if (xDistance < 0)
				{
					_direction = -1;
					_owner.scaleX = -1;
				}
				else
				{
					_direction = 1;
					_owner.scaleX = 1;
				}
			} // end if
			else
			{
				// stop
				//_mainBody.linearVelocityX = 0;
				//_mainBody.linearVelocityY = 0;
				
				// move in clockwise cicle
				_mainBody.linearVelocityX = Math.cos(haxe.Timer.stamp());
				_mainBody.linearVelocityY = Math.sin(haxe.Timer.stamp());
				
			} // end else
		} // end if
		
	} // end function
	
	
	private function flyWaypoint():Void
	{
		// TODO waypoint flying code
	} // end function
	
	
	
	public function addRigidBody(rigidBody:BRigidBody2D):BRigidBody2D
	{
		_bodies.push(rigidBody);
		
		if (_bodies.length == 1)
		{
			_mainBody = rigidBody;
		} // end if
		
		
		
		if (_owner != null)
		{
			_owner.addComponent(rigidBody);
			rigidBody.groupIndex = -3;

			if (_movementType == "fly")
			{
				for (body in _bodies)
				{
					body.gravityScale = 0;
				} // end for
			} // end if
		} // end if
		
		return rigidBody;
	} // end function
	
	
	public function addSensor(sensor:BRigidBody2D, name:String, x:Float = 0, y:Float = 0):BRigidBody2D
	{
		sensor.name = name;
		_sensors.push(sensor);
		
		if (_owner != null)
		{
			_owner.addComponent(sensor);
			sensor.isSensor = true;
			sensor.groupIndex = -3;
			sensor.gravityScale = 0;
		} // end if
		
		return sensor;
	} // end function
	
	
	public function getSensor(name:String):BRigidBody2D
	{
		var sensor:BRigidBody2D = null;
		
		for (sensor in _sensors)
		{
			if (sensor.name == name)
			{
				return sensor;
			} // end if
		} // end for
		
		return sensor;
	} // end function
	
	//**************************************** SET AND GET ******************************************
	
	
	private function get_movementState():String
	{
		return _movementState;
	}
	
	
	private function get_movementType():String
	{
		return _movementType;
	}
	private function set_movementType(value:String):String
	{
		_movementType = value;
		
		
		if (_movementType == "fly")
		{
			for (body in _bodies)
			{
				body.gravityScale = 0;
			} // end for
			
			_move = flyFollow;
		}
		else if(_movementType == "stationary" || _movementType == "walk" || _movementType == "crawl")
		{
			for (body in _bodies)
			{
				body.gravityScale = 1;
			} // end for
			
			_move = walkFollow;
		}
		else
		{
			for (body in _bodies)
			{
				body.gravityScale = 1;
			} // end for
			
			_move = walkWaypoint;
		}
		
		return _movementType;
	}
	
	
}