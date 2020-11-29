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
class PulseDoubleLaser extends RangedWeaponProjectile
{
	private static var _totalPulsers:Int = 0;

	public function new() 
	{
		super();
		
		_body.setShapeType("circle");
		_body.setSize(12, 12);
		//_body.applyGravity = false;
		_body.gravityScale = 0;
		//_body.type = "dynamic";
		
		speed = 10;
		angle = 0;
		lifeSpan = 1500;
		damage = 1;
		destroyOnContacts = true;
		autoRotate = true;
		//hitFX = ;
		//hitSFX = Assets.getSound("");
		
		var image = addChild(new Image(BGame.sAssets.getTexture("pulse double laser blur2 glow5 blue0000")));
		image.x = -Math.ceil(image.width/2);
		image.y = -Math.ceil(image.height/2);
		
	}
	
	//**************************************** HANDLERS *********************************************
	
	
	
	//**************************************** FUNCTIONS ********************************************
	
	
	
	//**************************************** SET AND GET ******************************************
	
	
}