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

import haxe.Timer;
import openfl.Assets;
import openfl.Vector;

import starling.core.Starling;

import starling.display.Sprite;
import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

import starling.display.Image;
import starling.textures.Texture;

import openfl.utils.Timer;
import openfl.events.TimerEvent;
import openfl.geom.Point;

import openfl.display.Bitmap;

/**
 * ...
 * @author Rohaan Allport
 */
class BCamera2DControl extends Sprite
{
	public var minScale:Float = 0.25;
	public var maxScale:Float = 10;
	
	private var mouseX:Int = 0;
	private var mouseY:Int = 0;
	
	private var elementsInStage:Array<Dynamic> = new Array<Dynamic>();
	
	public var orignalStageX:Float;
	public var orignalStageY:Float;
	
	public var firstTouchX:Float;
	public var firstTouchY:Float;
	public var refTouchX:Float;
	public var refTouchY:Float;
	
	public var inicialPosX:Float;
	public var inicialPosY:Float;
	public var moveOrSelect:Bool;
	public var itemSelectable:Bool;
	
	public var scrollable:Bool;
	public var qScrollable:Float;
	
	public var tiempoDrag:Int;
	public var cada:Int = 1;
	public var velX:Float;
	public var velY:Float;
	public var friccion:Float = 4;
	public var sensibility:Int = 20;
	public var accuracyDragForce:Int = 300;
	
	public var canvas:Sprite;
	public var targetCam:Sprite;
	
	private var touch:Touch;
	private var pos:Point;
	
	private var dx:Int;
	private var dy:Int;
	private var oDist:Int = 0;
	private var currentScale:Float = 1;
	private var onZoom:Bool = false;
	
	private var lap:openfl.utils.Timer = new openfl.utils.Timer(300, 0);
	
	
	public function new()
	{
		super();
	}
	
	
	//**************************************** HANDLERS *********************************************
	
	
	
	//**************************************** FUNCTIONS ********************************************
	
	
	public function init(camX:Float, camY:Float, world:Sprite, targetCam:Sprite):Void
	{
		
		canvas = world;
		this.targetCam = targetCam;
		
		currentScale = canvas.scaleY;
		
		targetCam.x = camX;
		targetCam.y = camY;
		
		orignalStageX = targetCam.x;
		orignalStageY = targetCam.y;
		
		qScrollable = Std.int(canvas.width - stage.stageWidth) >> 1;
		
		stage.addEventListener(TouchEvent.TOUCH, onTouch);
	
		//trace("canvas.targetCam",canvas.targetCam.x,canvas.targetCam.y)
		//targetCam.mouseEnabled=false;
		//canvas.targetCam.visible=false; //<--------------------------------------------------------- targetCam
		//addChildAt(targetCam,numChildren);
	}
	
	
	public function getCoordinateByTime(o:Bool):Void
	{
		if (o)
		{
			tiempoDrag = Std.int(haxe.Timer.stamp() * 1000);
			refTouchX = (mouseX);
			refTouchY = (mouseY);
			lap.addEventListener(TimerEvent.TIMER, timerLap, false, 0, true);
			lap.start();
		}
		else
		{
			refTouchX = (mouseX);
			refTouchY = (mouseY);
			lap.stop();
			lap.removeEventListener(TimerEvent.TIMER, timerLap);
		}
	}
	
	public function timerLap(e:TimerEvent):Void
	{
		tiempoDrag = Std.int(haxe.Timer.stamp() * 1000);
		refTouchX = (mouseX);
		refTouchY = (mouseY);
	}
	
	public function stageTouched():Void
	{
		itemSelectable = true;
		velX = 0;
		velY = 0;
		
		getCoordinateByTime(true);
		firstTouchX = (mouseX);
		firstTouchY = (mouseY);
		
		inicialPosX = (targetCam.x);
		inicialPosY = (targetCam.y);
	}
	
	public function noStageTouched():Void
	{
		getCoordinateByTime(false);
	}
	
	public function adjustRegisterPoint():Void
	{
		var adjustRegX:Float = targetCam.x;
		var adjustRegY:Float = targetCam.y;
		
		targetCam.x = 0;
		targetCam.y = 0;
		
		canvas.x += adjustRegX;
		canvas.y += adjustRegY;
	}
	
	public function moveStage():Void
	{
		//trace("on move")
		var xValue:Int = Std.int(mouseX - firstTouchX);
		var yValue:Int = Std.int(mouseY - firstTouchY);
		
		if ((abs(xValue) > 10 || abs(yValue) > 10) && !onZoom)
		{
			targetCam.x = inicialPosX - (xValue) / (canvas.scaleX);
			targetCam.y = inicialPosY - (yValue) / (canvas.scaleY);
			
			itemSelectable = false;
			stageBound();
		}
		else
		{
			itemSelectable = true;
		}
	}
	
	public function stageBound():Void
	{
		//testTarget.x = targetCam.x;                        
		//testTarget.y = targetCam.y;
	
		///Limite Izquierdo y control de Flecha
		//        if(canvas.targetCam.x>canvas.stageWidth>>1){
		//                canvas.targetCam.x=canvas.stageWidth>>1;
		//        }
		//        
		//        //Limite Derecho y control de Flecha
		//        if(canvas.targetCam.x<-qScrollable){
		//                canvas.targetCam.x=-qScrollable;
		//        }
	}
	
	public function outStage():Void
	{
		//if(scrollable){                                
		//}
		tiempoDrag += -Std.int(haxe.Timer.stamp() * 1000);
		velX += ((sensibility / canvas.scaleX) * ((tiempoDrag != 0) ? ((refTouchX - mouseX) / tiempoDrag) : 11));
		velY += ((sensibility / canvas.scaleY) * ((tiempoDrag != 0) ? ((refTouchY - mouseY) / tiempoDrag) : 11));
		
		stage.addEventListener(Event.ENTER_FRAME, controlMov);
		getCoordinateByTime(false);
	}
	
	public function abs(a:Float):Float
	{
		return a < 0 ? -a : a;
	}
	
	public function controlMov(e:Event):Void
	{
		if (++cada > 8)
		{
			cada = 1;
			velX /= friccion;
			velY /= friccion;
		}
		if (targetCam != null)
		{
			targetCam.x -= (velX / canvas.scaleX);
			targetCam.y -= (velY / canvas.scaleY);
			
			if ((velX < 0 ? -velX : velX) < 0.5)
			{
				velX = 0;
				stage.removeEventListener(Event.ENTER_FRAME, controlMov);
			}
			
			stageBound();
		}
	}
	
	
	private function onTouch(e:TouchEvent):Void
	{
		touch = e.getTouch(stage);
		var touches:Vector<Touch> = e.touches;
		
		if (touch != null)
		{
			//pos=touch.getLocation(stage);
			mouseX = Std.int(touch.globalX);
			mouseY = Std.int(touch.globalY);
			
			if (touch.phase == "began")
			{
				stageTouched();
			}
			
			if (touch.phase == "moved")
			{
				moveStage();
			}
		}
		
		// retrieves the touch points
		// if two fingers
		if (touches.length == 2)
		{
			var finger1:Touch = touches[0];
			var finger2:Touch = touches[1];
			var distance:Int;
			var dx:Int;
			var dy:Int;
			
			// if both fingers moving (dragging)
			if (finger1.phase == TouchPhase.MOVED && finger2.phase == TouchPhase.MOVED)
			{
				onZoom = true;
				
				if (oDist == 0)
					oDist = Std.int(fingerDistance(finger1, finger2) / currentScale);
				
				distance = fingerDistance(finger1, finger2);
				
				if (distance / oDist > minScale && distance / oDist < maxScale)
					canvas.scaleX = canvas.scaleY = currentScale = distance / oDist;
			}
		}
		
		if (touch != null)
		{
			if (touch.phase == "ended")
			{
				onZoom = false;
				oDist = 0;
				outStage();
			}
		}
	
	}
	
	private function fingerDistance(finger1:Touch, finger2:Touch):Int
	{
		dx = Std.int(Math.abs(finger1.globalX - finger2.globalX));
		dy = Std.int(Math.abs(finger1.globalY - finger2.globalY));
		
		return Std.int(Math.sqrt(dx * dx + dy * dy));
	}

	
	//**************************************** SET AND GET ******************************************
	
	


}