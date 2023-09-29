Stage2 = Object:extend()

function Stage2:new()
    self.area = Area(self)
    self.area:addPhysicsWorld()
    self.timer = Timer()
    self.area.world:addCollisionClass('Enemy')
    self.area.world:addCollisionClass('Player')
    self.area.world:addCollisionClass('Projectile', {ignores = {'Projectile', 'Player'}})
    self.area.world:addCollisionClass('Collectable', {ignores = {'Collectable', 'Projectile'}})
    self.area.world:addCollisionClass('EnemyProjectile', {ignores = {'EnemyProjectile', 'Projectile', 'Enemy'}})
    self.font = fonts.m5x7_16
    self.timer1=0
    self.main_canvas = love.graphics.newCanvas(gw, gh)
    self.player = self.area:addGameObject('Player', gw/2, gh/2)
    
end

function Stage2:update(dt)
    
    camera.smoother = Camera.smooth.damped(5)
    camera:lockPosition(dt, gw/2, gh/2)

    self.area:update(dt)
    if self.timer1 <= 0 then
        self.area:addGameObject('Rock', 0, 0)
        self.area:addGameObject('CleanRock',0,0)
        self.timer1=70
    end
    if self.player.score>=350 then
        self.area:addGameObject('InfoText', self.x, self.y, {text = 'NextStage', color = {1,1,1}})
        slow(0.15, 1)
        gotoRoom('Stage3')
    end
    self.timer1=self.timer1-1
end

function Stage2:draw()
    love.graphics.setCanvas(self.main_canvas)
    love.graphics.clear()
    camera:attach(0, 0, gw, gh)
        self.area:draw()
    camera:detach()
    love.graphics.setFont(self.font)
    love.graphics.setColor(default_color)
    love.graphics.print(self.player.score, gw - 20, 10, 0, 1, 1,
    math.floor(self.font:getWidth(self.player.score)/2), self.font:getHeight()/2)
    love.graphics.setColor(255, 255, 255)
    -- HP
    local r, g, b = unpack(hp_color)
    local hp, max_hp = self.player.hp, self.player.max_hp
    love.graphics.setColor(r, g, b)
    love.graphics.rectangle('fill', gw/2 -20, gh - 16, 60*(hp/max_hp), 6)
    love.graphics.setColor(r - 32, g - 32, b - 32)
    love.graphics.rectangle('line', gw/2-20 , gh - 16, 60, 6)
    love.graphics.setCanvas()
    -- Boost
    local boost, max_boost = self.player.boost, self.player.max_boost
    love.graphics.setColor(0, 0, 1)
    love.graphics.rectangle('fill', gw/2+140, 16, 100*(boost/max_boost), 6)
    love.graphics.setColor(r - 32, g - 32, b - 32)
    love.graphics.rectangle('line', gw/2+140, 16, 100, 6)
    love.graphics.setCanvas()
    -- Ammo
    local ammo, max_ammo = self.player.ammo, self.player.max_ammo
    love.graphics.setColor(0, 1, 0)
    love.graphics.rectangle('fill', gw/2+250, 16, 100*(ammo/max_ammo), 6)
    love.graphics.setColor(r - 32, g - 32, b - 32)
    love.graphics.rectangle('line', gw/2+250, 16, 100, 6)
    love.graphics.setCanvas()
    
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.setBlendMode('alpha', 'premultiplied')
    love.graphics.draw(self.main_canvas, 0, 0, 0, sx, sy)
    love.graphics.setBlendMode('alpha')
end
function Stage2:finish()
    timer:after(1, function()
        gotoRoom('Menu')
    end)
end
function Stage2:destroy()
    self.area:destroy()
    self.area = nil
    self.player = nil
end
