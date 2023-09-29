SuperShooter = GameObject:extend()

function SuperShooter:new(area, x, y, opts)
    SuperShooter.super.new(self, area, x, y, opts)

    local direction = table.random({-1, 1})
    self.x = gw/2 + direction*(gw/2 + 48)
    self.y = random(16, gh - 16)
    self.depth=75
    self.w, self.h = 12, 6
    self.collider = self.area.world:newPolygonCollider({self.w, 0, -self.w/2, self.h, -self.w, 0, -self.w/2, -self.h})
    self.collider:setPosition(self.x, self.y)
    self.collider:setObject(self)
    self.collider:setCollisionClass('Enemy')
    self.v = -direction*random(20, 40)
    self.collider:setFixedRotation(false)
    self.collider:setAngle(direction == 1 and math.pi or 0)
    self.collider:setFixedRotation(true)
    self.collider:setLinearVelocity(self.v, 0)
    self.hp = 100
    self.timer:every(random(3, 5), function()
        self.area:addGameObject('PreAttackEffect', self.x + 1.4*self.w*math.cos(self.collider:getAngle()), self.y + 1.4*self.w*math.sin(self.collider:getAngle()), 
        {SuperShooter = self, color = {1,0,1}, duration = 1})
        self.timer:after(1, function()
            local spawnAngleOffset = math.pi/2 -- угол между соседними пулями
            local numProjectiles = 3 -- количество пуль, которые нужно спавнить
            local currentAngle = self.collider:getAngle() - spawnAngleOffset*(numProjectiles-1)/2 -- начальный угол первой пули

            for i=1, numProjectiles do
                local angle = currentAngle + (i-1)*spawnAngleOffset -- рассчитываем угол текущей пули
                self.area:addGameObject('EnemyProjectile', self.x + 1.4*self.w*math.cos(angle), self.y + 1.4*self.w*math.sin(angle), 
                {r = math.atan2(current_room.player.y - self.y, current_room.player.x - self.x), v = random(80, 100), s = 3.5}) -- спавним пулю с текущим углом 
            end
        end)
    end)
end

function SuperShooter:update(dt)
    SuperShooter.super.update(self, dt)

    self.collider:setLinearVelocity(self.v, 0) 
end

function SuperShooter:draw()
    love.graphics.setColor(1,0,1)
    if self.hit_flash then love.graphics.setColor(default_color) end
    local points = {self.collider:getWorldPoints(self.collider.shapes.main:getPoints())}
    love.graphics.polygon('line', points)
    love.graphics.setColor(1,0,1)
end

function SuperShooter:destroy()
    SuperShooter.super.destroy(self)
end

function SuperShooter:hit(damage)
    if self.dead then return end

    self.hp = self.hp - (damage or 100)
    if self.hp <= 0 then
        self.dead = true
        death_sound:play()
        self.area:addGameObject('Ammo', self.x, self.y)
        if love.math.random(0, 1)==1 then
            self.area:addGameObject('Boost', self.x+5, self.y+5)
        end
        self.area:addGameObject('EnemyDeathEffect', self.x, self.y, {color = hp_color, w = 2.5*self.w})
    else
        self.hit_flash = true
        self.timer:after('hit_flash', 0.2, function() self.hit_flash = false end)
    end
end
