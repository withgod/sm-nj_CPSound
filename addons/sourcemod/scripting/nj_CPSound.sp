/**
* vim: set ts=4 
* Author: withgod <noname@withgod.jp>
* GPL 2.0
*
**/

#pragma semicolon 1

#include <sourcemod>
#include <sdktools>

#define PLUGIN_VERSION "0.0.2"
#define CAPTURE_SOUND_DEAULT "ambient/cow1.wav"

new Handle:g_njCPSoundEnable = INVALID_HANDLE;
new Handle:g_njCPSoundFile   = INVALID_HANDLE;
new String:soundFile[PLATFORM_MAX_PATH];
new maxclients;

public Plugin:myinfo = 
{
	name = "nj_CPSound",
	author = "withgod",
	description = "CP Sound plugin",
	version = PLUGIN_VERSION,
	url = "http://github.com/withgod/sm-nj_CPSound"
};

public OnPluginStart()
{
	LoadTranslations("nj_CPSound.phrases");
	CreateConVar("nj_cpsound_version", PLUGIN_VERSION, "nj capture sound", FCVAR_PLUGIN|FCVAR_SPONLY|FCVAR_REPLICATED|FCVAR_NOTIFY);
	g_njCPSoundEnable = CreateConVar("nj_cpsound", "1", "cp sound Enable/Disable (0 = disabled | 1 = enabled)", 0, true, 0.0, true, 1.0);
	g_njCPSoundFile   = CreateConVar("nj_cpsound_file", CAPTURE_SOUND_DEAULT, "capture sound(default ambient/cow1.wav)", 0);

	HookConVarChange(g_njCPSoundFile, HandleSoundFile);
	GetConVarSoundFile();

	HookEvent("controlpoint_starttouch", OnCaptureEvent);
}

public HandleSoundFile(Handle:cvar, const String:oldVal[], const String:newVal[])
{
	GetConVarSoundFile();
}

public GetConVarSoundFile()
{
	GetConVarString(g_njCPSoundFile, soundFile, sizeof(soundFile));
	if (!StrEqual(CAPTURE_SOUND_DEAULT, soundFile))
	{
		decl String:tmpPath[PLATFORM_MAX_PATH];
		Format(tmpPath, sizeof(tmpPath), "sound/%s", soundFile);
		AddFileToDownloadsTable(tmpPath);
	}
	PrecacheSound(soundFile);
}

public OnMapStart()
{
	maxclients = GetMaxClients();
	GetConVarSoundFile();
}

public OnCaptureEvent(Handle:event, const String:name[], bool:dontBroadcast)
{
	if (GetConVarBool(g_njCPSoundEnable))
	{
		new client  = GetEventInt(event, "player");

		decl String:playerName[64];
		GetClientName(client, playerName, 64);

		EmitSoundToAll(soundFile);

		for (new i = 1; i < maxclients; i++)
		{
			if (IsClientConnected(i) && IsClientInGame(i))
			{
				//PrintToServer("client[%i] is lang[%d]. server lang[%d]", i, lang, LANG_SERVER);
				PrintToChat(i, "%t", "nj_CPSound_Capture_Message", playerName);
			}
		}
		//PrintToServer("[nj] client [%s] captured area. sound [%s] played", playerName, soundFile);
	}
}
