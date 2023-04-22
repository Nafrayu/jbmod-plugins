#include <sourcemod>
#include <sdktools>
#include <sdktools_functions>
#include <sdktools_tempents>
#include <sdktools_sound>
#include <sdkhooks>

#pragma newdecls required
#pragma semicolon 1


public Plugin myinfo = 
{
name        = "func_breakable HP tracker thing",
author      = "Digby ° ૩ °#4534, STRESSED CAT IN A BOX",
description = "Plugin so that fnaf-life's newest releases will work properly in JBMod :)",
version     = "1.0",
url         = "https://discord.gg/P6ZwJvCsG8"
};


public void OnPluginStart()
{
	HookEntityOutput("logic_case", "RemoveHealth", OutputHook);
	HookEntityOutput("math_counter", "RemoveHealth", OutputHook);
	HookEntityOutput("logic_timer", "RemoveHealth", OutputHook);
	HookEntityOutput("func_breakable", "RemoveHealth", OutputHook);
	
	HookEntityOutput("logic_case", "Substract", OutputHook);
	HookEntityOutput("math_counter", "Substract", OutputHook);
	HookEntityOutput("logic_timer", "Substract", OutputHook);
	HookEntityOutput("func_breakable", "Substract", OutputHook);
	// PowerlvlHP
	// GetEntPropString(entity, Prop_Data, "m_iName", buffer, size);
}


public void OutputHook(const char[] name, int caller, int activator, float delay)
{
	char callerClassname[64];
	if (caller >= 0 && IsValidEntity(caller)) {
		GetEntityClassname(caller, callerClassname, sizeof(callerClassname));
	}

	char activatorClassname[64];
	if (activator >= 0 && IsValidEntity(activator)) {
		GetEntityClassname(activator, activatorClassname, sizeof(activatorClassname));
	}
	
	PrintToChatAll("[ENTOUTPUT] %s (caller: %d/%s, activator: %d/%s)", name, caller, callerClassname, activator, activatorClassname);
}













int g_Health[4096]; // this could be 2048 idk what game you're in


public void OnEntityCreated(int entity, const char[] classname)
{
if (StrEqual(classname, "func_breakable"))
SDKHook(entity, SDKHook_OnTakeDamagePost, OnTakeDamagePost);
}

void OnTakeDamagePost(int victim, int attacker, int inflictor, float damage, int damagetype, int weapon, const float damageForce[3], const float damagePosition[3], int damagecustom)
{
int health = GetEntProp(victim, Prop_Data, "m_iHealth");

PrintToChatAll("func_breakable health after taking dmg: %i", health);


if (health != g_Health[victim])
{
g_Health[victim] = health;

// idk what this power is but you had it in your code
float power = float(health) / 10.0;

PrintToChatAll("Power: %.2f", victim, health, power);
}
}