function Bola(img, x, y, width, height) 
    return {
        img = img,
        x = x,
        y = y,
        width = width,
        height = height,
        reset = function(self)
            self.body.x = display.contentCenterX
            self.body.y = 80
        end,
        draw = function(self)
            self.body = display.newImageRect(img,width, height);
            self.body.x = x
            self.body.y = y
            physics.addBody(self.body)

              -- Function to handle ball rotation on player collision
              local function onCollision(event)
                if event.phase == "began" then
                    local other = event.other
                    if other.type == "player" then
                        -- Determine collision side: left or right of the player
                        if self.body.x < other.x then
                            -- Ball hits from the left, spin clockwise
                            self.body:applyAngularImpulse(2)
                        else
                            -- Ball hits from the right, spin counterclockwise
                            self.body:applyAngularImpulse(-2)
                        end
                    end
                end
            end

            -- Attach collision listener
            self.body:addEventListener("collision", onCollision)
        end
    }
end

return Bola