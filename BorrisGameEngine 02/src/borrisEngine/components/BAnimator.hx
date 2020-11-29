package borrisEngine.components;

import starling.core.Starling;
import starling.display.MovieClip;

import borrisEngine.core.BEntity;
import borrisEngine.core.BEntityComponent;


/**
 * ...
 * @author Rohaan Allport
 */
class BAnimator extends BEntityComponent
{
	public var currentAnimation(get, never):MovieClip;
	public var numAnimations(get, never):Int;
	
	private var _animations:Array<MovieClip>;
	private var _currentAnimation:MovieClip;
	
	
	public function new() 
	{
		super();
		
		_animations = new Array<MovieClip>();
	}
	
	//**************************************** HANDLERS *********************************************
	
	
	//**************************************** FUNCTIONS ********************************************
	
	
	/**
	 * 
	 * @param	animation
	 * @param	loop
	 * @return
	 */
	public function addAnimation(animation:MovieClip, name:String, loop:Bool = true):MovieClip
	{
		_animations.push(animation);
		_owner.addChild(animation);
		
		
		animation.name = name;
		animation.loop = loop;
		animation.visible = false;
		Starling.current.juggler.add(animation);
		
		if (_animations.length == 1)
		{
			_currentAnimation = animation;
			animation.visible = true;
		}
		
		return animation;
	} // end function 
	
	
	/**
	 * @param	animation
	 * @return
	 */
	public function removeAnimation(animation:MovieClip):MovieClip
	{
		_animations.remove(animation);
		_owner.removeChild(animation);
		Starling.current.juggler.remove(animation);
		
		return animation;
	} // end function 
	
	
	/**
	 * 
	 * @param	index
	 * @return
	 */
	public function removeAnimationAt(index:Int):MovieClip
	{
		var animation:MovieClip;
		animation = _animations.splice(index, 1)[0];
		_owner.removeChild(animation);
		
		Starling.current.juggler.remove(animation);
		
		return animation;
	} // end function 
	
	
	/**
	 * 
	 * @param	name
	 * @return
	 */
	public function removeAnimationByName(name:String):MovieClip
	{
		var animation:MovieClip;
		animation = getAnimationByName(name);
		_animations.remove(animation);
		_owner.removeChild(animation);
		
		Starling.current.juggler.remove(animation);
		
		return animation;
	} // end function 
	
	
	/**
	 * 
	 * @param	index
	 * @return
	 */
	public function getAnimationAt(index:Int):MovieClip
	{
		return _animations[index];
	} // end function 
	
	
	/**
	 * 
	 * @param	name
	 * @return
	 */
	public function getAnimationByName(name:String):MovieClip
	{
		for (animation in _animations)
		{
			if (name == animation.name)
			{
				return animation;
			} // end if
		} // end for
		
		return null;
	} // end function 
	
	
	/**
	 * 
	 * @param	animation
	 */
	public function switchAnimation(animation:MovieClip):MovieClip
	{
		for (tempAnimation in _animations)
		{
			tempAnimation.visible = false;
			
			if (animation == tempAnimation)
			{
				animation.visible = true;
				_currentAnimation = animation;
			}
		} // end for
		
		return _currentAnimation;
		
	} // end function 
	
	
	/**
	 * 
	 * @param	name
	 */
	public function switchAnimationByName(name:String):MovieClip
	{
		for (animation in _animations)
		{
			animation.visible = false;
			
			if (animation.name == name)
			{
				animation.visible = true;
				_currentAnimation = animation;
			}
		} // end for
		
		return _currentAnimation;
		
	} // end function 
	
	
	
	
	//**************************************** SET AND GET ******************************************
	
	
	/**
	 * 
	 */
	private function get_currentAnimation():MovieClip
	{
		return _currentAnimation;
	}
	
	
	/**
	 * 
	 */
	private function get_numAnimations():Int
	{
		return _animations.length;
	}
	
	
}