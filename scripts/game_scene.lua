--游戏主场景
require("AudioEngine")
require("scripts/config")
require("scripts/warrior")
require("scripts/npc")
require("scripts/bullet")

local gameScene = CCScene:create()
local bgSprite1  
local bgSprite2 
local warrior --主角
local touchX --触摸点X
local touchY
local bulletArray = CCArray:create() --存放所有子弹
bulletArray:retain()
local npcArray = CCArray:create()  --存放所有敌机
npcArray:retain()

local winSize = CCDirector:sharedDirector():getVisibleSize()

local bgMusic
local explodeMusic

function initAudio()
	bgMusic = CCFileUtils:sharedFileUtils():fullPathForFilename("warriors/bgMusic.mp3")
	explodeMusic = CCFileUtils:sharedFileUtils():fullPathForFilename("warriors/explodeEffect.ogg")
end

function init_bg_layer()
	local bgLayer = CCLayer:create()

	bgSprite1 = CCSprite:createWithSpriteFrameName("bg01.png")
	--适配不同分辨率begin
	bgSprite1:setScaleX(winSize.width/bgSprite1:getTextureRect():getMaxX())
	bgSprite1:setScaleY(winSize.height/bgSprite1:getTextureRect():getMaxY())
	--适配不同分辨率end

	bgSprite1:setPosition(0,0)
	bgSprite1:setAnchorPoint(0,0)
	bgLayer:addChild(bgSprite1)

	bgSprite2 = CCSprite:createWithSpriteFrameName("bg01.png")
	bgSprite2:setScaleX(winSize.width/bgSprite2:getTextureRect():getMaxX())
	bgSprite2:setScaleY(winSize.height/bgSprite2:getTextureRect():getMaxY())
	--bgSprite2:setPosition(0,bgSprite1:getPositionY() + bgSprite1:getContentSize().height)
	bgSprite2:setPosition(0,bgSprite1:getPositionY() + winSize.height -5)	-- -5是为了消除两张图片相接处的黑边
	bgSprite2:setAnchorPoint(0,0)
	bgLayer:addChild(bgSprite2)

	--bgSprite1:getTexture():setAliasTexParameters() --消除两张图片之间的黑边，事实证明没用

	return bgLayer
end

function update_bg_layer()
	local speedY = 2

	bgSprite1:setPosition(0, bgSprite1:getPositionY() - speedY)
	--bgSprite2:setPosition(0, bgSprite1:getPositionY() + bgSprite1:getContentSize().height)
	bgSprite2:setPosition(0, bgSprite1:getPositionY() + winSize.height -5)

	if bgSprite2:getPositionY() <= 0 then
		bgSprite1:setPositionY(0)
	end
end

function update()
	update_bg_layer()	
end

local function getWarriorPoint()
	return warrior:getPositionX(), warrior:getPositionY()
end

local function checkBound(x,y)
	if x <= 0 then
		x = 0
	elseif x >= (winSize.width - warrior:getContentSize().width) then
		x = winSize.width - warrior:getContentSize().width
	end

	if y <= 0 then
		y = 0
	elseif y >= (winSize.height - warrior:getContentSize().height) then
		y = winSize.height - warrior:getContentSize().height
	end

	return x,y
end

function init_scene()
	initAudio()	
	--AudioEngine.playMusic(bgMusic, true)

	gameScene:addChild(init_bg_layer(), 200)

	--add warrior
	warrior = create_warrior()
	local warriorLayer = CCLayer:create()
	warriorLayer:addChild(warrior)


	--点击事件
	local function register_touch_event()
		local function onTouchBegan(x,y)
			touchX = x
			touchY = y

			return true  --必须返回true，否则moved和ended事件没法执行
		end
		local function onTouchMoved(x,y)
			local deltaX = x - touchX
			local deltaY = y - touchY

			local curX, curY = getWarriorPoint()

			local finalX = curX + deltaX
			local finalY = curY + deltaY

			--边界判断
			finalX, finalY = checkBound(finalX, finalY)
			warrior:setPosition(finalX, finalY)

			touchX = x
			touchY = y			
		end
		local function onTouchEnded(x,y)
			
		end
		local function onTouch_(eventType, x, y)
			if eventType == "began" then
				return onTouchBegan(x,y)
			elseif eventType == "moved" then
				return onTouchMoved(x,y)
			elseif eventType == "ended" then
				return onTouchEnded(x,y)
			end		
		end
		warriorLayer:registerScriptTouchHandler(onTouch_)
		warriorLayer:setTouchEnabled(true)
	end
	register_touch_event()

	--add npc	
	--[[for k,v in pairs(NPC) do
		local n = create_npc(v.time, v.type, CCPoint(v.startX, v.startY))
		warriorLayer:addChild(n)

		npcArray:addObject(n)
	end--]]
	
	--create npc
	local function npc_create()
		local npcSeed = tostring(os.time()):reverse()
		math.randomseed(npcSeed)
		local randomNpc = math.random(0, table.getn(NPC)-1)
		--CCLuaLog("NPC table size is " .. table.getn(NPC))
		local c = NPC[randomNpc + 1]
		--local n = create_npc(c.time, c.type, CCPoint(c.startX, c.startY))
		local startX = math.random(0, winSize.width - 60)
		--CCLuaLog("startX = "..startX)
		local n = create_npc(c.time, c.type, CCPoint(startX, winSize.height - 60))
		warriorLayer:addChild(n)

		npcArray:addObject(n)
	end
	

	--create bullet 
	local function b_create( )
		local bullet = create_bullet(warrior)
		bulletArray:addObject(bullet)
		warriorLayer:addChild(bullet)	
	end
	local function b_move( )
		local size = bulletArray:count()
		
		for i=size-1,0, -1 do --倒序遍历
			local b = tolua.cast(bulletArray:objectAtIndex(i), "CCSprite")

			bullet_move(b)

			
			--checkCollison
			local npcSize = npcArray:count()
			--for j=0,npcSize-1 do
			for j=npcSize-1,0,-1 do
				local _npc = tolua.cast(npcArray:objectAtIndex(j), "CCSprite")

				if bullet_collison(b, _npc)  then
					--CCLuaLog("bullet collision i = "..i .. ", j = " .. j)
					--隐藏子弹
					b:setVisible(false)
					--播放动画 
					local anim = player_explode_anim(_npc)
					warriorLayer:addChild(anim)
					
					--播放音效
					AudioEngine.playEffect( explodeMusic )
					--AudioEngine.playMusic( explodeMusic )	--playMusic会把背景音乐打断
					--删除NPC					
					warriorLayer:removeChildByTag(_npc:getTag(), true)
					npcArray:removeObjectAtIndex(j, true)
					--删除子弹
					warriorLayer:removeChildByTag(b:getTag(), true)
					bulletArray:removeObjectAtIndex(i, true)
					b = nil
					break
				elseif _npc~=nil and npc_bound_collison(_npc)	then
					--npc超出边界 
					warriorLayer:removeChildByTag(_npc:getTag(), true)
					npcArray:removeObjectAtIndex(j, true)
				end
			end
			
			--如果子弹超出边界就删除
			
			if  b~=nil and b:getPositionY() >= winSize.height then
				--删除子弹
				warriorLayer:removeChildByTag(b:getTag(), true)
				bulletArray:removeObject(b)
				--bulletArray:removeObjectAtIndex(i)
			end
			

		end
	end


	local function keypadHandler(strEvent)
		CCLuaLog("============== strEvent : ".. strEvent)
		if "backClicked" == strEvent then
			--CCLuaLog("back clicked")
			local mainScene = require("scripts.mainmenu")
			CCDirector:sharedDirector():runWithScene(mainScene)
    	elseif "menuClicked" == strEvent then
    		CCLuaLog("menu clicked")
    	end
	end
	warriorLayer:registerScriptKeypadHandler(keypadHandler)

	gameScene:addChild(warriorLayer, 300)

	CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(update, 0, false)
	CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(npc_create, 0.5, false)
	CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(b_create, 0.3, false)
	CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(b_move, 0.01, false)
end


init_scene()
return gameScene