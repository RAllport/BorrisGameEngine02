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
class BRevoluteJoint extends BJoint
{
	private var _realJoint:B2RevoluteJoint;
	
	private var _anchor:B2Vec2;
	private var _upperAngle:Float;
	private var _lowerAngle:Float;
	private var _enableLimit:Bool;
	private var _motorSpeed:Float;
	private var _maxMotorTorque:Float;
	private var _enableMotor:Bool;
	
	
	public function new(rBodyA:BRigidBody2D, rBodyB:BRigidBody2D, anchor:B2Vec2, upperAngle:Float = 0, 
										lowerAngle:Float = 0, enableLimit:Bool = false, motorSpeed:Float = 0, 
										maxMotorTorque:Float = 0, enableMotor:Bool = false) 
	{
		super(rBodyA, rBodyB);
		
		_anchor = anchor;
		_upperAngle = upperAngle;
		_lowerAngle = lowerAngle;
		_enableLimit = enableLimit;
		_motorSpeed = motorSpeed;
		_maxMotorTorque = maxMotorTorque;
		_enableMotor = enableMotor;
		
		_realJoint = CreateJoint.revoluteJoint(_rBodyA.realBody, _rBodyB.realBody, _anchor, _upperAngle, _lowerAngle, _enableLimit, _motorSpeed, _maxMotorTorque, _enableMotor);
	}
	
	
	//**************************************** HANDLERS *********************************************
		
		
		
	//**************************************** FUNCTIONS ********************************************
	
	
	
	
	
	//**************************************** SET AND GET ******************************************
	
	
}