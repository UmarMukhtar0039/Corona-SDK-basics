local toast = {displayGroup = nil}
local dt = require("deltaTime")

local timer = 0
local timeLimit = 3

toastQueue = {} -- stores only strings passed in showToast
local toastObject = {} -- an object that will have text and box display objects
local removeToast

---------------------------

local function update( )
    dt = deltaTime.getDelta()
    -- if toast queue is empty donot move forward
    if #toastQueue ~= 0 then 
        timer = timer + dt
        if timer > timeLimit then -- if time limit is reached and there is an    
            if toastObject.text ~= nil then
                temp = table.remove(toastQueue, 1)
                temp = nil
                removeToast()
            end
            if  #toastQueue ~= 0 then              
                toastObject.text = display.newText(toast.displayGroup,tostring(toastQueue[1]), display.contentCenterX, display.contentCenterY) 
                toastObject.box = display.newRect(toast.displayGroup, toastObject.text.x, toastObject.text.y, toastObject.text.width, toastObject.text.height)
                toastObject.box.alpha = 0.3
            end
            timer = 0
        end
    end
end

---------------------------

-- this function is called from update when we have to delete a toast from display
function removeToast( )
    toastObject.text:removeSelf()
    toastObject.text = nil
    toastObject.box:removeSelf()
    toastObject.box = nil
    
end

---------------------------

-- this function will only add string to a toastQueue
-- called from external script
function toast.showToast( string )
    toastQueue[#toastQueue+1] = string
    toastObject.text = nil
    toastObject.box = nil
end

---------------------------

Runtime:addEventListener("enterFrame", update)

return toast