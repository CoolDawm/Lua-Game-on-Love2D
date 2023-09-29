default_color = {1, 1, 1}
background_color = {0, 0, 0}
ammo_color = {0, 1, 0}
boost_color = {1, 0, 1}
hp_color = {1, 0, 0}
skill_point_color = {0, 1, 1}
default_colors = {default_color, hp_color, ammo_color, boost_color, skill_point_color}
negative_colors = {
    {255-default_color[1], 255-default_color[2], 255-default_color[3]}, 
    {255-hp_color[1], 255-hp_color[2], 255-hp_color[3]}, 
    {255-ammo_color[1], 255-ammo_color[2], 255-ammo_color[3]}, 
    {255-boost_color[1], 255-boost_color[2], 255-boost_color[3]}, 
    {255-skill_point_color[1], 255-skill_point_color[2], 255-skill_point_color[3]}
}
all_colors = M.append(default_colors, negative_colors)
attacks = {
    ['Neutral'] = {cooldown = 0.24, ammo = 0, abbreviation = 'N', color = default_color},
    ['Double'] = {cooldown = 0.32, ammo = 2, abbreviation = '2', color = ammo_color},
    ['Triple'] = {cooldown = 0.32, ammo = 3, abbreviation = '3', color = ammo_color},
    ['Rapid'] = {cooldown = 0.12, ammo = 1, abbreviation = 'R', color = default_color},
    ['Back'] = {cooldown = 0.32, ammo = 2, abbreviation = 'Ba', color = skill_point_color},
    ['Side'] = {cooldown = 0.32, ammo = 3, abbreviation = 'Si', color = boost_color},
}
source1 = love.audio.newSource('recourses/sounds/over.mp3', 'static')
end_sound = ripple.newSound(source1)
source2 = love.audio.newSource('recourses/sounds/death.mp3', 'static')
death_sound = ripple.newSound(source2)
source3 = love.audio.newSource('recourses/sounds/shoot.mp3', 'static')
shoot_sound = ripple.newSound(source3)
shoot_sound.volume = .35
death_sound.volume=.50