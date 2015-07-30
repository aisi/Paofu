--
-- Author: cmwang
-- Date: 2015-07-30 16:02:02
--
import(".EliminateMarcos")
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
	self.bgView = display.newSprite("gameBoardBg.png")
	local size = self.bgView:getContentSize()
	self.bgView:setPosition(size.width*0.5,size.height*0.5)
	self.bgView:addTo(self)
	self:setContentSize(size)

	for i=1,cc.exports.BOARD_ROW do
		for j =1,cc.exports.BOARD_COLOUM do
			local grid = EliminateGrid.new(j,i)
			grid:setPosition((i-1)*cc.exports.ITEM_WIDTH+cc.exports.PADDING_X,
				(cc.exports.BOARD_ROW-j)*cc.exports.ITEM_HEIGHT+cc.exports.PADDING_Y)
			self:addChild(grid)
			self.grids[i..j] = grid
		end
	end
end

return EliminateBoard