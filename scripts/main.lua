

mainBG = nil

function ERROR_TRACE(msg)
	print("================================")
	print("Moon Warriors Error : ".. tostring(msg).."\n")
	print(debug.traceback())
	print("================================")
end

function loadRes()
	CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("warriors/textureTransparentPack.plist")
	CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("warriors/textureOpaquePack.plist")
	CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("warriors/explosion.plist")
	mainBG = CCTextureCache:sharedTextureCache():addImage("warriors/main_bg.png")
end

function main()
	collectgarbage("setpause",100)
	collectgarbage("setstepmul", 5000)

	loadRes()

	--local gameScene = require("scripts.game_scene")
	--CCDirector:sharedDirector():runWithScene(gameScene)
	
	local mainScene = require("scripts.mainmenu")
	CCDirector:sharedDirector():runWithScene(mainScene)
end


xpcall(main, ERROR_TRACE)