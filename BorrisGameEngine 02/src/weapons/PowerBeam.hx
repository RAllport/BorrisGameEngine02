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
class PowerBeam extends RangedWeaponProjectile
{
	private static var _totalPulsers:Int = 0;

	public function new() 
	{
		super();
		
		//_body.setShapeType("circle");
		_body.setSize(2000, 80);
		//_body.applyGravity = false;
		_body.gravityScale = 0;
		_body.type = "kinematic";
		
		speed = 0;
		angle = 0;
		lifeSpan = 2000;
		damage = 10;
		destroyOnContacts = true;
		autoRotate = true;
		//hitFX = ;
		//hitSFX = Assets.getSound("");
		
		var image = addChild(new Image(BGame.sAssets.getTexture("Beam piece 10000")));
		image.x = -Math.ceil(image.width/2);
		image.y = -Math.ceil(image.height / 2);
		
		image = addChild(new Image(BGame.sAssets.getTexture("Beam piece 10000")));
		image.height = 40;
		image.x = -Math.ceil(image.width/2);
		image.y = -Math.ceil(image.height / 2);
		
		image = addChild(new Image(BGame.sAssets.getTexture("Beam piece 10000")));
		image.height = 20;
		image.x = -Math.ceil(image.width/2);
		image.y = -Math.ceil(image.height/2);
		
		
		/*var pe:BParticleEmitter = cast(addComponent(new BParticleEmitter()), BParticleEmitter);
		pe.type = BCustomizableParticle;
		pe.bitmapData = BGame.sAssets.getTexture("particle circle blur2 glow6 red.png");
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
		//pe.rotation = -90;*/
		
		
		//name = "Pulser" + ++_totalPulsers;
		//trace(name);
	}
	
	//**************************************** HANDLERS *********************************************
	
	
	
	//**************************************** FUNCTIONS ********************************************
	
	
	
	//**************************************** SET AND GET ******************************************
	
	
}