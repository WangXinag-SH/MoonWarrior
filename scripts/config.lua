
local winSize = CCDirector:sharedDirector():getVisibleSize()

NPC = {
	{	
		name = "npc1",
		type=0,
		startX=0 ,
		startY=winSize.height - 60,
		time = 1.0
	},
	{
		name = "npc2",
		type=1,
		startX= 70,
		startY=winSize.height - 60,
		time = 10.0
	},
	{
		name = "npc3",
		type=2,
		startX=140,
		startY=winSize.height - 60,
		time = 15.0
	},
	{
		name = "npc4",
		type=3,
		startX=210,
		startY=winSize.height - 60,
		time = 8.0
	},	
	{
		name = "npc5",
		type=4,
		startX= 280,
		startY=winSize.height - 60,
		time = 4.0
	}	
}


--for k,v in pairs(NPC) do
--	print(v.type)
--end
