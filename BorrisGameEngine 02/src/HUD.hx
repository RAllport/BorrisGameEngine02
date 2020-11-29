package;

import borrisEngine.core.BEntity;
import borrisEngine.core.BGame;
import starling.core.Starling;
import starling.utils.Align;

import starling.display.Image;
import starling.display.MovieClip;
import starling.display.Sprite;
import starling.text.TextField;
import starling.text.TextFormat;

/**
 * ...
 * @author Rohaan Allport
 */
class HUD extends BEntity
{
	private var container:Sprite = new Sprite();
	
	// assets
	public var lifeBar:MovieClip;
	public var energyBar:MovieClip;
	public var weaponIndicator:MovieClip;
	
	private var _helmet:Image;
	private var _livesIcon:Image;
	private var _atomsIcon:Image;
	private var _weaponBack:Image;
	private var _scoreBack:Image;
	private var _atomsBack:Image;
	
	// text
	public var ammoText:TextField;
	public var reloadsText:TextField;
	public var atomsText:TextField;
	public var scoreText:TextField;
	

	public function new() 
	{
		super();
		
		forceActive = true;
		
		//
		var fontName:String = "font";
		
		// initialize assets
		
		// MovieClips and Images
		lifeBar = new MovieClip(BGame.sAssets.getTextures("energy bar instance "));
		lifeBar.x = 80;
		lifeBar.y = 200;
		lifeBar.scaleX = -1;
		Starling.current.juggler.add(lifeBar);
		lifeBar.stop();
		
		energyBar = new MovieClip(BGame.sAssets.getTextures("energy bar instance "));
		energyBar.x = 120;
		energyBar.y = 200;
		energyBar.scaleX = -1;
		Starling.current.juggler.add(energyBar);
		energyBar.stop();
		
		
		_livesIcon = new Image(BGame.sAssets.getTexture("helmit side blue instance 10000"));
		_livesIcon.x = 30;
		_livesIcon.y = 660;
		
		// text
		var tf:TextFormat = new TextFormat(fontName, 24, 0xffffff, Align.CENTER, Align.CENTER);

		ammoText = new TextField(100, 50, "000", tf);
		reloadsText = new TextField(100, 50, "08", tf);
		atomsText = new TextField(100, 50, "0001", tf);
		scoreText = new TextField(100, 50, "0000", tf);
		
		/*ammoText.hAlign = Align.LEFT;
		reloadsText.hAlign = Align.LEFT;
		atomsText.hAlign = Align.LEFT;
		scoreText.hAlign = Align.LEFT;*/
		
		ammoText.batchable = true;
		reloadsText.batchable = true;
		atomsText.batchable = true;
		scoreText.batchable = true;
		
		ammoText.x = 600;
		ammoText.y = 10;
		reloadsText.x = 600;
		reloadsText.y = 50;
		atomsText.x = 1180;
		atomsText.y = 670;
		scoreText.x = 1180;
		scoreText.y = 10;
		
		
		// add assets to respective containers
		addChild(container);
		container.addChild(lifeBar);
		container.addChild(energyBar);
		container.addChild(_livesIcon);
		
		container.addChild(ammoText);
		container.addChild(reloadsText);
		container.addChild(atomsText);
		container.addChild(scoreText);
	}
	
	
	//**************************************** HANDLERS *********************************************
	
	
	
	//**************************************** FUNCTIONS ********************************************
	
	
	/**
	 * @inheritDoc
	 */
	override public function update():Void
	{
		super.update();
		
		x = _scene.mainCamera.targetCam.x - stage.stageWidth/2;
		y = _scene.mainCamera.targetCam.y - stage.stageHeight/2;
		
	} // end function
	
	
	//**************************************** SET AND GET ******************************************
	
	
}