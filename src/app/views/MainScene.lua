local EliminateBoard = require("app.views.EliminateBoard")



local MainScene = class("MainScene", cc.load("mvc").ViewBase)

MainScene.RESOURCE_FILENAME = "MainScene.csb"

function MainScene:onCreate()
	display.loadSpriteFrames("eliminateGameRes.plist","eliminateGameRes.png",nil)

	self.bgView = display.newSprite("gameBg.png")
	self.bgView:setAnchorPoint(0,0)
	self.bgView:addTo(self)
    
    self.board = EliminateBoard.new()
    local boardSize = self.board:getContentSize()
    self.board:setPosition((display.width - boardSize.width)*0.5,(display.height-boardSize.height)*0.5)
    self.board:addTo(self)

    if display.height ~= 960 then
		local scale = display.height/960
		self.bgView:setScaleY(scale)
	end
end

return MainScene
