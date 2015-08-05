--
-- Author: cmwang
-- Date: 2015-08-04 16:26:46
--
local M = cc.exports.EliminateMarcos
local U = cc.exports.EliminateUtil
local EliminateCheckAction = class("EliminateCheckAction")

function EliminateCheckAction:ctor(actionContext)
	self.context = actioContext
end

function EliminateCheckAction:doStep()
	
end

function EliminateCheckAction:checkSwap(grid0,grid1)

end

function EliminateCheckAction:checkEliminate(boardData)
	for row = 0,M.BOARD_ROW-1 do
		for coloum = 0,M.BOARD_COLOUM-1 do
			local chainRow,chainColoum,grid,eliminateGrids
			local rowLength,coloumLength
			grid = boardData[U:gridPos2Index(coloum, row)]
			chainRow = self:rowChain(boardData, grid)
			chainColoum = self:coloumChain(boardData, grid)
			eliminateGrids = {}
			rowLength = table.nums(chainRow)
			coloumLength = table.nums(chainColoum)

			if coloumLength >=4 then
				print("coloum bird"..coloumLength)
			elseif rowLength>=4 then
				print("row bird"..rowLength)
			elseif coloumLength>=2 and rowLength>=2 then
				print("bomb"..rowLength..coloumLength)
			elseif coloumLength>=3 then
				print ("lighting coloum"..coloumLength)
			elseif rowLength>=3 then
				print ("lighting row"..rowLength)
			end

			if rowLength >=2 then
				table.merge(eliminateGrids, chainRow)
			end
			if coloumLength >=2 then
				table.merge(eliminateGrids,chainColoum)
			end

			table.insert(eliminateGrids,grid)

			if table.nums(eliminateGrids)>=3 then
				for k,v in pairs(eliminateGrids) do
					v:onEliminate()
				end
			end
		end
	end
end

function EliminateCheckAction:coloumChain(boardData,grid)
	local chainList = {}
	local nextCol = grid.coloum+1
	local nextRow = grid.row
	local nextGrid = boardData[U:gridPos2Index(nextCol,nextRow)]

	while nextGrid~=nil and nextGrid.cube~=nil and nextGrid.cube.colorType==grid.cube.colorType do
		table.insert(chainList,nextGrid)
		nextCol = nextCol+1
		nextGrid = boardData[U:gridPos2Index(nextCol,nextRow)]
	end

	nextCol = grid.coloum-1
	nextGrid = boardData[U:gridPos2Index(nextCol,nextRow)]
	while nextGrid~=nil and nextGrid.cube~=nil and nextGrid.cube.colorType == grid.cube.colorType do
		table.insert(chainList,nextGrid)
		nextCol= nextCol - 1
		nextGrid = boardData[U:gridPos2Index(nextCol,nextRow)]
	end

	return chainList
end

function EliminateCheckAction:rowChain(boardData,grid)	
	local chainList = {}
	local nextCol = grid.coloum
	local nextRow = grid.row+1
	local nextGrid = boardData[U:gridPos2Index(nextCol,nextRow)]

	while nextGrid~=nil and nextGrid.cube~=nil and nextGrid.cube.colorType==grid.cube.colorType do
		table.insert(chainList,nextGrid)
		nextRow = nextRow + 1
		nextGrid = boardData[U:gridPos2Index(nextCol,nextRow)]
	end

	local nextRow = grid.row-1
	nextGrid = boardData[U:gridPos2Index(nextCol,nextRow)]
	while nextGrid~=nil and nextGrid.cube~=nil and nextGrid.cube.colorType == grid.cube.colorType do
		table.insert(chainList,nextGrid)
		nextRow = nextRow - 1
		nextGrid = boardData[U:gridPos2Index(nextCol,nextRow)]
	end

	return chainList
end

return EliminateCheckAction

