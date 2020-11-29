package weapons;

import borrisEngine.components.BParticleEmitter;
import borrisEngine.components.BRigidBody2D;
import borrisEngine.core.BEntity;
import borrisEngine.entities.paricles.BCustomizableParticle;
import openfl.Assets;
import openfl.display.Bitmap;

/**
 * ...
 * @author Rohaan Allport
 */
class SpreadLightning extends RangedWeaponProjectile
{
	private static var _totalPulsers:Int = 0;

	public function new() 
	{
		super();
		
		_body.setShapeType("polygon");
		_body.setSize(100, 100);
		//_body.applyGravity = false;
		_body.gravityScale = 0;
		//_body.type = "kinematic";
		
		speed = 0;
		angle = 0;
		lifeSpan = 300;
		damage = 1;
		destroyOnContactse = false;
		autoRotate = true;
		//hitFX = ;
		//hitSFX = Assets.getSound("");
		
		var image = addChild(new Bitmap(Assets.getBitmapData("img/Effects/particle start8-05 blur2 glow6 cyan.png")));
		image.x = -Math.ceil(image.width/2);
		image.y = -Math.ceil(image.height/2);
		
		
		/*var pe:BParticleEmitter = cast(addComponent(new BParticleEmitter()), BParticleEmitter);
		pe.type = BCustomizableParticle;
		pe.bitmapData = Assets.getBitmapData("img/Effects/particle circle blur2 glow6 red.png");
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