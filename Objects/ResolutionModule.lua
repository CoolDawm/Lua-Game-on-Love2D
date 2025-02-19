ResolutionModule = Object:extend()

function ResolutionModule:new(menu, y)
    self.Menu = Menu
    self.y = y

    self.Menu:addLine(0.02, 'Available resolutions: ')
    self.Menu:addLine(0.04, '    480x270')
    self.Menu:addLine(0.06, '    960x540')
    self.Menu:addLine(0.08, '    1440x810')
    self.Menu:addLine(0.10, '    1920x1080')
    self.selection_index = sx
    self.selection_widths = {
        self.console.font:getWidth('480x270'), self.console.font:getWidth('960x540'),
        self.console.font:getWidth('1440x810'), self.console.font:getWidth('1920x1080')
    }
end

function ResolutionModule:update(dt)
    if not self.active then return end

    if input:pressed('up') then
        self.selection_index = self.selection_index - 1
        if self.selection_index < 1 then self.selection_index = #self.selection_widths end
    end

    if input:pressed('down') then
        self.selection_index = self.selection_index + 1
        if self.selection_index > #self.selection_widths then self.selection_index = 1 end
    end

    if input:pressed('return') then
        self.active = false
        resize(self.selection_index)
        self.menu:addLine(0.02, '')
        self.menu:addInputLine(0.04)
    end
end

function ResolutionModule:draw()
    if not self.active then return end

    local width = self.selection_widths[self.selection_index]
    local r, g, b = unpack(default_color)
    love.graphics.setColor(r, g, b, 96)
    local x_offset = self.console.font:getWidth('    ')
    love.graphics.rectangle('fill', 8 + x_offset - 2, self.y + self.selection_index*12, 
    width + 4, self.console.font:getHeight())
    love.graphics.setColor(r, g, b, 255)
end
