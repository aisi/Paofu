--
-- Author: cmwang
-- Date: 2015-07-30 16:50:00
--
--import(".EliminateMarcos")
local U = cc.exports.EliminateUtil

local EliminateGrid = class(EliminateGrid, function()
	local node = display.newNode()
	return node
end)

function EliminateGrid:ctor(coloum,row)
	self.itemList = {}
	self.coloum = coloum
	self.row = row

	self.bgIndex = 0
	self:initBgView()
end

function EliminateGrid:initBgView()
	if (self.coloum+self.row)%2==0 then
		self.bgView = display.newSprite("#tilebg0.png")
	else
		self.bgView = display.newSprite("#tilebg1.png")
	end
	self.bgView:setPosition(U:grid2Pos(self.coloum,self.row))
end

function EliminateGrid:addItem(item)
	self.itemList[#self.itemList+1] = item
	self.colorType = item.colorType
end

return EliminateGrid