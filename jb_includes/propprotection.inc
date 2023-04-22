/** Double-include prevention */
#if defined _mynatives_included_
  #endinput
#endif
#define _mynatives_included_
 
// set owner
native void pp_setOwner(int ent, int client);