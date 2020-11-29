package borrisEngine.components;

import borrisEngine.core.*;
import borrisEngine.core.BEntityComponent;

import borrisEngine.utils.createPhysics.*;

import box2D.dynamics.joints.*;
import box2D.common.math.B2Vec2;

/**
 * ...
 * @author Rohaan Allport
 */
class BWeldJoint extends BJoint
{
	private var _realJoint:B2WeldJoint;
	
	private var _anchor:B2Vec2;
	
	
	public function new(rBodyA:BRigidBody2D, rBodyB:BRigidBody2D, anchor:B2Vec2) 
	{
		super(rBodyA, rBodyB);
		
		_anchor = anchor;
		
		_realJoint = CreateJoint.weldJoint(_rBodyA.realBody, _rBodyB.realBody, _anchor);
		
	}
	
	
	//**************************************** HANDLERS *********************************************
		
		
		
	//**************************************** FUNCTIONS ********************************************
	
	
	
	
	
	//**************************************** SET AND GET ******************************************
	
	
}