--
-- Author: cmwang
-- Date: 2015-07-30 16:02:02
--

require "app/Eliminate/EliminateMarcos"
require "app/Eliminate/EliminateUtil"

local M = cc.exports.EliminateMarcos
local U = cc.exports.EliminateUtil

local EliminateGrid = import(".EliminateGrid")
local EliminateItem = import(".EliminateItem")

local EliminateBoard = class("EliminateBoard",function (  )
	local node = display.newNode()
	return node
end)

function EliminateBoard:ctor()
	self:restart()
	self:initData()
	self:initBackground()
	self:initGrids()
	self:initItems()
	performWithDelay(self,function()
		print("-------------")
		print(" delay call")
		print("-------------")
	end, 5.0)
end

function EliminateBoard:restart()
	self.grids = nil
end

function EliminateBoard:initData()
	self.grids = {}
end

function EliminateBoard:initBackground()
	self.bgView = display.newSprite("#gameBoardBg.png")
	local size = self.bgView:getContentSize()
	self.bgView:setPosition(size.width*0.5,size.height*0.5)
	self.bgView:addTo(self)
	self:setContentSize(size)

	self.lowerLayer = display.newLayer():addTo(self)
	self.itemLayer = display.newLayer():addTo(self)
	self.upperLayer = display.newLayer():addTo(self)
end

function EliminateBoard:initGrids()
	for i=0,M.BOARD_ROW-1 do
		for j =0,M.BOARD_COLOUM-1 do
			local grid = EliminateGrid.new(j,i)
			self.lowerLayer:addChild(grid.bgView)
			self.grids[U:gridPos2Index(j,i)] = grid
		end
	end
end

function EliminateBoard:initItems()
	local mapData = M.testData
	for index,value in pairs(mapData) do
		local item = EliminateItem.new(value)
		item:setGridPos(U:index2GridPos(index))
		item:addToView(self.itemLayer)
		self.grids[index]:addItem(item)
	end
end
return EliminateBoard