package borrisEngine.components;

import starling.display.*;
import starling.events.Event;
import starling.geom.Rectangle;
import starling.textures.Texture;

import borrisEngine.core.*;
import borrisEngine.entities.*;
import borrisEngine.entities.paricles.*;
import borrisEngine.events.BEntityComponentEvent;

/**
 * ...
 * @author Rohaan Allport
 */
class BParticleEmitter extends BEntityComponent
{
	public static inline var CIRCLE:String = "circle";
	public static inline var RECTANGLE:String = "rectangle";
	public static inline var HORIZONTAL_LINE:String = "horizontalLine";
	public static inline var VERTICAL_LINE:String = "verticalLine";
	
	public static inline var CONTINUOUS:String = "continuous";
	public static inline var BURST:String = "burst";
	
	
	//public var numParticles(get, set):Int = 0;
	public var shape(get, set):String;
	public var emitionMode(get, set):String;
	public var burstDelay(get, set):Float;
	private var totalParticles(get, set):Int;
	
	public var texture:Texture = BGame.sAssets.getTexture("particle round grad0000");
	
	public var type:Class<BEulerEntity> = BCustomizableParticle;
	public var numParticles:Int = 3;
	
	public var speed:Float = 10;
	public var randomSpeedFrom:Array<Float> = [];
	public var speedOverTime:Array<Float> = [];
	public var radius:Float = 30;
	public var width:Float = 10;
	public var height:Float = 10;
	public var x:Float = 0;
	public var y:Float = 0;
	public var thickness:Float = 1;
	
	public var upperAngle:Float = 0;
	public var lowerAngle:Float = 360;
	
	public var lifeSpan:Float; // millisoconds
	public var size:Float = 1;
	public var sizeOverTime:Array<Float> = [1, 1];
	public var color:Int = -1;
	public var colorOverTime:Array<UInt> = [0xFFFFFF, 0xFFFFFF];
	public var alpha:Float = 1;
	public var alphaOverTime:Array<Float> = [1, 1];
	
	public var inwards:Bool = false;
	public var autoUpdate = true;
	
	//public var _pool:BEntityPool;
	
	private var _particles:Array<BEntity> = [];
	private var _positionShapeFunction:Dynamic;
	private var _shape:String = CIRCLE;
	private var _emitionFunction:Dynamic;
	private var _emitionMode:String = CONTINUOUS;
	private var _burstCounter:Float = 0;
	private var _burstDelay:Float = 1;
	private var _totalParticles:Int = 0;
	
	
	// TODO these are temporary variables to get some stuff done ASAP. Remove them and apply proper function using the varaibles above later.
	//public var speed:Float;
	public var gravity:Float = 0;
	public var acceleration:Float = 0;
	public var friction:Float = 0;
	public var autoRotate:Bool = false;
	public var spin:Float = 0;
	public var fadeSpeed:Float = 0;
	public var growSpeed:Float = 0;
	public var angle:Float = 0;
	//public var lifeSpan:Float = 0;
	public var rotation:Float = 0;
	
	
	
	public function new() 
	{
		super();
		
		shape = CIRCLE;
		emitionMode = CONTINUOUS;
		
		//_pool = new BEntityPool();
		
		/*_owner.graphics.beginFill(0xffffff, 1);
		_owner.graphics.drawCircle(0, 0, radius);
		_owner.graphics.endFill();*/
	}
	
	//**************************************** HANDLERS *********************************************
	
	
	/**
	 * 
	 */
	/*override private function entityAddedHandler(event:BEntityComponentEvent):Void
	{
		
	} // end function entityAddedHandler*/
	
	
	//**************************************** FUNCTIONS ********************************************
	
	
	/**
	 * @inheritDoc
	 */
	override public function update():Void
	{
		super.update();
		
		if(autoUpdate)
			_emitionFunction();
		
	} // end function update
	
	
	/**
	 * 
	 */
	public function emitNow():Void
	{
		emit();
	} // end function
	
	
	/**
	 * 
	 */
	public function createParticles(amount:Int = 0):Void
	{
		type = BEulerEntity;
		
		for (i in 0...amount)
		{
			//cast(BScene.pool.getEntity(type), BEulerEntity);
			//_particles.push(BScene.pool.addEntities(type));
			
			var testParticle = cast(BScene.pool.getEntity(BEulerEntity), BEulerEntity);
			var particle:BEulerEntity = null;
			if (testParticle.numChildren == 0 && testParticle.numComponents == 0)
			{
				trace("making particle");
				particle = testParticle;
				var image = new Image(texture);
				image.x = -Math.ceil(texture.width/2);
				image.y = -Math.ceil(texture.height/2);
				particle.addChild(image);
				
				_particles.push(particle);
			} // end if
			
		} // end for
		
	} // end function createParticles
	
	
	/**
	 * 
	 */
	public function emitXEveryYSeconds():Void
	{
		
	} // end function 
	
	
	/**
	 * 
	 */
	public function emitXEveryYSecondsZTimes():Void
	{
		
	} // end function 
	
	
	/**
	 * 
	 */
	private function emit():Void
	{
		for (i in 0...numParticles)
		{
			//var particle:BEulerEntity = cast(_pool.getEntity(type), BEulerEntity);
			var particle:BEulerEntity = cast(BScene.pool.getEntity(type), BEulerEntity);
			// TODO optimize this. holy shit! i forgot about that
			if (type == BCustomizableParticle)
			{
				cast(particle, BCustomizableParticle).texture = texture;
			}
			_positionShapeFunction(particle);
			particle.scaleX = particle.scaleY = size;
			particle.speed = speed;
			// TODO fix alpha
			//particle.alpha = alpha;
			
			//if(color > 0) particle.color = color;
			particle.gravity = gravity;
			particle.acceleration = acceleration;
			particle.friction = friction;
			particle.autoRotate = autoRotate;
			particle.spin = spin;
			particle.fadeSpeed = fadeSpeed;
			particle.growSpeed = growSpeed;
			//particle.angle = angle;
			//particle.angle = Math.random() * ((upperAngle - lowerAngle) - (upperAngle + lowerAngle)/2) * Math.PI/180;
			//particle.angle = Math.random() * (upperAngle - lowerAngle) * Math.PI/180 - (upperAngle + lowerAngle)/2 * Math.PI/180;
			particle.angle = Math.random() * (upperAngle - lowerAngle) * Math.PI/180 - upperAngle * Math.PI/180;
			particle.rotation = rotation;
			
			_owner.scene.addEntity(particle);
			//trace("particle: " + particle.speed);
			//trace(particle.xVelocity);
			particle.alpha = alpha;
			
		} // end for
		
		
		
	} // end function 
	
	
	/**
	 * 
	 */
	private function doBurst():Void
	{
		_burstCounter += BGame.deltaTime;
		
		if (_burstCounter >= _burstDelay)
		{
			_burstCounter = 0;
			emit();
		} // end if
		
	} // end function 
	
	
	/**
	 * 
	 */
	private function doContinuous() 
	{
		emit();
	} // end function 
	
	
	/**
	 * 
	 */
	private function circleShapePosition(particle:BEulerEntity):Void
	{
		var piA:Float = Math.random() * Math.PI * 2;
		
		//particle.x = _owner.x + Math.cos(piA) * Math.random() * radius;
		//particle.y = _owner.y + Math.sin(piA) * Math.random() * radius;
		//particle.x = _owner.x + x + Math.cos(piA) * Math.random() * radius;
		//particle.y = _owner.y + y + Math.sin(piA) * Math.random() * radius;
		particle.x = _owner.x + Math.cos(_owner.rotation * (Math.PI / 180)) * x + Math.cos(piA) * Math.random() * radius;
		particle.y = _owner.y + Math.sin(_owner.rotation * (Math.PI/180)) * y + Math.sin(piA) * Math.random() * radius;
		
		if(Math.cos(_owner.rotation * (Math.PI/180)) == 0)
			particle.x = _owner.x + x + Math.cos(piA) * Math.random() * radius;
		
		if(Math.sin(_owner.rotation * (Math.PI/180)) != 0)
			particle.y = _owner.y + y + Math.sin(piA) * Math.random() * radius;
		
	} // end function 
	
	
	/**
	 * 
	 */
	private function rectangleShapePosition(particle:BEulerEntity):Void
	{
		particle.x = _owner.x + Math.random() * width - width/2;
		particle.y = _owner.y + Math.random() * height - height/2;
	} // end function 
	
	
	/**
	 * 
	 */
	private function horizontalLineShapePosition(particle:BEulerEntity):Void
	{
		particle.x = _owner.x + Math.random() * width - width/2;
		particle.y = _owner.y;
	} // end function 
	
	
	/**
	 * 
	 */
	private function verticalLineShapePosition(particle:BEulerEntity):Void
	{
		particle.x = _owner.x;
		particle.y = _owner.y + Math.random() * height - height/2;
	} // end function 
	
	
	//**************************************** SET AND GET ******************************************
	
	
	private function get_shape():String 
	{
		return _shape;
	}
	
	private function set_shape(value:String):String 
	{
		_shape = value;
		
		switch(_shape)
		{
			case BParticleEmitter.CIRCLE:
				_positionShapeFunction = circleShapePosition;
			
			case BParticleEmitter.RECTANGLE:
				_positionShapeFunction = rectangleShapePosition;
			
			case BParticleEmitter.HORIZONTAL_LINE:
				_positionShapeFunction = horizontalLineShapePosition;
			
			case BParticleEmitter.VERTICAL_LINE:
				_positionShapeFunction = verticalLineShapePosition;
			
		} // end switch
		
		return _shape;
	}
	
	
	private function get_emitionMode():String 
	{
		return _emitionMode;
	}
	
	private function set_emitionMode(value:String):String 
	{
		_emitionMode = value;
		
		switch(_emitionMode)
		{
			case BParticleEmitter.CONTINUOUS:
				_emitionFunction = doContinuous;
			
			case BParticleEmitter.BURST:
				_emitionFunction = doBurst;
			
		} // end switch 
		
		return _emitionMode;
	}
	
	
	private function get_burstDelay():Float 
	{
		return _burstDelay;
	}
	
	private function set_burstDelay(value:Float):Float 
	{
		return _burstDelay = value;
	}
	
	
	private function get_totalParticles():Int 
	{
		return _totalParticles;
	}
	
	private function set_totalParticles(value:Int):Int 
	{
		_totalParticles = value;
		
		//cast(BScene.pool.getEntity(type), BEulerEntity);
		//_particles.push(BScene.pool.addEntities(type));
		
		return _totalParticles;
	}
	
	
	/*private function get_numParticles():Int 
	{
		return _numParticles;
	}
	
	private function set_numParticles(value:Int):Int 
	{
		if (_particles.length < value)
		{
			
		} // end if
		
		return _numParticles = value;
	}*/
	
	
}