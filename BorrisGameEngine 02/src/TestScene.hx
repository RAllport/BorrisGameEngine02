package;

import borrisEngine.TestLevelCreatorEntity;
import borrisEngine.components.BCollectable;
import borrisEngine.components.BRigidBody2D;
import borrisEngine.core.*;
import enemies.*;
import borrisEngine.entities.paricles.BLightning;
import borrisEngine.ui.BStarlingInput;
import openfl.ui.Keyboard;
import starling.display.Image;

/**
 * ...
 * @author Rohaan Allport
 */
class TestScene extends BScene
{
	private var _player:TestPlayer;
	private var _HUD:HUD;
	
	var lightning:BLightning;
	
	
	public function new() 
	{
		super();
		
		// testing
		var mainLevelEntity:TestLevelCreatorEntity = cast(addEntity(new TestLevelCreatorEntity()), TestLevelCreatorEntity);
		mainLevelEntity.createStaticPlatform(20, 0, 5, 2);
		
		_player = cast(addEntity(new TestPlayer()), TestPlayer);
		_HUD = cast(addEntity(new HUD()), HUD);
		
		mainLevelEntity.name = "main level entity";
		_player.name = "player";
		_HUD.name = "HUD";
		
		//_mainCamera.target = player;
		//_mainCamera.nudgeToMouse = true;
		_mainCamera.changeTarget(_player);
		physics.bodyToFollow = cast(_player.getComponentByName("torsoBody"), BRigidBody2D).realBody;
		_sOriginX = _mainCamera.targetCam.x;
		_sOriginY = _mainCamera.targetCam.y;
		
		// collectable testing
		/*var collectable:BEntity = new BEntity();
		var collectableC:BCollectable = new BCollectable();
		collectableC.bodyName = "torsoBody";
		collectableC.body = cast(_player.getComponentByName("torsoBody"), BRigidBody2D);
		collectable.addComponent(collectableC);*/
		
		// enemy
		var enemy:StandingRobotUnit = new StandingRobotUnit();
		cast(enemy.getComponentByName("body"), BRigidBody2D).x = 2000;
		//cast(enemy.getComponentByName("body"), BRigidBody2D).y = -100;
		
		enemy.ai.target = _player;
		addEntity(enemy);
		
		lightning = cast(_currentLayer.addChild(new BLightning()), BLightning);
		lightning.x = 200;
		lightning.y = 200;
		lightning.numBranches = 20;
		//lightning.
		lightning.branchWidth = 1;
		lightning.color = 0xffffff;
		lightning.frequency = 20;
		lightning.amplitude = 10;
		lightning.lightningLength = 200;
		lightning.branchSpread = 0;
		lightning.branchAngularSpread = Math.PI * 2;
		lightning.amplitudeDelta = 2;
		//lightning.isForkLightning = false;
		lightning.startFromCenter = false;
		lightning.variableBranchWidth = true;
		//lightning.hasGlow = false;
		//lightning.glowColor = 0x0099FF;
		//lightning.glowSize = 2;
		//lightning.body.SetPosition(new b2vec2(10, 10));
		//lightning.rotation = 1;
		
		var entity:BEntity;
		var img:Image;
		
		var layer2 = addLayer(new BLayer());
		layer2.paralaxX = layer2.paralaxY = 0.6;
		entity = layer2.addEntity(new BEntity());
		entity.addChild(new Image(BGame.sAssets.getTexture("explosion 01 core 010000")));
		
		var layer3 = addLayer(new BLayer());
		layer3.paralaxX = layer3.paralaxY = 0.8;
		entity = layer3.addEntity(new BEntity());
		entity.addChild(new Image(BGame.sAssets.getTexture("explosion 01 core 020000")));
		
	}
	
	
	//**************************************** HANDLERS *********************************************
	
	
	//**************************************** FUNCTIONS ********************************************
	
	
	/**
	 * @inheritDoc
	 */
	override public function update():Void
	{
		super.update();
		//lightning.update();
		
		if (BStarlingInput.keyPressed(Keyboard.P))
		{
			var menu:MenuScreen = cast(_game.getSceneAt(1), MenuScreen);
			_game.switchScene(menu, 0);
			menu.tweenIn();
		}
		
	} // end function update
	
	
	//**************************************** SET AND GET ******************************************
	
	
	
}