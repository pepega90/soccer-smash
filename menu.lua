
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------


-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- TODO: Complete menu scene

function gotoGame(event) 
	composer.gotoScene( "game" , {effect = "slideDown", time=600})
end

-- create()
function scene:create( event )
	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen
	local bg = display.newImageRect( sceneGroup, "assets/Sprites/background1.jpg", display.actualContentWidth, display.actualContentHeight )
	bg.x = display.contentCenterX
	bg.y = display.contentCenterY

	font_game = "assets/New Athletic M54.ttf"

	local gameText = display.newText(sceneGroup, "Soccer Smash", 250, 80, font_game, 50)
	gameText:setFillColor(0,0,0)

	local btn_play = display.newImageRect( sceneGroup, "assets/ButtonPlayGame.png", 234, 63 )
	btn_play:scale(0.5, 0.5)
	btn_play.x = display.contentCenterX
	btn_play.y = display.contentCenterY
	btn_play:addEventListener("tap", gotoGame)

	-- rectangle to hide text "Country Flag"
	rect_hider = display.newRect( sceneGroup, display.contentCenterX, display.contentCenterY + 60, 300, 30 )

	-- credit text
	credit_text = display.newText(sceneGroup, "created by aji mustofa @pepega90", display.contentCenterX, display.contentCenterY + 60, native.systemFontBold, 10)
	credit_text:setFillColor(0,0,0)
end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
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
