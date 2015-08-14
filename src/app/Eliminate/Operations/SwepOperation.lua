--
-- Author: cmwang
-- Date: 2015-08-14 15:15:50
--
local M = cc.exports.EliminateMarcos
local U = cc.exports.EliminateUtil
local G = cc.exports.EliminateGlobal

local SwepOperation = class("SwepOperation")
function SwepOperation:ctor(Context)
    self.actived = false
	self.context = Context
    self.gridOne = nil
    self.gridTwo = nil

	self.context.touchLayer:onTouch( function(event)
        -- event.name 是触摸事件的状态：began, moved, ended, cancelled
        -- event.x, event.y 是触摸点当前位置
        -- event.prevX, event.prevY 是触摸点之前的位置
        local pt = self.context.touchLayer:convertToNodeSpace(cc.p(event.x,event.y))
        local label = string.format("sprite: %s x,y: %0.2f, %0.2f", event.name, pt.x, pt.y)
       -- print(label)
        if self.actived then
            if event.name == "began" then
                local coloum,row =  U:pos2Grid(pt.x,pt.y)
                --print(coloum.." "..row)
                local grid = G.EliminateContext.grids[U:gridPos2Index(coloum, row)]
                if grid ==nil then
                    return self.actived
                end
                if self.gridOne ==nil then
                    if grid~=nil and grid.cube~=nil and grid.cube:canMove() then
                        self.gridOne = grid
                    end
                else
                    if math.abs(self.gridOne.row-grid.row)+math.abs(self.gridOne.coloum-grid.coloum) == 1 then
                        if grid~=nil and grid.cube~=nil and grid.cube:canMove() then
                            self.gridTwo = grid
                            self:checkSwap()
                        end
                    else
                        if grid~=nil and grid.cube~=nil and grid.cube:canMove() then
                            self.gridOne = grid
                        end
                    end
                end
            elseif event.name == "moved" then
                if self.gridOne ~=nil then
                    local coloum,row =  U:pos2Grid(pt.x,pt.y)
                    --print(coloum.." "..row)
                    local grid = G.EliminateContext.grids[U:gridPos2Index(coloum, row)]
                    if math.abs(self.gridOne.row-grid.row)+math.abs(self.gridOne.coloum-grid.coloum) == 1 then
                        if grid~=nil and grid.cube~=nil and grid.cube:canMove() then
                            self.gridTwo = grid
                            self:checkSwap()
                        end
                    end
                end
            end
        end

        return self.actived
    end)
end


function SwepOperation:checkSwap()

    if self.gridOne.cube.colorType == self.gridTwo.cube.colorType then
        self:runFailAction()
    else
        local tmp = self.gridOne.cube
        self.gridOne.cube = self.gridTwo.cube
        self.gridTwo.cube = tmp

        local result = table.nums(self:rowChain(G.EliminateContext.grids,self.gridOne))>=3 or
                       table.nums(self:coloumChain(G.EliminateContext.grids,self.gridOne))>=3 or
                       table.nums(self:rowChain(G.EliminateContext.grids,self.gridTwo))>=3 or
                       table.nums(self:coloumChain(G.EliminateContext.grids,self.gridTwo))>=3

        local tmp = self.gridOne.cube
        self.gridOne.cube = self.gridTwo.cube
        self.gridTwo.cube = tmp
        
        if result  then
            self:runSuccessAction()
        else
            self:runFailAction() 
        end
    end


end

function SwepOperation:runFailAction()
    local tmpPosX1 = self.gridOne.cube.view:getPositionX()
    local tmpPosX2 = self.gridTwo.cube.view:getPositionX()
    local tmpPosY1 = self.gridOne.cube.view:getPositionY()
    local tmpPosY2 = self.gridTwo.cube.view:getPositionY()

    local seq1 = cc.Sequence:create(
        cc.MoveTo:create(0.22, cc.p(tmpPosX2,tmpPosY2)),
        cc.MoveTo:create(0.22, cc.p(tmpPosX1,tmpPosY1))
        )
    local seq2 = cc.Sequence:create(
        cc.MoveTo:create(0.22, cc.p(tmpPosX1,tmpPosY1)),
        cc.MoveTo:create(0.22, cc.p(tmpPosX2,tmpPosY2)),
        cc.CallFunc:create(function()
            self.gridOne = nil
            self.gridTwo =  nil
            self.actived = true
        end)
        )

    self.gridOne.cube.view:runAction(seq1)
    self.gridTwo.cube.view:runAction(seq2)
   
    self.actived = false
end

function SwepOperation:runSuccessAction()
  
    local tmpPosX1 = self.gridOne.cube.view:getPositionX()
    local tmpPosX2 = self.gridTwo.cube.view:getPositionX()
    local tmpPosY1 = self.gridOne.cube.view:getPositionY()
    local tmpPosY2 = self.gridTwo.cube.view:getPositionY()

    local seq1 = cc.Sequence:create(
        cc.MoveTo:create(0.22, cc.p(tmpPosX2,tmpPosY2))
        )
    local seq2 = cc.Sequence:create(
        cc.MoveTo:create(0.22, cc.p(tmpPosX1,tmpPosY1)),
        cc.CallFunc:create(function()
            local tmp = self.gridOne.cube
            self.gridOne.cube = self.gridTwo.cube
            self.gridTwo.cube = tmp

            self.gridOne.cube.row = self.gridOne.row
            self.gridOne.cube.coloum = self.gridOne.coloum
            self.gridTwo.cube.row = self.gridTwo.row
            self.gridTwo.cube.coloum = self.gridTwo.coloum

            self.gridOne = nil
            self.gridTwo =  nil
        end)
        )

    self.gridOne.cube.view:runAction(seq1)
    self.gridTwo.cube.view:runAction(seq2)
    

    self.actived = false
end



function SwepOperation:coloumChain(boardData,grid)
    local chainList = {}
    table.insert(chainList,grid)
    local nextCol = grid.coloum+1
    local nextRow = grid.row
    local nextGrid = boardData[U:gridPos2Index(nextCol,nextRow)]

    while nextCol<M.BOARD_COLOUM 
        and nextGrid~=nil 
        and nextGrid.cube~=nil
        and nextGrid.cube.colorType==grid.cube.colorType 
        and nextGrid.cube:canEliminate() do
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
        and nextGrid.cube:canEliminate() do
        table.insert(chainList,nextGrid)
        nextCol= nextCol - 1
        nextGrid = boardData[U:gridPos2Index(nextCol,nextRow)]
    end

    return chainList
end

function SwepOperation:rowChain(boardData,grid)  
    local chainList = {}
    table.insert(chainList,grid)
    local nextCol = grid.coloum
    local nextRow = grid.row+1
    local nextGrid = boardData[U:gridPos2Index(nextCol,nextRow)]

    while nextRow<M.BOARD_ROW 
        and nextGrid~=nil 
        and nextGrid.cube~=nil 
        and nextGrid.cube.colorType==grid.cube.colorType
        and nextGrid.cube:canEliminate() do
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
        and nextGrid.cube:canEliminate() do
        table.insert(chainList,nextGrid)
        nextRow = nextRow - 1
        nextGrid = boardData[U:gridPos2Index(nextCol,nextRow)]
    end

    return chainList
end
function SwepOperation:setStable(isStable)
    if self.gridOne ==nil and self.gridTwo==nil and isStable then
        self.actived = true
    end
end
return SwepOperation