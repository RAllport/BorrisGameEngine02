package borrisEngine.entities.paricles;

import openfl.geom.Matrix;
import openfl.geom.Point;

import starling.display.Sprite;
import starling.display.Quad;
import starling.events.*;
import starling.core.Starling;
import starling.utils.*;
import starling.filters.*;

import borrisEngine.core.BScene;
import borrisEngine.entities.*;

/**
 * ...
 * @author Rohaan Allport
 */
class BLightning extends Sprite//BEulerEntity
{
	// set and get
	public var numBranches(get, set):Int;							// The number of lightning branch.
	public var branchWidth(get, set):Float;							// The width in pixels of the branches.
	public var color(get, set):UInt;								// The color of the lightning.
	// Note: The frequency is a length. Not the frquency of a wave.
	public var frequency(get, set):Float;							// The frequency of the lightning. (I made the code so that is it actually slightly randomized)
	public var amplitude(get, set):Float;							// The (max) amplitude of a lightning branch. (I made the code so that is it randomized)
	public var lightningLength(get, set):Float;						// The length of the lightning. (this is sort of imcomplete)
	public var branchSpread(get, set):Float;						// A gap in pixels between the lightning branches.
	public var branchAngularSpread(get, set):Float;					// An angle that the branches spread out to. (It's kinda hard to explain)
	public var amplitudeDelta(get, set):Float;						// A value which changes the amplitude over distance.
	//public var frqencyDelta(get, set):Float;						// 	
	
	public var isForkLightning(get, set):Bool;						// Whther the lightning is a fork lightning or not.
	public var startFromCenter(get, set):Bool;						// Whether or not the branches start from a center point.
	//public var endAtCenter(get, set):Bool;						// Whether or not the branches come together at the end.
	public var variableBranchWidth(get, set):Bool; 					// 
	//public var variableFrequency(get, set):Bool;					// 
	//public var varibaleAmplitude(get, set):Bool;					// 
	public var everyXFrame(get, set):Int;
	
	
	// constants
	public static inline var ANGULAR_SPREAD_CONSTANT:String = "angularSpreadConstant";
	public static inline var ANGULAR_SPREAD_RANDOM:String = "angularSpreadRandom";
	
	
	// assets
	
	// other
	private var _segments:Array<Quad> = [];
	private var _branches:Array<Sprite> = [];
	private var _p1:Point = new Point();						// The point at which to place a lightning segment segment.
	private var _p2:Point = new Point();						// The 
	private var _sLength:Float = 0;								// The length of a lighting segment.
	private var _sXDistance:Float = 0;							// The X distance between 2 adjacent lightning segments
	private var _sYDistance:Float = 0;							// The Y distance between 2 adjacent lightning segments
	private var _sAngle:Float = 0;								// The angle of a lightning segment.
	private var _totalSpread:Float = 0;							// The total spread of the branches. eg, say 4 branches with 10px spread is a total of 30px spread. ((4-1) * 10). we subtract 1 to account for the top and bottom branches to be at the edges.
	//private var branchSpreadGap:Float;						// The actual Gap between branches. Fixes and off-by-one error.
	private var _numSegments:Int = 5;							// The number of segments in the branches. Used to help with lightningLength
	private var _amplitudeDeltaIncrement:Float = 0.3;			// The amount the Amplitude should increase by per segment to reach the amplitudeDelta value.
	
	//private var angularSpreadMode:String;						// constant or random
	
	
	//private var outerGlow:BlurFilter;
	
	// set and get
	private var _numBranches:Int = 3;
	private var _color:UInt = 0xFFFFFF;
	private var _branchWidth:Float = 3;
	private var _frequency:Float = 60;
	private var _amplitude:Float = 24;
	private var _lightningLength:Float = 600;
	private var _branchSpread:Float = 0;
	private var _branchAngularSpread:Float = 0;
	private var _amplitudeDelta:Float = 0;
	//private var _frqencyDelta:Float = 0;
	
	private var _isForkLightning:Bool = false;
	private var _startFromCenter:Bool = true;
	//private var _endAtCenter:Bool = false;
	private var _variableBranchWidth:Bool = true;
	//private var _variableFrequency:Bool = false;
	//private var _varibaleAmplitude:Bool = false;
	
	
	//private var _hasGlow:Bool = true;						// 
	//private var _glowColor:UInt = 0x0099FF				// 
	//private var _glowSize:Float = 4;						// 
	private var _everyXFrame:Int = 4;
	private var _everyXFrameCounter:Int = 0;
	
	// TODO implement frequency delta
	// TODO implement endAtCenter
	
	
	//public function Lightning(x:Float, y:Float, angle:Float = 0, spread:Float = 0 ) 
	public function new() 
	{
		super();
		
		//gravity = 0;
		
		numBranches = _numBranches;
		//lifeSpan = Math.POSITIVE_INFINITY;
		
	}
	
	
	//**************************************** HANDLERS *********************************************
	
	
	
	//**************************************** FUNCTIONS ********************************************
	
	
	/**
	 * 
	 */
	public function update():Void
	{
		
		_everyXFrameCounter++;
		if (_everyXFrameCounter == _everyXFrame)
		{
			_everyXFrameCounter = 0;
			
			var segment:Quad;
			removeChildren();
			
			for(j in 0..._numBranches)
			{
				var branch = new Sprite();
				//var branch = _branches[j];
				branch.rotation = Math.random() * _branchAngularSpread - _branchAngularSpread / 2;
				//branch.removeChildren();
				addChild(branch);
				
				// if start from center, set all point values to 0.
				if (_startFromCenter)
				{
					_p1.x = 0;
					_p1.y = 0;
					_p2.x = 0;
					_p2.y = 0;
				}
				else // chaneg the amplitude
				{
					_p1.x = 0;
					_p2.x = 0;
					
					_p1.y = Math.random() * _amplitude - _amplitude/2 - _totalSpread/2 + j * _branchSpread;
					_p2.y = Math.random() * _amplitude - _amplitude/2 - _totalSpread/2 + j * _branchSpread;
				}
				
				
				// loop for the lightning length
				for(i in 0..._numSegments)
				//for(i in 0...branch.numChildren)
				{
					//var segment = branch.getChildAt(i);
					
					_p2.x = _p1.x;
					_p2.y = _p1.y;
					
					// this is the frequency
					//p1.x = i * 30 + (Math.random() * 8 + 26); // random number from 26-34 therefore a random number from 
					// NOTE the lightninglength is not always equally divisible by the frequency hance making an overshoot
					_p1.x = i * _frequency + (Math.random() * (_frequency/16) + _frequency - (_frequency/8));
					if (i == (branch.numChildren - 1))
					{
						_p1.x = _lightningLength;					
					} // end if
					
					// this is the amplitude, brach spread and amplitude delta
					if (_amplitudeDelta != 0)
					{
						_p1.y = (Math.random() * (_amplitude + (_amplitudeDeltaIncrement * i)) - (_amplitude + (_amplitudeDeltaIncrement * i))/2) - _totalSpread/2 + (j * _branchSpread);
					}
					else
					{
						_p1.y = Math.random() * _amplitude - _amplitude/2 - _totalSpread/2 + j * _branchSpread;
					}
					
					// calculate segment x and y distance
					_sXDistance = _p1.x - _p2.x;
					_sYDistance = _p1.y - _p2.y;
					
					// calculate segment length by using pythagorus
					_sLength = Math.sqrt(_sXDistance * _sXDistance + _sYDistance * _sYDistance);
					
					// set that angle of the segment
					_sAngle = Math.atan2(_sYDistance, _sXDistance);
					
					segment = new Quad(_sLength, _branchWidth, _color);

					if (_variableBranchWidth)
					{
						segment.height = Math.random() * _branchWidth + _branchWidth / 2;
					}
					segment.pivotX = 0;
					segment.pivotY = segment.height/2;
					segment.rotation = _sAngle;
					segment.x = _p2.x;
					segment.y = _p2.y;
					//segment.scaleY = 1;
					//segment.skewX = Math.random() * 2 - 1;
					//segment.skewY = 1;
					//segment.transformationMatrix = new Matrix();
					
					branch.addChild(segment);
					
				} // end for
				
			} // end for
			
			
		} // end if
		
		//super.update();
	} // end function update
	
	
	private function generateBranch():Void
	{
		var branch:Sprite = new Sprite();
		
		for (i in 0..._numSegments)
		{
			
		} // end for
	} // end function
	
	
	private function generateSegments():Void
	{
		
		// TODO resuse segments
		_segments = [];
		
		for (branch in _branches)
		{
			branch.removeChildren();
			for (i in 0..._numSegments)
			{
				var segment:Quad = new Quad(_frequency, _branchWidth, _color);
				segment.pivotX = -_branchWidth/2;
				segment.pivotX = -_branchWidth/2;
				branch.addChild(segment);
			} // end for
		} // end for
		
		/*for (segment in _segments)
		{
			segment.parent.removeChild(s);
		} // end for*/
		
	} // end function
	
	
	/**
	 * Sets the properties for fork mode.
	 * 
	 * @param	maxSplits
	 * @param	minSplits
	 * @param	maxSplitFrequency
	 * @param	minSplitFrequency
	 * @param	splitScale
	 */
	/*public function setForkBranches(maxSplits:Int = 3, minSplits:Int = 1, maxSplitFrequency:Int = 3, minSplitFrequency:Int = 1, splitScale:Float = 0.9 ):Void
	{
		
	} // end function setForkBranches*/
	
	
	//**************************************** SET AND GET ******************************************
	
	
	private function get_numBranches():Int
	{
		return _numBranches;
	}
	
	private function set_numBranches(value:Int):Int
	{
		_numBranches = value;
		
		if (_numBranches > _branches.length)
		{
			var branch:Sprite;
			for (i in 0...(_numBranches - _branches.length))
			{
				branch = new Sprite();
				addChild(branch);
				_branches.push(branch);
			} // end for
		}
		else if (_numBranches < _branches.length)
		{
			// TODO perhaps instead of of remving them, deactivate them and set visibility false
			removeChildren(1, (_branches.length - _numBranches));
			_branches.splice(1, (_branches.length - _numBranches));
		} // ene else
		
		_totalSpread = (_numBranches - 1) * _branchSpread;
		//branchSpreadGap = totalSpread/(_branches - 1);
		
		generateSegments();
		return numBranches;
	}
	
	
	private function get_branchWidth():Float
	{
		return _branchWidth;
	}
	
	private function set_branchWidth(value:Float):Float
	{
		_branchWidth = value;
		generateSegments();
		return _branchWidth;
	}
	
	
	private function get_frequency():Float
	{
		return _frequency;
	}
	
	private function set_frequency(value:Float):Float
	{
		_frequency = value;
		_numSegments = Math.ceil(_lightningLength / _frequency);
		generateSegments();
		return _frequency;
	}
	
	
	private function get_amplitude():Float
	{
		return _amplitude;
	}
	
	private function set_amplitude(value:Float):Float
	{
		return _amplitude = value;
	}
	
	
	private function get_lightningLength():Float
	{
		return _lightningLength;
	}
	
	private function set_lightningLength(value:Float):Float
	{
		_lightningLength = value;
		_numSegments = Math.ceil(_lightningLength / _frequency);
		generateSegments();
		return _lightningLength;
	}
	
	
	private function get_branchSpread():Float
	{
		return _branchSpread;
	}
	
	private function set_branchSpread(value:Float):Float
	{
		_branchSpread = value;
		_totalSpread = (_numBranches - 1) * _branchSpread;
		//branchSpreadGap = totalSpread/(_branches - 1);
		return _branchSpread;
	}
	
	
	private function get_branchAngularSpread():Float
	{
		return _branchAngularSpread;
	}
	
	private function set_branchAngularSpread(value:Float):Float
	{
		return _branchAngularSpread = value;
	}
	
	
	private function get_amplitudeDelta():Float
	{
		return _amplitudeDelta;
	}
	
	private function set_amplitudeDelta(value:Float):Float
	{
		_amplitudeDelta = value;
		_amplitudeDeltaIncrement = (_amplitude * _amplitudeDelta) / _numSegments;
		return _amplitudeDelta;
	}
	
	
	private function get_isForkLightning():Bool
	{
		return _isForkLightning;
	}
	
	private function set_isForkLightning(value:Bool):Bool
	{
		return _isForkLightning = value;
	}
	
	
	private function get_startFromCenter():Bool
	{
		return _startFromCenter;
	}
	
	private function set_startFromCenter(value:Bool):Bool
	{
		return _startFromCenter = value;
	}
	
	
	private function get_variableBranchWidth():Bool
	{
		return _variableBranchWidth;
	}
	
	private function set_variableBranchWidth(value:Bool):Bool
	{
		return _variableBranchWidth = value;
	}
	
	
	/*private function set_hasGlow(value:Bool):Bool
	{
		if (value == _hasGlow)
			return;
		
		_hasGlow = value;
		
		if (value)
		{
			outerGlow = BlurFilter.createGlow(_glowColor, 2, _glowSize, 0.5);
			outerGlow.mode = FragmentFilterMode.BELOW;
			filter = outerGlow;
			//filter.cache();
		}
		else
		{
			filter = null;
		}
		
	}
	
	private function get_hasGlow():Bool
	{
		return _hasGlow;
	}
	
	
	private function set_glowColor(value:UInt):Void
	{
		if (value == _glowColor)
			return;
		
		_glowColor = value;	
			
		if (_hasGlow)
		{
			outerGlow = BlurFilter.createGlow(_glowColor, 2, _glowSize, 0.5);
			outerGlow.mode = FragmentFilterMode.BELOW;
			filter = outerGlow;
			//filter.cache();
		}
		
	}
	
	private function get_glowColor():UInt
	{
		return _glowColor;
	}
	
	
	private function set_glowSize(value:Float):Void
	{
		if (value == _glowSize)
			return;
		
		_glowSize = value;	
			
		if (_hasGlow)
		{
			outerGlow = BlurFilter.createGlow(_glowColor, 2, _glowSize, 0.5);
			outerGlow.mode = FragmentFilterMode.BELOW;
			filter = outerGlow;
			//filter.cache();
		}
		
	}
	
	private function get_glowSize():Float
	{
		return _glowSize;
	}
	*/
	
	private function get_everyXFrame():Int
	{
		return _everyXFrame;
	}
	
	private function set_everyXFrame(value:Int):Int
	{
		return _everyXFrame = value;
	}
	
	
	private function get_color():UInt
	{
		return _color;
	}
	
	private function set_color(value:UInt):UInt
	{
		_color = value;
		generateSegments();
		return _color;
	}
	
	
	
	
}