package;

import borrisEngine.core.BGame;
import borrisEngine.ui.BSButton;
import starling.events.Event;

import starling.display.*;
import starling.textures.Texture;


/**
 * ...
 * @author Rohaan Allport
 */
class MenuScreen extends BaseScreen
{
	// buttons
	private var _startBtn:BSButton;
	private var _controlsBtn:BSButton;
	private var _achievementsBtn:BSButton;
	private var _optionsBtn:BSButton;
	private var _creditsBtn:BSButton;
	private var _quitBtn:BSButton;
	
	private var _buttons:Array<DisplayObject>;
	

	public function new() 
	{
		super();
		
	}
	
	
	//**************************************** HANDLERS *********************************************
	
	
	/**
	 * 
	 * @param	event
	 */
	private function onButtonTriggered(event:Event):Void 
	{
		//var button:Button = cast(event.target, Button);
		var button = cast(event.target, DisplayObject);
		
		if(button == _startBtn)
		{
			_game.switchScene(_game.getSceneAt(0), 2000);
			tweenOut();
		}
		else if (button == _controlsBtn)
		{
			_game.switchScene(Main.controlsScene, 2000);
			Main.controlsScene.tweenIn(2);
			tweenOut();
		}
		else if (button == _achievementsBtn)
		{
			_game.switchScene(Main.achievementsScene, 2000);
			Main.achievementsScene.tweenIn(2);
			tweenOut();
		}
		else if (button == _optionsBtn)
		{
			_game.switchScene(Main.optionsScene, 2000);
			Main.optionsScene.tweenIn(2);
			tweenOut();
		}
		else if (button == _creditsBtn)
		{
			_game.switchScene(Main.creditsScene, 2000);
			Main.creditsScene.tweenIn(2);
			tweenOut();
		}
		#if !htmlf
		else if (button == _quitBtn)
		{
			trace("Quit Game!");
		}
		#end
		
	} // end function
	
	
	//**************************************** FUNCTIONS ********************************************
	
	
	/**
	 * @inheritDoc
	 */
	override private function initialize():Void
	{
		super.initialize();
		
		//
		var buttonUpState = BGame.sAssets.getTexture("button 2 back0000");
		var buttonOverState = BGame.sAssets.getTexture("button 2 back0001");
		var buttonDownState = BGame.sAssets.getTexture("button 2 back0002");
		
		
		var buttonX = 200;
		var buttonYDifference = 76;
		
		_startBtn = new BSButton(buttonUpState, "Start", buttonDownState, buttonOverState);
		//_startBtn = new Button(buttonUpState, "Start", buttonDownState, buttonOverState);
		_controlsBtn = new BSButton(buttonUpState, "Controls", buttonDownState, buttonOverState);
		_achievementsBtn = new BSButton(buttonUpState, "achievements", buttonDownState, buttonOverState);
		_optionsBtn = new BSButton(buttonUpState, "Options", buttonDownState, buttonOverState);
		_creditsBtn = new BSButton(buttonUpState, "Credits", buttonDownState, buttonOverState);
		_quitBtn = new BSButton(buttonUpState, "Quit", buttonDownState, buttonOverState);
		
		
		_startBtn.x = buttonX;
		_startBtn.y = 200;
		_controlsBtn.x = buttonX;
		_controlsBtn.y = _startBtn.y + buttonYDifference * 1;
		_achievementsBtn.x = buttonX;
		_achievementsBtn.y = _startBtn.y + buttonYDifference * 2;
		_optionsBtn.x = buttonX;
		_optionsBtn.y = _startBtn.y + buttonYDifference * 3;
		_creditsBtn.x = buttonX;
		_creditsBtn.y = _startBtn.y + buttonYDifference * 4;
		_quitBtn.x = buttonX;
		_quitBtn.y = _startBtn.y + buttonYDifference * 5;
		
		
		_buttons = [_startBtn, _controlsBtn, _achievementsBtn, _optionsBtn, _creditsBtn];
		#if !html5
		_buttons.push(_quitBtn);
		#end
		
		container.addChild(_startBtn);
		container.addChild(_controlsBtn);
		container.addChild(_achievementsBtn);
		container.addChild(_optionsBtn);
		container.addChild(_creditsBtn);
		#if !html5
		container.addChild(_quitBtn);
		#end
		
		tweenIn();
		//tweenStuff(_buttons, 0.4, Std.int(stage.stageWidth/2 - _startBtn.width/2), 1);
		
		// event handling
		addEventListener(Event.TRIGGERED, onButtonTriggered);
		
	} // end function 
	
	
	/**
	 * @inheritDoc
	 */
	override public function tweenIn(delay:Float = 0):Void
	{
		super.tweenIn(delay);
		tweenStuff(_buttons, (delay + 0.4), Std.int(stage.stageWidth/2 - _startBtn.width/2), 1);
	} // end function 
	
	
	/**
	 * @inheritDoc
	 */
	override public function tweenOut(delay:Float = 0):Void
	{
		super.tweenOut(0.5 + delay);
		tweenStuff(_buttons, (delay + 0.4), 200, 0);
	} // end function 
	
}