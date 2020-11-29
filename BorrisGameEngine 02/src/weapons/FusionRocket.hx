package weapons;

import openfl.Assets;
import openfl.display.Bitmap;

import borrisEngine.components.BParticleEmitter;
import borrisEngine.components.BRigidBody2D;
import borrisEngine.core.BEntity;
import borrisEngine.core.BGame;
import borrisEngine.entities.paricles.BCustomizableParticle;
import borrisEngine.entities.paricles.Smoke;

import starling.display.*;

/**
 * ...
 * @author Rohaan Allport
 */
class FusionRocket extends RangedWeaponProjectile
{
	private static var _totalPulsers:Int = 0;

	public function new() 
	{
		super();
		
		//_body.setShapeType("circle");
		_body.setSize(76, 14);
		//_body.applyGravity = false;
		_body.gravityScale = 0;
		//_body.type = "dynamic";
		
		speed = 10;
		angle = 0;
		lifeSpan = 1500;
		damage = 0.3;
		destroyOnContacts = true;
		autoRotate = true;
		//hitFX = ;
		//hitSFX = Assets.getSound("");
		
		var image = addChild(new Image(BGame.sAssets.getTexture("fusion rocket0000")));
		image.x = -Math.ceil(image.width/2);
		image.y = -Math.ceil(image.height/2);
		
		
		var pe:BParticleEmitter = cast(addComponent(new BParticleEmitter()), BParticleEmitter);
		pe.type = Smoke;
		//pe.bitmapData = Assets.getBitmapData("img/Effects/particle circle blur2 glow6 red.png");
		pe.x = -38;
		pe.numParticles = 2;
		pe.radius = 10;
		pe.size = 0.5;
		pe.speed = 0;
		pe.alpha = 1;
		//pe.color = 0x0066ff;
		
		//pe.gravity = -0.2;
		//pe.acceleration = 0;
		//pe.friction = 0;
		//pe.autoRotate = false;
		//pe.spin = 0;
		pe.fadeSpeed = -0.02;
		pe.growSpeed = 0.04;
		//pe.angle = -Math.PI/2;
		//pe.rotation = -90;
		
	}
	
	//**************************************** HANDLERS *********************************************
	
	
	
	//**************************************** FUNCTIONS ********************************************
	
	
	
	//**************************************** SET AND GET ******************************************
	
	
}