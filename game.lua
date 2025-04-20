local composer = require( "composer" )
local scene = composer.newScene()
local physics = require("physics")

physics.start()
physics.setGravity(0, 20)

require("gawang")
require("player")
require("player_2")
require("bola")
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
base_dir = "./assets/Sprites/"
char_dir = base_dir .. "Characters/"
flag_dir = base_dir .. "Flag/"

player1_score = 0
player2_score = 0
is_scored = false

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- helper function untuk animation
function createAnimation(imagePaths, body, frameDelay)
    local animation = {
        frames = imagePaths,
        currentFrame = 1,
        frameDelay = frameDelay or 100,
        timerHandle = nil,
        play = function(self)
            local function updateFrame()
                -- Set texture directly on the existing body
                if body then
                    body.fill = { type = "image", filename = self.frames[self.currentFrame] }
                    self.currentFrame = self.currentFrame + 1
                    if self.currentFrame > #self.frames then
                        self.currentFrame = 1
                    end
                end
            end
            self.timerHandle = timer.performWithDelay(self.frameDelay, updateFrame, 0)
        end,
        stop = function(self)
            if self.timerHandle then
                timer.cancel(self.timerHandle)
                self.timerHandle = nil
            end
        end
    }
    return animation
end

local function createBoundaries()
    -- Left wall
    local leftWall = display.newRect(-122, display.contentCenterY, 10, display.actualContentHeight)
    physics.addBody(leftWall, "static")

    -- Right wall
    local rightWall = display.newRect(601, display.contentCenterY, 10, display.actualContentHeight)
    physics.addBody(rightWall, "static")

    -- Top wall
    local topWall = display.newRect(display.contentCenterX, -5, display.actualContentWidth, 10)
    physics.addBody(topWall, "static")

    -- Bottom wall
    local bottomWall = display.newRect(display.contentCenterX, display.actualContentHeight + 5, display.actualContentWidth, 10)
    physics.addBody(bottomWall, "static")

    -- Make the walls invisible
    -- leftWall.isVisible = false
    -- rightWall.isVisible = false
    -- topWall.isVisible = false
    -- bottomWall.isVisible = false
end

function updateScore(player)
     if player == 2 and not is_scored then
        player2_score = player2_score + 1
        player2_text_score.text = tostring(player2_score)
     elseif player == 1 and not is_scored then
        player1_score = player1_score + 1
        player1_text_score.text = tostring(player1_score)
     end 
end

-- Collision event listener
local function onCollision(event)
    if event.phase == "began" then
        if (event.object1 == bola.body and event.object2 == gawang_kiri.body) or
           (event.object1 == gawang_kiri.body and event.object2 == bola.body) then
            updateScore(2)
            is_scored = true
            timer.performWithDelay(2000, onTimeResetGame)
        elseif (event.object1 == bola.body and event.object2 == gawang_kanan.body) or
        (event.object1 == gawang_kanan.body and event.object2 == bola.body) then
            updateScore(1)
            is_scored = true
            timer.performWithDelay(2000, onTimeResetGame)
        end
    end
end


function onTimeResetGame() 
    goal_text.isVisible = false
    player1:reset()
    player2:reset()
    bola:reset()
    is_scored = false
end

function gameLoop()
    if is_scored then
        goal_text.isVisible = true
    end
end

-- create()
function scene:create( event )

	local sceneGroup = self.view
    -- background
    bg = display.newImageRect(sceneGroup,base_dir.."background2.jpg", display.actualContentWidth, display.actualContentHeight);
    bg.x = display.contentCenterX
    bg.y = display.contentCenterY
	createBoundaries()

    -- goal text
    goal_text = display.newText(sceneGroup, "GOALL!!", display.contentCenterX, 100, native.systemFontBold, 40)
    goal_text.isVisible = false 
    goal_text:setFillColor(1,1, 0)

    -- player 1
    player1 = Player(char_dir .. "german/Idle/Idle_000.png", 100, 100, 360/3, 360/3)
    player1.flag_img = flag_dir .. "England.png"
    player1:draw()
    player1:initAnimation()

    -- score player 1
    player1_text_score = display.newText(sceneGroup, tostring(player1_score), 220, 35, native.systemFont, 30)
    player1_text_score:setFillColor(0,0,0)

    -- player 2
    player2 = Player2(char_dir .. "brazil/Idle/Idle_000.png", 376, 100, 360/3, 360/3)
    player2.flag_img = flag_dir .. "Brazil.png"
    player2:draw()
    player2:initAnimation()

    -- score player 2
    player2_text_score = display.newText(sceneGroup, tostring(player2_score), 250, 35, native.systemFont, 30)
    player2_text_score:setFillColor(0,0,0)
   
    sceneGroup:insert(player1.body)
    sceneGroup:insert(player2.body)

    -- insert flag to sceneGroup
    sceneGroup:insert(player1.flag_obj)
    sceneGroup:insert(player2.flag_obj)

    -- floor, untuk menahan player jatuh dari layer 280
    floor_rect = display.newRect(sceneGroup, 240, 270, display.actualContentWidth, 10)
    floor_rect:setFillColor(0,0,0)
    floor_rect.isVisible = false
    physics.addBody(floor_rect, "static", {friction = 0.01});

	-- bola
	bola = Bola(base_dir .. "Ball 02.png", display.contentCenterX, 80, 130 /5, 130 /5)
	bola:draw()
    sceneGroup:insert(bola.body)

    -- gawang_kiri
    gawang_kiri = Gawang(base_dir .. "gawang.png", -113, 208, 198/3, 373/3, false)
    gawang_kiri:draw()
    sceneGroup:insert(gawang_kiri.body)

    -- gawang_kanan
    gawang_kanan = Gawang(base_dir .. "gawang.png", 593, 208, 198/3, 373/3, true)
    gawang_kanan:draw()
    sceneGroup:insert(gawang_kanan.body)
end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
        player1:move()
        player2:move()
        Runtime:addEventListener("collision", onCollision)
        Runtime:addEventListener("enterFrame", gameLoop)
        -- Runtime:addEventListener("enterFrame", gameLoop)

        local function PositionCursor()
			-- Create a text object for displaying coordinates
			local positionText = display.newText(
				"X: 0, Y: 0", -- Initial text
				display.contentCenterX, -- Starting X position
				display.contentCenterY, -- Starting Y position
				native.systemFont, -- Font
				20 -- Font size
			)
			positionText:setFillColor(0,0,0) -- Set text color (white)

			-- Create a visual marker (circle) for the cursor

			-- Function to update position on screen
			local function updateCursor(event)
				-- Update text position and content
				positionText.x = event.x -- Offset text to avoid overlap with cursor
				positionText.y = event.y
				positionText.text = "X: " .. math.floor(event.x) .. ", Y: " .. math.floor(event.y)
			end

			-- Add a Runtime listener to track touch or mouse movement
			Runtime:addEventListener("mouse", updateCursor)
		end

		-- Call the PositionCursor function to enable the helper
		-- PositionCursor()
	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen

	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view

end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene
