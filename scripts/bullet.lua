local winSize = CCDirector:sharedDirector():getVisibleSize()
function create_bullet(owner)
	local bullet = CCSprite:createWithSpriteFrameName("W2.png")
	--CCLuaLog("create_bullet pos is ".. owner:getPositionX()..", " ..owner:getPositionY())
	
	--CCLuaLog("owner:getContentSize = " .. owner:getContentSize())
	bullet:setPosition(owner:getPositionX() + 30, owner:getPositionY()+40)

	bullet:setTag(os.time())

	return bullet
end

function bullet_move(bullet)
	local speed = 5
	--local move = CCMoveTo:create(1.0, CCPoint(bullet:getPositionX(), bullet:getPositionY() + speed))
	--bullet:runAction(move)
	bullet:setPositionY(bullet:getPositionY() + speed)
	--CCLuaLog("move bullet pos is ".. bullet:getPositionX()..", " ..bullet:getPositionY())


end

function bullet_collison(bullet,npc)
	if bullet == nil then
		return false
	end

	local bulletBox = bullet:boundingBox()
	local npcBox = npc:boundingBox()

	if(bulletBox:intersectsRect(npcBox)) then
		return true
	end

	return false
end

function player_explode_anim(npc)
	local sprite = CCSprite:createWithSpriteFrameName("explosion_01.png")
	sprite:setPosition(npc:getPosition())
	local idx = 1
	local array = CCArray:create()

	while true do
		local name = string.format("explosion_%02d.png", idx)
		--CCLuaLog("palyer expload_anim name : ".. name)
		local frame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(name)
		if frame == nil then
			break
		end
		array:addObject(frame)
		idx = idx + 1
	end

	local animation = CCAnimation:createWithSpriteFrames(array,0.1)
	local animate = CCAnimate:create(animation)

	--sprite:runAction( CCRepeatForever:create(animate) )
	sprite:runAction( animate )

	return sprite;
end