--撒马尔罕NPC
--老娘
--如意小子策划

--脚本号
x002945_g_ScriptId = 000102

--所拥有的事件ID列表
x002945_g_eventList={250507}
--**********************************
--事件列表
--**********************************
function x002945_UpdateEventList( sceneId, selfId,targetId )
    local  PlayerName=GetName(sceneId,selfId)	
	local  PlayerSex=GetSex(sceneId,selfId)
	if PlayerSex == 0 then
		PlayerSex = "姑娘"
	else
		PlayerSex = "少侠"
	end
	BeginEvent(sceneId)
		AddText(sceneId,"  #72这不是"..PlayerName..PlayerSex.."吗，累死老娘了！听说那孩子在圣火宫刷经验，老娘千里迢迢从苏州赶来，你要见着他的话，麻烦你转告他：你妈叫你回家吃饭！")
		for i, eventId in x002945_g_eventList do
			CallScriptFunction( eventId, "OnEnumerate",sceneId, selfId, targetId )
		end
	EndEvent(sceneId)
	DispatchEventList(sceneId,selfId,targetId)
end

--**********************************
--事件交互入口
--**********************************
function x002945_OnDefaultEvent( sceneId, selfId,targetId )
	x002945_UpdateEventList( sceneId, selfId, targetId )
end

--**********************************
--事件列表选中一项
--**********************************
function x002945_OnEventRequest( sceneId, selfId, targetId, eventId )
	for i, findId in x002945_g_eventList do
		if eventId == findId then
			CallScriptFunction( eventId, "OnDefaultEvent",sceneId, selfId, targetId )
			return
		end
	end
end

--**********************************
--接受此NPC的任务
--**********************************
function x002945_OnMissionAccept( sceneId, selfId, targetId, missionScriptId )
	for i, findId in x002945_g_eventList do
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
function x002945_OnMissionRefuse( sceneId, selfId, targetId, missionScriptId )
	--拒绝之后，要返回NPC的事件列表
	for i, findId in x002945_g_eventList do
		if missionScriptId == findId then
			x002945_UpdateEventList( sceneId, selfId, targetId )
			return
		end
	end
end

--**********************************
--继续（已经接了任务）
--**********************************
function x002945_OnMissionContinue( sceneId, selfId, targetId, missionScriptId )
	for i, findId in x002945_g_eventList do
		if missionScriptId == findId then
			CallScriptFunction( missionScriptId, "OnContinue", sceneId, selfId, targetId )
			return
		end
	end
end

--**********************************
--提交已做完的任务
--**********************************
function x002945_OnMissionSubmit( sceneId, selfId, targetId, missionScriptId, selectRadioId )
	for i, findId in x002945_g_eventList do
		if missionScriptId == findId then
			CallScriptFunction( missionScriptId, "OnSubmit", sceneId, selfId, targetId, selectRadioId )
			return
		end
	end
end

--**********************************
--死亡事件
--**********************************
function x002945_OnDie( sceneId, selfId, killerId )
end
