-- 苏州
--循环任务
--问路脚本
x500025_g_scriptId = 500025

-- 问路类型 type: 1 为二级菜单, 2 为直接问路
x500025_g_Signpost = {
	{ type=2, name="虫鸟坊坊主", x=87, y=142, tip="云霏霏", desc="虫鸟坊坊主云霏霏（87,142）在西门内向北的虫鸟坊内。按下TAB键，地图上会有闪烁的标识的。", eventId=-1 },
}

--**********************************
--列举事件
--**********************************
function x500025_OnEnumerate( sceneId, selfId, targetId )
	for i, signpost in x500025_g_Signpost do
		AddNumText(sceneId, x500025_g_scriptId, signpost.name, -1, i)
	end
end

--**********************************
--任务入口函数
--**********************************
function x500025_OnDefaultEvent( sceneId, selfId, targetId )
	signpost = x500025_g_Signpost[GetNumText()]

	if signpost.type == 1 then
		BeginEvent(sceneId)
			AddText(sceneId, signpost.name .. "：")
			CallScriptFunction( signpost.eventId, "OnEnumerate", sceneId, selfId, targetId )
		EndEvent(sceneId)
		DispatchEventList(sceneId, selfId, targetId)
	elseif signpost.type == 2 then
		CallScriptFunction( SCENE_SCRIPT_ID, "AskTheWay", sceneId, selfId, sceneId, signpost.x, signpost.y, signpost.tip )

		BeginEvent(sceneId)
			AddText(sceneId, signpost.desc)
		EndEvent(sceneId)
		DispatchEventList(sceneId, selfId, targetId)
	end

end
