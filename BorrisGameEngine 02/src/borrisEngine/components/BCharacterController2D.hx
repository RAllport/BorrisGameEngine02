package borrisEngine.components;

import borris.managers.BSoundHandler;
import openfl.Assets;
import openfl.geom.Point;
import openfl.media.Sound;
import openfl.ui.Keyboard;

import starling.display.Sprite;
import starling.display.MovieClip;
import starling.events.Event;

//import weapons.Pulser;
import weapons.RangedWeapon;

import box2D.common.math.B2Vec2;

import borrisEngine.core.BScene;
import borrisEngine.core.BEntity;
import borrisEngine.core.BEntityComponent;
//import borrisEngine.entities.paricles.BCustomizableParticle;
import borrisEngine.ui.BStarlingInput;
import borrisEngine.utils.createPhysics.CreateShape;


/**
 * ...
 * @author Rohaan Allport
 */
class BCharacterController2D extends BEntityComponent
{
	//public var defaulControls(get, set):Bool;
	
	private var _booleanControls:Array<Dynamic>;
	
	private var _up:Bool;
	private var _down:Bool;
	private var _left:Bool;
	private var _right:Bool;
	private var _action:Bool;
	private var _nextWeapon:Bool;
	private var _prevWeapon:Bool;
	
	// other owner components
	private var _rigidBody:BRigidBody2D;
	private var _groundSensorBody:BRigidBody2D;
	private var _bodyJoint:BPrismaticJoint;
	private var _animator:BAnimator;
	private var _pulser:RangedWeapon;
	private var _hydraWaveGun:RangedWeapon;
	private var _assaultPulser:RangedWeapon;
	private var _fluxRailgun:RangedWeapon;
	private var _plasmaLauncher:RangedWeapon;
	private var _fissionRocketLauncher:RangedWeapon;
	private var _gammaMinigun:RangedWeapon;
	private var _megaBlaster:RangedWeapon;
	private var _currentGun:RangedWeapon;
	
	
	// Images & MovieClips
	private var _standingMC:MovieClip;
	private var _runningForwardMC:MovieClip;
	private var _runningBackwardMC:MovieClip;
	private var _jumpingMC:MovieClip;
	private var _duckingMC:MovieClip;
	private var _dashingForwardMC:MovieClip;
	private var _dashingBackwardMC:MovieClip;
	private var _hoveringForwardMC:MovieClip;
	private var _hoveringBackwardMC:MovieClip;
	
	private var _frontHandsMC:MovieClip;
	private var _backHandsMC:MovieClip;
	
	
	// movement variables;
	public var maxSpeed:Float = 6;//8;
	public var maxRunningSpeed:Float = 6;//8;
	public var maxCrouchingSpeed:Float = 2;
	public var jumpForce:Float;
	public var doubleJumpForce:Float;
	public var highJumpForce:Float;
	public var runningImpulse:Float;
	public var playerNormal:B2Vec2;
	private var _canJump:Bool;
	private var _canDoubleJump:Bool;
	private var _canHighJump:Bool;
	private var _canHover:Bool;
	private var _canDash:Bool;
	private var _dashForce:Float;
	private var _dashDelayCounter:Int;
	private var _dashDelayFrame:Int;
	private var _djRange:Int = 10; // double jump velocity range ()
	private var _direction:Float;
	private var _angleInRad:Float;
	private var _angleInDeg:Float;
	private var _freeMoving:Bool = false;
	
	// states 
	//private var playerState:String;
	private var _standing:Bool;
	private var _running:Bool;
	private var _jumping:Bool;
	private var _ducking:Bool;
	private var _dashing:Bool;
	private var _hovering:Bool;
	//private var _wallJumping:Bool;
	//private var _falling:Bool;
	//private var _climbing:Bool;
	//private var _swinging:Bool; // from grapling
	//private var _grinding:Bool; // like on a skateboard
	//private var _meleeAttacking:Bool;
	//private var _meleeMode:Bool;
	//private var _gunMode:Bool;
	//private var _dying:Bool; 
	//private var _dead:Bool;
	private var _touchingFloor:Bool;
	
	private var _scaleRate:Float = 1;
	
	
	public var playerHealth:Int = 100;
	public var playerFullHealth:Int = 100;
	//private var playerHP_mc:MovieClip;
	//private var weaponGuage_mc:MovieClip;
	//private var ammoGuage_mc:MovieClip;
	//private var ammoT_fmt:TextFormat;
	
	
	/**
	 * Contructs a new BCharacterController2D object.
	 */
	public function new(body:BRigidBody2D) 
	{
		super();
		
		_booleanControls = new Array<Dynamic>();
		
		/*if (_owner.getComponent(BRigidBody2D) != null)
		{
			_rigidBody = cast(owner.getComponent(BRigidBody2D), BRigidBody2D);
		}
		else
		{
			_rigidBody = cast(_owner.addComponent(new BRigidBody2D(_owner)), BRigidBody2D);
		} // end if else*/
		
		_rigidBody = body;
		
	}
	
	
	//**************************************** HANDLERS *********************************************
	
	/**
	 * 
	 */
	override private function entityAddedHandler(event:Event):Void
	{
		_groundSensorBody = cast(_owner.getComponentByName("groundSensorBody"), BRigidBody2D);
		_bodyJoint = cast(_owner.getComponentByName("bodyJoint"), BPrismaticJoint);
		
		if (_owner.getComponent(BAnimator) != null)
		{
			_animator = cast(_owner.getComponent(BAnimator), BAnimator);
		}
		
		_pulser = cast(_owner.getComponentByName("pulse pistol"), RangedWeapon);
		_hydraWaveGun = cast(_owner.getComponentByName("hydra wave gun"), RangedWeapon);
		_assaultPulser = cast(_owner.getComponentByName("assault pulser"), RangedWeapon);
		_fluxRailgun = cast(_owner.getComponentByName("flux railgun"), RangedWeapon);
		_plasmaLauncher = cast(_owner.getComponentByName("plasma launcher"), RangedWeapon);
		_fissionRocketLauncher = cast(_owner.getComponentByName("fission rocket launcher"), RangedWeapon);
		_gammaMinigun = cast(_owner.getComponentByName("gamma minigun"), RangedWeapon);
		_megaBlaster = cast(_owner.getComponentByName("mega blaster"), RangedWeapon);
		_currentGun = _pulser;
		
		// movement variables
		maxSpeed = 5.5; //6; //8;
		jumpForce = -20;
		doubleJumpForce = -36;
		highJumpForce = -26;
		runningImpulse = 8; //2.2;
		playerNormal = new B2Vec2(0, 0);
		_canJump = false;
		_canDoubleJump = false;
		_canHover = false;
		_canDash = false;
		_dashForce = 22; //40;
		_dashDelayCounter = 0;
		_dashDelayFrame = 30;
		
		_standing = true;
		_running = false;
		_jumping = false;
		_ducking = false;
		_dashing = false;
		_hovering = false;
		
		
		//
		_standingMC = _animator.getAnimationByName("standing");
		_runningForwardMC = _animator.getAnimationByName("runningForward");
		_runningBackwardMC = _animator.getAnimationByName("runningBackward");
		_jumpingMC = _animator.getAnimationByName("jumping");
		_duckingMC = _animator.getAnimationByName("ducking");
		_dashingForwardMC = _animator.getAnimationByName("dashingForward");
		_dashingBackwardMC = _animator.getAnimationByName("dashingBackward");
		_hoveringForwardMC = _animator.getAnimationByName("hoveringForward");
		_hoveringBackwardMC = _animator.getAnimationByName("hoveringBackward");
		
		_frontHandsMC = cast(_owner.getChildByName("frontHands"), MovieClip);
		_backHandsMC = cast(_owner.getChildByName("backHands"), MovieClip);
		
	} // end function entityAddedHandler
		
		
	//**************************************** FUNCTIONS ********************************************
	
	/**
	 * @inheritDoc
	 */
	override public function update():Void
	{
		super.update();
		
		_up = BStarlingInput.keyPressed(Keyboard.UP) || BStarlingInput.keyPressed(Keyboard.W);
		_down = BStarlingInput.keyIsDown(Keyboard.DOWN) || BStarlingInput.keyIsDown(Keyboard.S);
		_left = BStarlingInput.keyIsDown(Keyboard.LEFT) || BStarlingInput.keyIsDown(Keyboard.A);
		_right = BStarlingInput.keyIsDown(Keyboard.RIGHT) || BStarlingInput.keyIsDown(Keyboard.D);
		_action = BStarlingInput.keyIsDown(Keyboard.SHIFT) || BStarlingInput.keyIsDown(Keyboard.CONTROL) || BStarlingInput.keyIsDown(Keyboard.SPACE);
		var holdUp = BStarlingInput.keyIsDown(Keyboard.UP) || BStarlingInput.keyIsDown(Keyboard.W);
		
		// toggle free moving when the 0 key is pressed
		if(BStarlingInput.keyPressed(Keyboard.NUMBER_0))
		{
			_freeMoving = !_freeMoving;
		}
		
		// if free moving is true
		if(_freeMoving)
		{
			freeMove();
			return;
		}
		
		var mousePos:Point = BStarlingInput.touchPositionIn(_owner.parent);
		var shoulderPosX = _owner.x + _frontHandsMC.x;
		var shoulderPosY = _owner.y + _frontHandsMC.y;
		_angleInRad = Math.atan2(mousePos.y - shoulderPosY, mousePos.x - shoulderPosX);
		_angleInDeg = _angleInRad * (180 / Math.PI);
		
		// rotate the player animations
		if(_angleInRad >= -Math.PI/2 && _angleInRad < Math.PI/2)
		{
			_direction = 1;
			_frontHandsMC.rotation = _backHandsMC.rotation = _angleInRad;
		}
		else
		{
			_direction = -1;
			_frontHandsMC.rotation = _backHandsMC.rotation = -_angleInRad - Math.PI;
		} // end else
		
		_owner.scaleX = _direction;
		
		// animate
		if(holdUp && !_canJump && _rigidBody.linearVelocityY > 0 && _rigidBody.linearVelocityX > 0 && _direction > 0 || 
				holdUp && !_canJump && _rigidBody.linearVelocityY > 0 && _rigidBody.linearVelocityX < 0 && _direction < 0)
		{
			_animator.switchAnimation(_hoveringForwardMC);
		}
		else if(holdUp && !_canJump && _rigidBody.linearVelocityY > 0 && _rigidBody.linearVelocityX < 0 && _direction > 0 || 
				holdUp && !_canJump && _rigidBody.linearVelocityY > 0 && _rigidBody.linearVelocityX > 0 && _direction < 0)
		{
			_animator.switchAnimation(_hoveringBackwardMC);
		}
		else if(!_canJump || _right && !_canJump || _left && !_canJump)
		{
			_animator.switchAnimation(_jumpingMC);
		}
		else if(_down && _canJump)
		{
			_animator.switchAnimation(_duckingMC);
		}
		/*else if(_canDash && BStarlingInput.keyPressed(Keyboard.LEFT) && BStarlingInput.lastKey == Keyboard.LEFT && BStarlingInput.lastKeyFrameDifference <= 6 || 
				_canDash && BStarlingInput.keyPressed(Keyboard.RIGHT) && BStarlingInput.lastKey == Keyboard.RIGHT && BStarlingInput.lastKeyFrameDifference <= 6) // dashing
		{
			//trace("dashing");
			_animator.switchAnimation(_dashingForwardMC);
			//dashing = true;
		}*/
		else if(!_up && !_left && !_right && _canJump)
		{
			_animator.switchAnimation(_standingMC);
		}
		else if(_left && _canJump && _direction < 0 || 
				_right && _canJump && _direction > 0)
		{
			_animator.switchAnimation(_runningForwardMC);
		}
		else if(_left && _canJump && _direction > 0 || 
				_right && _canJump && _direction < 0)
		{
			_animator.switchAnimation(_runningBackwardMC);
		}
		
		if (BStarlingInput.keyReleased(Keyboard.DOWN) || BStarlingInput.keyReleased(Keyboard.S))
		{
			_duckingMC.currentFrame = 0;
		}
		if (BStarlingInput.keyReleased(Keyboard.UP) || BStarlingInput.keyReleased(Keyboard.W))
		{
			_hoveringForwardMC.currentFrame = 0;
			_hoveringBackwardMC.currentFrame = 0;
			_jumpingMC.currentFrame = 0;
		}
		
		
		
		// move left and right
		if(_left)
		{
			//runningWheelJoint.SetMotorSpeed(-15);
			//runningWheelJoint.SetMaxMotorTorque(50);
			if(_rigidBody.linearVelocityX > -maxSpeed)
			{
				_rigidBody.applyImpulse(new B2Vec2(-runningImpulse, 0));
				if(_rigidBody.linearVelocityX < -maxSpeed)
				{
					_rigidBody.linearVelocityX = -maxSpeed;
				} // end if
			} // end if
		} // end if
		else if(_right)
		{
			//runningWheelJoint.SetMotorSpeed(15);
			//runningWheelJoint.SetMaxMotorTorque(50);
			if(_rigidBody.linearVelocityX < maxSpeed)
			{
				_rigidBody.applyImpulse(new B2Vec2(runningImpulse, 0));
				if(_rigidBody.linearVelocityX > maxSpeed)
				{
					_rigidBody.linearVelocityX = maxSpeed;
				} // end if
			} // end if
		} // end else if
		
		// TODO make a numContacts getter for the userdata contacts
		if (_groundSensorBody.realBody.getUserData() != null)
		{
			if(Std.int(_groundSensorBody.realBody.getUserData().contacts) > 0)
			{
				_canJump = true;
				_canHighJump = true;
				runningImpulse = 8;
				_touchingFloor = true;
			}
			else
			{
				_canJump = false;
				_canHighJump = false;
				runningImpulse = 1;
				_touchingFloor = false;
			} // end else
		} // end if
		
		// jump
		if(_canJump)
		{
			if(_up && !_action)
			{
				_rigidBody.applyImpulse(new B2Vec2(0, jumpForce));
				_canJump = false;
				_canDoubleJump = true; 
				_canHighJump = false;
				//_canHover = true;
			}
		} // end if 
		
		// duble jump
		if(_canDoubleJump && _up)
		{
			if(_rigidBody.linearVelocityY < _djRange && _rigidBody.linearVelocityY >= 0 || _rigidBody.linearVelocityY > -_djRange && _rigidBody.linearVelocityY < 0)
			{
				_rigidBody.linearVelocityY = 0;
				_rigidBody.applyImpulse(new B2Vec2(0, doubleJumpForce));
				_canDoubleJump = false;
				//_canHover = true;
			}
		} // end if
		
		// high jump
		if(_canHighJump)
		{
			if(_up && _action)
			{
				_rigidBody.applyImpulse(new B2Vec2(0, highJumpForce));
				_canJump = false;
				_canDoubleJump = false; 
				_canHighJump = false;
				//_canHover = true;
				_animator.switchAnimation(_jumpingMC);
			}
		} // end if
		
		
		// hover down
		//if(_canHover)
		//{
			if(holdUp)
			{
				if(_rigidBody.linearVelocityY > 0)
				{
					_rigidBody.linearVelocityY = 0.5;
					//_flame.visible = true;
				}
			}
			/*else
			{
				_flame.visible = false;
			}*/
		//}
		
			
		// dash
		if(_dashDelayCounter < 30)
		{
			_dashDelayCounter++;
		}
		if(_dashDelayCounter >= 30 && !_down)
		{
			_canDash = true;
			/*if (BStarlingInput.keyReleased(Keyboard.LEFT) || BStarlingInput.keyReleased(Keyboard.RIGHT))
			{
				_canDash = true;
			}*/
		}
		
		if(_canDash)
		{
			
			//if(_action && BStarlingInput.keyPressed(Keyboard.LEFT))
			//if(BStarlingInput.keyPressed(Keyboard.LEFT) && BStarlingInput.lastKey == Keyboard.LEFT && BStarlingInput.lastKeyFrameDifference <= 6)
			if(_left && BStarlingInput.keyIsDown(Keyboard.SPACE))
			{
				_rigidBody.applyImpulse(new B2Vec2(-_dashForce, 0));
				_canDash = false;
				_dashDelayCounter = 0;
				_animator.switchAnimation(_dashingForwardMC);
			}
			//if(_action && BStarlingInput.keyPressed(Keyboard.RIGHT))
			//if(BStarlingInput.keyPressed(Keyboard.RIGHT) && BStarlingInput.lastKey == Keyboard.RIGHT && BStarlingInput.lastKeyFrameDifference <= 6)
			if(_right && BStarlingInput.keyIsDown(Keyboard.SPACE))
			{
				_rigidBody.applyImpulse(new B2Vec2(_dashForce, 0));
				_canDash = false;
				_dashDelayCounter = 0;
				_animator.switchAnimation(_dashingForwardMC);
			}
			//_dashing = true;
		}
		
		// stop the dash after X (10) frames
		if(!_canDash && _dashDelayCounter == 10)
		{
			_rigidBody.linearVelocityX = 0;
			//_rigidBody.linearVelocityY = 0;
			//lowerBodyBody.linearVelocityX = 0;
			//lowerBodyBody.linearVelocityY = 0;
			//runningWheelBody.SetLinearVelocity(new B2Vec2(0, _rigidBody.linearVelocityY));
			//_dashing = false;
		}
		
		
		// duck/crouch
		if(_down)
		{
			// TODO make BJoint functions, setters and getters
			_bodyJoint.realJoint.setLimits(-35/40, 0);
			maxSpeed = maxCrouchingSpeed;
			_canDash = false;
		}
		else if(BStarlingInput.keyReleased(Keyboard.DOWN) || BStarlingInput.keyReleased(Keyboard.S))
		{
			_bodyJoint.realJoint.setLimits(0, 0);
			maxSpeed = maxRunningSpeed;
		}
		
		
		//
		switchGun();
		
		//if(BStarlingInput.mousePressed)
		if(BStarlingInput.mouseIsDown)
		{
			_currentGun.angle = _angleInRad;
			_currentGun.shoot();
		} // end if
		
		
	} // end function update
	
	
	/**
	 * 
	 */
	private function animate():Void
	{
		
	} // end function
		
	
	/**
	 * 
	 */
	private function switchGun():Void
	{
		if (BStarlingInput.keyPressed(Keyboard.NUMBER_1))
		{
			_currentGun = _pulser;
			_frontHandsMC.currentFrame = _backHandsMC.currentFrame = 1;
		}
		else if (BStarlingInput.keyPressed(Keyboard.NUMBER_2))
		{
			_currentGun = _hydraWaveGun;
			_frontHandsMC.currentFrame = _backHandsMC.currentFrame = 2;
		}
		else if (BStarlingInput.keyPressed(Keyboard.NUMBER_3))
		{
			_currentGun = _assaultPulser;
			_frontHandsMC.currentFrame = _backHandsMC.currentFrame = 3;
		}		
		else if (BStarlingInput.keyPressed(Keyboard.NUMBER_4))
		{
			_currentGun = _fluxRailgun;
			_frontHandsMC.currentFrame = _backHandsMC.currentFrame = 4;
		}		
		else if (BStarlingInput.keyPressed(Keyboard.NUMBER_5))
		{
			_currentGun = _plasmaLauncher;
			_frontHandsMC.currentFrame = _backHandsMC.currentFrame = 5;
		}		
		else if (BStarlingInput.keyPressed(Keyboard.NUMBER_6))
		{
			_currentGun = _fissionRocketLauncher;
			_frontHandsMC.currentFrame = _backHandsMC.currentFrame = 6;
		}		
		else if (BStarlingInput.keyPressed(Keyboard.NUMBER_7))
		{
			_currentGun = _gammaMinigun;
			_frontHandsMC.currentFrame = _backHandsMC.currentFrame = 7;
		}	
		/*else if (BStarlingInput.keyPressed(Keyboard.NUMBER_8))
		{
			_currentGun = _megaBlaster;
			_frontHandsMC.currentFrame = _backHandsMC.currentFrame = 8;
		}*/
		
	} // end function
		
	
	/**
	 * 
	 * @param	name
	 * @param	condition
	 * @param	callBack
	 */
	public function defineBooleanControl(name:String, condition:Bool, callBack:Dynamic):Void
	{
		
	} // end function defineBooleanControl
	
	
	/**
	 * Allow the player to freely move around a word using controls.
	 * 
	 * @param	speed
	 */
	private function freeMove(speed:Float = 6):Void
	{
		
		/*torsoBody.SetSleepingAllowed(false);
		if()
		{
			
		}*/
		//var gCancelForce = new B2Vec2(torsoBody.GetMass() * -torsoBody.GetWorld().GetGravity().x, torsoBody.GetMass() * -torsoBody.GetWorld().GetGravity().y);
		//torsoBody.ApplyForce(gCancelForce, torsoBody.GetWorldCenter());
		
		if(_left)
		{
			_rigidBody.awake = true;
			_rigidBody.linearVelocityX = -speed;
			//_owner.x -= speed;
		}
		if(_right)
		{
			_rigidBody.awake = true;
			_rigidBody.linearVelocityX = speed;
			//_owner.x += speed;
		}
		if(BStarlingInput.keyIsDown(Keyboard.UP) || BStarlingInput.keyIsDown(Keyboard.W))
		{
			_rigidBody.awake = true;
			_rigidBody.linearVelocityY = -speed * 2;
			//_owner.y -= speed;
		}
		if(_down)
		{
			_rigidBody.awake = true;
			_rigidBody.linearVelocityY = speed;
			//_owner.y += speed;
		}
		
	} // end function freeMove
	
	
	
	/**
	 * 
	 */
	public function healthRegen():Void
	{
		if (playerHealth < playerFullHealth)
		{
			playerHealth++;
		} // end if
		
	} // end function
	
	
	/**
	 * 
	 * @param	damage
	 */
	public function applyDamage(damage:Int):Void
	{
		// TODO implememnt _playerCanMove
		//if (_player)
		//{
			playerHealth -= damage;
			
			if (playerHealth <= 0)
			{
				//BSoundHandler.playSound();
				//startCoroutine(killPlayer());
				killPlayer();
			} // end if
		//} // end if
		
	} // end function
	
	
	/**
	 * 
	 */
	public function killPlayer() 
	{
		//if (_playerCanMove)
		//{
		
		//freezeMotion();
		
		//_animator.switchAnimation(dieMC);
		
		
		
		//} // end if
		 
	} // end function
	
	
	/**
	 * 
	 */
	public function pickUp():Void
	{
		
	} // end function
	
	
	/**
	 * 
	 */
	public function beatLevel():Void
	{
		
	} // end function
	
	
	/**
	 * 
	 */
	/*public function respawn(spawnPoint:SpawnPoint):Void
	{
		
	} // end funcion*/
	
	
	//**************************************** SET AND GET ******************************************
	
	
	
}