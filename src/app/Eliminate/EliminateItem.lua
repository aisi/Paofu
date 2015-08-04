--
-- Author: cmwang
-- Date: 2015-08-03 14:44:25
--
local U = cc.exports.EliminateUtil
local M = cc.exports.EliminateMarcos
local EliminateItem = class("EliminateItem")

function EliminateItem:ctor(itemId)
	self:initWithItemId(itemId)
end

function EliminateItem:initWithItemId(itemId)
	self.view = display.newSprite("#"..itemId..".png")
	self.itemId = itemId
	self.colorType = itemId-20100
end

function EliminateItem:setGridPos(coloum,row)
	self.view:setPosition(U:grid2Pos(coloum, row))
end

function EliminateItem:addToView(target)
	self.view:addTo(target)
end
return EliminateItem