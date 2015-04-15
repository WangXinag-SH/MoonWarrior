
local winSize = CCDirector:sharedDirector():getVisibleSize()

function getTextureByType(type)
	--CCLuaLog("str = ".. string.format("E%d.png", type))
	return string.format("E%d.png", type)
end

--type : 0-5
function create_npc(time, type, startPos)
	--local npc = CCSprite:create(getTexureByType(type))
	local npc = CCSprite:createWithSpriteFrameName(getTextureByType(type))
	npc:setPosition(startPos)
	npc:setAnchorPoint(0,0)

	npc:setTag(type + 100)

	npc_move(time, npc)
	return npc
end

function npc_move(time , npc)
	local seed = tostring(os.time()):reverse()
	math.randomseed(seed)
	local finalX = math.random(0, winSize.width)
	local finalY = math.random(0, winSize.height)

	local move = CCMoveTo:create(time, CCPoint(finalX, finalY))
	npc:runAction(move)
end
