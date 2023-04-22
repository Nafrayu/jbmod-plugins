

public Action:Godmode_OnTakeDamage(int victim, int &attacker, int &inflictor, float &damage, int &damagetype, int &weapon, float damageForce[3], float damagePosition[3])
{
	// PrintToConsoleAll("(victim %i attacker %i inflictor %i damage %f damagetype %i weapon %i)", victim, attacker, inflictor, damage, damagetype, weapon);
	
	if (attacker > 0 && attacker <= MaxClients
	&& victim > 0 && victim <= MaxClients)
	{
		if (IsValidEntity(attacker) && HasEntProp(attacker, Prop_Data, "m_takedamage"))
		{
			if (GetEntProp(attacker, Prop_Data, "m_takedamage") != 2)
			{
				damage = 0.0;
				if (victim != attacker)
				{
					PrintToConsole(attacker, "Unable to damage other players while in buddha or godmode");
				}
				return Plugin_Changed;
			}
		}
	}

	// SDKHooks_TakeDamage(attacker, victim, victim, 1.0, DMG_GENERIC, -1, _, _, bool:true);
}


public Action:FixFalldamage_OnTakeDamage(int victim, int &attacker, int &inflictor, float &damage, int &damagetype)
{
    // if fall damage is enabled then continue with whatever
    if ( g_cvarFallDamageToggle.BoolValue ) {
        //PrintToChatAll("fall damage not toggled");
        return Plugin_Continue;
    }

    if ( !(damagetype & DMG_FALL) ) {
        //PrintToChatAll("i didn't fall");
        return Plugin_Continue;
    }

    // remove fall damage
    damage = 0.0;

    return Plugin_Changed;
}

