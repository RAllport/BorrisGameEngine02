package borrisEngine.components;

import haxe.Constraints.Function;

import openfl.geom.Matrix;

import borrisEngine.core.BEntity;
import borrisEngine.core.BEntityComponent;
import borrisEngine.events.BEntityComponentEvent;
import borrisEngine.utils.createPhysics.*;
//import borrisEngine.BPPhysics.gravity.Gravity;

import box2D.dynamics.*;
import box2D.collision.*;
import box2D.collision.shapes.*;
import box2D.dynamics.joInts.*;
import box2D.dynamics.contacts.*;
import box2D.common.*;
import box2D.common.math.*;


/**
 * BUG setting owner x and y won't update the position of the body, and then makes the own go to the position of the body. hence wrong place
 * @author Rohaan Allport
 */
class BRigidBody2D extends BEntityComponent
{
	public var realBody(get, never):B2Body;
	
	public var active(get, set):Bool;
	public var angle(get, set):Float;
	//public var allowDragging(get, set):Bool;
	public var angularDamping(get, set):Float;
	public var angularVelocity(get, set):Float;
	public var applyGravity(get, set):Bool;
	public var autoSleep(get, set):Bool;
	public var awake(get, set):Bool;
	public var bullet(get, set):Bool;
	public var categoryBits(get, set):UInt;
	//public var conveyorBeltSpeed:Float;
	public var density(get, set):Float;
	//public var disabled(get, set):Bool;
	public var fixedRotation(get, set):Bool;
	public var friction(get, set):Float;
	// TODO make gravityAngle property
	//public var gravityAngle(get, set):Float;
	// TODO make gravityMod property
	//public var gravityMod(get, set):Bool;
	public var gravityScale(get, set):Float;
	public var groupIndex(get, set):Int;
	public var inertiaScale(get, set):Float;
	//public var isGround(get, set):Bool;
	public var isSensor(get, set):Bool;
	public var linearDamping(get, set):Float;
	public var linearVelocityX(get, set):Float;
	public var linearVelocityY(get, set):Float;
	public var maskBits(get, set):UInt;
	public var mass(get, set):Float;
	//public var reportBeginContact:Bool;
	//public var reportEndContact:Bool;
	//public var reportPostSolve:Bool;
	//public var reportPreSolve:Bool;
	public var restitution(get, set):Float;
	//public var tweened:Bool;
	public var shapeType(get, never):String;
	public var type(get, set):String;
	public var useAutoMass(get, set):Bool;
	public var width(get, set):Float;
	public var height(get, set):Float;
	public var x(get, set):Float;
	public var y(get, set):Float;
	public var numContacts(get, never):Int;
	
	//public static var container:DisplayObjectContainer;			// Used for initializing.
	public static var world:B2World;								// Used for initializing.
	public static var physScale:Float = 40;						// Used for initializing.
	//public static var boundries:Rectangle;						// Used to remove the entity if it goes too far
	
	
	private var _body:B2Body = null; 								// the B2Body
	private var _fixtures:Array<B2Fixture>;
	private var _matrix:Matrix = null; 								// A transform matrix that helps with BorrisPhysics -> BodyShape coordinate translation.
	// TODO create a materials class as a wrapper for B2Fixture
	//private var _materials:Array<BMaterial2D>;
	@:allow(borrisEngine.utils.BSceneParser)
	private var _ownerFollow:Bool = true;
	
	private var _selfBody:Bool = false; 							// Is this BodyShape acting as B2Body?
	//public var _gravity:V2; 										// The last gravity vector applied to this body (only set when acting as a body).
	//public var _customGravity:Gravity = null; 						// A custom gravity object to use instead of world gravity.
	//public var _bufferedShapes:Array = [];
	
	
	// calculation
	private var _gCancelForce:B2Vec2;
	private var _gScaleForce:B2Vec2;
	private var _filterData:B2FilterData;
	
	
	
	// set and get
	private var _active:Bool = true;
	private var _angle:Float = 0;
	//private var _allowDragging:Bool = false;
	private var _angularDamping:Float = 0;
	private var _angularVelocity:Float = 0;
	private var _applyGravity:Bool = true;
	private var _autoSleep:Bool = true;
	private var _awake:Bool = true;
	private var _bullet:Bool = false;
	private var _categoryBits:UInt = 0x0001;
	//private var _conveyorBeltSpeed:Float = 0;
	private var _density:Float = 1;
	//private var _disabled:Bool = false;
	private var _fixedRotation:Bool = false;
	private var _friction:Float = 0.3;
	private var _gravityAngle:Float = 0;
	private var _gravityMod:Bool = false;
	private var _gravityScale:Float = 1;
	private var _groupIndex:Int = 0;
	private var _inertiaScale:Float = 1;
	private var _isGround:Bool = false;
	private var _isSensor:Bool = false;
	private var _linearDamping:Float = 0;
	private var _linearVelocityX:Float = 0;
	private var _linearVelocityY:Float = 0;
	private var _maskBits:UInt = 0xFFFF;
	private var _mass:Float;
	//private var _reportBeginContact:Bool = false;
	//private var _reportEndContact:Bool = false;
	//private var _reportPostSolve:Bool = false;
	//private var _reportPreSolve:Bool = false;
	private var _restitution:Float = 0.3;
	//private var _tweened:Bool = false;
	private var _type:String = "dynamic";
	private var _useAutoMass:Bool = true;
	private var _width:Float = 0;
	private var _height:Float = 0;
	private var _x:Float = 0;
	private var _y:Float = 0;
	private var _shapeType:String = "box";
	
	
	//private var _linearDrag:Float = 0;
	//private var _angularDrag:Float = 0.05;
	
	private var _contactEdges:B2ContactEdge;
	private var _numContacts:Int = 0;
	
	public var onContact:Dynamic;
	
	
	/**
	 * 
	 * @param	owner
	 */
	// BUG Many properties can't be set untill after the component is added to a BEntity.
	public function new(ownerFollow:Bool = true) 
	{
		super();
		
		_ownerFollow = ownerFollow;
	}
	
	
	//**************************************** HANDLERS *********************************************
	
	
	/**
	 * 
	 * @param	event
	 */
	override private function entityAddedHandler(event:BEntityComponentEvent):Void
	{
		super.entityAddedHandler(event);
		
		_x = _owner.x;// + _owner.width/2;
		_y = _owner.y;// + _owner.height/2;
		_width = _owner.width;
		_height = _owner.height;
		
		if (_owner.width == 0 && _owner.height == 0)
		{
			_width = 20;
			_height = 20;
			//_type = "static";
			_body = CreateShape.createBox(_x, _y, _height, _width, _type, _angle, _density, _restitution, _friction);
			//_body = CreateShape.createCircle(_x, _y, _width, _type, _angle, _density, _restitution, _friction);
		}
		else
		{
			_body = CreateShape.createBox(_x, _y, _height, _width, _type, _angle, _density, _restitution, _friction);
			//_body = CreateShape.createCircle(_x, _y, _width, _type, _angle, _density, _restitution, _friction);
		}
		
		world = _body.getWorld();
		
		_filterData = _body.getFixtureList().getFilterData();
		
		setGravityForces();
		
		_groupIndex = _filterData.groupIndex;
		_categoryBits = _filterData.categoryBits;
		_maskBits = _filterData.maskBits;
		
		_mass = _useAutoMass ? _body.getMass() : 1;
		_x = _body.getPosition().x * physScale;
		_y = _body.getPosition().y * physScale;
		
		_body.setUserData({name: "B2Body", displayObject: _owner, contacts: 0});
		
	} // end function entityAddedHandler
	
		
	//**************************************** FUNCTIONS ********************************************
	
	
	/**
	 * @inheritDoc
	 */
	override public function update():Void
	{
		//trace("RigidBody updating: " + _owner.name);
		
		if (_owner != null)
		{
			
			// if gravity should be applied
			if(applyGravity)
			{
				// if the gravity scale is not 1
				if(_gravityScale != 1)
				{
					// first add a force (equal to gravity) upward on the body to cancel gravity
					_body.applyForce(_gCancelForce, _body.getWorldCenter());
					// second, add a force that is a scale of the force by gravity
					_body.applyForce(_gScaleForce, _body.getWorldCenter());
				}
			}
			else if(!applyGravity) 
			{
				// add a force upward on the body to cancel gravity
				_body.applyForce(_gCancelForce, _body.getWorldCenter());
				//_body.applyImpulse(_gCancelForce, _body.getWorldCenter());
			}
			
			// make the body rotate in the direction it is traveling
			/*if(autoRotate)
			{
			{
				var angle:Float = Math.atan2(this.body.GetLinearVelocity().y, this.body.GetLinearVelocity().x);
				this.body.angle = angle;
			}*/
			
			
			handleContacts();
			
			// make the owner BEntity have the position and rotation of the B2Body
			if (_ownerFollow)
			{
				_owner.x = Math.round(_body.getPosition().x * physScale);
				_owner.y = Math.round(_body.getPosition().y * physScale);
				_owner.rotation = _body.getAngle();			
			} // end if
			
		}
		
		super.update();
		
	} // end 
	
	
	/**
	 * @inheritDoc
	 */
	override public function destroy():Void
	{
		super.destroy();
		destroyBody();
	} // end 
	
	
	/**
	 * 
	 * @param	width
	 * @param	height
	 */
	public function setSize(width:Float, height:Float):Void
	{
		_width = width;
		_height = height;
		
		var shape:B2Shape = _body.getFixtureList().getShape();
		var shapeType:B2ShapeType = _body.getFixtureList().getShape().getType();
		_body.DestroyFixture(_body.getFixtureList());
		
		switch(shapeType)
		{
			case B2ShapeType.CIRCLE_SHAPE:
				//trace("cirlce shape");
				shape = new B2CircleShape(Math.max((_width/2) / CreateShape.physScale, (_height/2) / CreateShape.physScale));
				
			case B2ShapeType.EDGE_SHAPE:
				//trace("edge shape");
				
			case B2ShapeType.POLYGON_SHAPE:
				//trace("polygon shape");
				shape = new B2PolygonShape();
				cast(shape, B2PolygonShape).setAsBox((_width / 2) / CreateShape.physScale, (_height / 2) / CreateShape.physScale);
				
			case B2ShapeType.UNKNOWN_SHAPE:
				//trace("cirlce shape");
				
		} // end switch
		
		
		var fixtureDef:B2FixtureDef = new B2FixtureDef();
				
		fixtureDef.density = _density;
		fixtureDef.restitution = _restitution;
		fixtureDef.friction = _friction;
		fixtureDef.shape = shape;
		fixtureDef.filter = _filterData;
		fixtureDef.isSensor = _isSensor;
		_body.createFixture(fixtureDef);
		
		if (!_useAutoMass)
		{
			_body.resetMassData();
		} // end if
		
		setGravityForces();
		
	} // end function
	
	
	/**
	 * 
	 * @param	type
	 */
	public function setShapeType(type:String):Void
	{
		if (type == _shapeType)
		{
			return;
		} // end if
		
		_shapeType = type;
		var shape:B2Shape = _body.getFixtureList().getShape();
		var shapeType:B2ShapeType = _body.getFixtureList().getShape().getType();
		
		if (_body == null)
		{
			switch(_shapeType)
			{
				case "box":
					//_body = CreateShape.createBox(_owner.x, _owner.y, 20, 1000, "static", _angle, _density, _restitution, _friction);
					_body = CreateShape.createBox(_owner.x + _owner.width / 2, _owner.y + _owner.height / 2, _owner.height, _owner.width, _type, _angle, _density, _restitution, _friction);
				
				case "circle":
					//_body = CreateShape.createCircle(_owner.x, _owner.y, 20, "static", _angle, _density, _restitution, _friction);
					_body = CreateShape.createCircle(_owner.x + _owner.width/2, _owner.y + _owner.height/2, Math.max(_owner.height, _owner.width), _type, _angle, _density, _restitution, _friction);
			
				case "polygon":
					_body = CreateShape.createBox(_owner.x + _owner.width / 2, _owner.y + _owner.height / 2, _owner.height, _owner.width, _type, _angle, _density, _restitution, _friction);
				
			} // end switch
			
			return;
		} // end if
		else
		{
			//trace("body not null");
			switch(_shapeType)
			{
				case "box":
					shape = new B2PolygonShape();
					cast(shape, B2PolygonShape).setAsBox((_width / 2) / CreateShape.physScale, (_height / 2) / CreateShape.physScale);
					
				case "circle":
					shape = new B2CircleShape(Math.max((_width / 2) / CreateShape.physScale, (_height / 2) / CreateShape.physScale));
					
				case "polygon":
					shape = new B2PolygonShape();
					cast(shape, B2PolygonShape).setAsBox((_width / 2) / CreateShape.physScale, (_height / 2) / CreateShape.physScale);
					
					
			} // end switch
		} // en else
		
		_body.DestroyFixture(_body.getFixtureList());
		var fixtureDef:B2FixtureDef = new B2FixtureDef();
				
		fixtureDef.density = _density;
		fixtureDef.restitution = _restitution;
		fixtureDef.friction = _friction;
		fixtureDef.shape = shape;
		fixtureDef.filter = _filterData;
		fixtureDef.isSensor = _isSensor;
		_body.createFixture(fixtureDef);
		
		if (!_useAutoMass)
		{
			_body.resetMassData();
		} // end if
		
		setGravityForces();
		
	} // end 
		
	
	/**
	 * Handles contats.
	 * Called in RigidBody.update().
	 */
	// TODO implement handleContants()
	private function handleContacts():Void
	{
		if (_body.getUserData())
		{
			if(_body.getUserData().contacts > 0)
			{
				//trace("Body " + _owner.name + " made contact!");
				//onContact();
			} // end if
		} // end if
		
	} // end function handleContacts
	
	
	/**
	 * 
	 */
	// TODO implement createBody()
	private function createBody():Void
	{
		
	} // end 
	
	
	/**
	 * 
	 */
	private function destroyBody():Void
	{
		//trace("destroying body!");
		world.destroyBody(_body);
		_body = null;
		
	} // end 
	
	
	/**
	 * Set the gravity forces (gCabcelForce, gScaleForce) to be used for the gravityScale property.
	 * Called in contructor, set gravityScale, and set mass, setShapeType and setSize.
	 */
	private function setGravityForces():Void
	{
		_gCancelForce = new B2Vec2(_body.getMass() * -_body.getWorld().getGravity().x, _body.getMass() * -_body.getWorld().getGravity().y);
		_gScaleForce = new B2Vec2((_body.getMass() * _body.getWorld().getGravity().x) * _gravityScale, (_body.getMass() * _body.getWorld().getGravity().y) * _gravityScale);	
	} // end 
	
	
	//====================================
	// BorrisPhysics duplicate functions
	//====================================
	
	
	/*public function applyForce(force:B2Vec2, poInt:B2Vec2):Void
	{
		body.applyForce(force, poInt);
	}
	
	public function applyImpulse(impulse:B2Vec2, poInt:B2Vec2):Void
	{
		body.applyImpulse(impulse, poInt);
	} // end */
	
	
	/**
	 * 
	 * @param	force
	 */
	public function applyForce(force:B2Vec2/*force:Vector2*/):Void
	{
		_body.applyForce(force, _body.getWorldCenter());
		//body.applyForce(new B2Vec2(0, 0), body.getWorldCenter());
	} // end 
	
	
	/**
	 * 
	 * @param	impulse
	 */
	public function applyImpulse(impulse:B2Vec2):Void
	{
		_body.applyImpulse(impulse, _body.getWorldCenter());
	} // end 
	
	
	/**
	 * 
	 * @param	torque
	 */
	public function applyTorque(torque:Float):Void
	{
		_body.applyTorque(torque);
	}
	
	
	public function isContacting1(rigidBody:BRigidBody2D):Bool
	{
		var edge = _body.getContactList();
		
		while (edge != null)
		{
			if (edge.contact.isTouching())
			{
				if (edge.contact.getFixtureB().getBody() == rigidBody.realBody)
				{
					return true;
				} // end if
			} // end if
			
			edge = edge.next;
		} // end while
		
		return false;
	} // end function
	
	
	/**
	 * 
	 * @param	name the name of the BEntity
	 * @return
	 */
	public function isContacting2(name:String):Bool
	{
		var edge = _body.getContactList();
		
		while (edge != null)
		{
			if (edge.contact.isTouching())
			{
				if (edge.contact.getFixtureB().getBody().getUserData().displayObject.name == "name")
				{
					return true;
				} // end if
			} // end if
			
			edge = edge.next;
		} // end while
		
		return false;
	} // end function
	
	
	
	public function isContacting3(type:Class<BEntity>):Bool
	{
		var edge = _body.getContactList();
		
		while (edge != null)
		{
			if (edge.contact.isTouching())
			{
				if (Std.is(edge.contact.getFixtureB().getBody().getUserData().displayObject, type))
				{
					return true;
				} // end if
			} // end if
			
			edge = edge.next;
		} // end while
		
		return false;
	} // end function
	
	
	public function isContacting4(type:Class<BEntity>):BEntity
	{
		var edge = _body.getContactList();
		
		while (edge != null)
		{
			if (edge.contact.isTouching())
			{
				if (Std.is(edge.contact.getFixtureB().getBody().getUserData().displayObject, type))
				{
					//return true;
					return cast(edge.contact.getFixtureB().getBody().getUserData().displayObject, BEntity);
				} // end if
			} // end if
			
			edge = edge.next;
		} // end while
		
		return null;
	} // end function
	
	
	public function isContacting5(entity:BEntity):Bool
	{
		var edge = _body.getContactList();
		
		while (edge != null)
		{
			if (edge.contact.isTouching())
			{
				if (edge.contact.getFixtureB().getBody().getUserData().displayObject == entity)
				{
					return true;
				} // end if
			} // end if
			
			edge = edge.next;
		} // end while
		
		return false;
	} // end function
	
	//**************************************** SET AND GET ******************************************
	
	
	private function get_realBody():B2Body
	{
		return _body;
	}
	
	
	private function get_active():Bool
	{
		return _body.isActive();
		//return _active;
	}
	
	private function set_active(value:Bool):Bool
	{
		_body.setActive(value);
		return _active = value;
	}
	
	
	private function get_angle():Float
	{
		return _body.getAngle();
		//return _angle;
	}
	
	private function set_angle(value:Float):Float
	{
		_body.setAngle(value);
		return _angle = value;
	}
	
	
	/*public function get allowDragging():Bool
	{
		return _allowDragging;
	}
	
	public function set allowDragging(value:Bool):Bool
	{
		_allowDragging = value;
	}*/
	
	
	private function get_angularDamping():Float
	{
		return _body.getAngularDamping();
		//return _angularDamping;
	}
	
	private function set_angularDamping(value:Float):Float
	{
		_body.setAngularDamping(value);
		return _angularDamping = value;
	}
	
	
	private function get_angularVelocity():Float
	{
		return _body.getAngularVelocity();
		//return _angularVelocity;
	}
	
	private function set_angularVelocity(value:Float):Float
	{
		_body.setAngularVelocity(value);
		return _angularVelocity = value;
	}
	
	
	private function get_applyGravity():Bool
	{
		return _applyGravity;
	}
	
	private function set_applyGravity(value:Bool):Bool
	{
		return _applyGravity = value;
	}
	
	
	private function get_autoSleep():Bool
	{
		return _body.isSleepingAllowed();
		//return _autoSleep;
	}
	
	private function set_autoSleep(value:Bool):Bool
	{
		_body.setSleepingAllowed(value);
		return _autoSleep = value;
	}
	
	
	private function get_awake():Bool
	{
		return _body.isAwake();
		//return _awake;
	}
	
	private function set_awake(value:Bool):Bool
	{
		_body.setAwake(value);
		return _awake = value;
	}
	
	
	private function get_bullet():Bool
	{
		return _body.isBullet();
		//return _bullet;
	}
	
	private function set_bullet(value:Bool):Bool
	{
		_body.setBullet(value);
		return _bullet = value;
	}
	
	
	private function get_categoryBits():UInt
	{
		return _filterData.categoryBits;
		//return _categoryBits;
	}
	
	private function set_categoryBits(value:UInt):UInt
	{
		_body.getFixtureList().getFilterData().categoryBits = value;
		//filterData.categoryBits = value;
		return _categoryBits = value;
	}
	
	
	private function get_density():Float
	{
		//return body.materialList.GetDensity();
		return _density;
	}
	
	private function set_density(value:Float):Float
	{
		_body.getFixtureList().setDensity(value);
		if (_useAutoMass)
		{
			_body.resetMassData();
		}
		
		return _density = value;
	}
	
	
	/*private function get disabled():Bool
	{
		return _disabled;
	}
	
	public function set disabled(value:Bool):Bool
	{
		_disabled = value;
	}*/
	
	
	private function get_fixedRotation():Bool
	{
		return _body.isFixedRotation();
		//return _fixedRotation;
	}
	
	private function set_fixedRotation(value:Bool):Bool
	{
		_body.setFixedRotation(value);
		return _fixedRotation = value;
	}
	
	
	private function get_friction():Float
	{
		//return body.materialList.GetFriction();
		return _friction;
	}
	
	private function set_friction(value:Float):Float
	{
		_body.getFixtureList().setFriction(value);
		return _friction = value;
	}
	
	
	private function get_gravityScale():Float
	{
		return _gravityScale;
	}
	
	private function set_gravityScale(value:Float):Float
	{
		_gravityScale = value;
		setGravityForces();
		return _gravityScale;
	}
	
	
	private function get_groupIndex():Int
	{
		return _filterData.groupIndex;
		//return _groupIndex;
	}
	
	private function set_groupIndex(value:Int):Int
	{
		//_body.getFixtureList().getFilterData().groupIndex = value;
		_groupIndex = _filterData.groupIndex = value;
		_body.getFixtureList().setFilterData(_filterData);
		return _groupIndex = value;
	}
	
	
	private function get_inertiaScale():Float
	{
		return _body.getDefinition().inertiaScale;
		//return _inertiaScale;
	}
	
	private function set_inertiaScale(value:Float):Float
	{
		_body.getDefinition().inertiaScale = value;
		return _inertiaScale = value;
	}
	
	
	/*public function get_isGround():Bool
	{
		return _isGround;
	}
	
	public function set isGround(value:Bool):Bool
	{
		_isGround = value;
	}
	*/
	
	
	private function get_isSensor():Bool
	{
		//return body.materialList.IsSensor();
		return _isSensor;
	}
	
	private function set_isSensor(value:Bool):Bool
	{
		_body.getFixtureList().setSensor(value);
		return _isSensor = value;
	}
	
	
	private function get_linearDamping():Float
	{
		return _body.getLinearDamping();
		//return _linearDamping;
	}
	
	private function set_linearDamping(value:Float):Float
	{
		_body.setLinearDamping(value);
		return _linearDamping = value;
	}
	
	
	private function get_linearVelocityX():Float
	{
		return _body.getLinearVelocity().x;
		//return _linearVelocityX;
	}
	
	private function set_linearVelocityX(value:Float):Float
	{
		_body.setLinearVelocity(new B2Vec2(value, _body.getLinearVelocity().y));
		//return _linearVelocityX = value;
		return value;
	}
	
	
	private function get_linearVelocityY():Float
	{
		return _body.getLinearVelocity().y;
		//return _linearVelocityY;
	}
	
	private function set_linearVelocityY(value:Float):Float
	{
		_body.setLinearVelocity(new B2Vec2(_body.getLinearVelocity().x, value));
		//return _linearVelocityY = value;
		return value;
	}
	
	
	private function get_maskBits():UInt
	{
		return _filterData.maskBits;
		//return _maskBits;
	}
	
	private function set_maskBits(value:UInt):UInt
	{
		_body.getFixtureList().getFilterData().maskBits = value;
		//filterData.maskBits = value;
		return _maskBits = value;
	}
	
	
	private function get_mass():Float
	{
		return _body.getMass();
		//return _mass;
	}
	
	private function set_mass(value:Float):Float
	{
		if (!_useAutoMass)
		{
			var massData:B2MassData = new B2MassData();
			massData.mass = value;
			
			_body.setMassData(massData);
			_mass = value;
			
			setGravityForces();
		}
		return _mass;
	}
	
	
	/*private function get_reportBeginContact():Bool
	{
		return _reportBeginContact;
	}
	
	public function set reportBeginContact(value:Bool):Bool
	{
		_reportBeginContact = value;
	}*/
	
	
	/*private function get_reportEndContact():Bool
	{
		return _reportEndContact;
	}
	
	public function set reportEndContact(value:Bool):Bool
	{
		_reportEndContact = value;
	}*/
	
	
	/*private function get_reportPostSolve():Bool
	{
		return _reportPostSolve;
	}
	
	public function set reportPostSolve(value:Bool):Bool
	{
		_reportPostSolve = value;
	}*/
	
	
	/*private function get_reportPreSolve():Bool
	{
		return _reportPreSolve;
	}
	
	public function set reportPreSolve(value:Bool):Bool
	{
		_reportPreSolve = value;
	}*/
	
	
	private function get_restitution():Float
	{
		//return body.materialList.GetRestitution();
		return _restitution;
	}
	
	private function set_restitution(value:Float):Float
	{
		_body.getFixtureList().setRestitution(value);
		return _restitution = value;
	}
	
	
	private function get_shapeType():String
	{
		return _shapeType;
	}
	
	
	private function get_type():String
	{
		return _type;
	}
	
	private function set_type(value:String):String
	{
		_type = value;
		
		switch(_type)
		{
			case "static":
				_body.setType(B2Body.b2_staticBody);
			
			case "dynamic":
				_body.setType(B2Body.b2_dynamicBody);
			
			case "kinematic":
				_body.setType(B2Body.b2_kinematicBody);
				
		} // end switch
		
		return _type;
	}
	
	
	private function get_useAutoMass():Bool
	{
		return _useAutoMass;
	}
	
	private function set_useAutoMass(value:Bool):Bool
	{
		return _useAutoMass = value;
	}
	
	
	private function get_width():Float
	{
		return _width;
	}
	
	private function set_width(value:Float):Float
	{
		if (_width == value)
		{
			return _width;
		}
		_width = value;
		setSize(_width, _height);
		return _width;
	}
	
	
	private function get_height():Float
	{
		return _height;
	}
	
	private function set_height(value:Float):Float
	{
		if (_height == value)
		{
			return _height;
		}
		_height = value;
		setSize(_width, _height);
		return _height;
	}
	
	
	private function get_x():Float
	{
		return _x;
	}
	
	private function set_x(value:Float):Float
	{
		_x = value;
		_body.setPosition(new B2Vec2(_x / physScale, _y / physScale));
		if (_ownerFollow)
		{
			_owner.x = Math.round(_body.getPosition().x * physScale);
		}
		
		return _x;
	}
	
	
	private function get_y():Float
	{
		return _y;
	}
	
	private function set_y(value:Float):Float
	{
		_y = value;
		_body.setPosition(new B2Vec2(_x / physScale, _y / physScale));
		if (_ownerFollow)
		{
			_owner.y = Math.round(_body.getPosition().y * physScale);
		}
		
		return _y;
	}
	
	private function get_numContacts():Int 
	{
		
		/*if (_body.getUserData() != null)
		{
			//trace("body user data");
			if(Std.int(_body.getUserData().contacts) > 0)
			{
				return Std.int(_body.getUserData().contacts);
			} // end if
			
			return Std.int(_body.getUserData().contacts);
		} // end if
		
		return 0;*/
		
		return Std.int(_body.getUserData().contacts);
	}
	
	
	/*private function get_contactEdges():B2ContactEdge
	{
		return _body.getcon
	}*/
	
}