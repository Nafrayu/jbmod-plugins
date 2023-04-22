#include <sdktools>
#include <sdkhooks>
#include <sourcemod>

new const Float:FORCE_MUL_VEC[3] = {1.25, 1.25, 1.0};
//#define DAMAGE_MUL 10.0
#define DAMAGE_DIV 100.0

new ConVar:g_cvarSmgHop;

public Plugin myinfo =
{
	name = "JBMod SMG Hop Plugin",
	author = "I am SCREAMING",
	description = "Makes player have a lot of force on explosions",
	version = "1.1",
	url = "http://www.sourcemod.net/"
};

// Imprecise method, which does not guarantee v = v1 when t = 1, due to floating-point arithmetic error.
// This method is monotonic. This form may be used when the hardware has a native fused multiply-add instruction.
stock float lerp(float v0, float v1, float t) {
  return v0 + t * (v1 - v0);
}

// stock void VectorsToAngle(float vec1[3], float vec2[3], float ang[3])
// {
// 	float v[3];
// 	SubtractVectors(vec1, vec2, v);
// 	NormalizeVector(v, v);
// 	GetVectorAngles(v, ang);
// }

stock void BlastForce(int victim, int inflictor, float damage)
{
	float ply_pos[3];
	float inf_pos[3]; // inflictor not infinite

	GetClientAbsOrigin(victim, ply_pos);
	GetEntPropVector(inflictor, Prop_Send, "m_vecOrigin", inf_pos);

	float push_vec[3];
	VectorsToVelocity(ply_pos, inf_pos, push_vec);

	float ply_vel[3];
	GetEntPropVector(victim, Prop_Data, "m_vecVelocity", ply_vel);

	//NegateVector(push_vec);

	ScaleVector( push_vec, damage );
	AddVectors(push_vec, ply_vel, push_vec);

	//float eye_ang[3];
	//GetClientEyeAngles(victim, eye_ang);
	//NegateVector(eye_ang);

	//SubtractVectors(push_vec, eye_ang, push_vec);

	MultiplyVectors(push_vec, FORCE_MUL_VEC, push_vec);
	push_vec[2] = 300.0;

	// NOTE: put damage division value in seperate var
	push_vec[2] /= ( damage / DAMAGE_DIV );

	int buttons;
	buttons = GetClientButtons(victim);

	int is_on_ground;
	is_on_ground = GetEntityFlags(victim) & FL_ONGROUND;

	if ( is_on_ground || buttons & IN_JUMP ) {
		push_vec[2] *= 1.65;
		//PrintToChatAll("%f, %f, %f", push_vec[0], push_vec[1], push_vec[2]);
	}

	// prevent player from jumping high randomly
	if (push_vec[2] >= 850.0) {
		// PrintToChatAll("ok your velocity is too much");
		push_vec[2] = 600.0;
		push_vec[2] += damage;
	}

	// PrintToChatAll("%f, %f, %f", push_vec[0], push_vec[1], push_vec[2]);

	TeleportEntity(victim, NULL_VECTOR, NULL_VECTOR, push_vec);
}

stock void VectorsToVelocity(float vec1[3], float vec2[3], float result[3])
{
	SubtractVectors(vec1, vec2, result);
	NormalizeVector(result, result);
}

/**
 * Multiplies two vectors.  It is safe to use either input buffer as an output
 * buffer.
 *
 * @param vec1          First vector.
 * @param vec2          Second vector.
 * @param result        Result buffer.
 */
stock void MultiplyVectors(const float vec1[3], const float vec2[3], float result[3])
{
	result[0] = vec1[0] * vec2[0];
	result[1] = vec1[1] * vec2[1];
	result[2] = vec1[2] * vec2[2];
}

public void OnPluginStart()
{
	g_cvarSmgHop = CreateConVar("mp_smghop", "1");
	for (new i=1; i<=MaxClients; i++)
	{
		if (IsValidEntity(i))
		{
			SDKHook(i, SDKHook_OnTakeDamage, Player_OnTakeDamage);
		}
	}
}

public OnPluginEnd()
{
	for (new i=1; i<=MaxClients; i++)
	{
		if (IsValidEntity(i))
		{
			SDKHook(i, SDKHook_OnTakeDamage, Player_OnTakeDamage);
		}
	}
}

public OnClientPutInServer(int client)
{
	SDKHook(client, SDKHook_OnTakeDamage, Player_OnTakeDamage);
}

public Action:Player_OnTakeDamage(int victim, int &attacker, int &inflictor, float &damage, int &damagetype)
{
	if ( !g_cvarSmgHop.BoolValue ) {
		return Plugin_Continue;
	}

	if ( !(damagetype & DMG_BLAST) ) {
		//PrintToChatAll("i didn't get exploded");
		return Plugin_Continue;
	}

	if (victim != attacker) {
		//PrintToChatAll("i didn't hurt myself");
		return Plugin_Continue;
	}

	// run custom blast force code
	BlastForce(victim, inflictor, damage);

	// remove blast damage from self
	damage = 0.0;

	return Plugin_Changed;
}
