// Template logic
// If I haven't commented something, it's because I don't know what it is, but I do know it's important.
const int levicharge = 70;
const int levilength = 450;
const int maxcharge = levicharge + levilength;
const float levipower = 2.2;
//Import scripts! These are important for reasons. Basically, they let you steal code from base to use as your own, legally.
#include "Hitters.as"; //Basically, all the types of attacks you get.
#include "Knocked.as"; //Known as stun.
#include "ThrowCommon.as"; //You know when you press 'C' in game and you throw what you're holding?
#include "RunnerCommon.as"; //Movement scripts.
void onInit(CBlob@ this)
{
	this.set_u32("Chargestart", 0);
}
void onTick(CBlob@ this) //This script is called 30 times a second. It's a general update script. Most of your modding will be done here.
{
	Vec2f pos = this.getPosition();
	if(this.isKeyJustPressed(key_action1))
	{
		this.set_u32("Chargestart", getGameTime() + levicharge);
	}
	if(this.isKeyJustReleased(key_action1))
	{
		unLevitate(this);		
	}
	int Chargestart = this.get_u32("Chargestart");
	if(Chargestart < getGameTime() && Chargestart != 0)
	{
		this.Tag("othergrav");
		Vec2f norm = this.getAimPos() - this.getPosition();
		norm.Normalize();
		norm.y -= 0.4;
		norm.x /= 2.0f;
		norm *= levipower * (0.3f + ((getGameTime() + levilength )- (Chargestart + levicharge)) / 90.0f);
		this.AddForce(norm);
		print("Levitation power x "  + norm.x + "Levitation power y " + norm.y);
		this.getShape().SetGravityScale(0.9f);
		if(Chargestart + levilength < getGameTime())
		{
			unLevitate(this);
			this.set_u32("Chargestart", getGameTime() + levicharge);
		}
		//Draw a bar! Perhaps make it so that the bar starts green when beginning the charge, then goes to red when it's active
	}
	/////////////////////////////
	//That's it for the template class. You would usually add your code for abilities or attacks here.
	
	//If you wanna check if the player is pressing left click, use: if(this.isKeyPressed(key_action1))
	//Similarily, right click is: if(this.isKeyPressed(key_action2))
	
	//I can't really help or explain more. Making classes is hard and difficult. Every class is different, so there's no method to make every class.
	//Hope these files helped!
	//////////////////////////////
}
void unLevitate(CBlob@ this)
{
	this.set_u32("Chargestart", 0);
	this.getShape().SetGravityScale(1.0f);
	this.Untag("othergrav");
}
void onRender(CSprite@ this)
{
	CBlob@ blob = this.getBlob();
	int Chargestart = blob.get_u32("Chargestart");
	if(Chargestart != 0)
	{
		Vec2f pos = blob.getPosition();
		Vec2f upperleft = getDriver().getScreenPosFromWorldPos(pos);
		upperleft.x -= 35;
		upperleft.y -= (maxcharge / 2) / 8;
		Vec2f lowerright = upperleft;
		lowerright.x += 10;
		int Power = (getGameTime() - Chargestart + levicharge) / 8;
		lowerright.y += Power;
		if((getGameTime() - Chargestart) > 0)
		{
			GUI::DrawRectangle(upperleft, lowerright, SColor(255, 20, 170, 20));
		}
		else
		{
			GUI::DrawRectangle(upperleft, lowerright, SColor(255, 170, 20, 20));
		}
	}
}