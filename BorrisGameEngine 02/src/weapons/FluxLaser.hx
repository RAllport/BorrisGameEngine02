package weapons;

import borrisEngine.components.BParticleEmitter;
import borrisEngine.components.BRigidBody2D;
import borrisEngine.core.BEntity;
import borrisEngine.core.BGame;
import borrisEngine.entities.paricles.BCustomizableParticle;

import starling.display.*;

/**
 * ...
 * @author Rohaan Allport
 */
class FluxLaser extends RangedWeaponProjectile
{
	private static var _totalPulsers:Int = 0;

	public function new() 
	{
		super();
		
		//_body.setShapeType("circle");
		_body.setSize(2000, 24);
		//_body.applyGravity = false;
		_body.gravityScale = 0;
		_body.type = "kinematic";
		
		speed = 0;
		angle = 0;
		lifeSpan = 250;
		damage = 5;
		destroyOnContacts = false;
		//autoRotate = true;
		//hitFX = ;
		//hitSFX = Assets.getSound("");
		
		var image = addChild(new Image(BGame.sAssets.getTexture("pulser laser blur2 glow6 red0000")));
		image.x = -Math.ceil(image.width/2);
		image.y = -Math.ceil(image.height/2);
		
		
	}
	
	//**************************************** HANDLERS *********************************************
	
	
	
	//**************************************** FUNCTIONS ********************************************
	
	
	
	//**************************************** SET AND GET ******************************************
	
	
}