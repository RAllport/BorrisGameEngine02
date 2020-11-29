package borrisEngine.borrisPhysics;

import openfl.display.*;

import box2D.dynamics.*;
import box2D.collision.*;
import box2D.collision.shapes.*;
import box2D.dynamics.joints.*;
import box2D.dynamics.contacts.*;
import box2D.common.*;
import box2D.common.math.*;

import borrisEngine.borrisPhysics.BContactListener;
import borrisEngine.ui.BStarlingInput;
import borrisEngine.utils.BPhysicsInit;
import borrisEngine.utils.createPhysics.*;


/**
 * A wrapper to manage the physics of the application.
 * 
 * @author Rohaan Allport
 */
class BBox2DPhysicsWrapper extends BBasePhysicsWrapper
{
	
	public var world:B2World;
	public var bomb:B2Body;
	public var mouseJoint:B2MouseJoint;
	public var velocityIterations:Int = 10;
	public var positionIterations:Int = 10;
	public var timeStep:Float = 0.06;
	public static var physScale:Float = 40;
	
	// 
	public var bodyToFollow:B2Body;
	
	
	/**
	 * Contructs a new BPhysicsWrapper object.
	 */
	public function new() 
	{
		super();
		
		
		// Define the gravity vector
		var gravity:B2Vec2 = new B2Vec2(0.0, 10.0);
		
		// Allow bodies to sleep
		var doSleep:Bool = true;
		
		// Construct a world object
		world = new B2World(gravity, doSleep);
		world.setWarmStarting(true);
		world.setContactListener(new BContactListener());
		
		// set debug draw
		//renderSprite = new Sprite();
		BPhysicsInit.setupDegugDraw(world, BBasePhysicsWrapper.renderSprite, physScale);
		//BPhysicsInit.setupStarlingDebugDraw(world, renderSprite, physScale);
		
		// initialize Create Classes
		// BUG because CreateShape and CreateJoint are initialized with each new BPhysicsWrapper, the b2World changes. So everytime a new BScene is made the world changes.
		// fix it by initializing them once. then everytime a scene is switched, change their world
		if(!BBasePhysicsWrapper._factoriesInitialized)
		{
			CreateShape.initialize(world, physScale);
			CreateJoint.initialize(world, physScale);
			BBasePhysicsWrapper._factoriesInitialized = true;
		}
		
		// test bodies
		/*CreateShape.createCircle(300, 300, 12, "dynamic", 0, 1, 0, 0.8);
		CreateShape.createPolygon(300, 334, 
								[[-15, -22], [15, -22], [15, 19], [12, 22], [-12, 22], [-15, 19]], 
								"dynamic", 0, 1, 0, 0.8);
		CreateShape.createBox(300, 376, 50, 24, "dynamic", 0, 1, 0, 0.8);
		CreateShape.createCircle(300, 400, 12, "dynamic", 0, 1, 0, 3);
		CreateShape.createBox(300, 417, 10, 30, "dynamic", 0, 0.1, 0.3, 0.8);
		
		
		CreateShape.createBox(620, 650, 50, 1200, "static", 0, 1, 0, 0.8);
		CreateShape.createBox(-100, 360, 400, 80, "static", 0, 1, 0, 0.8);
		CreateShape.createBox(1200, 360, 400, 80, "static", 0, 1, 0, 0.8);*/
		
		trace(world != null? "World contructed!" : "world not made :(");
	}
	
	
	//**************************************** HANDLERS *********************************************
	
	
	
	//**************************************** FUNCTIONS ********************************************
	
	
	/**
	 * 
	 */
	// TODO find performance drop in update.
	// BUG FIXED constant drawing in debog draw with neko
	override public function update():Void 
	{
		// TODO change or separate mouse editing functions
		// Update mouse joint
		//updateMouseWorld();
		//mouseDestroy();
		//mouseDrag();
		
		// Update physics
		world.step(timeStep, velocityIterations, positionIterations);
		world.clearForces();
		
		//Main.m_fpsCounter.updatePhys(getTimer());
		
		// Render
		if(BBasePhysicsWrapper.debugDrawing)
			world.drawDebugData();
		
		
		// update Camera
		if (bodyToFollow != null)
		{
			updateCamera(bodyToFollow, BBasePhysicsWrapper.renderSprite, true, physScale, false);
		} // end if
		
	} // end function update
	
	
	/**
	 * for flash display objects
	 * 
	 * @param	bodyToFollow
	 * @param	renderSprite
	 * @param	following
	 * @param	physScale
	 * @param	mouseNudge
	 */
	public function updateCamera(bodyToFollow:B2Body, renderSprite:flash.display.Sprite, following:Bool = true, physScale:Float = 40, mouseNudge:Bool = false):Void
	{
		var posX:Float = 0;
		var posY:Float = 0;
		
		if(following) 
		{
			posX = bodyToFollow.getWorldCenter().x * physScale;
			posY = bodyToFollow.getWorldCenter().y * physScale;
			
			/*if(posX < 200) 
			{
				posX = 200;
			}
			if(posX > 400) 
			{
				posX = 400;
			}
			
			if(posY < -100)
			{
				posY = -100;
			}
			if(posY > 200)
				{
				posY = 200;
			}*/
		}
		
		
		renderSprite.x = renderSprite.stage.stageWidth/2 - posX;
		renderSprite.y = renderSprite.stage.stageHeight/2 - posY;
		//trace("render sprite X: " + renderSprite.x);
		//trace("render sprite Y: " + renderSprite.y);
		
	} // end function
	
	
	/**
	 * 
	 */
	override public function updateMouseWorld():Void
	{
		BBasePhysicsWrapper.mouseXWorldPhys = (BStarlingInput.mouseX)/physScale; 
		BBasePhysicsWrapper.mouseYWorldPhys = (BStarlingInput.mouseY)/physScale; 
		
		BBasePhysicsWrapper.mouseXWorld = (BStarlingInput.mouseX); 
		BBasePhysicsWrapper.mouseYWorld = (BStarlingInput.mouseY); 
		
	}
	
	
	/**
	 * 
	 */
	override public function mouseDrag():Void
	{
		// mouse press
		if (BStarlingInput.mouseIsDown && mouseJoint == null)
		{
			var body:B2Body = getBodyAtMouse();
			
			if(body != null)
			{
				var md:B2MouseJointDef = new B2MouseJointDef();
				md.bodyA = world.getGroundBody();
				md.bodyB = body;
				md.target.set(BBasePhysicsWrapper.mouseXWorldPhys, BBasePhysicsWrapper.mouseYWorldPhys);
				md.collideConnected = true;
				md.maxForce = 300.0 * body.getMass();
				mouseJoint = cast(world.createJoint(md), B2MouseJoint);
				body.setAwake(true);
			}
		}
		
		
		// mouse release
		if (!BStarlingInput.mouseIsDown)
		{
			if(mouseJoint != null)
			{
				world.destroyJoint(mouseJoint);
				mouseJoint = null;
			}
		}
		
		
		// mouse move
		if(mouseJoint != null)
		{
			var p2:B2Vec2 = new B2Vec2(BBasePhysicsWrapper.mouseXWorldPhys, BBasePhysicsWrapper.mouseYWorldPhys);
			mouseJoint.setTarget(p2);
		}
	}
	
	
	/**
	 * 
	 */
	override public function mouseDestroy():Void
	{
		// mouse press
		if (!BStarlingInput.mouseIsDown && BStarlingInput.keyPressed(68/*D*/))
		{
			
			var body:B2Body = getBodyAtMouse(true);
			
			if (body != null)
			{
				trace("Destroying body!");
				world.destroyBody(body);
				return;
			}
		}
	}
	
	
	//======================
	// GetBodyAtMouse
	//======================
	private var mousePVec:B2Vec2 = new B2Vec2();
	
	/**
	 * 
	 * @param	includeStatic
	 * @return
	 */
	public function getBodyAtMouse(includeStatic:Bool = false):B2Body 
	{
		// Make a small box.
		mousePVec.set(BBasePhysicsWrapper.mouseXWorldPhys, BBasePhysicsWrapper.mouseYWorldPhys);
		var aabb:B2AABB = new B2AABB();
		aabb.lowerBound.set(BBasePhysicsWrapper.mouseXWorldPhys - 0.001, BBasePhysicsWrapper.mouseYWorldPhys - 0.001);
		aabb.upperBound.set(BBasePhysicsWrapper.mouseXWorldPhys + 0.001, BBasePhysicsWrapper.mouseYWorldPhys + 0.001);
		
		var body:B2Body = null;
		var fixture:B2Fixture;
		
		// Query the world for overlapping shapes.
		function GetBodyCallback(fixture:B2Fixture):Bool
		{
			var shape:B2Shape = fixture.getShape();
			if (fixture.getBody().getType() != B2Body.b2_staticBody || includeStatic)
			{
				var inside:Bool = shape.testPoint(fixture.getBody().getTransform(), mousePVec);
				if(inside)
				{
					body = fixture.getBody();
					return false;
				}
			}
			return true;
		}
		world.queryAABB(GetBodyCallback, aabb);
		return body;
	}
	
	
	//**************************************** SET AND GET ******************************************
	
	
}