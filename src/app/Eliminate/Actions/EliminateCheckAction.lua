--
-- Author: cmwang
-- Date: 2015-08-04 16:26:46
--
local M = cc.exports.EliminateMarcos
local U = cc.exports.EliminateUtil
local EliminateCheckAction = class("EliminateCheckAction")
local tip = {}
function EliminateCheckAction:ctor(actionContext)
	self.context = actionContext
end

function EliminateCheckAction:onEnter()
	print("-----------------")
	self.eliminateGrids = {}
	tip = {}
end
function EliminateCheckAction:onExit()
	
	local str = ""
	for k,v in pairs(tip) do
		str = str.." "..v
		if k%8==0 then
			print(str)
			str=""
		end
	end
	self.tip = nil
	self.eliminateGrids = nil
	print("-----------------")
end


function EliminateCheckAction:doStep()
	self:onEnter()
	self:checkBoard(self.context.grids)
	self:onExit()
end

function EliminateCheckAction:checkSwap(grid0,grid1)

end

function EliminateCheckAction:checkBoard(boardData)
	local eliminateGrids
	for row = 0,M.BOARD_ROW-1 do
		for coloum = 0,M.BOARD_COLOUM-1 do
			self:checkEliminatePerGrid(boardData,coloum,row)
		end
	end

	for k,v in pairs(self.eliminateGrids) do
		v:onEliminate()
	end
end

function EliminateCheckAction:checkEliminatePerGrid(boardData,coloum,row)
	local contactGrids = {}
	local grid = boardData[U:gridPos2Index(coloum, row)]	

	self:findContactGrids(boardData,coloum, row, contactGrids,grid.cube.colorType)
	tip[#tip+1] = (table.nums(contactGrids))
	local maxRowCount = 0
	local maxColoumCount = 0
	for k,v in pairs(contactGrids) do	
		local chainRow = self:rowChain(boardData, v)
		local chainColoum = self:coloumChain(boardData, v)
		local rowLen = table.nums(chainRow)
		local coloumLen = table.nums(chainColoum)
		maxRowCount = math.max(maxRowCount,rowLen)
		maxColoumCount = math.max(maxColoumCount,coloumLen)
		
		if rowLen >=3 then
			for key,value in pairs(chainRow) do
				if not U:itemInArr(self.eliminateGrids, value) then
					table.insert(self.eliminateGrids,value) 
				end
			end
		end

		if coloumLen >=3  then
			for key,value in pairs(chainColoum) do
				if not U:itemInArr(self.eliminateGrids, value) then
					table.insert(self.eliminateGrids,value) 
				end
			end
		end
	end
end

function EliminateCheckAction:findContactGrids(boardData,coloum,row,contactGrids,colorType)
	if row<0 or row>=M.BOARD_ROW or coloum<0 or coloum>=M.BOARD_COLOUM then
		return 
	end

	local grid = boardData[U:gridPos2Index(coloum, row)]

	if U:itemInArr(contactGrids, grid) then
		return
	end
	if grid==nil or grid.cube==nil or grid.cube.locked or grid.cube.colorType ~= colorType then
		return
	end

	table.insert(contactGrids, grid)

	self:findContactGrids(boardData,coloum-1,row,contactGrids,colorType)
	self:findContactGrids(boardData,coloum+1,row,contactGrids,colorType)
	self:findContactGrids(boardData,coloum,row-1,contactGrids,colorType)
	self:findContactGrids(boardData,coloum,row+1,contactGrids,colorType)
end

function EliminateCheckAction:coloumChain(boardData,grid)
	local chainList = {}
	table.insert(chainList,grid)
	local nextCol = grid.coloum+1
	local nextRow = grid.row
	local nextGrid = boardData[U:gridPos2Index(nextCol,nextRow)]

	while nextCol<M.BOARD_COLOUM 
		and nextGrid~=nil 
		and nextGrid.cube~=nil
		and nextGrid.cube.colorType==grid.cube.colorType 
		and not nextGrid.cube.locked do
		table.insert(chainList,nextGrid)
		nextCol = nextCol+1
		nextGrid = boardData[U:gridPos2Index(nextCol,nextRow)]
	end

	nextCol = grid.coloum-1
	nextGrid = boardData[U:gridPos2Index(nextCol,nextRow)]
	while nextCol>=0 
		and nextGrid~=nil 
		and nextGrid.cube~=nil 
		and nextGrid.cube.colorType == grid.cube.colorType
		and not nextGrid.cube.locked do
		table.insert(chainList,nextGrid)
		nextCol= nextCol - 1
		nextGrid = boardData[U:gridPos2Index(nextCol,nextRow)]
	end

	return chainList
end

function EliminateCheckAction:rowChain(boardData,grid)	
	local chainList = {}
	table.insert(chainList,grid)
	local nextCol = grid.coloum
	local nextRow = grid.row+1
	local nextGrid = boardData[U:gridPos2Index(nextCol,nextRow)]

	while nextRow<M.BOARD_ROW 
		and nextGrid~=nil 
		and nextGrid.cube~=nil 
		and nextGrid.cube.colorType==grid.cube.colorType
		and not nextGrid.cube.locked do
		table.insert(chainList,nextGrid)
		nextRow = nextRow + 1
		nextGrid = boardData[U:gridPos2Index(nextCol,nextRow)]
	end

	local nextRow = grid.row-1
	nextGrid = boardData[U:gridPos2Index(nextCol,nextRow)]
	while nextRow>=0 
		and nextGrid~=nil 
		and nextGrid.cube~=nil
		and nextGrid.cube.colorType == grid.cube.colorType 
		and not nextGrid.cube.locked do
		table.insert(chainList,nextGrid)
		nextRow = nextRow - 1
		nextGrid = boardData[U:gridPos2Index(nextCol,nextRow)]
	end

	return chainList
end

return EliminateCheckAction

