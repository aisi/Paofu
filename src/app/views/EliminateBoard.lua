--
-- Author: cmwang
-- Date: 2015-07-30 16:02:02
--
import(".EliminateMarcos")
import(".EliminateUtil")
local EliminateGrid = import(".EliminateGrid")
local EliminateBoard = class("EliminateBoard",function (  )
	local node = display.newNode()
	return node
end)

function EliminateBoard:ctor()
	self:initData()
	self:initView()
end

function EliminateBoard:initData()
	self.grids = {}
end

function EliminateBoard:initView()
	self.bgView = display.newSprite("#gameBoardBg.png")
	local size = self.bgView:getContentSize()
	self.bgView:setPosition(size.width*0.5,size.height*0.5)
	self.bgView:addTo(self)
	self:setContentSize(size)

	self.lowerLayer = display.newLayer():addTo(self)
	self.itemLayer = display.newLayer():addTo(self)
	self.upperLayer = display.newLayer():addTo(self)

	for i=1,cc.exports.EliminateMarcos.BOARD_ROW do
		for j =1,cc.exports.EliminateMarcos.BOARD_COLOUM do
			local grid = EliminateGrid.new(j,i)
			grid:setPosition(cc.exports.EliminateUtil:grid2Pos(j,i))
			print(cc.exports.EliminateUtil:pos2Grid(grid:getPosition()))
			self.lowerLayer:addChild(grid)
			self.grids[i..j] = grid
		end
	end
end

return EliminateBoard