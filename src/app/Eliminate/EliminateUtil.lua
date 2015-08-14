--
-- Author: cmwang
-- Date: 2015-08-03 15:44:24
--
cc.exports.EliminateUtil = cc.exports.EliminateUtil or {}

function EliminateUtil:grid2Pos(coloum,row)	

	return (coloum)*cc.exports.EliminateMarcos.ITEM_WIDTH
			+cc.exports.EliminateMarcos.PADDING_X
			+cc.exports.EliminateMarcos.ITEM_WIDTH*0.5,
		   (cc.exports.EliminateMarcos.BOARD_ROW-1-row)*cc.exports.EliminateMarcos.ITEM_HEIGHT
		   +cc.exports.EliminateMarcos.PADDING_Y+cc.exports.EliminateMarcos.ITEM_HEIGHT*0.5
				
end

function EliminateUtil:pos2Grid(x,y)
	local tmpX = x - cc.exports.EliminateMarcos.PADDING_X
	local gridX = math.floor(tmpX/cc.exports.EliminateMarcos.ITEM_WIDTH)
	local tmpY = y-cc.exports.EliminateMarcos.PADDING_Y
	local gridY = cc.exports.EliminateMarcos.BOARD_ROW-math.floor(tmpY/cc.exports.EliminateMarcos.ITEM_HEIGHT)-1
	return gridX,gridY
end

function EliminateUtil:index2GridPos(index)
	local tmpRow = math.floor(index/cc.exports.EliminateMarcos.BOARD_ROW)
	local tmpColoum = index - tmpRow*cc.exports.EliminateMarcos.BOARD_ROW
	return tmpColoum,tmpRow
end

function EliminateUtil:gridPos2Index(coloum,row)
	--print(coloum.."  "..row)
	if coloum >=cc.exports.EliminateMarcos.BOARD_COLOUM 
		or coloum<0 
		or  row >=cc.exports.EliminateMarcos.BOARD_ROW 
		or row <0 then
		return -1
	end
	return row*cc.exports.EliminateMarcos.BOARD_ROW+coloum
end

function EliminateUtil:itemInArr(t,value)
	for k,v in pairs(t) do
		if v==value then
			return true
		end
	end
	return false
end