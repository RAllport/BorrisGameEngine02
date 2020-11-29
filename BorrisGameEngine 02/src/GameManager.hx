package;

import borrisEngine.core.BEntityComponent;

/**
 * ...
 * @author Rohaan Allport
 */
class GameManager extends BEntityComponent
{
	// 
	public var nextLevel:String;
	public var respawnLevel:String;
	
	// game stats
	public var score:Int = 0;
	public var highScore:Int = 0;
	public var startLives:Int = 3;
	public var lives:Int = 3;
	
	// 
	public var hud:HUD;
	
	private var _player:TestPlayer;
	

	public function new() 
	{
		super();
		
	}
	
	
	//**************************************** HANDLERS *********************************************
	
	
	
	//**************************************** FUNCTIONS ********************************************
	
	
	
	//**************************************** SET AND GET ******************************************
	
	
}