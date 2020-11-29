package;

import borrisEngine.core.BGame;
import borrisEngine.core.BScene;
import borrisEngine.ui.*;
import starling.animation.*;
import starling.core.*;
import starling.display.*;


/**
 * ...
 * @author Rohaan Allport
 */
class BaseScreen extends BScene
{
	// assets
	private var _background1:Image;
	private var _background2:Image;
	private var _title:Image;
	private var _topEdge1:Image;
	private var _topEdge2:Image;
	private var _rightEdge1:Image;
	private var _rightEdge2:Image;
	private var _bottomEdge1:Image;
	private var _mediumScreen:Image;
	private var _cursor:Cursor1;
	
	
	var container:Sprite;
	

	public function new() 
	{
		super();
		
	}
	
	
	//**************************************** HANDLERS *********************************************
	
	
	
	//**************************************** FUNCTIONS ********************************************
	
	
	/**
	 * @inheritDoc
	 */
	override private function initialize():Void
	{
		// dirty fix
		container = new Sprite();
		container.x = - stage.stageWidth/2;
		container.y = - stage.stageHeight / 2;
		addChild(container);
		
		// Assets
		//_background1 = new Image(BGame.sAssets.getTexture("BgStars1"));
		//_background1.width = stage.stageWidth + 100;
		//_background1.height = stage.stageHeight + 100;
		//_background1.color = 0x666666;
		//_background1.visible = false;
		
		_background2 = new Image(BGame.sAssets.getTexture("black box0000"));
		_background2.width = stage.stageWidth + 100;
		_background2.height = stage.stageHeight + 100;
		_background2.alpha = 0.4;
		_background2.visible = false;
		
		_topEdge1 = new Image(BGame.sAssets.getTexture("top piece 10000"));
		_topEdge2 = new Image(BGame.sAssets.getTexture("top piece 20000"));
		_rightEdge1 = new Image(BGame.sAssets.getTexture("side piece 10000"));
		_rightEdge2 = new Image(BGame.sAssets.getTexture("side piece 20000"));
		_bottomEdge1 = new Image(BGame.sAssets.getTexture("bottom piece 10000"));
		
		_cursor = new Cursor1();
		
		
		// position them
		_topEdge1.x = 5;
		_topEdge1.y = -200;
		_topEdge2.x = 441;
		_topEdge2.y = -200;
		_rightEdge1.x = 1300;
		_rightEdge1.y = 144;
		_rightEdge2.x = 1400;
		_rightEdge2.y = 160;
		_bottomEdge1.x = 5;
		_bottomEdge1.y = 750;
		
		
		// add assets
		//container.addChild(_background1);
		container.addChild(_background2);
		container.addChild(_topEdge1);
		container.addChild(_topEdge2);
		container.addChild(_rightEdge1);
		container.addChild(_rightEdge2);
		container.addChild(_bottomEdge1);
		container.addChild(_cursor);
		
		//tweenIn();
		
	} // end function 
	
	
	
	/**
	 * @inheritDoc
	 */
	override public function update():Void
	{
		super.update();
		_cursor.updateCursor(BStarlingInput.mouseX, BStarlingInput.mouseY);
	} // end function
	
	
	/**
	 * 
	 * @param	delay
	 */
	public function tweenIn(delay:Float = 0):Void
	{
		//Starling.current.juggler.tween(_background1, 1.0, 	{transition: Transitions.EASE_IN_OUT, delay: delay, alpha: 0.4});
		
		Starling.current.juggler.tween(_topEdge1, 1.0, 		{transition: Transitions.EASE_IN_OUT, delay: delay, x: 5, y: 5});
		Starling.current.juggler.tween(_topEdge2, 0.5, 		{transition: Transitions.EASE_IN_OUT, delay: delay, x: 441, y: 5});
		Starling.current.juggler.tween(_rightEdge1, 0.8, 	{transition: Transitions.EASE_IN_OUT, delay: delay, x: 1039, y: 144});
		Starling.current.juggler.tween(_rightEdge2, 1.6, 	{transition: Transitions.EASE_IN_OUT, delay: delay, x: 1149, y: 160});
		Starling.current.juggler.tween(_bottomEdge1, 1.2, 	{transition: Transitions.EASE_IN_OUT, delay: delay, x: 5, y: 575});
		
	} // end function
	
	
	/**
	 * 
	 * @param	delay
	 */
	public function tweenOut(delay:Float = 0):Void
	{
		//Starling.current.juggler.tween(_background1, 1.0, 	{transition: Transitions.EASE_IN_OUT, delay: delay, alpha: 0});
		
		Starling.current.juggler.tween(_topEdge1, 1.0, 		{transition: Transitions.EASE_IN_OUT, delay: delay, x: 5, y: -200});
		Starling.current.juggler.tween(_topEdge2, 0.5, 		{transition: Transitions.EASE_IN_OUT, delay: delay, x: 441, y: -200});
		Starling.current.juggler.tween(_rightEdge1, 0.8, 	{transition: Transitions.EASE_IN_OUT, delay: delay, x: 1300, y: 144});
		Starling.current.juggler.tween(_rightEdge2, 1.6, 	{transition: Transitions.EASE_IN_OUT, delay: delay, x: 1400, y: 160});
		Starling.current.juggler.tween(_bottomEdge1, 1.2, 	{transition: Transitions.EASE_IN_OUT, delay: delay, x: 5, y: 750});
		
	} // end function
	
	
	/**
	 * 
	 * @param	delay
	 */
	public function tweenStuff(buttons:Array<DisplayObject>, delay:Float = 0, endX:Int = 0, endAlpha:Float = 1, timeDifference:Float = 0.1):Void
	{
		for (button in buttons)
		{
			delay += timeDifference;
			
			Starling.current.juggler.tween(button, 0.5, {transition: Transitions.EASE_IN_OUT, delay: delay, x: endX, alpha: endAlpha});
		} // end for 
		
	} // end function
	
	
	//**************************************** SET AND GET ******************************************
	
	
}