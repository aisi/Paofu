--
-- Author: cmwang
-- Date: 2015-08-03 14:44:25
--
local U = cc.exports.EliminateUtil
local M = cc.exports.EliminateMarcos
local G = cc.exports.EliminateGlobal

local EliminateItem = class("EliminateItem")

function EliminateItem:ctor(itemId)
	self:initWithItemId(itemId)
end

function EliminateItem:initWithItemId(itemId)
	self.view = display.newSprite("#"..itemId..".png")
	self.itemId = itemId
	self.colorType = itemId-20100
	self.locked = false
end

function EliminateItem:setGridPos(coloum,row)
	self.coloum = coloum
	self.row = row
	self.view:setPosition(U:grid2Pos(coloum, row))
end

function EliminateItem:addToView(target)
	self.view:addTo(target)
end

function EliminateItem:onEliminate()
	self.locked = true
	self.view:stopAllActions()
	local seq = cc.Sequence:create(
		cc.ScaleTo:create(0.2,0.0),
		cc.CallFunc:create(function()
			self.view:removeSelf()
			G.EliminateContext.grids[U:gridPos2Index(self.coloum, self.row)].cube = nil
		end)
		)
	self.view:runAction(seq)
end

function EliminateItem:gotoGrid(grid)
	local disY =  grid.row - self.row
	self.coloum = grid.coloum
	self.row = grid.row
	grid.cube  = self
	print(disY)
	self.locked = true

	local seq = cc.Sequence:create(
		cc.EaseIn:create(cc.MoveTo:create(math.sqrt(disY/M.DROP_UNIT_ACC), cc.p(U:grid2Pos(grid.coloum,  grid.row))),2),
		cc.CallFunc:create(function()
			self.locked = false
		end),
		cc.MoveBy:create(0.05, cc.p(0,5)),
		cc.MoveBy:create(0.05, cc.p(0,-5))
		)
	self.view:runAction(seq)

	return true
end
return EliminateItem