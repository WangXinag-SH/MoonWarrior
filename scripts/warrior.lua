require("scripts/bullet")


local winSize = CCDirector:sharedDirector():getWinSize()
local bulletArray = CCArray:create()
bulletArray:retain()

function create_warrior()
	local warriorSprite = CCSprite:createWithSpriteFrameName("ship03.png")
	warriorSprite:setPosition(winSize.width/2, 0)
	warriorSprite:setAnchorPoint(0,0)

	--add anim
	local rect = CCRectMake(387, 81, 60, 38)
	local frame01 = CCSpriteFrame:create("warriors/textureTransparentPack.png", rect)
	rect = CCRectMake(406, 35, 61, 44)
	local frame02 = CCSpriteFrame:create("warriors/textureTransparentPack.png", rect)
	local array = CCArray:create()
	array:addObject(frame01)
	array:addObject(frame02)
	local animation = CCAnimation:createWithSpriteFrames(array, 0.1)
	local animate = CCAnimate:create(animation)
	warriorSprite:runAction(CCRepeatForever:create(animate))

	--add bullet
	--[[local bullet = create_bullet(warriorSprite)
	bulletArray:addObject(bullet)
	local function b_move( ... )
		local size = bulletArray:count()
		for i=0,size-1 do
			local b = tolua.cast(bulletArray:objectAtIndex(i), "CCNode")

		--	bullet_move(b)
			
		end

		--local newBullet = create_bullet(warriorSprite)
		--bulletArray:addObject(newBullet)
	end


	CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(b_move, 0 , false)
]]
	return warriorSprite
end