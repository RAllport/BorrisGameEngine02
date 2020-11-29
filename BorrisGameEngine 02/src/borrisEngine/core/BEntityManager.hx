package borrisEngine.core;

import starling.geom.Rectangle;

/**
 * ...
 * @author Rohaan Allport
 */
class BEntityManager
{
	public static var numEntities(get, never):Int;
	public static var numPools(get, never):Int;
	public static var quickPool(get, set):BEntityPool;
	
	
	private static var _pools:Array<BEntityPool> = [];
	private static var _numEntities:Int = 0;
	private static var _quickPool:BEntityPool;

	/*public function new() 
	{
		
	}*/
	
	
	//**************************************** HANDLERS *********************************************
	
	
	//**************************************** FUNCTIONS ********************************************
	
	
	/**
	 * 
	 * 
	 * @param	name
	 * @return 
	 */
	public static function createPoolByName(name:String, bouderies:Rectangle = null):BEntityPool
	{
		var ep:BEntityPool = new BEntityPool();
		ep.name = name;
		_pools.push(ep);
		
		return ep;
	}
	
	
	/**
	 * Returns the first instance of a BEntityPool with the specified name.
	 * 
	 * @param	name The name of the BEntityPool to search for
	 * @return 
	 */
	public static function getPoolByName(name:String):BEntityPool
	{
		for (pool in _pools)
		{
			if (pool.name == name)
			{
				return pool;
			}
		}
		
		return null;
	}
	
	
	//**************************************** SET AND GET ******************************************
	
	
	/**
	 * 
	 */
	private static function get_numEntities():Int
	{
		_numEntities = 0;
		for (pool in _pools)
		{
			_numEntities += pool.totalEntities;
		}
		return _numEntities;
	}
	
	
	/**
	 * 
	 */
	private static function get_numPools():Int
	{
		return _pools.length;
	}
	
	
	/**
	 * 
	 */
	private static function get_quickPool():BEntityPool
	{
		return _quickPool;
	}
	
	private static function set_quickPool(value:BEntityPool):BEntityPool
	{
		_quickPool = value;
		return _quickPool;
	}
	
	
}