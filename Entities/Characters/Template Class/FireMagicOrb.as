const int FIRE_FREQUENCY = 40;
const f32 ORB_SPEED = 1.5f;

void onInit(CBlob@ this)
{
	this.set_u32("last magic fire", getGameTime() - FIRE_FREQUENCY);
}

void onTick(CBlob@ this)
{
	if (getNet().isServer() && this.isKeyPressed(key_action1))
	{
		u32 lastFireTime = this.get_u32("last magic fire");
		const u32 gametime = getGameTime();
		int diff = gametime - (lastFireTime + FIRE_FREQUENCY);

		if (diff > 0)
		{
			Vec2f pos = this.getPosition();
			Vec2f aim = this.getAimPos();
			Vec2f norm = aim - pos;
			norm.Normalize();
			lastFireTime = gametime;
			this.set_u32("last magic fire", lastFireTime);
			CBlob@ orb = server_CreateBlob("orb", this.getTeamNum(), pos + norm * 10);
			if (orb !is null)
			{
				orb.setVelocity(norm * ORB_SPEED);
				orb.SetDamageOwnerPlayer(this.getPlayer());
			}
		}
	}
}
