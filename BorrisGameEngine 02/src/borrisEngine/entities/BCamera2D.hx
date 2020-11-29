/* Author: Rohaan Allport
 * Date Created: 13/02/2016 (dd/mm/yyyy)
 * Date Completed: (dd/mm/yyyy)
 *
 * Decription:
 *
 * Todos:
 *
 *
 */

package borrisEngine.entities;

import openfl.display.Bitmap;

import borrisEngine.core.BEntity;

import starling.animation.*;
import starling.display.*;
import starling.events.Event;
import starling.textures.Texture;
import starling.core.Starling;


/**
 * ...
 * @author Rohaan Allport
 */
class BCamera2D extends BEntity
{
	public var minScale(get, set):Float;
	public var maxScale(get, set):Float;
	
	
	public var targetCam:Sprite;
	public var explorer:Sprite = new Sprite();
	private var targetCamLink:Sprite = new Sprite();
	
	private var correctionX:Float = 0;
	private var correctionY:Float = 0;
	
	private var xCenter:Float;
	private var yCenter:Float;
	private var varAux:Int;
	
	private var i:Int;
	
	private var valueYCam:Float;
	private var valueXCam:Float;
	private var limitTop:Float;
	private var limitBottom:Float;
	private var limitLeft:Float;
	private var limitRight:Float;
	
	private var mcOriginal:Sprite;
	private var mcGoTo:Sprite;
	
	private var maskCamView:Sprite = new Sprite();
	private var refWorld:Sprite = new Sprite();
	
	private var markedTarget:Sprite;
	
	private var tweenAnimation:Tween;
	private var duration:Float = 0.8;
	
	private var tweenScale:Tween;
	
	private var widthScene:Float;
	private var heightScene:Float;
	
	private var test:Bool;
	
	private var tmpLayer:Sprite;
	
	private var controlTo:Sprite;
	private var toControlSw:Bool;
	private var dragAndZoom:Bool;
	
	private var fControl:BCamera2DControl;
	
	private var countMaxLayers:Int = 5;
	private var countObjectLayers:Int = 0;
	private var objectsLayersX:Array<Sprite> = new Array<Sprite>();
	private var objectsLayersY:Array<Sprite> = new Array<Sprite>();
	private var depthLayersX:Array<Int> = new Array<Int>();
	private var depthLayersY:Array<Int> = new Array<Int>();
	
	public var refreshRate:Int = 1;
	private var refreshCount:Int = 0;
	
	private var testTarget:Sprite = new Sprite();
	
	public function new(world:Sprite, widthScene:Float = 0, heightScene:Float = 0, test:Bool = true, explorer:Sprite = null, dragAndZoom:Bool = true)
	{
		super();
		
		this.test = test;
		
		this.widthScene = widthScene;
		this.heightScene = heightScene;
		this.dragAndZoom = dragAndZoom;
		
		/*
		   this.limitLeft=leftLimit;
		   this.limitRight=rightLimit;
		   this.limitTop=upLimit;
		   this.limitBottom=downLimit;
		
		   this.correctionX = correctionX;
		   this.correctionY = correctionY;
		 */
		
		(stage != null) ? init() : addEventListener(Event.ADDED_TO_STAGE, init);
		
		refWorld = world;
		
		if (explorer != null)
		{
			this.explorer = cast(explorer, Sprite);
		}
		else
		{
			this.explorer = new Sprite();
		}
		targetCam = this.explorer;
		
		world.addChild(targetCam);
	
	}
	
	
	//**************************************** HANDLERS *********************************************
	
	
	private function init(e:Event = null):Void
	{
		trace("Fluocam initialized", stage.stageWidth, 'x', stage.stageHeight);
		stage.addChild(targetCamLink);
		this.xCenter = Std.int(widthScene) >> 1;
		this.yCenter = Std.int(heightScene) >> 1;
		
		working(true);
		
		if (dragAndZoom)
		{
			fControl = new BCamera2DControl();
			refWorld.addChild(fControl);
			fControl.init(targetCam.x, targetCam.y, refWorld, targetCam);
		}
	
	}
	
	
	//**************************************** FUNCTIONS ********************************************
	
	
	public function addLayer(sprite:Sprite, depth:Int, moveOnCamX:Bool = true, moveOnCamY:Bool = false):Void
	{
		if (countObjectLayers < countMaxLayers)
		{
			if (moveOnCamX)
			{
				objectsLayersX[countObjectLayers] = sprite;
				depthLayersX[countObjectLayers] = Std.int(1 / depth);
			}
			
			if (moveOnCamY)
			{
				objectsLayersY[countObjectLayers] = sprite;
				depthLayersY[countObjectLayers] = Std.int(1 / depth);
			}
			
			++countObjectLayers;
		}
		/*else
		{
			trace();
		}*/
	
	}
	
	public function working(sw:Bool = true):Void
	{
		sw ? stage.addEventListener(Event.ENTER_FRAME, fluoCam) : stage.removeEventListener(Event.ENTER_FRAME, fluoCam);
	}
	
	public function changeTarget(explorer:Sprite, toMark:Sprite = null, refreshRate:Int = 1):Void
	{
		this.refreshRate = refreshRate;
		targetCam = explorer;
	}
	
	public function goToTarget(explorer:Sprite, toMark:Sprite = null, controlTo:Sprite = null):Void
	{
		if (controlTo != null)
		{
			this.controlTo = controlTo;
			toControlSw = true;
		}
		else
		{
			toControlSw = false;
		}
		
		targetToTarget(targetCam, explorer);
	}
	
	public function goFromMarkedTarget(explorer:Sprite):Void
	{
		targetToTarget(markedTarget, explorer);
	}
	
	public function explore(explorer:Sprite):Void
	{
		//Move the cam on the target then give control to the cam
		explorer.x = targetCam.x;
		explorer.y = targetCam.y;
		targetCam = explorer;
	}
	
	private function fluoCam(e:Event):Void
	{
		//sprite.addChild(anotherObject);
		//sprite.flatten(); // optimize
		//sprite.unflatten(); // restore normal behaviour
		
		/*************************Layers Efect Move********************************/
		i = countMaxLayers = 0;
		while (--i > -1)
		{
			tmpLayer = (objectsLayersX[i] != null) ? objectsLayersX[i] : null;
			if (tmpLayer != null)
			{
				tmpLayer.x = depthLayersX[i] * targetCam.x;
			}
			tmpLayer = (objectsLayersY[i] != null) ? objectsLayersY[i] : null;
			if (tmpLayer != null)
			{
				tmpLayer.y = depthLayersY[i] * targetCam.y;
			}
		}
		/*************************************************************************/
		
		valueXCam = (xCenter - targetCam.x * refWorld.scaleX) + correctionX * refWorld.scaleX;
		valueYCam = (yCenter - targetCam.y * refWorld.scaleY) + correctionY * refWorld.scaleY;
		
		if (test)
		{
			testTarget.x = -valueXCam;
			testTarget.y = -valueYCam;
		}
		
		checkLimits();
	}
	
	private function checkLimits():Void
	{
		//if(!isNaN(limitBottom)){
		//refWorld.y = ((valueYCam>limitBottom)?valueYCam:limitBottom);
		//}else{
		//refWorld.y = valueYCam;
		//}
		
		/*
		   refWorld.x = (!isNaN(limitLeft))?((valueXCam>limitLeft)?valueXCam:limitLeft):valueXCam;
		   refWorld.x = (!isNaN(limitRight))?((valueXCam>limitRight)?valueXCam:limitRight):valueXCam;
		   refWorld.y = (!isNaN(limitTop))?((valueYCam>limitTop)?valueYCam:limitTop):valueYCam;
		   refWorld.y = (!isNaN(limitBottom))?((valueYCam>limitBottom)?valueYCam:limitBottom):valueYCam;
		 */
		
		refWorld.x = valueXCam;
		refWorld.y = valueYCam;
	}
	
	public function targetToTarget(trgO:Sprite, trg:Sprite):Void
	{
		
		targetCam = targetCamLink;
		explorer = trg;
		targetCamLink.x = trgO.x;
		targetCamLink.y = trgO.y;
		
		tweenAnimation = new Tween(targetCamLink, duration, Transitions.LINEAR);
		tweenAnimation.animate("x", trg.x);
		tweenAnimation.animate("y", trg.y);
		
		tweenAnimation.onComplete = explorerIsexplorer;
		
		Starling.current.juggler.add(tweenAnimation);
	}
	
	private function explorerIsexplorer():Void
	{
		Starling.current.juggler.remove(tweenAnimation);
		
		this.dispatchEvent(new Event("FINISH"));
		targetCam = toControlSw ? controlTo : explorer;
	}
	
	public function zoomToTarget(zoom:Float, durationZoom:Float):Void
	{
		tweenScale = new Tween(refWorld, durationZoom, Transitions.LINEAR);
		tweenScale.scaleTo(zoom);
		
		tweenScale.onComplete = finishCamZoom;
		Starling.current.juggler.add(tweenScale);
	}
	
	private function finishCamZoom():Void
	{
		Starling.current.juggler.remove(tweenScale);
		this.dispatchEvent(new Event("FINISH_ZOOM"));
	}
	
	public function zoomWorld(zoom:Float):Void
	{
		refWorld.scaleX = refWorld.scaleY = zoom;
	}
	
	
	//**************************************** SET AND GET ******************************************
	
	
	public function get_minScale():Float  { return fControl.minScale; }
	
	public function set_minScale(value:Float):Float
	{
		return fControl.minScale = value;
	}
	
	public function get_maxScale():Float  { return fControl.maxScale; }
	
	public function set_maxScale(value:Float):Float
	{
		return fControl.maxScale = value;
	}



}