package borrisEngine.components;

import borrisEngine.core.BEntity;
import borrisEngine.core.BEntityComponent;
import borrisEngine.utils.createPhysics.*;
import box2D.dynamics.joints.B2Joint;

import box2D.dynamics.*;
import box2D.collision.*;
import box2D.collision.shapes.*;
import box2D.dynamics.joInts.*;
import box2D.dynamics.contacts.*;
import box2D.common.*;
import box2D.common.math.*;

/**
 * ...
 * @author Rohaan Allport
 */
class BJoint extends BEntityComponent
{
	//private var _realJoint:B2Joint;
	
	private var _type:String;
	
	private var _rBodyA:BRigidBody2D;
	private var _rBodyB:BRigidBody2D;
	/*private var _anchorA:B2Vec2;
	private var _anchorB:B2Vec2;
	private var _upperAngle:Float;
	private var _lowerAngle:Float;
	private var _axis:B2Vec2;
	private var _upperTranslation:Float;
	private var _lowerTranslation:Float;
	private var _groundAnchorA:B2Vec2;
	private var _groundAnchorB:B2Vec2;
	private var _enableLimit:Bool;
	private var _motorSpeed:Float;
	private var _maxMotorTorque:Float;
	private var _maxMotorForce:Float;
	private var _enableMotor:Bool;*/
	

	public function new(rBodyA:BRigidBody2D, rBodyB:BRigidBody2D)
	{
		super();
		
		_rBodyA = rBodyA;
		_rBodyB = rBodyB;
		
		CreateJoint.world = _rBodyA.realBody.getWorld();
		
		/*switch(type)
		{
			case "revolute":
				
			
			case "distance":
				
			
			case "prismatic":
				
			
			case "gear":
				
			
			case "pully":
				
			
			case "friction":
				
			
			case "weld":
				
			
			
		} // end switch*/
		
	}
	
	
	//**************************************** HANDLERS *********************************************
		
		
		
	//**************************************** FUNCTIONS ********************************************
	
	
	
	
	
	//**************************************** SET AND GET ******************************************
	
	
}