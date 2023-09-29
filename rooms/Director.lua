Director = Object:extend()

function Director:new(stage)
    self.stage = stage
    self.timer = Timer()

    self.difficulty = 1
    self.round_duration = 22
    self.round_timer = 0

    self.difficulty_to_points = {}
    self.difficulty_to_points[1] = 16
    for i = 2, 1024, 4 do
        self.difficulty_to_points[i] = self.difficulty_to_points[i-1] + 8
        self.difficulty_to_points[i+1] = self.difficulty_to_points[i]
        self.difficulty_to_points[i+2] = math.floor(self.difficulty_to_points[i+1]/1.5)
        self.difficulty_to_points[i+3] = math.floor(self.difficulty_to_points[i+2]*2)
    end

    self.enemy_to_points = {
        ['Rock'] = 1,
        ['Shooter'] = 2,
        ['CleanRock']=5,
    }

    self.enemy_spawn_chances = {
        [1] = chanceList({'Rock', 1}),
        [2] = chanceList({'Rock', 8}, {'Shooter', 4},{'Rock', 1}),
        [3] = chanceList({'Rock', 8}, {'Shooter', 8},{'Rock', 4}),
        [4] = chanceList({'Rock', 4}, {'Shooter', 8},{'Rock', 8}),
    }
    for i = 5, 1024 do
        self.enemy_spawn_chances[i] = chanceList({'Rock', love.math.random(2, 12)}, {'Shooter', love.math.random(2, 12)},{'Shooter', love.math.random(2, 12)})
    end
    self:setEnemySpawnsForThisRound()
    self.adds_to_points = {
        ['Ammo'] = 6,
        ['Boost'] = 10,
        ['AttackV'] = 10,
    }
    
    self.adds_spawn_chances = {
        [1] = chanceList({'Ammo', 1}),
        [2] = chanceList({'Ammo', 1}, {'Boost', 1},{'AttackV', 1}),
        [3] = chanceList({'Ammo', 3}, {'Boost', 1},{'AttackV', 1}),
        [4] = chanceList({'Ammo', 4}, {'Boost', 2},{'AttackV', 2}),
    }
    for i = 5, 1024 do
        self.adds_spawn_chances[i] = chanceList(
      	    {'Ammo', love.math.random(2, 12)}, 
      	    {'Boost', love.math.random(2, 12)}
    	)
    end
    self:setAddsSpawnsForThisRound()
end

function Director:update(dt)
    self.timer:update(dt)

    -- Difficulty
    self.round_timer = self.round_timer + dt
    if self.round_timer > self.round_duration then
        self.round_timer = 0
        self.difficulty = self.difficulty + 1
        self:setEnemySpawnsForThisRound()
    end
    if self.round_timer > self.round_duration then
        self.round_timer = 0
        self.difficulty = self.difficulty + 1
        self:setAddsSpawnsForThisRound()
    end
end

function Director:setEnemySpawnsForThisRound()
    local points = self.difficulty_to_points[self.difficulty]

    -- Find enemies
    local runs = 0
    local enemy_list = {}
    while points > 0 and runs < 1000 do
        local enemy = self.enemy_spawn_chances[self.difficulty]:next()
        points = points - self.enemy_to_points[enemy]
        table.insert(enemy_list, enemy)
        runs = runs + 1
    end

    -- Find enemies spawn times
    local enemy_spawn_times = {}
    for i = 1, #enemy_list do enemy_spawn_times[i] = random(0, self.round_duration) end
    table.sort(enemy_spawn_times, function(a, b) return a < b end)

    -- Set spawn enemy timer
    for i = 1, #enemy_spawn_times do
        self.timer:after(enemy_spawn_times[i], function()
            self.stage.area:addGameObject(enemy_list[i])
        end)
    end
end

function Director:setAddsSpawnsForThisRound()
    local points = self.difficulty_to_points[self.difficulty]

    -- Find enemies
    local adds_list = {}
    while points > 0 do
        local add = self.adds_spawn_chances[self.difficulty]:next()
        points = points - self.adds_to_points[add]
        table.insert(adds_list, add)
    end
    -- Find enemies spawn times
    local add_spawn_times = {}
    for i = 1, #adds_list do 
    	add_spawn_times[i] = random(0, self.round_duration) 
    end
    table.sort(add_spawn_times, function(a, b) return a < b end)
    for i = 1, #add_spawn_times do
        self.timer:after(add_spawn_times[i], function()
            self.stage.area:addGameObject(adds_list[i])
        end)
    end
end
