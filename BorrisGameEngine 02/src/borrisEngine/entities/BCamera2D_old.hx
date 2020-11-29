package borrisEngine.entities;

import borrisEngine.core.BEntity;
import borrisEngine.borrisPhysics.BBox2DPhysicsWrapper;
import borrisEngine.ui.BStarlingInput;

import openfl.Assets;
import openfl.display.Shape;
import openfl.geom.Matrix;

import starling.core.Starling;
import starling.display.*;
import starling.events.*;

/**
 * ...
 * @author Rohaan Allport
 */
class BCamera2D_old extends BEntity
{	
	/**
	 * Gets or sets a target BEntity to follow
	 */
	public var target(get, set):BEntity;
	//public var nudgeTarget(get, set):Dynamic;
	public var nudgeToMouse(get, set):Bool;
	public var nudgeValue(get, set):Float;
	public var showCrosshair(get, set):Bool;
	
	private var _target:BEntity;
	private var _damping:Float;
	
	private var _screen:Shape;
	private var _crosshair:Shape;
	private var _crosshairWidth:Float = 100;
	private var _crosshairHeight:Float = 100;
	private var _crosshairOuterRaduis:Float = 30;
	private var _crosshairInnerRaduis:Float = 10;
	
	private var _nudgeToMouse:Bool = false;
	private var _nudgeValue:Float = 2.3;
	
	
	public function new() 
	{
		super();
		
		_screen = new Shape();
		_crosshair = new Shape();
		
		//addChild(_screen);
		//addChild(_crosshair);
		
		forceActive = true;
	}
	
	
	//**************************************** HANDLERS *********************************************
	
	
	/**
	 * 
	 * @param	event
	 */
	override private function onAddedToStage(event:Event):Void 
	{
		super.onAddedToStage(event);
		
		draw();
		//showCrosshair = false;
		//scaleX = scaleY = 1.5;
		
	} // end function onAddedToStage
	
	
	//**************************************** FUNCTIONS ********************************************
	
	
	/**
	 * @inheritDoc
	 */
	override public function update():Void 
	{
		super.update();
		// camera control
		if (_target != null)
		{
			if (_nudgeToMouse)
			{
				//x = Std.int(_target.x - stage.stageWidth / 2 + (_scene.mouseX - _target.x) / 2.3);
				//y = Std.int(_target.y - stage.stageHeight / 2 + (_scene.mouseY - _target.y) / 2.3);
			}
			else
			{
				x = Std.int(_target.x - stage.stageWidth / 2);
				y = Std.int(_target.y - stage.stageHeight / 2);
			}
			
			//var m:Matrix = transformationMatrix;
			//m.invert();
			//_scene.transformationMatrix = m;
			if (BBox2DPhysicsWrapper.debugDrawing)
			{
				//BPhysicsWrapper.renderSprite.transform.matrix = m;
			}
			
			// nope
			//Starling.current.viewPort.x = -Std.int(_target.x - stage.stageWidth / 2);
			//Starling.current.viewPort.y = -Std.int(_target.y - stage.stageHeight / 2);
		} // end if
		
	} // end 
	
	
	/**
	 * 
	 */
	private function drawCrosshair():Void
	{
		_crosshair.graphics.clear();
		
		_crosshair.graphics.lineStyle(2, 0x000000, 1, true);
		_crosshair.graphics.beginFill(0xffffff, 0.4);
		_crosshair.graphics.drawCircle(0, 0, _crosshairOuterRaduis);
		_crosshair.graphics.drawCircle(0, 0, _crosshairInnerRaduis);
		_crosshair.graphics.endFill();
		
		_crosshair.graphics.moveTo(-_crosshairWidth / 2, 0);
		_crosshair.graphics.lineTo(-_crosshairInnerRaduis, 0);
		_crosshair.graphics.moveTo(_crosshairInnerRaduis, 0);
		_crosshair.graphics.lineTo(_crosshairWidth / 2, 0);
		
		_crosshair.graphics.moveTo(0, -_crosshairWidth / 2);
		_crosshair.graphics.lineTo(0, -_crosshairInnerRaduis);
		_crosshair.graphics.moveTo(0, _crosshairInnerRaduis);
		_crosshair.graphics.lineTo(0, _crosshairWidth / 2);
		
		_crosshair.x = stage.stageWidth / 2;
		_crosshair.y = stage.stageHeight / 2;
		
	} // end 
	
	
	/**
	 * 
	 */
	private function draw():Void
	{
		_screen.graphics.clear();
		_screen.graphics.lineStyle(0.1, 0x000000, 1, true);
		//_screen.graphics.beginFill(0xffffff, 0.3);
		_screen.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
		//_screen.graphics.drawRect(-stage.stageWidth / 2, -stage.stageHeight / 2, stage.stageWidth, stage.stageHeight);
		_screen.graphics.endFill();
		
		drawCrosshair();
		
		
	} // end
	
	
	/**
	 * 
	 * @param	target
	 * @return
	 */
	public function setTarget(target:BEntity):BEntity
	{
		_target = target;
		return _target;
		
		return null;
	} // end 
	
	
	/**
	 * 
	 * @param	radius
	 * @param	times
	 */
	public function shake(radius:Float, times:Int):Void
	{
		
	} // end 
	
	
	//**************************************** SET AND GET ******************************************
	
	
	private function get_target():BEntity 
	{
		return _target;
	}
	private function set_target(value:BEntity):BEntity 
	{
		return setTarget(value);
	}
	
	
	private function get_nudgeToMouse():Bool 
	{
		return _nudgeToMouse;
	}
	private function set_nudgeToMouse(value:Bool):Bool 
	{
		return _nudgeToMouse = value;
	}
	
	
	private function get_nudgeValue():Float 
	{
		return _nudgeValue;
	}
	private function set_nudgeValue(value:Float):Float 
	{
		return _nudgeValue = value;
	}
	
	
	private function get_showCrosshair():Bool 
	{
		return _crosshair.visible;
	}
	private function set_showCrosshair(value:Bool):Bool 
	{
		return _crosshair.visible = value;
	}
	
	
}