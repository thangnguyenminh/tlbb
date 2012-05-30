--道具：百宝书匣
--脚本号 332205
--Author:  houzhifang  2008-11-06

x332205_g_scriptId = 332205
x332205_g_strGongGaoInfo = "#H诗曰“书中自有黄金屋”，#{_INFOUSR%s}#H求书若渴，今日偶然间在#G#{_ITEM30501171}#H中发现了一本#{_INFOMSG%s}#H。"
--x332205_g_strGongGaoInfo = "#{_INFOUSR%s}#H在使用百宝书匣后，获得了一本#{_INFOMSG%s}#H珍兽技能书。"
x332205_g_giftitem_index = 30501318

--**********************************
--事件交互入口
--**********************************
function x332205_OnDefaultEvent( sceneId, selfId, bagIndex )
-- 不需要这个接口，保留空函数
end

--**********************************
--这个物品的使用过程是否类似于技能：
--系统会在执行开始时检测这个函数的返回值，如果返回失败则忽略后面的类似技能的执行。
--返回1：技能类似的物品，可以继续类似技能的执行；返回0：忽略后面的操作。
--**********************************
function x332205_IsSkillLikeScript( sceneId, selfId)
	return 1; --这个脚本需要动作支持
end

--**********************************
--直接取消效果：
--系统会直接调用这个接口，并根据这个函数的返回值确定以后的流程是否执行。
--返回1：已经取消对应效果，不再执行后续操作；返回0：没有检测到相关效果，继续执行。
--**********************************
function x332205_CancelImpacts( sceneId, selfId )
	return 0; --不需要这个接口，但要保留空函数,并且始终返回0。
end

--**********************************
--条件检测入口：
--系统会在技能检测的时间点调用这个接口，并根据这个函数的返回值确定以后的流程是否执行。
--返回1：条件检测通过，可以继续执行；返回0：条件检测失败，中断后续执行。
--**********************************
function x332205_OnConditionCheck( sceneId, selfId )

	--校验使用的物�	
	if(1~=LuaFnVerifyUsedItem(sceneId, selfId)) then
		return 0
	end
					
	local FreeSpace = LuaFnGetPropertyBagSpace( sceneId, selfId )
	if( FreeSpace < 2 ) then
	        local strNotice = "对不起，您的背包已满，请至少留出两个道具栏空间。"
		      x332205_ShowNotice( sceneId, selfId, strNotice)
	        return 0
	end
	
	return 1;
end

--**********************************
--消耗检测及处理入口：
--系统会在技能消耗的时间点调用这个接口，并根据这个函数的返回值确定以后的流程是否执行。
--返回1：消耗处理通过，可以继续执行；返回0：消耗检测失败，中断后续执行。
--注意：这不光负责消耗的检测也负责消耗的执行。
--**********************************
function x332205_OnDeplete( sceneId, selfId )
	if(0<LuaFnDepletingUsedItem(sceneId, selfId)) then
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
function x332205_OnActivateOnce( sceneId, selfId )

    local RandomBase = GetBaibaoshuxiaItemDropBase( sceneId, selfId )
    if( RandomBase > 0 ) then    
       		
        local RandomNum = random( 0, RandomBase - 1 )
        local RandomID, Notice = BaibaoshuxiaItemDropItem( sceneId, selfId, RandomNum )
       
        if( RandomID > 0 ) then
        	BeginAddItem(sceneId)
			AddItem( sceneId, RandomID, 1 )
			AddItem( sceneId, x332205_g_giftitem_index, 1 )
			local Ret = LuaFnEndAddItemIgnoreFatigueState( sceneId, selfId )
			if Ret > 0 then
				LuaFnAddItemListToHumanIgnoreFatigueState(sceneId,selfId)
			    if 1 == Notice then
			    	local szItemTransfer = GetItemTransfer(sceneId,selfId, 0)
						x332205_ShowRandomSystemNotice( sceneId, selfId, szItemTransfer )
				   	end
				      
				    local ItemName = GetItemName(sceneId, RandomID)
				    local strNotice = "#{BBSX_081106_2}"..ItemName
				    x332205_ShowNotice( sceneId, selfId, strNotice)
				    LuaFnSendSpecificImpactToUnit(sceneId, selfId, selfId, selfId, 18, 0);
				 else
				    local strNotice = "#{BBSX_081106_1}"
				    x332205_ShowNotice( sceneId, selfId, strNotice)
			     end		
        	end
    	end
    
	return 1;
end

--**********************************
--引导心跳处理入口：
--引导技能会在每次心跳结束时调用这个接口。
--返回：1继续下次心跳；0：中断引导。
--注：这里是技能生效一次的入口
--**********************************
function x332205_OnActivateEachTick( sceneId, selfId)
	return 1; --不是引导性脚本, 只保留空函数.
end

function x332205_ShowNotice( sceneId, selfId, strNotice)
	BeginEvent( sceneId )
		AddText( sceneId, strNotice )
	EndEvent( sceneId )
	DispatchMissionTips( sceneId, selfId )    
end

function x332205_ShowRandomSystemNotice( sceneId, selfId, strItemInfo )
	
	local PlayerName = GetName(sceneId,selfId)
	local str = format( "#H诗曰“书中自有黄金屋”，#{_INFOUSR%s}#H求书若渴，今日偶然间在#G#{_ITEM30501171}#H中发现了一本#{_INFOMSG%s}#H。", PlayerName, strItemInfo )
	BroadMsgByChatPipe( sceneId, selfId, str, 4 )
	
end
