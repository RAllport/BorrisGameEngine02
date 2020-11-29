package borrisEngine.components;

import borrisEngine.core.*;
import borrisEngine.core.BEntityComponent;
import box2D.dynamics.joints.*;

import borrisEngine.utils.createPhysics.*;

import box2D.dynamics.joints.B2Joint;
import box2D.common.math.B2Vec2;

/**
 * ...
 * @author Rohaan Allport
 */
class BPrismaticJoint extends BJoint
{
	public var realJoint(get, null):B2PrismaticJoint;
	
	private var _realJoint:B2PrismaticJoint;
	
	private var _anchor:B2Vec2;
	private var _axis:B2Vec2;
	private var _upperTranslation:Float;
	private var _lowerTranslation:Float;
	private var _enableLimit:Bool;
	private var _motorSpeed:Float;
	private var _maxMotorForce:Float;
	private var _enableMotor:Bool;
	

	public function new(rBodyA:BRigidBody2D, rBodyB:BRigidBody2D, anchor:B2Vec2, axis:B2Vec2, 
										upperTranslation:Float = 0, lowerTranslation:Float = 0, enableLimit:Bool = false, motorSpeed:Float = 0, 
										maxMotorForce:Float = 0, enableMotor:Bool = false) 
	{
		super(rBodyA, rBodyB);
		
		_anchor = anchor;
		_axis = axis;
		_upperTranslation = upperTranslation;
		_lowerTranslation = lowerTranslation;
		_enableLimit = enableLimit; 
		_motorSpeed = motorSpeed;
		_maxMotorForce = maxMotorForce;
		_enableMotor = enableMotor;
		
		_realJoint = CreateJoint.prismaticJoint(_rBodyA.realBody, _rBodyB.realBody, _anchor, _axis, _upperTranslation, _lowerTranslation, _enableLimit, _motorSpeed, _maxMotorForce, _enableMotor);
	}
	
	
	
	
	//**************************************** HANDLERS *********************************************
		
		
		
	//**************************************** FUNCTIONS ********************************************
	
	
	
	
	
	//**************************************** SET AND GET ******************************************
	
	
	/**
	 * 
	 */
	private function get_realJoint():B2PrismaticJoint 
	{
		return _realJoint;
	}
	
}