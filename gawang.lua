function Gawang(img, x, y, width, height, flipHorizontal)
      return {
        img = img,
        x = x,
        y = y,
        width = width,
        height = height,
        flipHorizontal = flipHorizontal,
        draw = function(self) 
            self.body = display.newImageRect(self.img,self.width,self.height);
            self.body.x = self.x
            self.body.y = self.y

            if self.flipHorizontal then
                self.body.xScale = -1
            end

            physics.addBody(self.body, "static", { isSensor = true })
        end
      }
end

return Gawang