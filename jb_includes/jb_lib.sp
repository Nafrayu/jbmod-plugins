#if defined _jblib_included
	#endinput
#endif
#define _jblib_included

#define JBLIB_VERSION "1.0"

#include <sourcemod>
#include <sdktools>
#include <sdktools_functions>
#include <sdktools_tempents>
#include <sdktools_sound>
#include <sdkhooks>
#include <entity_prop_stocks>
#include <dhooks>
#include <smlib>
#include <vphysics>
#include "3x4_matrix.sp"
#include "4x4_matrix.sp"
#include "toScreen.sp"

// stock int jb_RefCreate(int i)
// {
	// int temp = i;
	// temp = EntIndexToEntRef(temp);
	// return temp;
// }

// stock int jb_RefGet(int i)
// {
	// int temp = i;
	// temp = EntRefToEntIndex(temp);
	// return temp;
// }

// local _vectorForward = vector3(1,0,0)
// local _vectorRight = vector3(0,1,0)
// local _vectorUp = vector3(0,0,1)
// function quatMeta:Rotate(angle)
	// self:RotateAroundAxis(_vectorForward, angle.z)
	// self:RotateAroundAxis(_vectorRight, angle.x)
	// self:RotateAroundAxis(_vectorUp, angle.y)
// end


/**
 * safe version of HasPhyics 
 * requies vphysics extension
 * 
 * @param ent 
 * @return 1 or 0
 */
stock jb_RemoveEntity(any ent)
{
	AcceptEntityInput(ent, "kill");
}



#define FLOAT_EPSILON	0.0001


stock any Min(any a, any b)
{
	return (a <= b) ? a : b;
}

stock any Max(any a, any b)
{
	return (a >= b) ? a : b;
}

stock any Clamp(any val, any min, any max)
{
	return Min(Max(val, min), max);
}


// Thanks to ficool2 for helping me with scary vector math
stock bool IntersectionLineAABBFast(const float mins[3], const float maxs[3], const float start[3], const float dir[3], float far)
{
	// Test each cardinal plane (X, Y and Z) in turn
	float near = 0.0;
	
	if (!CloseEnough(dir[0], 0.0, FLOAT_EPSILON))
	{
		float recipDir = 1.0 / dir[0];
		float t1 = (mins[0] - start[0]) * recipDir;
		float t2 = (maxs[0] - start[0]) * recipDir;
		
		// near tracks distance to intersect (enter) the AABB
		// far tracks the distance to exit the AABB
		if (t1 < t2)
			near = Max(t1, near), far = Min(t2, far);
		else // Swap t1 and t2
			near = Max(t2, near), far = Min(t1, far);
		
		if (near > far)
			return false; // Box is missed since we "exit" before entering it
	}
	else if (start[0] < mins[0] || start[0] > maxs[0])
	{
		// The ray can't possibly enter the box, abort
		return false;
	}
	
	if (!CloseEnough(dir[0], 0.0, FLOAT_EPSILON))
	{
		float recipDir = 1.0 / dir[1];
		float t1 = (mins[1] - start[1]) * recipDir;
		float t2 = (maxs[1] - start[1]) * recipDir;
		
		if (t1 < t2)
			near = Max(t1, near), far = Min(t2, far);
		else // Swap t1 and t2.
			near = Max(t2, near), far = Min(t1, far);
		
		if (near > far)
			return false; // Box is missed since we "exit" before entering it
	}
	else if (start[1] < mins[1] || start[1] > maxs[1])
	{
		// The ray can't possibly enter the box, abort
		return false;
	}
	
	// Ray is parallel to plane in question
	if (!CloseEnough(dir[2], 0.0, FLOAT_EPSILON))
	{
		float recipDir = 1.0 / dir[2];
		float t1 = (mins[2] - start[2]) * recipDir;
		float t2 = (maxs[2] - start[2]) * recipDir;
		
		if (t1 < t2)
			near = Max(t1, near), far = Min(t2, far);
		else // Swap t1 and t2.
			near = Max(t2, near), far = Min(t1, far);
	}
	else if (start[2] < mins[2] || start[2] > maxs[2])
	{
		// The ray can't possibly enter the box, abort
		return false;
	}
	
	return near <= far;
}


/**
 * Gets the next child, entity is parent of.
 *
 * @param parent		Entity Index (of Parent)
 * @param start			Start Index.
 * @return				Entity Index or -1 if no entity was found.
 */
stock int Entity_GetParentRoot(int child)
{
	/*
	int maxEntities = GetMaxEntities();
	for (int entity=start; entity < maxEntities; entity++) {

		if (!Entity_IsValid(entity)) {
			continue;
		}

		if (entity > 0 && entity <= MaxClients && !IsClientConnected(entity)) {
			continue;
		}

		if (Entity_GetParent(entity) == parent) {
			return entity;
		}
	}
	*/
	
	int root = Entity_GetParent(child);
	int lastroot = root;
	
	if (root != INVALID_ENT_REFERENCE)
	{
		while ((root = Entity_GetParent(root)) != INVALID_ENT_REFERENCE)
		{
			lastroot = root;
		} 
	}
	return lastroot;
}


bool CloseEnough(float a, float b, float epsilon)
{
	return FloatAbs(a - b) <= epsilon;
}


stock void RotateAroundAxis(const float angle[3], const float axis[3], const float rotation[3], float outang[3])
{
	// ROTATE BASED ON WORLD ANGLES
	// LTOW(NULL_VECTOR, myang, NULL_VECTOR, Float:{5.0,0.0,0.0}, NULL_VECTOR, newa);

	// ROTATE BASED ON LOCAL ANGLES
	// LTOW(NULL_VECTOR, Float:{5.0,0.0,0.0}, NULL_VECTOR, myang, NULL_VECTOR, newa);
	
	// LTOW = ADD
	// WTOL = SUB	
	
	new Float:rotLocal[3];
	new Float:locallyRotated[3];
	
	// put our ang into local space
	WTOL(NULL_VECTOR, angle, NULL_VECTOR, axis, NULL_VECTOR, rotLocal);
	
	// rotate in local space ("fake world angles", i fucking hope i remember what i mean by that...)
	LTOW(NULL_VECTOR, rotLocal, NULL_VECTOR, rotation, NULL_VECTOR, locallyRotated);
	
	// put it back to actual worldspace
	LTOW(NULL_VECTOR, locallyRotated, NULL_VECTOR, axis, NULL_VECTOR, outang);
}


stock void projectAngleOnPlane(const float angle[3], const float plane[3], float outang[3])
{
	float Lpos[3];
	float Lang[3];
	float outpos[3];

	// convert arbitrary angle to local space
	WTOL(Float:{0.0,0.0,0.0}, angle, Float:{0.0,0.0,0.0}, plane, Lpos, Lang);
	
	// remove pitch
	// Lang[0] = 0.0;
	
	// go back to worldspace
	LTOW(Float:{0.0,0.0,0.0}, Lang, Float:{0.0,0.0,0.0}, plane, outpos, outang);
}


stock void projectAngleOnPlaneNoPitch(const float angle[3], const float plane[3], float outang[3])
{
	float Lpos[3];
	float Lang[3];
	float outpos[3];

	// convert arbitrary angle to local space
	WTOL(Float:{0.0,0.0,0.0}, angle, Float:{0.0,0.0,0.0}, plane, Lpos, Lang);
	
	// remove pitch
	Lang[0] = 0.0;
	
	// go back to worldspace
	LTOW(Float:{0.0,0.0,0.0}, Lang, Float:{0.0,0.0,0.0}, plane, outpos, outang);
}


stock GetViewModel(client)
{
	return GetEntPropEnt(client, Prop_Send, "m_hViewModel");
}


stock jb_GiveEverything(int client)
{
	GivePlayerItem(client, "weapon_leafblower");
	GivePlayerItem(client, "weapon_physgun");

	GivePlayerItem(client, "weapon_crowbar");
	GivePlayerItem(client, "weapon_stunstick");
	GivePlayerItem(client, "weapon_physcannon");
	GivePlayerItem(client, "weapon_pistol");
	GivePlayerItem(client, "weapon_flaregun");
	GivePlayerItem(client, "weapon_357");
	GivePlayerItem(client, "weapon_smg1");
	GivePlayerItem(client, "weapon_ar2");
	GivePlayerItem(client, "weapon_shotgun");
	GivePlayerItem(client, "weapon_crossbow");
	GivePlayerItem(client, "weapon_frag");
	GivePlayerItem(client, "weapon_rpg");
	GivePlayerItem(client, "weapon_slam");
	GivePlayerItem(client, "weapon_bugbait");
	
	new array_size = GetEntPropArraySize(client, Prop_Send, "m_hMyWeapons");
	new entity;
	for(new a = 0; a < array_size; a++)
	{
		entity = GetEntPropEnt(client, Prop_Send, "m_hMyWeapons", a);

		if(entity != -1)
		{
			new priammo = GetEntProp(entity, Prop_Send, "m_iPrimaryAmmoType");
			new secammo = GetEntProp(entity, Prop_Send, "m_iSecondaryAmmoType");
			GivePlayerAmmo(client, 99999, priammo, bool:true);
			GivePlayerAmmo(client, 99999, secammo, bool:true);
		}
	}
}


stock jb_GiveAmmo(int client, char[] weaponName, bool secondary, int ammoCount)
{
	new array_size = GetEntPropArraySize(client, Prop_Send, "m_hMyWeapons");
	
	new entity;
	
	for(new a = 0; a < array_size; a++)
	{
		entity = GetEntPropEnt(client, Prop_Send, "m_hMyWeapons", a);
		
		if (entity != -1)
		{			
			new String:cname[256];
			GetEntPropString(entity, Prop_Data, "m_iClassname", cname, sizeof(cname));

			if (StrEqual(cname, weaponName) == true)
			{
				if (secondary == true)
				{	
					new secammo = GetEntProp(entity, Prop_Send, "m_iSecondaryAmmoType");
					GivePlayerAmmo(client, ammoCount, secammo, bool:true);
				}
				else 
				{
					new priammo = GetEntProp(entity, Prop_Send, "m_iPrimaryAmmoType");
					GivePlayerAmmo(client, ammoCount, priammo, bool:true);
				}
			}
		}
	}
}


/**
 * shorter version of sending a VGUIMenu usermessage
 *
 * @param client        Index of the client
 * @param menu          The menu to open/close
 * @return              nothing
 */
stock showVGUIMenu(client, const char[] menu, int show)
{
	Handle hMenu   = StartMessageOne("VGUIMenu", client);
	if (hMenu != INVALID_HANDLE)
	{
		BfWriteString(hMenu, menu);
		BfWriteByte(hMenu, show);
		EndMessage();
	}
}


/**
 * safe version of HasPhyics 
 * requies vphysics extension
 * 
 * @param ent 
 * @return 1 or 0
 */
stock HasPhysics(ent)
{
	if (ent < 1 || ent > 2047)
		return 0;
	
	if (IsValidEntity(ent) && IsEntNetworkable(ent))
	{
		
		return Phys_IsPhysicsObject(ent);
	}
	return 0;
}


stock jb_toolgun_effect(client, ent, Float:plypos[3], Float:endpos[3])
{
	EmitGameSoundToAll("PropJeep.FireCannon", client);
	
	TE_SetupBeamPoints(plypos, endpos, LaserCache, 0, 0, 0, 0.25, 
	4.0, 4.0, 0, 0.0, {255,128,0,255}, 0);
	TE_SendToAll(0.0);
	
	TE_SetupBeamRingPoint(endpos, 0.0, 128.1, LaserCache, 0, 0,
	0, 0.25, 4.0, 0.0, {255,128,0,255}, 1, FBEAM_HALOBEAM);
	TE_SendToAll(0.0);
}


stock jb_toolgun_effect_deny(client, ent, Float:plypos[3], Float:endpos[3])
{
	TE_SetupBeamPoints(plypos, endpos, LaserCache, 0, 0, 0, 0.25, 
	4.0, 4.0, 0, 0.0, {255,0,0,255}, 0);
	TE_SendToAll(0.0);
	
	// TE_SetupBeamRingPoint(endpos, 0.0, 128.1, LaserCache, 0, 0,
	// 0, 0.25, 4.0, 0.0, {255,0,0,255}, 1, FBEAM_HALOBEAM);
	// TE_SendToAll(0.0);
}


/**
 * fires a traceline and stores
 * hitpos inside endpos 
 * requies player angles
 * 
 * @param client fire trace for this player
 * @param plyang player angles
 * @param dist how long is this trace?
 * @param endpos store hitpos inside this variable
 * @return entity that has been hit
 */
stock TracePlayerAngles(client, Float:plyang[3], Float:dist, Float:endpos[3])
{
	new Float:plypos[3];
	// new Float:plyang[3];
	new Float:traceend[3] = {0.0, 0.0, 0.0};
	
	GetClientEyePosition(client, plypos);
	// GetClientEyeAngles(client, plyang); //broken
	// GetClientAbsAngles(client, plyang); 
	// PrintToConsole(client, "%f %f %f", plyang[0], plyang[1], plyang[2]);
	
	decl Float:fwd[ 3 ];
	GetAngleVectors(plyang,fwd,NULL_VECTOR,NULL_VECTOR);
	ScaleVector(fwd, dist);
	AddVectors(plypos, fwd, traceend);

	TR_TraceRayFilter(plypos, traceend, MASK_SOLID, RayType_EndPoint, TraceRayDontHitSelf, client);
	
	TR_GetEndPosition(endpos);

	return TR_GetEntityIndex(INVALID_HANDLE);
}


/**
 * fires a traceline and stores
 * hitpos inside endpos 
 * requies player angles
 * 
 * @param client fire trace for this player
 * @param plyang player angles
 * @param dist how long is this trace?
 * @param endpos store hitpos inside this variable
 * @return entity that has been hit
 */
stock TracePlayerAnglesNormal(client, Float:plyang[3], Float:dist, Float:endpos[3], Float:normal[3])
{
	new Float:plypos[3];
	// new Float:plyang[3];
	new Float:traceend[3] = {0.0, 0.0, 0.0};
	
	GetClientEyePosition(client, plypos);
	// GetClientEyeAngles(client, plyang); //broken
	// GetClientAbsAngles(client, plyang); 
	// PrintToConsole(client, "%f %f %f", plyang[0], plyang[1], plyang[2]);
	
	decl Float:fwd[ 3 ];
	GetAngleVectors(plyang,fwd,NULL_VECTOR,NULL_VECTOR);
	ScaleVector(fwd, dist);
	AddVectors(plypos, fwd, traceend);

	TR_TraceRayFilter(plypos, traceend, MASK_SOLID, RayType_EndPoint, TraceRayDontHitSelf, client);
	
	TR_GetEndPosition(endpos);
	TR_GetPlaneNormal(INVALID_HANDLE, normal);

	return TR_GetEntityIndex(INVALID_HANDLE);
}


/**
 * fires a traceline and returns
 * the entity that has been hit
 * 
 * @param client fire trace for this player
 * @return entity that has been hit
 */
stock jb_getAimTarget(client)
{
	new Float:plypos3[3];
	new Float:plyang[3];
	new Float:traceend[3] = {0.0, 0.0, 0.0};
	
	GetClientEyePosition(client, plypos3);
	GetClientEyeAngles(client, plyang); //broken
	// GetClientAbsAngles(client, plyang); 
	
	decl Float:fwd[ 3 ];
	GetAngleVectors(plyang,fwd,NULL_VECTOR,NULL_VECTOR);
	ScaleVector(fwd, 4096.0);
	AddVectors(plypos3, fwd, traceend);

	TR_TraceRayFilter(plypos3, traceend, MASK_SOLID, RayType_EndPoint, TraceRayDontHitSelf, client);
	
	//TR_GetEndPosition(endpos);

	return TR_GetEntityIndex(INVALID_HANDLE);
}


/**
 * fires a traceline and stores
 * hitpos inside endpos
 * 
 * @param client fire trace for this player
 * @param endpos store hitpos inside this var
 * @return entity that has been hit
 */
stock jb_getAimTargetHit(client, Float:endpos[3])
{
	new Float:plypos3[3];
	new Float:plyang[3];
	new Float:traceend[3] = {0.0, 0.0, 0.0};
	
	GetClientEyePosition(client, plypos3);
	GetClientEyeAngles(client, plyang); //broken
	// GetClientAbsAngles(client, plyang); 
	
	decl Float:fwd[ 3 ];
	GetAngleVectors(plyang,fwd,NULL_VECTOR,NULL_VECTOR);
	ScaleVector(fwd, 4096.0);
	AddVectors(plypos3, fwd, traceend);

	TR_TraceRayFilter(plypos3, traceend, MASK_SOLID, RayType_EndPoint, TraceRayDontHitSelf, client);
	
	TR_GetEndPosition(endpos);

	return TR_GetEntityIndex(INVALID_HANDLE);
}


/**
 * returns a filter so tracelines
 * dont hit the player that fires
 * them
 * 
 * @param entity this entity fired the trace
 * @param mask trace mask
 * @param data dont hit this entity
 * @return true or false
 */
stock bool:TraceRayDontHitSelf(entity, mask, any:data)
{
	if (entity == data) // Check if the TraceRay hit the itself.
	{
		return bool:false; // Don't let the entity be hit
	}
	
	return bool:true; // It didn't hit itself
}


/**
 * clamp vector to a box

 * 
 * @param v vector to clamp
 * @param v1 box min
 * @param v2 box max
 * @return nothing
 */
// stock VectorClampToBox(v, v1, v2)
// {
	// v[0] = Math_Clamp(v1[0], v2[0]);
	// v[1] = Math_Clamp(v1[1], v2[1]);
	// v[2] = Math_Clamp(v1[2], v2[2]);
// }



/**
 * Sets the given value to min
 * if the value is smaller than the given.
 * Don't use this with float values.
 *
 * @param value			Value
 * @param min			Min Value used as lower border
 * @return				Correct value not lower than min
 */
stock float Math_FMin(float value, float min)
{
	if (value < min) {
		value = min;
	}

	return value;
}

/**
 * Sets the given value to max
 * if the value is greater than the given.
 * Don't use this with float values.
 *
 * @param value			Value
 * @param max			Max Value used as upper border
 * @return				Correct value not upper than max
 */
stock float Math_FMax(float value, float max)
{
	if (value > max) {
		value = max;
	}

	return value;
}

/**
 * Makes sure a value is within a certain range and
 * returns the value.
 * If the value is outside the range it is set to either
 * min or max, if it is inside the range it will just return
 * the specified value.
 * Don't use this with float values.
 *
 * @param value			Value
 * @param min			Min value used as lower border
 * @param max			Max value used as upper border
 * @return				Correct value not lower than min and not greater than max.
 */
stock float Math_FClamp(float value, float min, float max)
{
	value = Math_FMin(value, min);
	value = Math_FMax(value, max);

	return value;
}


















