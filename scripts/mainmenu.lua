--主菜单 

local mainScene = CCScene:create()


local bgLayer = {}
local winSize = CCDirector:sharedDirector():getVisibleSize()

--根据分辨率不同获取需要缩放的比例
local function calcScale(  obj )
	local scaleX = winSize.width / obj:getTextureRect():getMaxX()
	local scaleY = winSize.height / obj:getTextureRect():getMaxY()
	
	return scaleX , scaleY
end

function init()
	bgLayer = CCLayer:create()
	local menuLayer = CCLayer:create()
	
	menuLayer:setTouchEnabled(true)
	menuLayer:setTouchPriority(kCCMenuHandlerPriority + 1)
	menuLayer:setTouchMode(kCCTouchesOneByOne)
	
	--背景
	local function create_bg()
		local bgSprite = CCSprite:createWithTexture(mainBG)
		bgSprite:setPosition(0,0)
		local scale_x, scale_y = calcScale(bgSprite)
		bgSprite:setScaleX(	scale_x )
		bgSprite:setScaleY( scale_y ) 
		bgSprite:setAnchorPoint(0,0)
		bgLayer:addChild(bgSprite)
	end
	
	--菜单
	local function create_menu()
		local rect = CCRectMake(0,0,126,33)
		local newGameNormal = CCSprite:create("warriors/menu.png", rect)
		rect = CCRectMake(0,33,126,33)
		local newGameSelected = CCSprite:create("warriors/menu.png", rect)
		rect = CCRectMake(0,66,126,33)
		local newGameDisabled = CCSprite:create("warriors/menu.png", rect)
		local newGame = CCMenuItemSprite:create(newGameNormal,newGameSelected,newGameDisabled)  		
		--newGame:setPosition(winSize.width/2, winSize.height/2)
		--newGame:setAnchorPoint(0.5,0.5)		
		--menuLayer:addChild(newGame)
		
		rect = CCRectMake(126,0,126,33)
		local optionNormal = CCSprite:create("warriors/menu.png", rect)
		rect = CCRectMake(126,33,126,33)
		local optionSelected = CCSprite:create("warriors/menu.png", rect)
		rect = CCRectMake(126,66,126,33)
		local optionDisabled = CCSprite:create("warriors/menu.png", rect)
		local option = CCMenuItemSprite:create(optionNormal,optionSelected,optionDisabled)  
		option:setPositionY(newGame:getPositionY() - newGame:getContentSize().height - 10)
		--option:setPosition(winSize.width/2, winSize.height/2 - newGame:getContentSize().height - 10)
		--option:setAnchorPoint(0.5,0.5)
		--menuLayer:addChild(option)
		
		rect = CCRectMake(126*2,0,126,33)
		local aboutNormal = CCSprite:create("warriors/menu.png", rect)
		rect = CCRectMake(126*2,33,126,33)
		local aboutSelected = CCSprite:create("warriors/menu.png", rect)
		rect = CCRectMake(126*2,66,126,33)
		local aboutDisabled = CCSprite:create("warriors/menu.png", rect)
		local about = CCMenuItemSprite:create(aboutNormal,aboutSelected,aboutDisabled)  
		about:setPositionY(option:getPositionY() - option:getContentSize().height - 10)
		--about:setPosition(winSize.width/2, winSize.height/2 - option:getContentSize().height * 2 - 20)
		--about:setAnchorPoint(0.5,0.5)
		--menuLayer:addChild(about)
		
		local function newGameCallBack(sender)
			local game_scene = require("scripts.game_scene")
			CCDirector:sharedDirector():replaceScene(game_scene)
		end
		local function optionCallBack(sender)
			CCLuaLog("option")
		end
		local function aboutCallBack(sender)
			CCLuaLog("about")
		end
		
		newGame:registerScriptTapHandler(newGameCallBack)
		option:registerScriptTapHandler(optionCallBack)
		about:registerScriptTapHandler(aboutCallBack)
		
		local menu = CCMenu:create()
		menu:setPosition(winSize.width/2,winSize.height/2)
		menu:addChild(newGame)
		menu:addChild(option)
		menu:addChild(about)
		
		menuLayer:addChild(menu)
	end

	create_bg()
	create_menu()
	mainScene:addChild(bgLayer)
	mainScene:addChild(menuLayer)
end

init()
return mainScene