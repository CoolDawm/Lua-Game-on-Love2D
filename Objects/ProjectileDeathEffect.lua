ProjectileDeathEffect =  GameObject:extend()

function ProjectileDeathEffect:new(area, x, y, opts)
    ProjectileDeathEffect.super.new(self, area, x, y, opts)
    self.first = true
    self.depth=75
    self.timer:after(0.1, function()
        self.first = false
        self.second = true
        self.timer:after(0.15, function()
            self.second = false
            self.dead = true
        end)
    end)
end

function ProjectileDeathEffect:update(dt)
    ProjectileDeathEffect.super.update(self, dt)
    if self.player then 
    	self.x = self.player.x + self.d*math.cos(self.player.r) 
    	self.y = self.player.y + self.d*math.sin(self.player.r) 
  	end
end

function ProjectileDeathEffect:draw()     
    if self.first then love.graphics.setColor(1,0,0)
    elseif self.second then love.graphics.setColor(self.color) end
    love.graphics.rectangle('fill', self.x - self.w/2, self.y - self.w/2, self.w, self.w)
end
function ProjectileDeathEffect:destroy()    
    ProjectileDeathEffect.super.destroy(self)       
end
function Projectile:die()
    self.dead = true
    self.area:addGameObject('ProjectileDeathEffect', self.x, self.y, 
    {color = hp_color, w = 3*self.s})
end


