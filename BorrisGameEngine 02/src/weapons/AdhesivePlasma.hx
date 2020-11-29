package weapons;

import openfl.Assets;
import openfl.display.Bitmap;

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
class AdhesivePlasma extends RangedWeaponProjectile
{
	private static var _totalPulsers:Int = 0;

	public function new() 
	{
		super();
		
		_body.setShapeType("circle");
		_body.setSize(20, 20);
		//_body.applyGravity = false;
		_body.gravityScale = 0.8;
		//_body.type = "dynamic";
		_body.friction = 0.3;
		_body.restitution = 0.5;
		
		speed = 12;
		angle = 0;
		lifeSpan = 5000;
		damage = 1;
		destroyOnContacts = false;
		autoRotate = false;
		//hitFX = ;
		//hitSFX = Assets.getSound("");
		
		var image = addChild(new Image(BGame.sAssets.getTexture("particle circle blur2 glow6 purple0000")));
		image.width = image.height = 40;
		image.x = -Math.ceil(image.width/2);
		image.y = -Math.ceil(image.height/2);
		
	}
	
	//**************************************** HANDLERS *********************************************
	
	
	
	//**************************************** FUNCTIONS ********************************************
	
	
	
	//**************************************** SET AND GET ******************************************
	
	
}