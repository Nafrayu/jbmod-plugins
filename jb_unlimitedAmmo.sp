#include <sdkhooks>
#include <sourcemod>

new bool:enable;

new const m_iClip_sizes[] =
{
	0,		//skip
	30,		//AR2			pri
	255,	//AR2AltFire	sec
	18,		//Pistol		pri
	45,		//SMG1			pri
	6,		//357			pri
	1,		//XBowBolt		pri
	6,		//Buckshot		pri
	255,	//RPG_Round		pri
	255,	//SMG1_Grenade	sec
	255,	//Grenade		pri
	255,	//Slam			sec
	255,	//wtf			sec
	255,	//wtf			sec
	255,	//wtf			sec
	255	//wtf			sec
}

#define RPG_Round 8
#define Grenade 10

public OnPluginStart()
{
	new Handle:cvar = CreateConVar("sm_hl2mp_unlimited_ammo", "1", "Lots of lots of ammunitions", FCVAR_PLUGIN, true, 0.0, true, 1.0);
	enable = GetConVarBool(cvar);
	HookConVarChange(cvar, cvar_changed);
	CloseHandle(cvar);

	for(new i = 1; i <= MaxClients; i++)
	{
		if(IsClientInGame(i))
		{
			OnClientPutInServer(i);
		}
	}
}

public cvar_changed(Handle:convar, const String:oldValue[], const String:newValue[])
{
	enable = StringToInt(newValue) == 1 ? true:false;
}

public OnClientPutInServer(client)
{
	SDKHookEx(client, SDKHook_FireBulletsPost, FireBulletsPost);
	SDKHookEx(client, SDKHook_WeaponSwitchPost, WeaponSwitchPost);
}

public FireBulletsPost(client, shots, const String:weaponname[])
{
	if(!enable)
	{
		return;
	}

	new weapon = GetEntPropEnt(client, Prop_Send, "m_hActiveWeapon");

	if(weapon != -1)
	{
		ReFillWeapon(client, weapon);
	}
}

public WeaponSwitchPost(client, weapon)
{
	if(enable && weapon != -1)
	{
		ReFillWeapon(client, weapon);
	}
}

ReFillWeapon(client, weapon)
{
	// new m_iPrimaryAmmoType = GetEntProp(weapon, Prop_Send, "m_iPrimaryAmmoType");
	// if(m_iPrimaryAmmoType != -1)
	// {
		// SetEntProp(client, Prop_Send, "m_iAmmo", 255, _, m_iPrimaryAmmoType);
		SetEntProp(weapon, Prop_Send, "m_iClip1", 420);
	// }

	// new m_iSecondaryAmmoType = GetEntProp(weapon, Prop_Send, "m_iSecondaryAmmoType");
	// if(m_iSecondaryAmmoType != -1)
	// {
		// SetEntProp(client, Prop_Send, "m_iAmmo", 255, _, m_iSecondaryAmmoType);
		SetEntProp(weapon, Prop_Send, "m_iClip2", 420);
	// }
}