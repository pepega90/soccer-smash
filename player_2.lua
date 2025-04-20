function Player2(img, x, y, width, height)
    return {
        img = img,
        x = x,
        y = y,
        width = width,
        height = height,
        speed = 200,
        jumpForce = -0.3,
        isMoving = { up = false, left = false, right = false },
        canJump = false,
        body = nil,
        currentAnimation = nil,
        animations = {},
        flag_img = "",
        reset = function (self)
            self.body.x = 376
            self.body.y = 100
        end,
        draw = function(self)
            self.body = display.newImageRect(img, width, height)
            self.body.x = x
            self.body.y = y
            self.body.xScale = -1
            physics.addBody(self.body, {bounce = 0.3, box = {
                x = 0,  -- Center offset X (keep as 0 for now)
                y = 0,  -- Center offset Y
                halfWidth = (self.width / 2) - 40,  -- Reduce width by trimming 10 pixels on both sides
                halfHeight = (self.height / 2) - 20  -- Reduce height for top and bottom trim
            }});
            self.body.type = "player"
            self.body.isFixedRotation = true;

            -- draw player flag image

            self.flag_obj = display.newImageRect(self.flag_img,231/4,162/4);
            self.flag_obj.x = 526
            self.flag_obj.y = 35
        end,

        initAnimation = function (self)
            self:addAnimation("idle", {
                char_dir .."brazil/Idle/Idle_000.png", 
                char_dir .."brazil/Idle/Idle_001.png", 
                char_dir .."brazil/Idle/Idle_002.png", 
                char_dir .."brazil/Idle/Idle_003.png", 
                char_dir .."brazil/Idle/Idle_004.png",
                char_dir .."brazil/Idle/Idle_005.png",
                char_dir .."brazil/Idle/Idle_006.png",
                char_dir .."brazil/Idle/Idle_007.png",
                char_dir .."brazil/Idle/Idle_008.png",
                char_dir .."brazil/Idle/Idle_009.png",
                char_dir .."brazil/Idle/Idle_010.png",
                char_dir .."brazil/Idle/Idle_011.png",
                char_dir .."brazil/Idle/Idle_012.png",
                char_dir .."brazil/Idle/Idle_013.png",
                char_dir .."brazil/Idle/Idle_014.png",
                char_dir .."brazil/Idle/Idle_015.png",
                char_dir .."brazil/Idle/Idle_016.png",
                char_dir .."brazil/Idle/Idle_017.png",
            })
            self:addAnimation("left", {
                char_dir .."brazil/Move Forward/Move Forward_000.png", 
                char_dir .."brazil/Move Forward/Move Forward_001.png", 
                char_dir .."brazil/Move Forward/Move Forward_002.png", 
                char_dir .."brazil/Move Forward/Move Forward_003.png", 
                char_dir .."brazil/Move Forward/Move Forward_004.png",
                char_dir .."brazil/Move Forward/Move Forward_005.png",
                char_dir .."brazil/Move Forward/Move Forward_006.png",
                char_dir .."brazil/Move Forward/Move Forward_007.png",
                char_dir .."brazil/Move Forward/Move Forward_008.png",
                char_dir .."brazil/Move Forward/Move Forward_009.png"
            })
            self:addAnimation("right", {
                char_dir .."brazil/Move Backward/Move Backward_000.png", 
                char_dir .."brazil/Move Backward/Move Backward_001.png", 
                char_dir .."brazil/Move Backward/Move Backward_002.png", 
                char_dir .."brazil/Move Backward/Move Backward_003.png", 
                char_dir .."brazil/Move Backward/Move Backward_004.png",
                char_dir .."brazil/Move Backward/Move Backward_005.png",
                char_dir .."brazil/Move Backward/Move Backward_006.png",
                char_dir .."brazil/Move Backward/Move Backward_007.png",
                char_dir .."brazil/Move Backward/Move Backward_008.png",
                char_dir .."brazil/Move Backward/Move Backward_009.png"
            })
            self:addAnimation("jump", {
                char_dir .."brazil/Jump/Jump_000.png", 
                char_dir .."brazil/Jump/Jump_001.png", 
                char_dir .."brazil/Jump/Jump_002.png", 
                char_dir .."brazil/Jump/Jump_003.png", 
                char_dir .."brazil/Jump/Jump_004.png"
            })
            self:addAnimation("kick", {
                char_dir .."brazil/Kick/Kick_000.png", 
                char_dir .."brazil/Kick/Kick_001.png", 
                char_dir .."brazil/Kick/Kick_002.png", 
                char_dir .."brazil/Kick/Kick_003.png", 
                char_dir .."brazil/Kick/Kick_004.png",
                char_dir .."brazil/Kick/Kick_005.png",
                char_dir .."brazil/Kick/Kick_006.png",
                char_dir .."brazil/Kick/Kick_007.png",
                char_dir .."brazil/Kick/Kick_008.png"
            })
        end,
        
        addAnimation = function(self, name, imagePaths)
            self.animations[name] = createAnimation(imagePaths, self.body, 50)
        end,
        
        playAnimation = function(self, name)
            if self.currentAnimation then
                self.currentAnimation:stop()
            end
            self.currentAnimation = self.animations[name]
            if self.currentAnimation then
                self.currentAnimation:play()
            end
        end,

        move = function(self)
            local function onKeyEvent(event)
                local phase = event.phase
                local key = event.keyName

                if phase == "down" then
                    if key == "up" and self.canJump then
                        self.canJump = false
                        self.body:applyLinearImpulse(0, self.jumpForce, self.body.x, self.body.y)
                        self:playAnimation("jump")
                    elseif key == "down" then
                        self:playAnimation("kick")

                        -- Check if the ball is nearby and kick it
                        if bola and bola.body then
                            local dx = bola.body.x - self.body.x
                            local dy = bola.body.y - self.body.y
                            local distance = math.sqrt(dx * dx + dy * dy)

                            -- Define a reasonable distance threshold for kicking the ball
                            if distance < 80 then
                                local impulseX = dx > 0 and 0.1 or -0.1 -- Kick left or right
                                local impulseY = -0.09 -- Add slight upward impulse
                                bola.body:applyLinearImpulse(impulseX, impulseY, bola.body.x, bola.body.y)
                            end
                        end

                    elseif key == "left" then
                        self:playAnimation("left")
                        self.isMoving.a = true
                    elseif key == "right" then
                        self:playAnimation("right")
                        self.isMoving.d = true
                    end
                elseif phase == "up" then
                    self:playAnimation("idle")
                    if key == "left" then
                        self.isMoving.a = false
                    elseif key == "right" then 
                        self.isMoving.d = false
                    end
                end

                local vx = 0
                if self.isMoving.a then vx = vx - self.speed end
                if self.isMoving.d then vx = vx + self.speed end

                local _, vy = self.body:getLinearVelocity()
                self.body:setLinearVelocity(vx, vy)
                return true
            end

            local function onCollision(event)
                if event.phase == "began" then
                    if event.other == floor_rect then
                        self.canJump = true
                    end
                end
            end

            self.body:addEventListener("collision", onCollision)
            Runtime:addEventListener("key", onKeyEvent)
        end
    }
end
