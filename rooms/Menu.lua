Menu = Object:extend()

function Menu:new()
    self.timer = Timer()

    self.font = fonts.Anonymous_8
    self.main_canvas = love.graphics.newCanvas(gw, gh)

    self.lines = {}
    self.line_y = 8
    camera:lookAt(gw/2, gh/2)

    self.inputting = false
    self.input_text = {}
    self.base_input_text = {'[', skill_point_color, 'root', default_color, ']arch~ '}
    self.cursor_visible = true
    self.timer:every('cursor', 0.5, function() self.cursor_visible = not self.cursor_visible end)

    self.modules = {}

    self:addLine(1, {'Start', boost_color, ' start'})
    self:addLine(1, {'Start Level 2', boost_color, ' start 2'})
    self:addLine(1, {'Start Level 3', boost_color, ' start 3'})
    self:addLine(1, {'Start Level 4', boost_color, ' start 4'})
    self:addLine(1, {'Start Infinite', boost_color, ' infinite'})
    self:addLine(1, {'Exit', boost_color, ' exit'})
    self:addInputLine(1.5)
end

function Menu:update(dt)
    self.timer:update(dt)
    for _, module in ipairs(self.modules) do module:update(dt) end

    if self.inputting then
        if input:pressed('return') then
            self.inputting = false

            self.line_y = self.line_y + 12
            local input_text = ''
            for _, character in ipairs(self.input_text) do input_text = input_text .. character end
            self.input_text = {}            
            if input_text=='start' then
                gotoRoom('Stage1')          
            end
            if input_text=='start 2' then
                gotoRoom('Stage2')          
            end
            if input_text=='start 3' then
                gotoRoom('Stage3')          
            end
            if input_text=='start 4' then
                gotoRoom('Stage4')          
            end
            if input_text=='infinite' then
                gotoRoom('Stage')          
            end
            if input_text=='exit' then
                love.event.quit()
            end
        end
        if input:pressRepeat('backspace', 0.02, 0.2) then 
            table.remove(self.input_text, #self.input_text) 
            self:updateText()
        end
    end
end

function Menu:draw()
    love.graphics.setCanvas(self.main_canvas)
    love.graphics.clear()
    camera:attach(0, 0, gw, gh)
    for _, line in ipairs(self.lines) do love.graphics.draw(line.text, line.x, line.y) end
    if self.inputting and self.cursor_visible then
        local r, g, b = unpack(default_color)
        love.graphics.setColor(r, g, b, 96)
        local input_text = ''
        for _, character in ipairs(self.input_text) do input_text = input_text .. character end
        local x = self.font:getWidth('[root]arch~ ' .. input_text)
        love.graphics.rectangle('fill', 8 + x, self.lines[#self.lines].y, self.font:getWidth('w'), self.font:getHeight())
        love.graphics.setColor(r, g, b, 255)
    end
    for _, module in ipairs(self.modules) do module:draw() end
    camera:detach()
    love.graphics.setCanvas()

    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.setBlendMode('alpha', 'premultiplied')
    love.graphics.draw(self.main_canvas, 0, 0, 0, sx, sy)
    love.graphics.setBlendMode('alpha')
end

function Menu:destroy()
    
end

function Menu:addLine(delay, text)
    self.timer:after(delay, function() 
        table.insert(self.lines, {x = 8, y = self.line_y, text = love.graphics.newText(self.font, text)}) 
        self.line_y = self.line_y + 12
    end)
end

function Menu:addInputLine(delay)
    self.timer:after(delay, function()
        table.insert(self.lines, {x = 8, y = self.line_y, text = love.graphics.newText(self.font, self.base_input_text)})
        self.line_y = self.line_y + 12
        self.inputting = true
    end)
end

function Menu:textinput(t)
    if self.inputting then
        table.insert(self.input_text, t)
        self:updateText()
    end
end

function Menu:updateText()
    local base_input_text = table.copy(self.base_input_text)
    local input_text = ''
    for _, character in ipairs(self.input_text) do input_text = input_text .. character end
    table.insert(base_input_text, input_text)
    self.lines[#self.lines].text:set(base_input_text)
    self.cursor_visible = true
    self.timer:every('cursor', 0.5, function() self.cursor_visible = not self.cursor_visible end)
end
