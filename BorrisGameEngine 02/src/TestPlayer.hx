package;

import borrisEngine.core.BEntityComponent;
import openfl.Assets;

import starling.display.*;
import starling.events.*;
import starling.textures.*;
import starling.geom.Rectangle;

import box2D.collision.shapes.B2PolygonShape;
import box2D.common.math.B2Vec2;
import box2D.dynamics.*;
import box2D.dynamics.joints.*;

import borrisEngine.core.BGame;
import borrisEngine.core.BEntity;
import borrisEngine.core.BScene;
import borrisEngine.entities.*;
//import borrisEngine.entities.paricles.*;

import borrisEngine.components.*;
import weapons.*;

/**
 * ...
 * @author Rohaan Allport
 */
class TestPlayer extends BEntity
{
	// Images & MovieClips
	private var _standingMC:MovieClip;
	private var _runningForwardMC:MovieClip;
	private var _runningBackwardMC:MovieClip;
	private var _jumpingMC:MovieClip;
	private var _duckingMC:MovieClip;
	private var _dashingForwardMC:MovieClip;
	private var _dashingBackwardMC:MovieClip;
	private var _hoveringForwardMC:MovieClip;
	private var _hoveringBackwardMC:MovieClip;
	
	private var _frontHandsMC:MovieClip;
	private var _backHandsMC:MovieClip;
	

	public function new() 
	{
		super(); 
		
		forceActive = true;
		
		//x = 000;
		//y = 100;
		
		// add components
		var headBody = cast(addComponent(new BRigidBody2D(false)), BRigidBody2D);
		var torseBody = cast(addComponent(new BRigidBody2D(true)), BRigidBody2D);
		var legsBody = cast(addComponent(new BRigidBody2D(false)), BRigidBody2D);
		var runningWheelBody = cast(addComponent(new BRigidBody2D(false)), BRigidBody2D);
		var groundSenserBody = cast(addComponent(new BRigidBody2D(false)), BRigidBody2D);
		
		headBody.y -= 34;
		//torseBody.x 
		legsBody.y += 44;
		runningWheelBody.y += 70;
		groundSenserBody.y += 86;
		
		torseBody.name = "torsoBody";
		groundSenserBody.name = "groundSensorBody";
		//runningWheelBody.name = "groundSensorBody";
		
		headBody.setShapeType("circle");
		headBody.setSize(24, 24);
		
		// there was the most annoying error ECAH!!!
		//torseBody.fixedRotation = true;
		torseBody.setSize(30, 44);
		
		legsBody.setSize(24, 50);
		legsBody.fixedRotation = true;
		
		runningWheelBody.setShapeType("circle");
		runningWheelBody.setSize(24, 24);
		
		groundSenserBody.setSize(30, 10);
		groundSenserBody.isSensor = true;
		
		headBody.groupIndex = 
		torseBody.groupIndex = 
		legsBody.groupIndex = 
		runningWheelBody.groupIndex = 
		groundSenserBody.groupIndex = -1;
		
		var neckJoint = cast(addComponent(new BWeldJoint(headBody, torseBody, headBody.realBody.getPosition())), BWeldJoint);
		var bodyJoint = cast(addComponent(new BPrismaticJoint(torseBody, legsBody, torseBody.realBody.getPosition(), new B2Vec2(0, 1), 0, 1, true, 0, 20, false)), BPrismaticJoint);
		var runningWheelJoint = cast(addComponent(new BRevoluteJoint(legsBody, runningWheelBody, runningWheelBody.realBody.getPosition(), 0, 0, false, 0, 10, true)), BRevoluteJoint);
		var groundSensorJoint = cast(addComponent(new BWeldJoint(groundSenserBody, legsBody, groundSenserBody.realBody.getPosition())), BWeldJoint);
		var animator = cast(addComponent(new BAnimator()), BAnimator);
		
		bodyJoint.name = "bodyJoint";
		
		
		// texture atlas
		//var main_character_TA:BTextureAtlas = new BTextureAtlas(BTexture.fromBitmapData(Assets.getBitmapData("img/Main Char sprites.png")), Xml.parse(Assets.getText("img/Main Char sprites.xml")));
		var main_character_TA = BGame.sAssets.getTextureAtlas("main char");
		
		_standingMC = new MovieClip(main_character_TA.getTextures("standing blue 2"), 30);
		_runningForwardMC = new MovieClip(main_character_TA.getTextures("running blue forwards"), 30);
		_runningBackwardMC = new MovieClip(main_character_TA.getTextures("running blue backwards"), 30);
		_jumpingMC = new MovieClip(main_character_TA.getTextures("jumping blue"), 30);
		_duckingMC = new MovieClip(main_character_TA.getTextures("ducking blue"), 20);
		_dashingForwardMC = new MovieClip(main_character_TA.getTextures("dashing blue forwards"), 30);
		_dashingBackwardMC = new MovieClip(main_character_TA.getTextures("dashing blue backwards"), 30);
		_hoveringForwardMC = new MovieClip(main_character_TA.getTextures("hover blue forwards"), 30);
		_hoveringBackwardMC = new MovieClip(main_character_TA.getTextures("hover blue backwards"), 30);
		//handsImage = new Image(main_character_TA.getTexture("arms0000"));
		_frontHandsMC = new MovieClip(main_character_TA.getTextures("arms front"), 2);
		_backHandsMC = new MovieClip(main_character_TA.getTextures("arms back"), 2);
		
		animator.addAnimation(_standingMC, "standing", true);
		animator.addAnimation(_runningForwardMC, "runningForward", true);
		animator.addAnimation(_runningBackwardMC, "runningBackward", true);
		animator.addAnimation(_jumpingMC, "jumping", false);
		animator.addAnimation(_duckingMC, "ducking", false);
		animator.addAnimation(_dashingForwardMC, "dashingForward", false);
		animator.addAnimation(_dashingBackwardMC, "dashingBackward", false);
		animator.addAnimation(_hoveringForwardMC, "hoveringForward", false);
		animator.addAnimation(_hoveringBackwardMC, "hoveringBackward", false);
		//animator.addAnimation(frontHandsMC, "frontHands", false);
		//animator.addAnimation(backHandsMC, "backHands", false);
		_frontHandsMC.name = "frontHands";
		_backHandsMC.name = "backHands";
		
		//animator.switchAnimationByName("runningForward");
		//animator.switchAnimationByName("runningBackward");
		
		/*standingMC.loop = true;
		runningForwardMC.loop = true;
		runningBackwardMC.loop = true;
		jumpingMC.loop = false;
		duckingMC.loop = false;
		dashingForwardMC.loop = false;
		dashingBackwardMC.loop = false;
		hoveringForwardMC.loop = false;
		hoveringBackwardMC.loop = false;*/
		_frontHandsMC.loop = true;
		_backHandsMC.loop = true;
		
		
		addChild(_frontHandsMC);
		addChildAt(_backHandsMC, 0);
		
		_standingMC.x = -16;
		_standingMC.y = -46;
		_runningForwardMC.x = -62;
		_runningForwardMC.y = -46;
		_runningBackwardMC.x = -62;
		_runningBackwardMC.y = -46;
		_jumpingMC.x = -23;
		_jumpingMC.y = -46;
		_duckingMC.x = -44;
		_duckingMC.y = -46;
		_dashingForwardMC.x = -56;
		_dashingForwardMC.y = -46;
		_dashingBackwardMC.x = -56;
		_dashingBackwardMC.y = -46;
		_hoveringForwardMC.x = -48;
		_hoveringForwardMC.y = -46;
		_hoveringBackwardMC.x = -26;
		_hoveringBackwardMC.y = -46;
		
		_frontHandsMC.pivotX = 38;
		_frontHandsMC.pivotY = 45;
		_frontHandsMC.x = 0;
		_frontHandsMC.y = -16;
		
		_backHandsMC.pivotX = 5;
		_backHandsMC.pivotY = 21;
		_backHandsMC.x = 0;
		_backHandsMC.y = -16;
		
		_frontHandsMC.currentFrame = _backHandsMC.currentFrame = 1;
		_frontHandsMC.pause();
		_backHandsMC.pause();
		
		// weapon components
		createWeapoens();
		
		var controllor = cast(addComponent(new BCharacterController2D(torseBody)), BCharacterController2D);
	}
	
	
	//**************************************** HANDLERS *********************************************
	
	
	
	//**************************************** FUNCTIONS ********************************************
	
	
	/**
	 * @inheritDoc
	 */
	override public function update():Void
	{
		super.update();
		
		//trace("Bounderies left: " + BEntity.boundries.left + " | Bounderies right: " + BEntity.boundries.right + " | Bounderies top: " + BEntity.boundries.top + " | Bounderies bottom: " + BEntity.boundries.bottom);
		
		//trace("Bounds: " + BEntity.boundries);
	} // end function update
	
	
	/**
	 * 
	 */
	private function createWeapoens():Void
	{
		// pulser
		var pulsePistol:RangedWeapon;
		pulsePistol = cast(addComponent(new RangedWeapon()), RangedWeapon);
		pulsePistol.projectileType = Pulser;
		pulsePistol.name = "pulse pistol";
		//pulsePistol.ammo = 100;
		//pulsePistol.maxAmmo = 100;
		pulsePistol.attackSpeed = 0.3;
		pulsePistol.startDelay = 0;
		pulsePistol.shootDelay = 0;
		pulsePistol.barrelPivot.y = -25;
		pulsePistol.barrelLength = 90;
		pulsePistol.spread = 50;
		pulsePistol.numberOfProjectiles = 1;
		//pulsePistol.fireFX = PulserFireFX;
		//pulsePistol.fireSFX = Assets.getSound("");
		
		// hydra wave gun
		var hydraWaveGun:RangedWeapon;
		hydraWaveGun = cast(addComponent(new RangedWeapon()), RangedWeapon);
		hydraWaveGun.projectileType = WaveLaser;
		hydraWaveGun.name = "hydra wave gun";
		//hydraWaveGun.accuracy = 1;
		//hydraWaveGun.ammo = 100;
		//hydraWaveGun.maxAmmo = 100;
		hydraWaveGun.attackSpeed = 0.8;
		hydraWaveGun.startDelay = 0;
		hydraWaveGun.shootDelay = 0;
		hydraWaveGun.barrelPivot.y = -20;
		hydraWaveGun.barrelLength = 74;
		hydraWaveGun.spread = 50;
		hydraWaveGun.numberOfProjectiles = 5;
		//hydraWaveGun.fireFX = WaveFireFX;
		//hydraWaveGun.fireSFX = Assets.getSound("");
		
		// assault pulser
		var assaultPulser:RangedWeapon;
		assaultPulser = cast(addComponent(new RangedWeapon()), RangedWeapon);
		assaultPulser.projectileType = PulseDoubleLaser;
		assaultPulser.name = "assault pulser";
		//assaultPulser.ammo = 100;
		//assaultPulser.maxAmmo = 100;
		assaultPulser.attackSpeed = 0.1;
		assaultPulser.startDelay = 0;
		assaultPulser.shootDelay = 0;
		assaultPulser.barrelPivot.y = -18;
		assaultPulser.barrelLength = 78;
		assaultPulser.spread = 50;
		assaultPulser.numberOfProjectiles = 1;
		//assaultPulser.fireFX = PulserFireFX;
		//assaultPulser.fireSFX = Assets.getSound("");
		
		// flux railgun
		var fluxRailgun:RangedWeapon;
		fluxRailgun = cast(addComponent(new RangedWeapon()), RangedWeapon);
		fluxRailgun.projectileType = FluxLaser;
		fluxRailgun.name = "flux railgun";
		//fluxRailgun.ammo = 100;
		//fluxRailgun.maxAmmo = 100;
		fluxRailgun.attackSpeed = 1;
		fluxRailgun.startDelay = 0;
		fluxRailgun.shootDelay = 0;
		fluxRailgun.barrelPivot.y = -18;
		fluxRailgun.barrelLength = 105;
		fluxRailgun.spread = 50;
		fluxRailgun.numberOfProjectiles = 1;
		//fluxRailgun.fireFX = PulserFireFX;
		//fluxRailgun.fireSFX = Assets.getSound("");
		
		// plasma launcher
		var plasmaLauncher:RangedWeapon;
		plasmaLauncher = cast(addComponent(new RangedWeapon()), RangedWeapon);
		plasmaLauncher.projectileType = AdhesivePlasma;
		plasmaLauncher.name = "plasma launcher";
		//plasmaLauncher.ammo = 100;
		//plasmaLauncher.maxAmmo = 100;
		plasmaLauncher.attackSpeed = 1.5;
		plasmaLauncher.startDelay = 0;
		plasmaLauncher.shootDelay = 0;
		plasmaLauncher.barrelPivot.y = -8;
		plasmaLauncher.barrelLength = 76;
		plasmaLauncher.spread = 50;
		plasmaLauncher.numberOfProjectiles = 1;
		//plasmaLauncher.fireFX = PulserFireFX;
		//plasmaLauncher.fireSFX = Assets.getSound("");
		
		// fission rocket launcher
		var fissionRocketLauncher:RangedWeapon;
		fissionRocketLauncher = cast(addComponent(new RangedWeapon()), RangedWeapon);
		fissionRocketLauncher.projectileType = FusionRocket;
		fissionRocketLauncher.name = "fission rocket launcher";
		//fissionRocketLauncher.ammo = 100;
		//fissionRocketLauncher.maxAmmo = 100;
		fissionRocketLauncher.attackSpeed = 1.8;
		fissionRocketLauncher.startDelay = 0;
		fissionRocketLauncher.shootDelay = 0;
		fissionRocketLauncher.barrelPivot.y = -27;
		fissionRocketLauncher.barrelLength = 100;
		fissionRocketLauncher.spread = 50;
		fissionRocketLauncher.numberOfProjectiles = 1;
		//fissionRocketLauncher.fireFX = PulserFireFX;
		//fissionRocketLauncher.fireSFX = Assets.getSound("");
		
		// gamma minigun
		var gammaMinigun:RangedWeapon;
		gammaMinigun = cast(addComponent(new RangedWeapon()), RangedWeapon);
		gammaMinigun.projectileType = GammaPulse;
		gammaMinigun.name = "gamma minigun";
		gammaMinigun.accuracy = 0.5;
		//gammaMinigun.ammo = 100;
		//gammaMinigun.maxAmmo = 100;
		gammaMinigun.attackSpeed = 0.04;
		gammaMinigun.startDelay = 0;
		gammaMinigun.shootDelay = 0;
		gammaMinigun.barrelPivot.y = -5;
		gammaMinigun.barrelLength = 110;
		gammaMinigun.spread = 30;
		gammaMinigun.numberOfProjectiles = 1;
		//gammaMinigun.fireFX = PulserFireFX;
		//gammaMinigun.fireSFX = Assets.getSound("");
		
		// mega blaster
		var megaBlaster:RangedWeapon;
		megaBlaster = cast(addComponent(new RangedWeapon()), RangedWeapon);
		megaBlaster.projectileType = PowerBeam;
		megaBlaster.name = "mega blaster";
		//megaBlaster.ammo = 100;
		//megaBlaster.maxAmmo = 100;
		megaBlaster.attackSpeed = 3;
		megaBlaster.startDelay = 1;
		megaBlaster.shootDelay = 0;
		megaBlaster.barrelPivot.y = -25;
		megaBlaster.barrelLength = 100;
		megaBlaster.spread = 50;
		megaBlaster.numberOfProjectiles = 1;
		//megaBlaster.fireFX = PulserFireFX;
		//megaBlaster.fireSFX = Assets.getSound("");
		
	} // end function 
	
	
	//**************************************** SET AND GET ******************************************
	
	
}