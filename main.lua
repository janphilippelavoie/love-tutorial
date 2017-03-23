debug = true

canShoot = true
canShootTimerMax = 0.5
canShootTimer = 0
bulletSpeed = 100
bullets = {}

function love.load(arg)
  player = { x = 200, y = 710, speed = 350,  img = nil }
  player.img = love.graphics.newImage('assets/aircrafts/Aircraft_01.png')
  bulletImage = love.graphics.newImage('assets/aircrafts/bullet_2_blue.png')
end

function love.update(dt)
  controls(dt)
  moveBullets(dt)
  checkCanShoot(dt)
end

function love.draw(dt)
  love.graphics.draw(player.img, player.x, player.y)
  for i, bullet in ipairs(bullets) do
    love.graphics.draw(bullet.img, bullet.x, bullet.y)
  end
end

function moveBullets(dt)
  for i, bullet in ipairs(bullets) do
    if bullet.y < 0 then
      table.remove(bullets, i)
    else
      bullet.y = bullet.y - (bulletSpeed*dt)
    end
  end
end

function checkCanShoot(dt)
  if not canShoot then
    print(canShootTimer)
    if canShootTimer < 0 then
      canShoot = true
    else
      canShootTimer = canShootTimer - dt
    end
  end
end

function controls(dt)
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

  if love.keyboard.isDown(' ') then
    shoot()
  end
end

function shoot()
  if canShoot then
    bullet = {
      x = player.x + player.img:getWidth()/2,
      y = player.y,
      img = bulletImage
    }
    table.insert(bullets, bullet)
    canShoot = false
    canShootTimer = canShootTimerMax
  end
end
