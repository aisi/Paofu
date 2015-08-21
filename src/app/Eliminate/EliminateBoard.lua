--
-- Author: cmwang
-- Date: 2015-07-30 16:02:02
--

require "app/Eliminate/EliminateMarcos"
require "app/Eliminate/EliminateUtil"
require "app/Eliminate/EliminateGlobal"

--local scheduler = require("framework.scheduler")
local M = cc.exports.EliminateMarcos
local U = cc.exports.EliminateUtil
local G = cc.exports.EliminateGlobal

local EliminateGrid = import(".EliminateGrid")
local EliminateItem = import(".EliminateItem")
local EliminateCheckAction = import(".Actions.EliminateCheckAction")
local SwepOperation = import(".Operations.SwepOperation")

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
	self:initActions()

	G.EliminateContext = self
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

	local rect  = self.bgView:getBoundingBox()
	rect.width = size.width
	rect.height =size.height
	rect.x=0
	rect.y=0
	local clip = cc.ClippingRectangleNode:create(rect)
	--clip:setClippingRegion(rect)
	

	self.bgView:setPosition(size.width*0.5,size.height*0.5)
	self.bgView:addTo(self)
	self:setContentSize(size)
	clip:addTo(self)

	self.lowerLayer = display.newLayer():addTo(clip)
	self.itemLayer = display.newLayer():addTo(clip)
	self.upperLayer = display.newLayer():addTo(clip)
	self.touchLayer = display.newLayer():addTo(clip)
end

function EliminateBoard:initGrids()
	for i=0,M.BOARD_ROW-1 do
		for j =0,M.BOARD_COLOUM-1 do
			local grid = EliminateGrid.new(j,i)
			self.lowerLayer:addChild(grid.bgView)
			self.grids[U:gridPos2Index(j,i)] = grid
		end
	end
	for i=0,2 do
		self.grids[i].isEntrance = true
	end
	

end

function EliminateBoard:initItems()
	local mapData = M.testData
	for index,value in pairs(mapData) do
		local item = EliminateItem.new(value)
		local coloum,row = U:index2GridPos(index)
		item:setGridPos(coloum,row)
		item:addToView(self.itemLayer)
		self.grids[index]:addCube(item)
	end
end

function EliminateBoard:initActions()
	self.checkEliminateAction = EliminateCheckAction.new(self)
	self:scheduleUpdateWithPriorityLua(function()
		self.checkEliminateAction:doStep()
		--collectgarbage("collect")
   		--print("memory3:", collectgarbage("count"))
	end,2)	
	self.swepOperation = SwepOperation.new(self) 

end
return EliminateBoard