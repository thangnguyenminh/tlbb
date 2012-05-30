--创建人[ QUFEI 2008-04-18 10:27 UPDATE BugID 34369 ]
--新圣火传递活动之燃烧的圣火事件脚本
--本活动每天开启三次,每个玩家每天只能参加一次

--MisDescBegin
--脚本号
x808095_g_ScriptId	= 808095

--接受任务NPC属性
x808095_g_Position_X=164.5310
x808095_g_Position_Z=262.5004
x808095_g_SceneID=30
x808095_g_AccomplishNPC_Name="苏飞"

--任务号
x808095_g_MissionId			= 1001
--下一个任务的ID
x808095_g_MissionIdNext	= 1002
--任务目标所在场景
x808095_g_AcceptNPC_SceneID	=	1
--任务目标npc
x808095_g_Name 					= "圣火坛"
--任务归类
x808095_g_MissionKind			= 13
--任务等级
x808095_g_MissionLevel		= 10
--是否是精英任务
x808095_g_IfMissionElite	= 0
--任务是否已经完成
x808095_g_IsMissionOkFail	= 0		--任务参数的第0位

--任务文本描述
x808095_g_MissionName			= "燃烧的圣火"
--任务描述
x808095_g_MissionInfo			= "#{XSHCD_20080418_008}"
--任务目标
x808095_g_MissionTarget		= "#{XSHCD_20080418_042}"
--未完成任务的npc对话
x808095_g_ContinueInfo		= "#{XSHCD_20080418_009}"
--完成任务npc说的话
x808095_g_MissionComplete	= "#{XSHCD_20080418_010}"
--每次活动可以完成的次数
x808095_g_MaxRound	= 3
--控制脚本
x808095_g_ControlScript		= 001066

-- 任务完成情况,内容动态刷新,占用任务参数的第1位
x808095_g_Custom	= { {id="已将火炬交给西湖的苏飞",num=1} }
--MisDescEnd

--任务是否完成
x808095_g_Mission_IsComplete = 0		--任务参数的第0位
--圣火交给苏飞的标记
x808095_g_RecordIdx 				 = 1		--任务参数的第1位
--任务脚本号记录
x808095_g_MissScriptID_Idx	 = 2		--任务参数的第2位
--任务发布NPC标记
x808095_g_AcceptNPC_Idx			 = 3		--任务参数的第3位 2.苏州NPC


x808095_g_AcceptMission_IDX		= 565	--燃烧的圣火接收任务索引
x808095_g_CompleteMission_IDX	= 566	--燃烧的圣火提交任务索引
x808095_g_MissionInfo_IDX			= 567	--任务说明索引
x808095_g_AfreshMission_IDX		= 568	--重新开始圣火传递索引

--所拥有的事件ID列表
x808095_g_EventList	= {}

x808095_g_Impact_Accept_Mission 	 = 47		-- 接受任务时的特效ID
x808095_g_Impact_Transport_Mission = 113 	-- 运输状态特效
x808095_g_Impact_GodOfFireMan_Mission  = 5942 -- 圣火传递男变身特效
x808095_g_Impact_GodOfFireGirl_Mission = 5943 -- 圣火传递女变身特效
x808095_g_Impact_DelGodOfFire_Mission  = 5944 -- 删除圣火特效的特效
x808095_g_PlayerSlow_LVL					 = 10		-- 接受任务的最低等级

x808095_g_Mission_StepNum					 = 0		-- 本任务在任务链的第几步

x808095_g_ItemId = { id=40004447,num=1 }	-- 任务物品

-- 圣火活动时间
x808095_g_Activity_Day						 = { dstart=504,  dend=510 }
x808095_g_Activity_Time						 = { tstart=1945, tend=2245 }

-- 5月10号后的活动开启时间,每周五
x808095_g_Activity_DayTime				 = 5

-- 奖励经验和金钱(与等级有关)
x808095_g_MoneyBonus_Param1				 = 30 
x808095_g_MoneyBonus_Param2				 = 320
x808095_g_ExpBonus_Param1				 	 = 160
x808095_g_ExpBonus_Param2				 	 = 500

-- 圣火任务列表
x808095_g_GodFire_MissionList			 = { 1001, 1002, 1003, 1004, 1005, 1006, 1007, 1008, 1009, 1010, 1011 }

--**********************************
--任务入口函数
--**********************************
--点击该任务后执行此脚本
function x808095_OnDefaultEvent( sceneId, selfId, targetId )

	local	key	= GetNumText()	
	if key == x808095_g_AcceptMission_IDX then
		--判断该npc是否是对应任务的npc
		if LuaFnGetName( sceneId, targetId ) ~= x808095_g_Name then
			x808095_NotifyTip( sceneId, selfId, "接受任务失败" )					
			return 0
		end
		-- 任务是否已满
		if IsMissionFull( sceneId, selfId ) == 1 then
			x808095_NotifyTip( sceneId, selfId, "#{QIANXUN_INFO_23}" )
			return 0
		end
		
		-- 检测任务接受条件
		if x808095_CheckAccept( sceneId, selfId, targetId )<=0 then
			return 0
		end

		-- 进入接受任务界面			
		x808095_AcceptMission( sceneId, selfId, targetId )				
	
	elseif key == x808095_g_CompleteMission_IDX then
		--判断该npc是否是对应任务的npc
		if LuaFnGetName( sceneId, targetId ) ~= x808095_g_AccomplishNPC_Name then
			x808095_NotifyTip( sceneId, selfId, "提交任务失败" )					
			return 0
		end
		-- 如果已经接了任务燃烧的圣火
		if IsHaveMission( sceneId, selfId, x808095_g_MissionId) > 0 then
												
			--发送任务需求的信息
			BeginEvent(sceneId)
				AddText(sceneId, x808095_g_MissionName)
				AddText(sceneId, x808095_g_ContinueInfo)			
			EndEvent( )
			
			local bDone = x808095_CheckSubmit( sceneId, selfId, targetId )				
			DispatchMissionDemandInfo(sceneId, selfId, targetId, x808095_g_ScriptId, x808095_g_MissionId, bDone)
			
		else			
			x808095_TalkInfo( sceneId, selfId, targetId, "#{XSHCD_20080418_072}" )
			return 0
		end
	elseif key == x808095_g_MissionInfo_IDX then
		--判断该npc是否是对应任务的npc
		if LuaFnGetName( sceneId, targetId ) ~= x808095_g_Name then
			x808095_NotifyTip( sceneId, selfId, "接受任务失败" )					
			return 0
		end
		x808095_TalkInfo( sceneId, selfId, targetId, "#{XSHCD_20080418_007}" )		
		return 0

	elseif key == x808095_g_AfreshMission_IDX then
	
		for i, MissionId in x808095_g_GodFire_MissionList do
			if IsHaveMission( sceneId, selfId, MissionId) > 0 then
				x808095_TalkInfo( sceneId, selfId, targetId, "#{XSHCD_20080418_070}" )
				return 0
			end
		end
	
		SetMissionData( sceneId, selfId, MD_GODOFFIRE_COMPLETE_STEPNUM, 0 )
		x808095_TalkInfo( sceneId, selfId, targetId, "#{XSHCD_20080418_068}" )
		return 0
	else
		x808095_NotifyTip( sceneId, selfId, "接受任务失败" )					
		return 0
	end

end

--**********************************
--列举事件
--**********************************
function x808095_OnEnumerate( sceneId, selfId, targetId )
	
	--检测活动是否过期
	if x808095_CheckHuoDongTime() <= 0 then
		return 0
	end

	if LuaFnGetName( sceneId, targetId ) == x808095_g_Name
		 and sceneId == x808095_g_AcceptNPC_SceneID then
		AddNumText( sceneId, x808095_g_ScriptId, "我要重新开始圣火传递", 7, x808095_g_AfreshMission_IDX )
		
		if IsHaveMission( sceneId, selfId, x808095_g_MissionId ) <= 0 then
			local	nStepNum = GetMissionData( sceneId, selfId, MD_GODOFFIRE_COMPLETE_STEPNUM )
			if nStepNum == x808095_g_Mission_StepNum then
				AddNumText( sceneId, x808095_g_ScriptId, "我要参加：燃烧的圣火", 7, x808095_g_AcceptMission_IDX )
			end
		end
		AddNumText( sceneId, x808095_g_ScriptId, "圣火传统活动帮助", 11, x808095_g_MissionInfo_IDX )
	elseif LuaFnGetName( sceneId, targetId ) == x808095_g_AccomplishNPC_Name
				 and sceneId == x808095_g_SceneID then
	
		if IsHaveMission( sceneId, selfId, x808095_g_MissionId ) > 0 then
			local misIndex = GetMissionIndexByID(sceneId,selfId,x808095_g_MissionId)

			-- 检测任务是否完成	
			if GetMissionParam(sceneId, selfId, misIndex, x808095_g_Mission_IsComplete) <= 0 then
				SetMissionByIndex( sceneId, selfId, misIndex, x808095_g_Mission_IsComplete, 1 )
				SetMissionByIndex( sceneId, selfId, misIndex, x808095_g_RecordIdx, 1 )
				x808095_NotifyTip( sceneId, selfId, "#{XSHCD_20080418_100}" )
				x808095_TalkInfo( sceneId, selfId, targetId, "#{XSHCD_20080418_098}" )
				return 0
			else
				AddNumText( sceneId, x808095_g_ScriptId, "我已经完成：燃烧的圣火", 7, x808095_g_CompleteMission_IDX )
			end
		end
	else
		return 0
	end

end

--**********************************
--检测接受条件，也供子任务调用
--**********************************
function x808095_CheckAccept( sceneId, selfId, targetId )
	
	--检测玩家是否符合接受任务的条件
	--判断该npc是否是对应任务的npc
	if LuaFnGetName( sceneId, targetId ) ~= x808095_g_Name then
		x808095_NotifyTip( sceneId, selfId, "接受任务失败" )					
		return 0
	end
	
	--检测活动是否过期
	if x808095_CheckHuoDongTime() <= 0 then
		x808095_TalkInfo( sceneId, selfId, targetId, "#{XSHCD_20080418_069}" )
		return 0
	end
	
	--检测等级
	if LuaFnGetLevel( sceneId, selfId ) < x808095_g_PlayerSlow_LVL then		
		x808095_TalkInfo( sceneId, selfId, targetId, "#{XSHCD_20080418_064}" )
		return 0
	end

	--检测运输状态驻留效果
	if LuaFnHaveImpactOfSpecificDataIndex(sceneId, selfId, x808095_g_Impact_Transport_Mission) ~= 0
		 or LuaFnHaveImpactOfSpecificDataIndex(sceneId, selfId, x808095_g_Impact_DelGodOfFire_Mission) ~= 0 then
		x808095_TalkInfo( sceneId, selfId, targetId, "#{GodFire_Info_014}" )
		return 0
	end

	--已经接过则不符合条件
	if IsHaveMission( sceneId, selfId, x808095_g_MissionId ) > 0 then
		x808095_TalkInfo( sceneId, selfId, targetId, "#{XSHCD_20080418_067}" )
		return 0
	end

	--检测玩家参加本次活动任务链第几步
	local	nStepNum = GetMissionData( sceneId, selfId, MD_GODOFFIRE_COMPLETE_STEPNUM )
	if nStepNum ~= x808095_g_Mission_StepNum then
		x808095_TalkInfo( sceneId, selfId, targetId, "#{XSHCD_20080418_066}" )
		return 0
	end

	--过一天活动次数就清除
	local nThisTime = GetDayTime()
	local	nDayTime = GetMissionData( sceneId, selfId, MD_GODOFFIRE_COMPLETE_DAYTIME )
	if nDayTime ~= nThisTime then
		SetMissionData( sceneId, selfId, MD_GODOFFIRE_COMPLETE_COUNT, 0 )
	end
	
	--检测玩家今天参加活动的次数
	local	nComCount = GetMissionData( sceneId, selfId, MD_GODOFFIRE_COMPLETE_COUNT )
	if nComCount >= x808095_g_MaxRound then
		x808095_TalkInfo( sceneId, selfId, targetId, "#{XSHCD_20080418_065}" )
		return 0
	end

	--检测是否处于双人骑乘状态
	if LuaFnGetDRideFlag(sceneId, selfId) ~= 0  then
		x808095_TalkInfo( sceneId, selfId, targetId, "#{ResultText_117}" )
		return 0
	end
	
	return 1
end

--**********************************
--接受，仅供子任务调用设置公共参数
--**********************************
function x808095_OnAccept( sceneId, selfId, targetId, scriptId )
	
	--判断该npc是否是对应任务的npc
 	if LuaFnGetName( sceneId, targetId ) ~= x808095_g_Name then
 		x808095_NotifyTip( sceneId, selfId, "接受任务失败" )					
		return 0
	end

	if x808095_CheckAccept( sceneId, selfId, targetId )<=0 then
		return 0
	end

	if LuaFnGetTaskItemBagSpace( sceneId, selfId ) < x808095_g_ItemId.num then
		x808095_NotifyTip( sceneId, selfId, "#{QX_20071129_027}" )		
		return 0
	end

	BeginAddItem(sceneId)
	AddItem(sceneId,x808095_g_ItemId.id, x808095_g_ItemId.num)
	local canAdd = EndAddItem(sceneId,selfId)						
	if canAdd > 0 then
		--加入任务到玩家列表
		local bAdd = AddMission( sceneId, selfId, x808095_g_MissionId, x808095_g_ScriptId, 0, 0, 0 )
		if bAdd >= 1 then				
			AddItemListToHuman(sceneId,selfId)
			
			--得到任务的序列号
			local	misIndex		= GetMissionIndexByID( sceneId, selfId, x808095_g_MissionId )
			
			--根据序列号把任务变量的第0位置0 (任务完成情况)
			SetMissionByIndex( sceneId, selfId, misIndex, x808095_g_Mission_IsComplete, 0 )
			SetMissionByIndex( sceneId, selfId, misIndex, x808095_g_RecordIdx, 0 )
			--根据序列号把任务变量的第2位置为任务脚本号
			SetMissionByIndex( sceneId, selfId, misIndex, x808095_g_MissScriptID_Idx, scriptId )		
			SetMissionByIndex(sceneId, selfId, misIndex, x808095_g_AcceptNPC_Idx, 2)

			local nDayTime = GetDayTime()
			SetMissionData( sceneId, selfId, MD_GODOFFIRE_COMPLETE_DAYTIME, nDayTime )

			LuaFnSendSpecificImpactToUnit( sceneId, selfId, selfId, selfId, x808095_g_Impact_Transport_Mission, 0 )
			
			-- 根据性别给变身Buffer
			if GetSex( sceneId, selfId ) == 1 then
				LuaFnSendSpecificImpactToUnit( sceneId, selfId, selfId, selfId, x808095_g_Impact_GodOfFireMan_Mission, 0 )
			else
				LuaFnSendSpecificImpactToUnit( sceneId, selfId, selfId, selfId, x808095_g_Impact_GodOfFireGirl_Mission, 0 )
			end
			
			LuaFnSendSpecificImpactToUnit( sceneId, selfId, selfId, selfId, x808095_g_Impact_DelGodOfFire_Mission, 0 )

			BeginEvent(sceneId)
				AddText(sceneId,x808095_g_MissionName)
				AddText(sceneId,x808095_g_MissionInfo)
				AddText(sceneId,"#{M_MUBIAO}#r")
				AddText(sceneId,"#{XSHCD_20080418_042}")				
				AddText(sceneId,"#{XSHCD_20080418_007}")				
			EndEvent( )					
			DispatchEventList(sceneId, selfId, targetId)
			
			-- LuaFnSendSpecificImpactToUnit( sceneId, selfId, selfId, selfId, x808095_g_Impact_Accept_Mission, 0 )
		end
	end

	return 1

end

--**********************************
--放弃，仅供子任务调用
--**********************************
function x808095_OnAbandon( sceneId, selfId )
  
  --删除玩家任务列表中对应的任务,物品和驻留效果
  if HaveItem(sceneId, selfId, x808095_g_ItemId.id) > 0 then
  	if LuaFnGetAvailableItemCount(sceneId, selfId, x808095_g_ItemId.id) >= x808095_g_ItemId.num then
  		DelItem( sceneId, selfId, x808095_g_ItemId.id, LuaFnGetAvailableItemCount(sceneId, selfId, x808095_g_ItemId.id) )
  	else
	  	x808095_NotifyTip( sceneId, selfId, "您的物品现在不可用或已被锁定。" )			
			return 0
  	end
  end

  if LuaFnHaveImpactOfSpecificDataIndex(sceneId, selfId, x808095_g_Impact_Transport_Mission) ~= 0 then
  	-- 如果玩家正在漕运或跑商就不清除运输Buff
  	if IsHaveMission( sceneId, selfId, 4021 ) <= 0
  		 and GetItemCount(sceneId, selfId, 40002000) <= 0 then  	
  		LuaFnCancelSpecificImpact( sceneId, selfId, x808095_g_Impact_Transport_Mission )
  	end
  end
  
  if LuaFnHaveImpactOfSpecificDataIndex(sceneId, selfId, x808095_g_Impact_GodOfFireMan_Mission) ~= 0 then
  	LuaFnCancelSpecificImpact( sceneId, selfId, x808095_g_Impact_GodOfFireMan_Mission )
  end
  
  if LuaFnHaveImpactOfSpecificDataIndex(sceneId, selfId, x808095_g_Impact_GodOfFireGirl_Mission) ~= 0 then
  	LuaFnCancelSpecificImpact( sceneId, selfId, x808095_g_Impact_GodOfFireGirl_Mission )
  end
  
  if LuaFnHaveImpactOfSpecificDataIndex(sceneId, selfId, x808095_g_Impact_DelGodOfFire_Mission) ~= 0 then
  	LuaFnCancelSpecificImpact( sceneId, selfId, x808095_g_Impact_DelGodOfFire_Mission )
  end
  
  if IsHaveMission( sceneId, selfId, x808095_g_MissionId ) > 0 then
	 	DelMission( sceneId, selfId, x808095_g_MissionId )
	end
	
	return 0

end

--**********************************
--继续
--**********************************
function x808095_OnContinue( sceneId, selfId, targetId )
	
	--判断该npc是否是对应任务的npc
	if LuaFnGetName( sceneId, targetId ) ~= x808095_g_AccomplishNPC_Name then
		x808095_NotifyTip( sceneId, selfId, "提交任务失败" )					
		return 0
	end

	-- 检查任务是否完成
	if x808095_CheckSubmit( sceneId, selfId, targetId ) ~= 1 then			
		return 0
	end
	
	BeginEvent(sceneId)
		AddText(sceneId,x808095_g_MissionName)
		AddText( sceneId, x808095_g_MissionComplete )				
	EndEvent( )
	DispatchMissionContinueInfo(sceneId,selfId,targetId,x808095_g_ScriptId,x808095_g_MissionId)
	
end

--**********************************
--检测是否可以提交
--**********************************
function x808095_CheckSubmit( sceneId, selfId, targetId )

	--判断该npc是否是对应任务的npc
	if LuaFnGetName( sceneId, targetId ) ~= x808095_g_AccomplishNPC_Name then
		x808095_NotifyTip( sceneId, selfId, "提交任务失败" )					
		return 0
	end

	if IsHaveMission( sceneId, selfId, x808095_g_MissionId ) <= 0 then
		x808095_TalkInfo( sceneId, selfId, targetId, "#{XSHCD_20080418_072}" )
		return 0
	end

	local misIndex = GetMissionIndexByID(sceneId,selfId,x808095_g_MissionId)

	-- 检测任务是否完成	
	if GetMissionParam(sceneId, selfId, misIndex, x808095_g_Mission_IsComplete) > 0 then
		return 1
	end
	
	return 0
	
end

--**********************************
--提交，仅供子任务调用
--**********************************
function x808095_OnSubmit( sceneId, selfId, targetId, selectRadioId )
	
	--判断该npc是否是对应任务的npc
	if LuaFnGetName( sceneId, targetId ) ~= x808095_g_AccomplishNPC_Name then
		x808095_NotifyTip( sceneId, selfId, "提交任务失败" )					
		return 0
	end

  -- 检查任务是否完成
	if x808095_CheckSubmit( sceneId, selfId, targetId ) ~= 1 then
		x808095_NotifyTip( sceneId, selfId, "提交任务失败" )				
		return 0
	end
	
	local strText = ""

	local playerlvl = LuaFnGetLevel( sceneId, selfId )
	local nExpNum = x808095_g_ExpBonus_Param1*playerlvl+x808095_g_ExpBonus_Param2
	local nMoneyNum = x808095_g_MoneyBonus_Param1*playerlvl+x808095_g_MoneyBonus_Param2

	nExpNum = floor(nExpNum)
	nMoneyNum = floor(nMoneyNum)
	LuaFnAddExp( sceneId, selfId, nExpNum )
	AddMoney( sceneId, selfId, nMoneyNum )
	-- x808095_TalkInfo( sceneId, selfId, targetId, strText )
	
	-- 活动顺利完成
	x808095_NotifyTip( sceneId, selfId, "#{XSHCD_20080418_083}" )

	x808095_DelMissionInfo( sceneId, selfId )
	
	-- 圣火任务第一步完成
	SetMissionData( sceneId, selfId, MD_GODOFFIRE_COMPLETE_STEPNUM, 1 )
	local	nStepNum = GetMissionData( sceneId, selfId, MD_GODOFFIRE_COMPLETE_COUNT )
	SetMissionData( sceneId, selfId, MD_GODOFFIRE_COMPLETE_COUNT, nStepNum+1 )
	
	-- 直接给玩家副本任务
	CallScriptFunction( 808096, "OnAccept", sceneId, selfId, targetId, x808095_g_ScriptId )

end

--**********************************
--杀死怪物或玩家
--**********************************
function x808095_OnKillObject( sceneId, selfId, objdataId ,objId)--参数意思：场景号、玩家objId、怪物表位置号、怪物
end

--**********************************
--进入区域事件
--**********************************
function x808095_OnEnterArea( sceneId, selfId, zoneId )	
end

--**********************************
--道具改变
--**********************************
function x808095_OnItemChanged( sceneId, selfId, itemdataId )
end

--**********************************
--接任务后显示的界面
--**********************************
function x808095_AcceptDialog(sceneId, selfId, rand, g_Dialog, targetId )

	BeginEvent( sceneId )
		AddText( sceneId, g_Dialog )
	EndEvent( sceneId )
	DispatchEventList( sceneId, selfId, targetId )

end

--**********************************
--交任务后显示的界面
--**********************************
function x808095_SubmitDialog( sceneId, selfId, rand )
end

--**********************************
--醒目提示
--**********************************
function x808095_NotifyTip( sceneId, selfId, msg )

	BeginEvent( sceneId )
		AddText( sceneId, msg )
	EndEvent( sceneId )
	DispatchMissionTips( sceneId, selfId )

end

--**********************************
--与NPC对话
--**********************************
function x808095_TalkInfo( sceneId, selfId, targetId, msg )

	BeginEvent(sceneId)
		AddText( sceneId, msg )
	EndEvent(sceneId)
	DispatchEventList(sceneId,selfId,targetId)

end

--**********************************
--取得本事件的MissionId，用于obj文件中对话情景的判断
--**********************************
function x808095_GetEventMissionId( sceneId, selfId )	
	return x808095_g_MissionId
end

function x808095_AcceptMission( sceneId, selfId, targetId )
	
	--判断该npc是否是对应任务的npc
	if LuaFnGetName( sceneId, targetId ) ~= x808095_g_Name then
		x808095_NotifyTip( sceneId, selfId, "接受任务失败" )
		return 0
	end

	local  PlayerName=GetName(sceneId,selfId)		
	
	--发送任务接受时显示的信息
	BeginEvent(sceneId)
		AddText(sceneId,x808095_g_MissionName)
		AddText( sceneId, x808095_g_MissionInfo )
		AddText(sceneId,"#{M_MUBIAO}")
		AddText(sceneId,"#{XSHCD_20080418_042}")
		AddText(sceneId,"#{M_SHOUHUO}")
		AddText(sceneId,"#{XSHCD_20080418_096}")
		
	EndEvent( )
	DispatchMissionInfo(sceneId,selfId,targetId,x808095_g_ScriptId,x808095_g_MissionId)	

end

--/////////////////////////////////////////////////////////////////////////////////////////////////////
--获取具体item的详细信息
function x808095_GetItemDetailInfo(itemId)
	return 0
end	

--**********************************
--检测活动时间
--**********************************
function x808095_CheckHuoDongTime()

	if 1 == 1 then
			return 0
		end

	local nMonth = GetTodayMonth()+1
	local nDate	 = GetTodayDate()
	local nHour	 = GetHour()
	local nMinute = GetMinute()
	local nThisDay = GetTodayWeek()
	local curDateTime = nMonth*100+nDate
  local curHourTime = nHour*100+nMinute
  
  if curHourTime >= x808095_g_Activity_Time.tstart and curHourTime <= x808095_g_Activity_Time.tend then
  	if curDateTime >= x808095_g_Activity_Day.dstart and curDateTime <= x808095_g_Activity_Day.dend then
  		return 1
 		elseif curDateTime > x808095_g_Activity_Day.dend and nThisDay == x808095_g_Activity_DayTime then
  		return 1
  	end
  end


	return 0

end

--**********************************
--道具使用
--**********************************
function x808095_OnUseItem( sceneId, selfId, bagIndex )	
end

--**********************************
--死亡事件
--**********************************
function x808095_OnDie( sceneId, selfId, killerId )
end

--**********************************
--删除活动信息
--删除玩家任务列表中对应的任务,物品和驻留效果
--**********************************
function x808095_DelMissionInfo( sceneId, selfId )

  if HaveItem(sceneId, selfId, x808095_g_ItemId.id) > 0 then
  	if LuaFnGetAvailableItemCount(sceneId, selfId, x808095_g_ItemId.id) >= x808095_g_ItemId.num then
  		DelItem( sceneId, selfId, x808095_g_ItemId.id, LuaFnGetAvailableItemCount(sceneId, selfId, x808095_g_ItemId.id) )  	
  	end
  end

  if LuaFnHaveImpactOfSpecificDataIndex(sceneId, selfId, x808095_g_Impact_Transport_Mission) ~= 0 then
  	-- 如果玩家正在漕运或跑商就不清除运输Buff
  	if IsHaveMission( sceneId, selfId, 4021 ) <= 0
  		 and GetItemCount(sceneId, selfId, 40002000) <= 0 then  	
  		LuaFnCancelSpecificImpact( sceneId, selfId, x808095_g_Impact_Transport_Mission )
  	end
  end
  
  if LuaFnHaveImpactOfSpecificDataIndex(sceneId, selfId, x808095_g_Impact_GodOfFireMan_Mission) ~= 0 then
  	LuaFnCancelSpecificImpact( sceneId, selfId, x808095_g_Impact_GodOfFireMan_Mission )
  end
  
  if LuaFnHaveImpactOfSpecificDataIndex(sceneId, selfId, x808095_g_Impact_GodOfFireGirl_Mission) ~= 0 then
  	LuaFnCancelSpecificImpact( sceneId, selfId, x808095_g_Impact_GodOfFireGirl_Mission )
  end
  
  if LuaFnHaveImpactOfSpecificDataIndex(sceneId, selfId, x808095_g_Impact_DelGodOfFire_Mission) ~= 0 then
  	LuaFnCancelSpecificImpact( sceneId, selfId, x808095_g_Impact_DelGodOfFire_Mission )
  end
  
  if IsHaveMission( sceneId, selfId, x808095_g_MissionId ) > 0 then  	
	 	DelMission( sceneId, selfId, x808095_g_MissionId )
	end
	
	return 0

end

--*************************************
-- 圣火特效有效期到时自动删除运输Buffer
--*************************************
function x808095_OnImpactFadeOut( sceneId, selfId, impactId )

	if impactId == x808095_g_Impact_DelGodOfFire_Mission then
		if LuaFnHaveImpactOfSpecificDataIndex(sceneId, selfId, x808095_g_Impact_Transport_Mission) ~= 0 then
  		LuaFnCancelSpecificImpact( sceneId, selfId, x808095_g_Impact_Transport_Mission )
  	end
	end

end
