package borrisEngine.borrisPhysics;

import box2D.dynamics.*;
import box2D.collision.*;
import box2D.collision.shapes.*;
import box2D.dynamics.joints.*;
import box2D.dynamics.contacts.*;
import box2D.common.*;
import box2D.common.math.*;


/**
 * ...
 * @author Rohaan Allport
 */
class BContactListener extends B2ContactListener
{
	public var materialA:B2Fixture;
	public var materialB:B2Fixture;
	public var bodyA:B2Body;
	public var bodyB:B2Body;
	
	public var currentContact:B2Contact;
	public var contacts:Array<B2Contact>;
	public var contactCount:Int;
	
	
	public function new() 
	{
		super();
		contacts = new Array<B2Contact>();
		contactCount = 0;
	}
	
	
	/**
	 * 
	 * @param	contact
	 */
	override public function beginContact(contact:B2Contact):Void
	{
		//super.BeginContact(contact);
		
		//trace("making contact");
		
		materialA = contact.getFixtureA();
		materialB = contact.getFixtureB();
		bodyA = contact.getFixtureA().getBody();
		bodyB = contact.getFixtureB().getBody();
		
		currentContact = contact;
		contacts.push(contact);
		
		
		if(bodyA.getUserData() == null)
		{
			bodyA.setUserData({name: "B2Body", displayObject: null, contacts: 0});
		}
		if (bodyB == null)
		{
			bodyB.setUserData({name: "B2Body", displayObject: null, contacts: 0});
		}
		
		
		//var bodyUserData:Object;
		var currentBody:B2Body;
		
		
		// set current body to bodyA
		currentBody = bodyA;
		
		// check if currentBody has user data
		if(currentBody.getUserData() != null) 
		{
			if(currentBody.getUserData().contacts != null) 
			{
				currentBody.getUserData().contacts++;
				//trace("Body A Contacts: " + currentBody.getUserData().contacts);
			}
		} // end if
		
		
		
		// set current body to bodyB
		currentBody = bodyB;
		
		// check if currentBody has user data
		if(currentBody.getUserData() != null) 
		{
			if(currentBody.getUserData().contacts != null) 
			{
				currentBody.getUserData().contacts++;
				//trace("Body B Contacts: " + currentBody.getUserData().contacts);
			}
		} // end if
		
	} // end function BeginContact
	
	
	/**
	 * 
	 * @param	contact
	 */
	override public function endContact(contact:B2Contact):Void
	{
		//super.EndContact(contact);
		
		// remove contact from contacts vector
		contacts.remove(contact);
		
		var currentBody:B2Body;
		
		// set current body to contact.materialA.body;
		currentBody = contact.getFixtureA().getBody();
		
		// check if currentBody has user data
		if(currentBody.getUserData() != null) 
		{
			/*if(currentBody.userData.name != null) 
			{
				trace("Current body name: " + currentBody.userData.name);
			}
			if(currentBody.userData.displayObject != null) 
			{
				currentBody.userData.contacts++;
			}*/
			if(currentBody.getUserData().contacts != null) 
			{
				currentBody.getUserData().contacts--;
				//trace("Current body contacts: " + currentBody.userData.contacts);
			}
		} // end if
		
		// set current body to contact.materialB.body;
		currentBody = contact.getFixtureB().getBody();
		
		// check if currentBody has user data
		if(currentBody.getUserData() != null) 
		{
			/*if(currentBody.userData.name != null) 
			{
				trace("Current body name: " + currentBody.userData.name);
			}
			if(currentBody.userData.displayObject != null) 
			{
				currentBody.userData.contacts++;
			}*/
			if(currentBody.getUserData().contacts != null) 
			{
				currentBody.getUserData().contacts--;
				//trace("Current body contacts: " + currentBody.userData.contacts);
			}
		} // end if
		
		
	} // end function EndContact
	
	
}