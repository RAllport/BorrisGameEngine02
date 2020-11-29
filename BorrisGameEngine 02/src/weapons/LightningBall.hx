package weapons;

import borrisEngine.components.BParticleEmitter;
import borrisEngine.components.BRigidBody2D;
import borrisEngine.core.BEntity;
import borrisEngine.core.BGame;
import borrisEngine.core.BScene;
import borrisEngine.entities.paricles.BCustomizableParticle;
import borrisEngine.entities.paricles.BLightning;

import starling.display.*;
import starling.filters.FragmentFilter;

/**
 * ...
 * @author Rohaan Allport
 */
class LightningBall extends RangedWeaponProjectile
{
	var lightning:BLightning;
	
	
	public function new() 
	{
		super();
		
		_body.setShapeType("circle");
		_body.setSize(60, 60);
		//_body.applyGravity = false;
		_body.gravityScale = 0;
		//_body.type = "dynamic";
		
		speed = 7;
		angle = 0;
		lifeSpan = 2000;
		damage = 5;
		destroyOnContacts = true;
		autoRotate = true;
		//hitFX = ;
		//hitSFX = Assets.getSound("");
		
		var image = addChild(new Image(BGame.sAssets.getTexture("shockwave circle irregular 10000")));
		image.width = image.height = 60;
		image.x = -Math.ceil(image.width/2);
		image.y = -Math.ceil(image.height/2);
		
		
		// make lightning
		lightning = new BLightning();
		//lightning = cast(BScene.pool.getEntity(BLightning), BLightning);
		//lightning.x = 0;
		//lightning.y = 0;
		lightning.numBranches = 20;
		lightning.branchWidth = 1;
		lightning.color = 0xffffff;
		lightning.frequency = 10;
		lightning.amplitude = 10;
		lightning.lightningLength = 30;
		lightning.branchSpread = 0;
		lightning.branchAngularSpread = 360;
		lightning.amplitudeDelta = 2;
		//lightning.isForkLightning = false;
		lightning.startFromCenter = false;
		lightning.variableBranchWidth = true;
		//lightning.hasGlow = false;
		//lightning.glowColor = 0x0099FF;
		//lightning.glowSize = 2;
		//lightning.body.SetPosition(new b2vec2(10, 10));
		//lightning.rotation = 1;
		addChild(lightning);
		
		
		var pe:BParticleEmitter = cast(addComponent(new BParticleEmitter()), BParticleEmitter);
		pe.type = BCustomizableParticle;
		pe.texture = BGame.sAssets.getTexture("particle circle blur2 glow6 cyan0000");
		pe.x = -7;
		pe.numParticles = 3;
		pe.radius = 20;
		pe.size = 0.6;
		pe.speed = 0;
		pe.alpha = 1;
		//pe.color = 0x0066ff;
		
		//pe.gravity = -0.2;
		//pe.acceleration = 0;
		//pe.friction = 0;
		//pe.autoRotate = false;
		//pe.spin = 0;
		pe.fadeSpeed = -0.06;
		pe.growSpeed = -0.03;
		//pe.angle = -Math.PI/2;
		//pe.rotation = -90;
		
	}
	
	//**************************************** HANDLERS *********************************************
	
	
	
	//**************************************** FUNCTIONS ********************************************
	
	override public function update():Void
	{
		super.update();
		lightning.update();
	} // end function 
	
	//**************************************** SET AND GET ******************************************
	
	
}