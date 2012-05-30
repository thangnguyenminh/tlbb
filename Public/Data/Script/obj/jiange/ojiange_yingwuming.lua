-- 007112
-- 赢无名 兑换

--脚本号
x007112_g_scriptId = 007112

--所拥有的事件ID列表
x007112_g_eventList={212221}



--**********************************
--事件列表
--**********************************
function x007112_UpdateEventList( sceneId, selfId,targetId )
	BeginEvent(sceneId)
		msg = "#{DG_8724_2}"
		AddText(sceneId,msg);
		for i, eventId in x007112_g_eventList do
			CallScriptFunction( eventId, "OnEnumerate",sceneId, selfId, targetId )
		end
	EndEvent(sceneId)
	DispatchEventList(sceneId,selfId,targetId)
end

--**********************************
--事件交互入口
--**********************************
function x007112_OnDefaultEvent( sceneId, selfId,targetId )
	x007112_UpdateEventList( sceneId, selfId, targetId )
end

--**********************************
--事件列表选中一项
--**********************************
function x007112_OnEventRequest( sceneId, selfId, targetId, eventId )
	for i, findId in x007112_g_eventList do
		if eventId == findId then
			CallScriptFunction( eventId, "OnDefaultEvent",sceneId, selfId, targetId )
			return
		end
	end
end

--**********************************
--接受此NPC的任务
--**********************************
function x007112_OnMissionAccept( sceneId, selfId, targetId, missionScriptId )

	for i, findId in x007112_g_eventList do
		if missionScriptId == findId then
			ret = CallScriptFunction( missionScriptId, "CheckAccept", sceneId, selfId )
			if ret > 0 then
				CallScriptFunction( missionScriptId, "OnAccept", sceneId, selfId )
			end
			return
		end
	end

end

--**********************************
--拒绝此NPC的任务
--**********************************
function x007112_OnMissionRefuse( sceneId, selfId, targetId, missionScriptId )

	--拒绝之后，要返回NPC的事件列表
	for i, findId in x007112_g_eventList do
		if missionScriptId == findId then
			x007112_UpdateEventList( sceneId, selfId, targetId )
			return
		end
	end

end

--**********************************
--继续（已经接了任务）
--**********************************
function x007112_OnMissionContinue( sceneId, selfId, targetId, missionScriptId )
	for i, findId in x007112_g_eventList do
		if missionScriptId == findId then
			CallScriptFunction( missionScriptId, "OnContinue", sceneId, selfId, targetId )
			return
		end
	end
end

--**********************************
--提交已做完的任务
--**********************************
function x007112_OnMissionSubmit( sceneId, selfId, targetId, missionScriptId, selectRadioId )

	for i, findId in x007112_g_eventList do
		if missionScriptId == findId then
			CallScriptFunction( missionScriptId, "OnSubmit", sceneId, selfId, targetId, selectRadioId )
			return
		end
	end
end

--**********************************
--死亡事件
--**********************************
function x007112_OnDie( sceneId, selfId, killerId )
end

