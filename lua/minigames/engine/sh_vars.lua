if SERVER then
	CreateConVar("ttt2_minigames", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE})
	CreateConVar("ttt2_minigames_autostart_random", "100", {FCVAR_NOTIFY, FCVAR_ARCHIVE})
	CreateConVar("ttt2_minigames_autostart_rounds", "0", {FCVAR_NOTIFY, FCVAR_ARCHIVE})
else -- CLIENT
	CreateConVar("ttt2_minigames_show_popup", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE})
end

MINIGAMES_BITS = 10
