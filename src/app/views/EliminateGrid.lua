--
-- Author: cmwang
-- Date: 2015-07-30 16:50:00
--
import(".EliminateMarcos")
local EliminateGrid = class(EliminateGrid, function()
	local node = display.newNode()
	return node
end)

function EliminateGrid:ctor(coloum,row)
	self.itemList = {}
	self.coloum = coloum
	self.row = row
	self:initBgView()
end

function EliminateGrid:initBgView()
	if (self.coloum+self.row)%2==0 then
		self.bgView = display.newSprite("#tilebg0.png")
	else
		self.bgView = display.newSprite("#tilebg1.png")
	end
	local bgViewSize = self.bgView:getContentSize()
	self.bgView:setPosition(cc.exports.ITEM_WIDTH*0.5,cc.exports.ITEM_HEIGHT*0.5):addTo(self)
end

return EliminateGrid