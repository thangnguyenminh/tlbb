--苗疆NPC
--城市传送人1
x029030_g_scriptId=029030

x029030_g_city0 = 222
x029030_g_city1 = 240
x029030_g_city2 = 614
x029030_g_city3 = 632

--**********************************

--事件交互入口

--**********************************

function x029030_OnDefaultEvent( sceneId, selfId,targetId )

	strCity0Name = CityGetCityName(sceneId, selfId, x029030_g_city0)
	strCity1Name = CityGetCityName(sceneId, selfId, x029030_g_city1)
	strCity2Name = CityGetCityName(sceneId, selfId, x029030_g_city2)
	strCity3Name = CityGetCityName(sceneId, selfId, x029030_g_city3)


	BeginEvent(sceneId)

		AddText(sceneId,"有什么我可以帮你的吗？")
		
		if(strCity0Name ~= "") then AddNumText(sceneId,x029030_g_scriptId,"城市1  "..strCity0Name,9,0) end
		if(strCity1Name ~= "") then AddNumText(sceneId,x029030_g_scriptId,"城市2  "..strCity1Name,9,1) end
		if(strCity2Name ~= "") then AddNumText(sceneId,x029030_g_scriptId,"城市3  "..strCity2Name,9,2) end
		if(strCity3Name ~= "") then AddNumText(sceneId,x029030_g_scriptId,"城市4  "..strCity3Name,9,3) end

	EndEvent(sceneId)

	DispatchEventList(sceneId,selfId,targetId)

end

--**********************************

--事件列表选中一项

--**********************************

function x029030_OnEventRequest( sceneId, selfId, targetId, eventId )

	if	(GetNumText()==0)	then	CityMoveToScene(sceneId, selfId, x029030_g_city0, 99, 152)
	elseif	(GetNumText()==1)	then	CityMoveToScene(sceneId, selfId, x029030_g_city1, 99, 152)
	elseif	(GetNumText()==2)	then	CityMoveToScene(sceneId, selfId, x029030_g_city2, 99, 152)
	elseif	(GetNumText()==3)	then	CityMoveToScene(sceneId, selfId, x029030_g_city3, 99, 152)
	end

end
