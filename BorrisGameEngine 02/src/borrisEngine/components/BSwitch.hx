package borrisEngine.components;

import borrisEngine.core.BEntityComponent;
import borrisEngine.components.BAnimator;
import starling.events.Event;

/**
 * ...
 * @author Rohaan Allport
 */
class BSwitch extends BEntityComponent
{
	public static inline var ON:String = "on";
	public static inline var OFF:String = "off";
	
	private var _animator:BAnimator;
	
	public var state:String = OFF;
	

	public function new() 
	{
		
	}
	
	
	//**************************************** HANDLERS *********************************************
	
	
	/**
	 * 
	 */
	override private function entityAddedHandler(event:Event):Void
	{
		if (_owner.getComponent(BAnimator) != null)
		{
			_animator = cast(_owner.getComponent(BAnimator), BAnimator);
		} // end if
		
	} // end function
	
	
	//**************************************** FUNCTIONS ********************************************
	
	
	/**
	 * 
	 */
	private var onTriggerEnter2D(sensor:BRigidBody2D):Void
	{
		_animator.switchAnimation(onMC);
	} // end function
	
	
	/**
	 * 
	 */
	private var onTriggerExit2D(sensor:BRigidBody2D):Void
	{
		_animator.switchAnimation(offMC);
	} // end function
	
	
	//**************************************** SET AND GET ******************************************
	
	
	
}