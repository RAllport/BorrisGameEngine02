package;

import borrisEngine.core.BGame;
import borrisEngine.ui.BSButton;

import starling.animation.Transitions;
import starling.core.Starling;
import starling.display.DisplayObject;
import starling.events.Event;
import starling.text.TextField;
import starling.text.TextFormat;
import starling.utils.Align;

/**
 * ...
 * @author Rohaan Allport
 */
class CreditsScreen extends BaseScreen
{
	// buttons
	public var _backBtn:BSButton;
	
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
		var button:BSButton = cast(event.target, BSButton);
		
		if (button == _backBtn)
		{
			_game.switchScene(Main.menuScene, 2000);
			tweenOut();
			Main.menuScene.tweenIn(2);
		} // end if
		
		
	} // end function
	
	
	//**************************************** FUNCTIONS ********************************************
	
	
	/**
	 * @inheritDoc
	 */
	override private function initialize():Void
	{
		super.initialize();
		
		var buttonUpState = BGame.sAssets.getTexture("button 2 back0000");
		var buttonOverState = BGame.sAssets.getTexture("button 2 back0001");
		var buttonDownState = BGame.sAssets.getTexture("button 2 back0002");
		
		
		var buttonX:Int = -20;
		var buttonY:Int = 100;
		var buttonYDifference:Int = Std.int(76 * 0.8);
		var startAlpha:Float = 1;
		
		
		_backBtn = new BSButton(BGame.sAssets.getTexture("button 2 back0000"), "Back", BGame.sAssets.getTexture("button 2 back0001"), BGame.sAssets.getTexture("button 2 back0002"));
		
		// backBtn
		_backBtn.x = stage.stageWidth - _backBtn.width - 50;
		_backBtn.y = stage.stageHeight - _backBtn.height - 40;
		//_backBtn.alpha = startAlpha;
		_backBtn.textField.format = new TextFormat(null, 30, 0xffffff, Align.CENTER, Align.CENTER);
		
		
		// assets to respective containers
		container.addChild(_backBtn);
		
		_buttons = [];
		
		//tweenIn();
		tweenOut();
		
		// event handling 
		addEventListener(Event.TRIGGERED, onButtonTriggered);
		
		
	} // end function 
	
	
	/**
	 * @inheritDoc
	 */
	override public function tweenIn(delay:Float = 0):Void
	{
		super.tweenIn(delay);
		//tweenStuff(_buttons, delay, 180, 1);
		Starling.current.juggler.tween(_backBtn, 1.0, 	{transition: Transitions.EASE_IN_OUT, delay: delay, x: (stage.stageWidth - _backBtn.width - 50), alpha: 1});
		
		
	} // end function 
	
	
	/**
	 * @inheritDoc
	 */
	override public function tweenOut(delay:Float = 0):Void
	{
		super.tweenOut(0.5 + delay);
		//tweenStuff(_buttons, delay, -20, 0);
		Starling.current.juggler.tween(_backBtn, 1.0, 	{transition: Transitions.EASE_IN_OUT, delay: delay, x: stage.stageWidth, alpha: 0});
		
	} // end function 
	
	
	//**************************************** SET AND GET ******************************************
	
	
	
}