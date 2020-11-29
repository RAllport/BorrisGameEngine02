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
class SpiderUnit extends BEntity
{
	private var _animator:BAnimator;
	public var ai:BBaseAI;
	
	
	public function new() 
	{
		super();
		
		// add components
		_animator = cast(addComponent(new BAnimator()), BAnimator);
		
		var mainBody = new BRigidBody2D(true);
		var legsBody = new BRigidBody2D(false);
		var runningWheelBody = new BRigidBody2D(false);
		//var groundSenor = new BRigidBody2D(false);
		//var leftSensor = new BRigidBody2D(false);
		//var rightSensor = new BRigidBody2D(false);
		
		
		//*******************************
		ai = new BBaseAI();
		
		ai.addRigidBody(mainBody);
		ai.addRigidBody(legsBody);
		ai.addRigidBody(runningWheelBody);
		//ai.addSensor(groundSenor, "ground sensor");
		//ai.addSensor(leftSensor, "left sensor");
		//ai.addSensor(rightSensor, "right sensor");
		
		
		ai.waypoints = [
			[1000, 0],
			[1500, 0]
		];
		
		ai.maxSpeed = 3;
		ai.seeingDistance = 2000;
		ai.jumpForce = -30;
		
		addComponent(ai);
		//*******************************
		
		mainBody.setSize(80, 100);
		mainBody.name = "body";
		
		legsBody.y = 50;
		legsBody.setSize(160, 40);
		legsBody.friction = 0;
		//legsBody.density = 0.5;
		
		runningWheelBody.y = 50;
		runningWheelBody.setShapeType("circle");
		runningWheelBody.setSize(80, 80);
		
		ai.getSensor("ground").y = 95;
		ai.getSensor("ground").setSize(50, 10);
		
		ai.getSensor("top").y = -85;
		ai.getSensor("top").setSize(100, 10);
		
		ai.getSensor("bottom").y = 125;
		ai.getSensor("bottom").setSize(100, 10);
		
		ai.getSensor("left").x = -120;
		//ai.getSensor("left").y = ;
		ai.getSensor("left").setSize(10, 100);
		
		ai.getSensor("right").x = 120;
		//ai.getSensor("right").y = ;
		ai.getSensor("right").setSize(10, 100);
		
		
		addComponent(new BWeldJoint(mainBody, legsBody, legsBody.realBody.getPosition()));
		addComponent(new BWeldJoint(legsBody, runningWheelBody, runningWheelBody.realBody.getPosition()));
		addComponent(new BWeldJoint(ai.getSensor("ground"), mainBody, ai.getSensor("ground").realBody.getPosition()));
		addComponent(new BWeldJoint(ai.getSensor("top"), mainBody, ai.getSensor("top").realBody.getPosition()));
		addComponent(new BWeldJoint(ai.getSensor("bottom"), mainBody, ai.getSensor("bottom").realBody.getPosition()));
		addComponent(new BWeldJoint(ai.getSensor("left"), mainBody, ai.getSensor("left").realBody.getPosition()));
		addComponent(new BWeldJoint(ai.getSensor("right"), mainBody, ai.getSensor("right").realBody.getPosition()));
		
		// texture atlas
		var enemy_TA = BGame.sAssets.getTextureAtlas("Enemy spider unit01");
		
		var _standingMC = new MovieClip(enemy_TA.getTextures("Sider unit1 standing"), 30);
		_standingMC.x = -_standingMC.width / 2;
		_standingMC.y = -_standingMC.height / 2 + 10;
		
		var _walkingMC = new MovieClip(enemy_TA.getTextures("Sider unit1 walking forward"), 30);
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