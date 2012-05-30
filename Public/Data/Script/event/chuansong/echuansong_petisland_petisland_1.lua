x400123_g_ScriptId = 400123

x400123_left 	=290.0000
x400123_right	=292.0000

x400123_top  	=56.0000
x400123_bottom	=61.0000


--玩家进入一个 area 时触发
function x400123_OnEnterArea( sceneId, selfId )

BeginUICommand(sceneId)
		UICommand_AddInt(sceneId, x400123_g_ScriptId);
		UICommand_AddString(sceneId, "GotoPetisland_1");
		UICommand_AddString(sceneId, "圣兽山为不加杀气场景，请注意安全。你确认要进入吗？");
	EndUICommand(sceneId)
	DispatchUICommand(sceneId,selfId, 24)

	--CallScriptFunction((400900), "TransferFunc",sceneId, selfId, 158,233,225,21)
end

--玩家在一个 area 呆了一段时间没走则定时触发
function x400123_OnTimer( sceneId, selfId )
	-- 毫秒，看在这个 area 停留多久了
	StandingTime = QueryAreaStandingTime( sceneId, selfId )
	-- 5秒后仍未传送
	if StandingTime >= 5000 then
		x400123_OnEnterArea( sceneId, selfId )
		ResetAreaStandingTime( sceneId, selfId, 0 )
	end
end

--玩家离开一个 area 时触发
function x400123_OnLeaveArea( sceneId, selfId )
end

--**********************************
--任务入口函数
--**********************************
function x400123_GotoPetisland_1( sceneId, selfId, targetId )	--点击该任务后执行此脚本
	
	-- 检查玩家是不是还在这个范围内
	if sceneId ~= 39   then
		--你已经不在可传送区域。
		BeginEvent(sceneId)
			AddText(sceneId,"你已经不在可传送区域。")
		EndEvent(sceneId)
		DispatchMissionTips(sceneId,selfId)
		return
	end
	
	local targetX, targetZ = GetWorldPos(sceneId, selfId)
	
	if 	targetX < x400123_left or
			targetX > x400123_right or
			targetZ < x400123_top  or
			targetZ > x400123_bottom   then
		
		BeginEvent(sceneId)
			AddText(sceneId,"你已经不在可传送区域。")
		EndEvent(sceneId)
		DispatchMissionTips(sceneId,selfId)
		return
			
	end
	
	CallScriptFunction((400900), "TransferFunc",sceneId, selfId, 158,233,225,21)
		
end
