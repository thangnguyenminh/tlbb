--生长点脚本，蚕豆幼苗
--脚本号
--g_ScriptId = 711027

--此生长点编号
x711027_g_GpId = 528

--下一个生长点的编号
x711027_g_GpIdNext = 529

function	 x711027_OnRecycle(sceneId,selfId,targetId)
	itemBoxX = GetItemBoxWorldPosX(sceneId,targetId)
	itemBoxZ = GetItemBoxWorldPosZ(sceneId,targetId)
	ItemBoxId = ItemBoxEnterScene(itemBoxX,itemBoxZ,x711027_g_GpIdNext,sceneId,QUALITY_MUST_BE_CHANGE,0)
	--得到生长点的主人GUID
	ItemBoxOwnerGUID = GetItemBoxOwner(sceneId, targetId)		--参数是SceneID，ItemBoxID
	--给ItemBox设定主人
	SetItemBoxOwner(sceneId,ItemBoxId,ItemBoxOwnerGUID)

	SetItemBoxMaxGrowTime(sceneId,ItemBoxId,450000)	--设定回收时间
	return 1
end
