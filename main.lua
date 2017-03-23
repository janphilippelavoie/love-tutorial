debug = true

function love.load(arg)
  player = { x = 200, y = 710, speed = 350,  img = nil }
  player.img = love.graphics.newImage('assets/aircrafts/Aircraft_01.png')
end

function love.update(dt)
  if love.keyboard.isDown('escape') then
    love.event.push('quit')
  end

  if love.keyboard.isDown('left', 'a') then
    if player.x > 0 then
      player.x = player.x - ( player.speed*dt )
    end
  end
  if love.keyboard.isDown('right', 'd') then
    if player.x < (love.graphics.getWidth() - player.img:getWidth()) then
      player.x = player.x + ( player.speed*dt )
    end
  end

end

function love.draw(dt)
  love.graphics.draw(player.img, player.x, player.y)
end
