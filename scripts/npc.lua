
local winSize = CCDirector:sharedDirector():getVisibleSize()

--local time2Arrive	--从起始点到终点的时间
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
	--local finalY = math.random(0, winSize.height)
	local finalY = -100
	
	local arriveTime = math.random(0.5, 1) * 2.0
	--CCLuaLog("arriveTime = " .. arriveTime)
	--local move = CCMoveTo:create(time, CCPoint(finalX, finalY))
	local move = CCMoveTo:create(arriveTime, CCPoint(finalX, finalY))
	npc:runAction(move)
end

function npc_bound_collison(npc)
	if npc:getPositionX() <  0 or npc:getPositionX() > (winSize.width - npc:getContentSize().width) then			
		return true
	end
	if npc:getPositionY() <  0 or npc:getPositionY() > (winSize.height - npc:getContentSize().height) then			
		return true
	end
	return false
end