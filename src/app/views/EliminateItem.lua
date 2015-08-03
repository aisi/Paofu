--
-- Author: cmwang
-- Date: 2015-08-03 14:44:25
--
import(".EliminateUtil")

local EliminateItem = class("EliminateItem")

function EliminateItem:ctor(itemId)
	self:initWithItemId(itemId)
end

function EliminateItem:initWithItemId(itemId)
	self.view = display.createSprite("#"..20100+itemId..".png")
end

function EliminateItem:setGridPos(coloum,row)
	self:setPosition(cc.exports.EliminateUtil:grid2Pos(coloum, row))
end
return EliminateItem