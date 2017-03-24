debug = true

isAlive = true
score = 0
canShoot = true
canShootTimerMax = 0.5
canShootTimer = 0
bulletSpeed = 1000
bullets = {}
enemies = {}
enemySpawnRate = 1
enemySpawnTimer = 0
enemySpeed = 300

function love.load(arg)
  player = { x = 200, y = 710, speed = 350,  img = nil }
  player.img = love.graphics.newImage('assets/aircrafts/Aircraft_01.png')
  bulletImage = love.graphics.newImage('assets/aircrafts/bullet_2_blue.png')
  enemyImage = love.graphics.newImage('assets/aircrafts/Aircraft_07.png')
end

function love.update(dt)
  moveBullets(dt)
  checkCanShoot(dt)
  controls(dt)
  spawnEnemies(dt)
  moveEnemies(dt)
  checkCollisions()
end

function love.draw(dt)
  if isAlive then
    love.graphics.draw(player.img, player.x, player.y)
  else
    love.graphics.print("Game over :(, press enter to play again",
     0, love.graphics.getHeight()/2, 0, 2, 2)
  end
  for i, bullet in ipairs(bullets) do
    love.graphics.draw(bullet.img, bullet.x, bullet.y)
  end
  for i, enemy in ipairs(enemies) do
    love.graphics.draw(enemy.img, enemy.x, enemy.y, math.pi, 1, 1, enemy.img:getWidth(), enemy.img:getHeight())
  end
  love.graphics.print(score, love.graphics.getWidth() - 75, 0, 0, 5, 5)
end

function spawnEnemies(dt)
  if enemySpawnTimer < 0 then
    enemy = {
      x = love.math.random(love.graphics.getWidth() - enemyImage:getWidth()),
      y = 0,
      img = enemyImage
    }
    table.insert(enemies, enemy)
    enemySpawnTimer = enemySpawnRate
  else
    enemySpawnTimer = enemySpawnTimer - dt
  end
end

function moveEnemies(dt)
  for i, enemy in ipairs(enemies) do
    if enemy.y > love.graphics.getHeight() then
      table.remove(enemies, i)
    else
      enemy.y = enemy.y + (enemySpeed * dt)
    end
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

  if love.keyboard.isDown('return') and not isAlive then
    reset()
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

function checkCollisions()
  for enemyIndex, enemy in ipairs(enemies) do
    if isColliding(
      enemy.x, enemy.y, enemy.img:getWidth(), enemy.img:getHeight(),
      player.x, player.y, player.img:getWidth(), player.img:getHeight()
    ) then
      isAlive = false
      table.remove(enemies, enemyIndex)
    end
    for bulletIndex, bullet in ipairs(bullets) do
      if isColliding(
      enemy.x, enemy.y, enemy.img:getWidth(), enemy.img:getHeight(),
      bullet.x, bullet.y, bullet.img:getWidth(), bullet.img:getHeight()
      ) then
        table.remove(enemies, enemyIndex)
        table.remove(bullets, bulletIndex)
        score = score + 10
      end
    end
  end
end

function reset()
  print(reset)
  enemies = {}
  bullets = {}
  score = 0
  isAlive = true
end

function isColliding(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end
