--
-- Author: cmwang
-- Date: 2015-07-30 16:15:43
--
cc.exports.EliminateMarcos = cc.exports.EliminateMarcos or {}

cc.exports.EliminateMarcos.ITEM_WIDTH = 68
cc.exports.EliminateMarcos.ITEM_HEIGHT = 68

cc.exports.EliminateMarcos.BOARD_ROW = 8
cc.exports.EliminateMarcos.BOARD_COLOUM = 8

cc.exports.EliminateMarcos.PADDING_X = 3
cc.exports.EliminateMarcos.PADDING_Y = 3

cc.exports.EliminateMarcos.testData = {}

for i=0,63 do
	local v = math.random(20101,20106)
	cc.exports.EliminateMarcos.testData[i] = v
end