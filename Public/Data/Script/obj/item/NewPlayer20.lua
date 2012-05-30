--注意：

--物品技能的逻辑只能使用基础技能和脚本来实现

--脚本:

--以下是脚本样例:

------------------------------------------------------------------------------------------
--新人礼包20级的默认脚本
--物品ID: 30008056

--脚本号
x300080_g_scriptId = 300080--临时写这个,真正用的时候一定要改.

--需要的等级
x300080_g_MinLevel = 20

--奖励物品列表
x300080_Gift ={30008057,30505133}


--**********************************
--事件交互入口
--**********************************
function x300080_OnDefaultEvent( sceneId, selfId, bagIndex )
-- 不需要这个接口，但要保留空函数
end

--**********************************
--这个物品的使用过程是否类似于技能：
--系统会在执行开始时检测这个函数的返回值，如果返回失败则忽略后面的类似技能的执行。
--返回1：技能类似的物品，可以继续类似技能的执行；返回0：忽略后面的操作。
--**********************************
function x300080_IsSkillLikeScript( sceneId, selfId)
	return 1; --这个脚本需要动作支持
end

--**********************************
--直接取消效果：
--系统会直接调用这个接口，并根据这个函数的返回值确定以后的流程是否执行。
--返回1：已经取消对应效果，不再执行后续操作；返回0：没有检测到相关效果，继续执行。
--**********************************
function x300080_CancelImpacts( sceneId, selfId )
	return 0; --不需要这个接口，但要保留空函数,并且始终返回0。
end

--**********************************
--条件检测入口：
--系统会在技能检测的时间点调用这个接口，并根据这个函数的返回值确定以后的流程是否执行。
--返回1：条件检测通过，可以继续执行；返回0：条件检测失败，中断后续执行。
--**********************************
function x300080_OnConditionCheck( sceneId, selfId )
	--校验使用的物品
	if(1~=LuaFnVerifyUsedItem(sceneId, selfId)) then
		return 0
	end

	local FreeSpace = LuaFnGetPropertyBagSpace( sceneId, selfId )
	if( FreeSpace < 5 ) then
	   local strNotice = "#{XRLB_81203_5}5#{XRLB_81203_6}"
		 x300080_MSG( sceneId, selfId, strNotice)
	   return 0
	end
	
	return 1; --不需要任何条件，并且始终返回1。
end

--**********************************
--消耗检测及处理入口：
--系统会在技能消耗的时间点调用这个接口，并根据这个函数的返回值确定以后的流程是否执行。
--返回1：消耗处理通过，可以继续执行；返回0：消耗检测失败，中断后续执行。
--注意：这不光负责消耗的检测也负责消耗的执行。
--**********************************
function x300080_OnDeplete( sceneId, selfId )
	
	if(0<LuaFnDepletingUsedItem(sceneId, selfId)) then
	
		local guid = LuaFnObjId2Guid(sceneId, selfId);
		
		if guid ~= nil then
			--local LogInfo = format("0X%08X," , guid);
			ScriptGlobal_AuditGeneralLog(LUAAUDIT_TSLB20, guid);
		end
	
		return 1;
	end
	return 0;
end

--**********************************
--只会执行一次入口：
--聚气和瞬发技能会在消耗完成后调用这个接口（聚气结束并且各种条件都满足的时候），而引导
--技能也会在消耗完成后调用这个接口（技能的一开始，消耗成功执行之后）。
--返回1：处理成功；返回0：处理失败。
--注：这里是技能生效一次的入口
--**********************************
function x300080_OnActivateOnce( sceneId, selfId )
	BeginAddItem( sceneId )
	AddItem( sceneId, x300080_Gift[1], 1 )
	AddItem( sceneId, x300080_Gift[2], 5 )
	local ret = EndAddItem( sceneId, selfId )
	if ret <= 0 then 
		return 
	end

	--为玩家增加新人礼包（30级）和金榜提名×5
	AddItemListToHuman(sceneId,selfId)
	
	x300080_MSG( sceneId, selfId, "#{XRLB_81203_7}#{_ITEM30008056}#{XRLB_81203_8}")
	return 1;
end

--**********************************
--引导心跳处理入口：
--引导技能会在每次心跳结束时调用这个接口。
--返回：1继续下次心跳；0：中断引导。
--注：这里是技能生效一次的入口
--**********************************
function x300080_OnActivateEachTick( sceneId, selfId)
	return 1; --不是引导性脚本, 只保留空函数.
end

function x300080_MSG( sceneId, selfId, strOutMsg)
	BeginEvent( sceneId )
		AddText(sceneId, strOutMsg)
	EndEvent( sceneId )
	DispatchMissionTips(sceneId, selfId);
end
