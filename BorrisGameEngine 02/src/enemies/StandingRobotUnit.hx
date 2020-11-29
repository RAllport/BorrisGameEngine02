package enemies;

import ai.BBaseAI;
import borrisEngine.components.BAnimator;
import borrisEngine.components.BJoint;
import borrisEngine.components.BRigidBody2D;
import borrisEngine.components.BWeldJoint;
import borrisEngine.core.BEntity;
import borrisEngine.core.BGame;
import box2D.common.math.B2Vec2;
import openfl.utils.Timer;
import starling.display.Image;
import starling.display.MovieClip;
import weapons.Pulser;
import weapons.RangedWeapon;
import weapons.RangedWeaponProjectile;

/**
 * ...
 * @author Rohaan Allport
 */
class StandingRobotUnit extends BEntity
{
	private var _animator:BAnimator;
	public var ai:BBaseAI;
	
	
	public function new() 
	{
		super();
		
		// add components
		_animator = cast(addComponent(new BAnimator()), BAnimator);
		
		var mainBody = new BRigidBody2D(true);
		var headBody = new BRigidBody2D(false);
		var legsBody = new BRigidBody2D(false);
		var runningWheelBody = new BRigidBody2D(false);
		
		
		//*******************************
		ai = new BBaseAI();
		
		ai.addRigidBody(mainBody);
		ai.addRigidBody(headBody);
		ai.addRigidBody(legsBody);
		ai.addRigidBody(runningWheelBody);
		
		
		ai.waypoints = [
			[1000, 0],
			[1500, 0]
		];
		
		ai.maxSpeed = 3;
		ai.seeingDistance = 2000;
		ai.jumpForce = -100;
		
		addComponent(ai);
		//*******************************
		
		mainBody.setSize(100, 100);
		mainBody.name = "body";
		
		headBody.y = 0;
		headBody.setShapeType("circle");
		headBody.setSize(70, 70);
		headBody.friction = 0;
		
		legsBody.y = 90;
		legsBody.setSize(80, 120);
		legsBody.friction = 0;
		
		runningWheelBody.y = 140;
		runningWheelBody.setShapeType("circle");
		runningWheelBody.setSize(80, 80);
		
		ai.getSensor("ground").y = 185;
		ai.getSensor("ground").setSize(100, 10);
		
		ai.getSensor("top").y = -145;
		ai.getSensor("top").setSize(100, 10);
		
		ai.getSensor("bottom").y = 200;
		ai.getSensor("bottom").setSize(100, 10);
		
		ai.getSensor("left").x = -120;
		//ai.getSensor("left").y = ;
		ai.getSensor("left").setSize(10, 100);
		
		ai.getSensor("right").x = 120;
		//ai.getSensor("right").y = ;
		ai.getSensor("right").setSize(10, 100);
		
		
		addComponent(new BWeldJoint(mainBody, legsBody, legsBody.realBody.getPosition()));
		addComponent(new BWeldJoint(mainBody, headBody, headBody.realBody.getPosition()));
		addComponent(new BWeldJoint(legsBody, runningWheelBody, runningWheelBody.realBody.getPosition()));
		addComponent(new BWeldJoint(ai.getSensor("ground"), mainBody, ai.getSensor("ground").realBody.getPosition()));
		addComponent(new BWeldJoint(ai.getSensor("top"), mainBody, ai.getSensor("top").realBody.getPosition()));
		addComponent(new BWeldJoint(ai.getSensor("bottom"), mainBody, ai.getSensor("bottom").realBody.getPosition()));
		addComponent(new BWeldJoint(ai.getSensor("left"), mainBody, ai.getSensor("left").realBody.getPosition()));
		addComponent(new BWeldJoint(ai.getSensor("right"), mainBody, ai.getSensor("right").realBody.getPosition()));
		
		// texture atlas
		var enemy_TA = BGame.sAssets.getTextureAtlas("Enemy standing robot unit 01");
		
		var _standingMC = new MovieClip(enemy_TA.getTextures("standing robot unit 01 standing"), 30);
		_standingMC.x = -_standingMC.width / 2;
		_standingMC.y = -_standingMC.height / 2 + 10;
		
		var _walkingMC = new MovieClip(enemy_TA.getTextures("standing robot unit 01 walking"), 30);
		_walkingMC.x = -_walkingMC.width / 2;
		_walkingMC.y = -_walkingMC.height / 2 + 20;
		
		_animator.addAnimation(_standingMC, "standing", true);
		_animator.addAnimation(_walkingMC, "walking", true);
		
		
		forceActive = true;
		
	}
	
	
	//**************************************** HANDLERS *********************************************
	
	
	
	//**************************************** FUNCTIONS ********************************************
	
	
	override public function update():Void
	{
		super.update();
		
		trace(ai.movementState);
		
		if (ai.movementState == BBaseAI.STILL)
		{
			_animator.switchAnimationByName("standing");
		} // end else if
		else //if (ai.movementState == BBaseAI.WALKING || ai.movementState == BBaseAI.JUMPING)
		{
			_animator.switchAnimationByName("walking");
		} // end if
		
		
	} // end function
	
	//**************************************** SET AND GET ******************************************
	
	
}