require 'gosu'
require './player'
require './ZOrder'
require './star'

$stdout.sync = true

class Tutorial < Gosu::Window

	attr_reader :number_of_players

	def initialize(number_of_players)
		@number_of_players = number_of_players
		super 1280, 960
		self.caption = "Tutorial Game"

		@background_image = Gosu::Image.new("images/space3.jpg", :tileable => true)
		
		
		@player = Player.new
		@player.warp(320, 240)
		
		
		if number_of_players == 2
			@player2 = Player.new
			@player2.warp(480, 240)
		end

		@star_anim = Gosu::Image.load_tiles("images/star.png", 25, 25)
		@stars = Array.new

		@font = Gosu::Font.new(20)
	end

	def update 

		keystrokes(@player, 1)

		@player.move
		@player.collect_stars(@stars)

		if number_of_players == 2
			keystrokes(@player2, 2)
			@player2.move
			@player2.collect_stars(@stars)
		end

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
		if number_of_players == 2
			@player2.draw
		end
		@stars.each { |star| star.draw}
		@font.draw("Player 1 Score: #{@player.score}", 10, 10, ZOrder::UI, 1.0, 1.0, Gosu::Color::YELLOW)
		if number_of_players == 2
			@font.draw("Player 2 Score: #{@player2.score}", 1120, 10, ZOrder::UI, 1.0, 1.0, Gosu::Color::YELLOW)
		end
	end

	def button_down(id)
		if id == Gosu::KB_ESCAPE
			close
		else
			super
		end
	end

end

puts "Would you like a 1 or 2 player game?"
number_of_players = gets.chomp.to_i

Tutorial.new(number_of_players).show
