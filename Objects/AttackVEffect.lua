AttackVEffect =  GameObject:extend()

function AttackVEffect:new(area, x, y, opts)
    AttackVEffect.super.new(self, area, x, y, opts)
    self.first = true
    self.depth=75
    self.current_color = {1, 0, 0}
    self.timer:after(0.2, function() 
        self.current_color = self.color 
        self.timer:after(0.35, function()
            self.dead = true
        end)
    end)
    self.visible = true
    self.timer:after(0.2, function()
        self.timer:every(0.05, function() self.visible = not self.visible end, 6)
        self.timer:after(0.35, function() self.visible = true end)
    end)
    self.sx, self.sy = 1, 1
    self.timer:tween(0.35, self, {sx = 2, sy = 2}, 'in-out-cubic')
end

function AttackVEffect:update(dt)
    AttackVEffect.super.update(self, dt)
    if self.player then 
    	self.x = self.player.x + self.d*math.cos(self.player.r) 
    	self.y = self.player.y + self.d*math.sin(self.player.r) 
  	end
end

function AttackVEffect:draw()     
    if not self.visible then return end

    love.graphics.setColor(self.current_color)
    draft:rhombus(self.x, self.y, math.floor(1.34*self.w), math.floor(1.34*self.h), 'fill')
    draft:rhombus(self.x, self.y, self.sx*2*self.w, self.sy*2*self.h, 'line')
    love.graphics.setColor(1, 0, 0)
end
function AttackVEffect:destroy()   
    AttackVEffect.super.destroy(self)
end



