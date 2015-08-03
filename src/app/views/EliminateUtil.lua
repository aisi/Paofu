--
-- Author: cmwang
-- Date: 2015-08-03 15:44:24
--
cc.exports.EliminateUtil = cc.exports.EliminateUtil or {}

function EliminateUtil:grid2Pos(coloum,row)	

	return (coloum-1)*cc.exports.EliminateMarcos.ITEM_WIDTH+cc.exports.EliminateMarcos.PADDING_X,
		   (cc.exports.EliminateMarcos.BOARD_ROW-row)*cc.exports.EliminateMarcos.ITEM_HEIGHT+cc.exports.EliminateMarcos.PADDING_Y
				
end

function EliminateUtil:pos2Grid(x,y)
	local tmpX = x - cc.exports.EliminateMarcos.PADDING_X
	local gridX = math.ceil(tmpX/cc.exports.EliminateMarcos.ITEM_WIDTH)+1
	local tmpY = y-cc.exports.EliminateMarcos.PADDING_Y
	local gridY = cc.exports.EliminateMarcos.BOARD_ROW-math.ceil(tmpY/cc.exports.EliminateMarcos.ITEM_HEIGHT)
	return gridX,gridY
end

function EliminateUtil:index2GridPos(index)
	local tmpRow = math.ceil(index/cc.exports.EliminateMarcos.BOARD_ROW)
	local tmpColoum = index - tmpRow*cc.exports.EliminateMarcos.BOARD_ROW
	return tmpColoum,tmpRow
end

function EliminateUtil:gridPos2Index(coloum,row)
	return row*cc.exports.EliminateMarcos.BOARD_ROW+coloum
end