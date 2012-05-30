-- 静候佳音 苏星河 －－>副本中的 苏星河
-- 200041

--************************************************************************
--MisDescBegin
--脚本号
x200041_g_ScriptId = 200041

--任务号
x200041_g_MissionId = 34

--前续任务号
x200041_g_PreMissionId = 33

--接受任务NPC属性
x200041_g_Position_X=152
x200041_g_Position_Z=153
x200041_g_SceneID=14
x200041_g_AccomplishNPC_Name="范百龄"

--目标NPC
x200041_g_Name = "苏星河"

--是否是精英任务
x200041_g_IfMissionElite = 1

--任务等级
x200041_g_MissionLevel = 60

--任务归类
x200041_g_MissionKind = 53

--任务文本描述
x200041_g_MissionName="静候佳音"
x200041_g_MissionInfo="#{Mis_juqing_0034}"
x200041_g_MissionTarget="#{Mis_juqing_Tar_0034}"
x200041_g_MissionComplete="  在下恭候多时了，大侠请入局一坐。"

x200041_g_MoneyBonus=7200
x200041_g_exp=17000

x200041_g_RadioItemBonus={{id=10415008 ,num=1},{id=10415009,num=1},{id=10415010,num=1},{id=10415011,num=1}}

x200041_g_Custom	= { {id="已找到苏星河",num=1} }

--MisDescEnd
--************************************************************************

--**********************************
--任务入口函数
--**********************************
function x200041_OnDefaultEvent( sceneId, selfId, targetId )
	--如果玩家完成过这个任务
	if (IsMissionHaveDone(sceneId,selfId,x200041_g_MissionId) > 0 ) then
		return
	elseif( IsHaveMission(sceneId,selfId,x200041_g_MissionId) > 0)  then
		-- 检测是不是在副本，再检测是不是，如果是就可以直完成任务，^_^
		local sceneType = LuaFnGetSceneType(sceneId) 
		if sceneType == 1 then --场景类型是副本
			-- 检测下名字，安全点点
			if GetName(sceneId, targetId) == x200041_g_Name  then
		    BeginEvent(sceneId)
				AddText(sceneId,x200041_g_MissionName)
				AddText(sceneId,x200041_g_MissionComplete)
				AddMoneyBonus( sceneId, x200041_g_MoneyBonus )
				for i, item in x200041_g_RadioItemBonus do
					AddRadioItemBonus( sceneId, item.id, item.num )
				end
		    EndEvent( )
		    DispatchMissionContinueInfo(sceneId,selfId,targetId,x200041_g_ScriptId,x200041_g_MissionId)
			end
		end
	
	--满足任务接收条件
	elseif x200041_CheckAccept(sceneId,selfId) > 0 then
		--发送任务接受时显示的信息
		BeginEvent(sceneId)
			AddText(sceneId,x200041_g_MissionName)
			AddText(sceneId,x200041_g_MissionInfo)
			AddText(sceneId,"#{M_MUBIAO}#r")
			AddText(sceneId,x200041_g_MissionTarget)
			AddText(sceneId,"#{M_SHOUHUO}#r")
			AddMoneyBonus( sceneId, x200041_g_MoneyBonus )
			for i, item in x200041_g_RadioItemBonus do
				AddRadioItemBonus( sceneId, item.id, item.num )
			end
		EndEvent( )
		DispatchMissionInfo(sceneId,selfId,targetId,x200041_g_ScriptId,x200041_g_MissionId)
	end
end

--**********************************
--列举事件
--**********************************
function x200041_OnEnumerate( sceneId, selfId, targetId )
	
	--如果玩家完成过这个任务
	if IsMissionHaveDone(sceneId,selfId,x200041_g_MissionId) > 0 then
		return 
	--如果已接此任务
	elseif IsHaveMission(sceneId,selfId,x200041_g_MissionId) > 0 then
		--需要在副本才可以
		local sceneType = LuaFnGetSceneType(sceneId)
		if sceneType == 1 then --场景类型是副本
			AddNumText(sceneId, x200041_g_ScriptId,x200041_g_MissionName,2,-1);
		end
		
	--满足任务接收条件
	elseif x200041_CheckAccept(sceneId,selfId) > 0 then	
		AddNumText(sceneId,x200041_g_ScriptId,x200041_g_MissionName,1,-1);
	end

end

--**********************************
--检测接受条件
--**********************************
function x200041_CheckAccept( sceneId, selfId )
	--判定条件
	--1，前续任务完成
	if IsMissionHaveDone(sceneId,selfId,x200041_g_PreMissionId) < 1 then
		return 0
	end
	if IsMissionHaveDone(sceneId,selfId,x200041_g_MissionId) > 0  then
		return 0
	end
	
	--2，等级达到60
	if GetLevel(sceneId, selfId) < 60   then
		return 0
	end

	--3，场景不是副本
	local sceneType = LuaFnGetSceneType(sceneId) ;
	if sceneType == 1 then --场景类型是副本
		return 0
	end
	
	return 1
end


--**********************************
--接受
--**********************************
function x200041_OnAccept( sceneId, selfId, targetId )

	if x200041_CheckAccept(sceneId, selfId) < 1   then
		return 0
	end
	
	--加入任务到玩家列表
	local ret = AddMission( sceneId,selfId, x200041_g_MissionId, x200041_g_ScriptId, 0, 0, 0 )
	if ret <= 0 then
		Msg2Player(  sceneId, selfId,"#Y你的任务日志已经满了" , MSG2PLAYER_PARA )
		return
	end

	Msg2Player(  sceneId, selfId,"#Y接受任务：静候佳音",MSG2PLAYER_PARA )

	local misIndex = GetMissionIndexByID(sceneId,selfId,x200041_g_MissionId)
	SetMissionByIndex( sceneId, selfId, misIndex, 0, 1)
end

--**********************************
--放弃
--**********************************
function x200041_OnAbandon( sceneId, selfId )
  DelMission( sceneId, selfId, x200041_g_MissionId )
end

--**********************************
--继续
--**********************************
function x200041_OnContinue( sceneId, selfId, targetId )
	
end	

--**********************************
--检测是否可以提交
--**********************************
function x200041_CheckSubmit( sceneId, selfId, selectRadioId )
	
end

--**********************************
--提交
--**********************************
function x200041_OnSubmit( sceneId, selfId, targetId, selectRadioId )
	-- 可以提交的条件判定
	-- 1，有这个任务，
	if( IsHaveMission(sceneId,selfId,x200041_g_MissionId) > 0)  then
  	BeginAddItem(sceneId)
		for i, item in x200041_g_RadioItemBonus do
			if item.id == selectRadioId then
				AddItem( sceneId,item.id, item.num )
			end
		end
		ret = EndAddItem(sceneId,selfId)
		--添加任务奖励
		if ret < 1 then
			--任务奖励没有加成功
			BeginEvent(sceneId)
				strText = "背包已满,无法完成任务"
				AddText(sceneId,strText);
			EndEvent(sceneId)
			DispatchMissionTips(sceneId,selfId)
			return
		end
		AddItemListToHuman(sceneId,selfId)

		AddMoney(sceneId,selfId,x200041_g_MoneyBonus );
		LuaFnAddExp( sceneId, selfId,x200041_g_exp)
		
		DelMission( sceneId,selfId,  x200041_g_MissionId )
		--设置任务已经被完成过
		MissionCom( sceneId,selfId,  x200041_g_MissionId )
		Msg2Player(  sceneId, selfId,"#Y完成任务：静候佳音",MSG2PLAYER_PARA )
		
		LuaFnSetCopySceneData_Param(sceneId, 8, 1)
		LuaFnSetCopySceneData_Param(sceneId, 10, 0)
		LuaFnSetCopySceneData_Param(sceneId, 20, selfId)
		
		-- 调用后续任务
		CallScriptFunction((200042), "OnDefaultEvent",sceneId, selfId, targetId )
	end
end

--**********************************
--杀死怪物或玩家
--**********************************
function x200041_OnKillObject( sceneId, selfId, objdataId, objId )

end

--**********************************
--进入区域事件
--**********************************
function x200041_OnEnterZone( sceneId, selfId, zoneId )
	
end

--**********************************
--道具改变
--**********************************
function x200041_OnItemChanged( sceneId, selfId, itemdataId )
	
end



