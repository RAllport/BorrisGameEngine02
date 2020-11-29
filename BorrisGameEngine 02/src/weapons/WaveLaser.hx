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
class WaveLaser extends RangedWeaponProjectile
{
	private static var _totalPulsers:Int = 0;

	public function new() 
	{
		super();
		
		_body.setShapeType("circle");
		_body.setSize(22, 22);
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
		
		var image = addChild(new Image(BGame.sAssets.getTexture("wave laser blur2 glow5 cyan0000")));
		image.x = -Math.ceil(image.width/2);
		image.y = -Math.ceil(image.height/2);
		
		var pe:BParticleEmitter = cast(addComponent(new BParticleEmitter()), BParticleEmitter);
		pe.type = BCustomizableParticle;
		pe.texture = BGame.sAssets.getTexture("particle circle blur2 glow6 cyan0000");
		pe.x = -7;
		pe.numParticles = 1;
		pe.radius = 5;
		pe.size = 0.3;
		pe.speed = 0;
		pe.alpha = 1;
		//pe.color = 0x0066ff;
		
		//pe.gravity = -0.2;
		//pe.acceleration = 0;
		//pe.friction = 0;
		//pe.autoRotate = false;
		//pe.spin = 0;
		pe.fadeSpeed = -0.02;
		pe.growSpeed = -0.01;
		//pe.angle = -Math.PI/2;
		//pe.rotation = -90;
		
	}
	
	//**************************************** HANDLERS *********************************************
	
	
	
	//**************************************** FUNCTIONS ********************************************
	
	
	
	//**************************************** SET AND GET ******************************************
	
	
}