package;

import borrisEngine.core.BGame;
import borrisEngine.ui.BSButton;

import starling.animation.Transitions;
import starling.core.Starling;
import starling.display.DisplayObject;
import starling.events.Event;
import starling.utils.Align;
import starling.text.TextField;
import starling.text.TextFormat;


/**
 * ...
 * @author Rohaan Allport
 */
class ControlsScreen extends BaseScreen
{
	// buttons
	public var _backBtn:BSButton;
	public var _shootBtn:BSButton;
	public var _jumpBtn:BSButton;
	public var _moveLeftBtn:BSButton;
	public var _moveRightBtn:BSButton;
	public var _duckBtn:BSButton;
	public var _actionBtn:BSButton;
	public var _nextWeaponBtn:BSButton;
	public var _prevWeaponBtn:BSButton;
	public var _switchWeaponBtn:BSButton;
	
	// text
	private var _shootTxt:TextField;
	private var _jumpTxt:TextField;
	private var _moveLeftTxt:TextField;
	private var _moveRightTxt:TextField;
	private var _duckTxt:TextField;
	private var _actionTxt:TextField;
	private var _nextWeaponTxt:TextField;
	private var _prevWeaponTxt:TextField;
	private var _switchWeaponTxt:TextField;
	
	
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
		
		_shootBtn = new BSButton(buttonUpState, "Shoot", buttonDownState, buttonOverState);
		_jumpBtn = new BSButton(buttonUpState, "Jump", buttonDownState, buttonOverState);
		_moveLeftBtn = new BSButton(buttonUpState, "Move Left", buttonDownState, buttonOverState);
		_moveRightBtn = new BSButton(buttonUpState, "Move Right", buttonDownState, buttonOverState);
		_duckBtn = new BSButton(buttonUpState, "Duck", buttonDownState, buttonOverState);
		_actionBtn = new BSButton(buttonUpState, "Action/Use", buttonDownState, buttonOverState);
		_nextWeaponBtn = new BSButton(buttonUpState, "Next Weapon", buttonDownState, buttonOverState);
		_prevWeaponBtn = new BSButton(buttonUpState, "Prev Weapon", buttonDownState, buttonOverState);
		_switchWeaponBtn = new BSButton(buttonUpState, "Switch Weapon", buttonDownState, buttonOverState);
		
		_backBtn = new BSButton(BGame.sAssets.getTexture("button 2 back0000"), "Back", BGame.sAssets.getTexture("button 2 back0001"), BGame.sAssets.getTexture("button 2 back0002"));
			
		_shootBtn.scale = 
		_jumpBtn.scale = 
		_moveLeftBtn.scale = 
		_moveRightBtn.scale = 
		_duckBtn.scale = 
		_actionBtn.scale = 
		_nextWeaponBtn.scale = 
		_prevWeaponBtn.scale = 
		_switchWeaponBtn.scale = 0.8;
		
		_shootBtn.x = 
		_jumpBtn.x = 
		_moveLeftBtn.x = 
		_moveRightBtn.x = 
		_duckBtn.x = 
		_actionBtn.x = 
		_nextWeaponBtn.x = 
		_prevWeaponBtn.x = 
		_switchWeaponBtn.x = buttonX;
		
		_shootBtn.y = buttonY + buttonYDifference * 0;
		_jumpBtn.y = buttonY + buttonYDifference * 1;
		_moveLeftBtn.y = buttonY + buttonYDifference * 2;
		_moveRightBtn.y = buttonY + buttonYDifference * 3;
		_duckBtn.y = buttonY + buttonYDifference * 4;
		_actionBtn.y = buttonY + buttonYDifference * 5;
		_nextWeaponBtn.y = buttonY + buttonYDifference * 6;
		_prevWeaponBtn.y = buttonY + buttonYDifference * 7;
		_switchWeaponBtn.y = buttonY + buttonYDifference * 8;
		
		// backBtn
		_backBtn.x = stage.stageWidth - _backBtn.width - 50;
		_backBtn.y = stage.stageHeight - _backBtn.height - 40;
		//_backBtn.alpha = startAlpha;

		
		
		// text
		var fontName = "font";
        var tf:TextFormat = new TextFormat("font", 30, 0xffffff, Align.LEFT);

        _backBtn.textField.format = tf;
		
		_shootTxt = new TextField(500, buttonYDifference, ": Left Mouse", tf);
		_jumpTxt = new TextField(500, buttonYDifference, ": W/Up", tf);
		_moveLeftTxt = new TextField(500, buttonYDifference, ": A/Left", tf);
		_moveRightTxt = new TextField(500, buttonYDifference, ": D/Right", tf);
		_duckTxt = new TextField(500, buttonYDifference, ": S/Down", tf);
		_actionTxt = new TextField(500, buttonYDifference, ": Space/Shift/Ctrl", tf);
		_nextWeaponTxt = new TextField(500, buttonYDifference, ": E", tf);
		_prevWeaponTxt = new TextField(500, buttonYDifference, ": Q", tf);
		_switchWeaponTxt = new TextField(500, buttonYDifference, ": 1-7", tf);
		
		_shootTxt.batchable = true;
		_jumpTxt.batchable = true;
		_moveLeftTxt.batchable = true;
		_moveRightTxt.batchable = true;
		_duckTxt.batchable = true;
		_actionTxt.batchable = true;
		_nextWeaponTxt.batchable = true;
		_prevWeaponTxt.batchable = true;
		_switchWeaponTxt.batchable = true;
		
		_shootTxt.x = _jumpTxt.x = _moveLeftTxt.x = _moveRightTxt.x = _duckTxt.x = _actionTxt.x = _nextWeaponTxt.x = _prevWeaponTxt.x = _switchWeaponTxt.x = 500;
		_shootTxt.y = _shootBtn.y;
		_jumpTxt.y = _jumpBtn.y;
		_moveLeftTxt.y = _moveLeftBtn.y;
		_moveRightTxt.y = _moveRightBtn.y;
		_duckTxt.y = _duckBtn.y;
		_actionTxt.y = _actionBtn.y;
		_nextWeaponTxt.y = _nextWeaponBtn.y;
		_prevWeaponTxt.y = _prevWeaponBtn.y;
		_switchWeaponTxt.y = _switchWeaponBtn.y;
		
		
		
		// assets to respective containers
		container.addChild(_shootBtn);
		container.addChild(_jumpBtn);
		container.addChild(_moveLeftBtn);
		container.addChild(_moveRightBtn);
		container.addChild(_duckBtn);
		container.addChild(_actionBtn);
		container.addChild(_nextWeaponBtn);
		container.addChild(_prevWeaponBtn);
		container.addChild(_switchWeaponBtn);
		container.addChild(_backBtn);
		
		container.addChild(_shootTxt);
		container.addChild(_jumpTxt);
		container.addChild(_moveLeftTxt);
		container.addChild(_moveRightTxt);
		container.addChild(_duckTxt);
		container.addChild(_actionTxt);
		container.addChild(_nextWeaponTxt);
		container.addChild(_prevWeaponTxt);
		container.addChild(_switchWeaponTxt);
		
		_buttons = [_shootBtn, _jumpBtn, _moveLeftBtn, _moveRightBtn, _duckBtn, _actionBtn, _nextWeaponBtn, _prevWeaponBtn, _switchWeaponBtn];
		
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
		tweenStuff(_buttons, delay, 180, 1);
		Starling.current.juggler.tween(_backBtn, 1.0, 	{transition: Transitions.EASE_IN_OUT, delay: delay, x: (stage.stageWidth - _backBtn.width - 50), alpha: 1});
		
		tweenStuff(
		[_shootTxt,
		_jumpTxt,
		_moveLeftTxt,
		_moveRightTxt,
		_duckTxt,
		_actionTxt,
		_nextWeaponTxt,
		_prevWeaponTxt,
		_switchWeaponTxt],
		delay, 500, 1
		);
	} // end function 
	
	
	/**
	 * @inheritDoc
	 */
	override public function tweenOut(delay:Float = 0):Void
	{
		super.tweenOut(0.5 + delay);
		tweenStuff(_buttons, delay, -20, 0);
		Starling.current.juggler.tween(_backBtn, 1.0, 	{transition: Transitions.EASE_IN_OUT, delay: delay, x: stage.stageWidth, alpha: 0});
		
		tweenStuff(
		[_shootTxt,
		_jumpTxt,
		_moveLeftTxt,
		_moveRightTxt,
		_duckTxt,
		_actionTxt,
		_nextWeaponTxt,
		_prevWeaponTxt,
		_switchWeaponTxt],
		delay, 700, 0
		);
	} // end function 
	
	
	//**************************************** SET AND GET ******************************************
	
}