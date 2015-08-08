--
-- Author: cmwang
-- Date: 2015-08-07 16:07:18
--
local ItemDropAction = class("ItemDropAction")

function ItemDropAction:ctor(target,time)
	self.target = target
	self.time = time
	self.delay = 0
end

function ItemDropAction:run()
	
end

function ItemDropAction:step(dt)

end

return ItemDropAction