require 'gosu'
require './player'
require './ZOrder'
require './star'

class Tutorial < Gosu::Window

	def initialize
		super 640, 480
		self.caption = "Tutorial Game"

		@background_image = Gosu::Image.new("images/space.png", :tileable => true)
		
		@player = Player.new
		@player.warp(320, 240)

		@player2 = Player.new
		@player2.warp(480, 240)

		@star_anim = Gosu::Image.load_tiles("images/star.png", 25, 25)
		@stars = Array.new

		@font = Gosu::Font.new(20)
	end

	def update 

		keystrokes(@player, 1)

		keystrokes(@player2, 2)


		# if Gosu.button_down? Gosu::KB_LEFT or Gosu::button_down? Gosu::GP_LEFT
		# 	@player.turn_left
		# end

		# if Gosu.button_down? Gosu::KB_RIGHT or Gosu::button_down? Gosu::GP_RIGHT
		# 	@player.turn_right
		# end

		# if Gosu.button_down? Gosu::KB_UP or Gosu.button_down? Gosu::GP_BUTTON_0
		# 	@player.accelerate
		# end

		@player.move
		@player.collect_stars(@stars)

		@player2.move
		@player2.collect_stars(@stars)

		if rand(100) < 4 and @stars.size < 25
			@stars.push(Star.new(@star_anim))
		end
	end

	def keystrokes(player, id)
		if id == 1
			if Gosu.button_down? Gosu::KB_LEFT or Gosu::button_down? Gosu::GP_LEFT
				player.turn_left
			end

			if Gosu.button_down? Gosu::KB_RIGHT or Gosu::button_down? Gosu::GP_RIGHT
				player.turn_right
			end

			if Gosu.button_down? Gosu::KB_UP or Gosu.button_down? Gosu::GP_BUTTON_0
				player.accelerate
			end
		end

		if id == 2
			if Gosu.button_down? Gosu::KB_A
				player.turn_left
			end

			if Gosu.button_down? Gosu::KB_D 
				player.turn_right
			end

			if Gosu.button_down? Gosu::KB_W or Gosu.button_down? Gosu::GP_BUTTON_0
				player.accelerate
			end
		end


	end

	def draw
		@background_image.draw(0, 0, ZOrder::BACKGROUND)
		@player.draw
		@player2.draw
		@stars.each { |star| star.draw}
		@font.draw("Player 1 Score: #{@player.score}", 10, 10, ZOrder::UI, 1.0, 1.0, Gosu::Color::YELLOW)
		@font.draw("Player 2 Score: #{@player2.score}", 480, 10, ZOrder::UI, 1.0, 1.0, Gosu::Color::YELLOW)
	end

	def button_down(id)
		if id == Gosu::KB_ESCAPE
			close
		else
			super
		end
	end

end

Tutorial.new.show
