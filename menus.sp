#define CHOICE1 "#choice1"
#define CHOICE2 "#choice2"
#define CHOICE3 "#choice3"
#define CHOICE4 "#choice4"
public void OnPluginStart()
{
  RegConsoleCmd("_a", Menu_Test1);
}
 
public int MenuHandler1(Menu menu, MenuAction action, int param1, int param2)
{
  switch(action)
  { 
    case MenuAction_Display:
    {
      char buffer[255];
      Format(buffer, sizeof(buffer), "Vote Nextmap", param1);
 
      Panel panel = view_as<Panel>(param2);
      panel.SetTitle(buffer);
      PrintToServer("Client %d was sent menu with panel %x", param1, param2);
    }
////////////////////////////////////////////////////////////////////////////////////////////////////////////// 
    case MenuAction_Select:
    {
      char info[32];
      menu.GetItem(param2, info, sizeof(info));
      if (StrEqual(info, CHOICE1))
      {
        ChangeClientTeam(param1, 0);
      }
      if (StrEqual(info, CHOICE2))
      {
        ChangeClientTeam(param1, 1);
      }
	  if (StrEqual(info, CHOICE3))
      {
        ChangeClientTeam(param1, 2);
      }
	  if (StrEqual(info, CHOICE4))
      {
        ChangeClientTeam(param1, 3);
      }

    }
//////////////////////////////////////////////////////////////////////////////////////////////////////////////   
    case MenuAction_End:
    {
      delete menu;
    }
 
    case MenuAction_DrawItem:
    {
      int style;
      char info[32];
      menu.GetItem(param2, info, sizeof(info), style);
      return style;
    }
 
    case MenuAction_DisplayItem:
    {
      char info[32];
      menu.GetItem(param2, info, sizeof(info));
    }
  }
 
  return 0;
}
 
public Action Menu_Test1(int client, int args)
{
  Menu menu = new Menu(MenuHandler1, MENU_ACTIONS_ALL);
  menu.SetTitle("Menu Title");
  menu.AddItem(CHOICE1, "Unassigned");
  menu.AddItem(CHOICE2, "Spectator");
  menu.AddItem(CHOICE3, "Red");
  menu.AddItem(CHOICE4, "Blue");
  menu.ExitButton = false;	
  menu.Display(client, 2147483647);
 
  return Plugin_Handled;
}