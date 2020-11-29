package borrisEngine.components;

import borrisEngine.core.BEntityComponent;
import borrisEngine.events.BEntityComponentEvent;

import starling.display.DisplayObject;


/**
 * ...
 * @author Rohaan Allport
 */
class BCollectable extends BEntityComponent
{
	public var bodyName:String;
	public var body:BRigidBody2D;
	
	private var _graphics:DisplayObject;
	private var _collectedGraphics:DisplayObject;
	
	private var _animator:BAnimator;
	private var _sensor:BRigidBody2D;
	
	private var _type:String = "coin";
	private var _value:Int = 1;
	private var _taken:Bool = false;
	

	public function new() 
	{
		super();
		
		_animator = new BAnimator();
		
		_sensor = new BRigidBody2D();
		
	}
	
	
	//**************************************** HANDLERS *********************************************
	
	
	/**
	 * 
	 */
	override private function entityAddedHandler(event:BEntityComponentEvent):Void
	{
		super.entityAddedHandler(event);
		
		_owner.addComponent(_animator);
		_owner.addComponent(_sensor);
		
		_sensor.name = "sensor";
		_sensor.setShapeType("cirlce");
		_sensor.setSize(30, 30);
		_sensor.isSensor = true;
	} // end function
	
	
	//**************************************** FUNCTIONS ********************************************
	
	
	/**
	 * @inheritDoc
	 */
	override public function update():Void
	{
		super.update();
		onTriggerEnter2D(body);
	} // end function
	
	
	/**
	 * 
	 */
	private function onTriggerEnter2D(body:BRigidBody2D):Void
	{
		/*if (!_taken && )
		{
			_taken = true;
		} // end if*/
		
		if (_sensor.realBody.getUserData() != null)
		{
			//if(Std.int(_sensor.realBody.getUserData().contacts) > 0 && body.name == bodyName)
			if(Std.int(_sensor.realBody.getUserData().contacts) > 0 && body.name == bodyName)
			{
				trace("Collectable taken!");
			} // end if
		} // end if
		
	} // end function
	
	
	/**
	 * 
	 */
	private function onTriggerExit2D(sensor:BRigidBody2D):Void
	{
		//_animator.switchAnimation(offMC);
	} // end function
	
	
	
	//**************************************** SET AND GET ******************************************
	
	
	
}