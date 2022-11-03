    #include <YSI-Includes\YSI\y_hooks>

new
    pInjuredTimer[MAX_PLAYERS] = {-1, ...},
    bool:pInjuredMoving[MAX_PLAYERS],
    pInjuredMovingStep[MAX_PLAYERS];

hook OnPlayerDisconnect(playerid, reason) {
        ApplyAnimation(playerid, "SWAT", "gnstwall_injurd", 4.1, true, 0, 0, 1, 0, 1);
        if(pInjuredTimer[playerid] != -1) {
        KillTimer(pInjuredTimer[playerid]);
        pInjuredTimer[playerid] = -1;
 
    }
}

hook OnPlayerSpawn(playerid) {
       if(PI[playerid][pi_STATE] == ROLEPLAY_STATE_CRACK) {
       SetPlayerHud(playerid);
       if(PLAYER_TEMP[playerid][pt_GAME_STATE] == GAME_STATE_DEAD) SetPlayerHealthEx(playerid, 60.0);
       SendAlertToMedics(playerid);
       SetCameraBehindPlayer(playerid);
       TogglePlayerControllableEx(playerid, false);
       KillTimer(PLAYER_TEMP[playerid][pt_TIMERS][3]);
       PLAYER_TEMP[playerid][pt_TIMERS][3] = SetTimerEx("TogglePlayerControl", 2000, false, "ib", playerid, true);
       SendClientMessageEx(playerid, -1, "{8b00ff}�{FFFFFF}Los servicios {f11717}publicos {FFFFFF}fuero alertados, un {f11717}m�dico {FFFFFF}est� en camino.");
       SendClientMessageEx(playerid, -1, "{8b00ff}�{FFFFFF}Est�s {f11717}herido, {FFFFFF}puedes esperar 3 minutos y usar {8b00ff}/morir {FFFFFF}o esperar un {f11717}m�dico.");
       PLAYER_TEMP[playerid][pt_TIMERS][3] = SetTimerEx("TogglePlayerControl", 2000, false, "ib", playerid, true);
       ApplyAnimation(playerid, "SWEET", "Sweet_injuredloop", 4.1, true, 0, 0, 0, 0, 1);
       if(pInjuredTimer[playerid] != -1) {
       KillTimer(pInjuredTimer[playerid]);
       pInjuredTimer[playerid] = -1;
        }
      }
  }



hook OnPlayerEnterVehicle(playerid, vehicleid, ispassenger) {
    if(PI[playerid][pi_STATE] == ROLEPLAY_STATE_CRACK)
	{
		new Float:sx, Float:sy, Float:sz;
	    GetPlayerPos(playerid, sx, sy, sz);
        RemovePlayerFromVehicle(playerid);
		SetPlayerPos(playerid, sx, sy, sz);
        ApplyAnimation(playerid, "SWAT", "gnstwall_injurd", 4.1, true, 0, 0, 1, 0, 1);
		return Y_HOOKS_BREAK_RETURN_1;
	}
    return Y_HOOKS_CONTINUE_RETURN_1;
}

hook OnPlayerUpdate(playerid) {
    if(PI[playerid][pi_STATE] == ROLEPLAY_STATE_CRACK) {
        new Keys, ud, lr;
        GetPlayerKeys(playerid, Keys, ud, lr);
        if(ud == KEY_UP /*|| ud == KEY_DOWN || lr == KEY_LEFT || lr == KEY_RIGHT*/) {
            if(!pInjuredMoving[playerid]) {
                pInjuredMoving[playerid] = true;
                if(pInjuredMovingStep[playerid] == 0) HealthDown(playerid);
            }
        }
        else {
            if(pInjuredMoving[playerid]) {
                pInjuredMoving[playerid] = false;
                if(pInjuredMovingStep[playerid] == 1) HealthDown(playerid);
            }
        }
        
        new anim = GetPlayerAnimationIndex(playerid);
        if(anim != 1017 && anim != 1537) HealthDown(playerid);
    }
    return Y_HOOKS_CONTINUE_RETURN_1;
}

forward HealthDown(playerid);
public HealthDown(playerid)
{
    if(pInjuredTimer[playerid] != -1) {
        KillTimer(pInjuredTimer[playerid]);
        pInjuredTimer[playerid] = -1;
    }
    
    if(PI[playerid][pi_STATE] == ROLEPLAY_STATE_CRACK) {
        new Float:rx, Float:rz;
        GetPlayerCameraRotation(playerid, rx, rz);

        GivePlayerHealthEx(playerid, -0.1);
        if(pInjuredMoving[playerid]) {
            switch(pInjuredMovingStep[playerid]) {
                case 0: {
                    ApplyAnimation(playerid, "PED", "CAR_crawloutRHS", 4.1, true, 1, 1, 0, 0, 1);
                    SetPlayerFacingAngle(playerid, rz + 90.0);
                    pInjuredMovingStep[playerid] = 1;
                    pInjuredTimer[playerid] = SetTimerEx("HealthDown", 1000, false, "i", playerid);
                    
                }
                case 1: {
                    ApplyAnimation(playerid, "SWEET", "Sweet_injuredloop", 4.1, true, 0, 0, 0, 0, 1);
                    SetPlayerFacingAngle(playerid, rz);
                    pInjuredMovingStep[playerid] = 0;
                    pInjuredTimer[playerid] = SetTimerEx("HealthDown", 2000, false, "i", playerid);
                }
            }
        }
        else {
            ApplyAnimation(playerid, "SWEET", "Sweet_injuredloop", 4.1, true, 0, 0, 0, 0, 1);
            SetPlayerFacingAngle(playerid, rz);
            pInjuredMovingStep[playerid] = 0;
            pInjuredTimer[playerid] = SetTimerEx("HealthDown", 3000, false, "i", playerid);
        }
    }
    return 1;
}
