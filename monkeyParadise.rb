require 'colorize'

class Game
	def initialize
		@character
		@rooms = []

		@map_tags = {
			:main_room_tag1 => 'Main',
			:main_room_tag2 => 'room',
			:leon_cage_tag1 => 'Leon',
			:leon_cage_tag2 => 'cage',
			:armoury_tag => 'Armoury',
			:crazy_wizard_room_tag1 => 'Crazy',
			:crazy_wizard_room_tag2 => 'wizard',
			:boom_room_tag1 => 'Bomb',
			:boom_room_tag2 => 'room',
		}

		@win = false

		start_game
	end

	def start_game
		add_character
		add_rooms		
		show_game_name
		show_character_attributes
		show_current_room @character.position
		room_behaviour @character.position
		show_lives
		#use_gps @character.position
		enter_the_room
	end

	def add_character
		@character = Character.new 'monkey', 1
	end

	def add_rooms
		main_room = Room.new 1, {:W => 2, :E => 3}, 'You are in the main room'
		leon_cage = Room.new 2, {:N => 4, :E => 1}, 'You are in the leon cage'
		crazy_wizard_room = Room.new 3, {:S => 5, :W => 1}, 'You are in the crazy wizard room'
		armoury = Room.new 4, {:S => 2}, 'You are in the armoury'
		bomb_room = Room.new 5, {:N => 3}, 'You are in the bom room'

		@rooms << main_room
		@rooms << leon_cage
		@rooms << crazy_wizard_room
		@rooms << armoury
		@rooms << bomb_room
	end

	def new_line
		puts ''
	end

	def clear_screen
		system 'cls'
	end

	def show_game_name
		new_line
		puts ' *****************************************'
		puts ' MONKEY PARADISE Alpha 1.0 - Crafted by JC'
		puts ' *****************************************'
		new_line
	end

	def show_character_attributes
		new_line
		puts ' You are a ' + @character.name + ' and you are awesome as fuck!'
		new_line
	end

	def show_lives
		lives = @character.lives

		print ' Lives ' unless @character.lives == 0

		while lives > 0 do
			print "\u2665".colorize(:red)
			lives -= 1
		end

		new_line
	end

	def win
		clear_screen

		puts 'THANKS FOR PLAYING!'

		new_line
		puts 'https://github.com/jcmoralesbrigidano/MonkeyParadise'		
	end

	def print_room_name room_to_colour
		current_room = get_current_room room_to_colour
		current_room_number = current_room.number

		case current_room_number
			when 1
				@map_tags.each do |tag, content|
					if tag == :main_room_tag1 || tag == :main_room_tag2
						@map_tags[tag] = @map_tags[tag].colorize(:red)
					else
						@map_tags[tag] = @map_tags[tag].colorize(:white)
					end
				end
			when 2
				@map_tags.each do |tag, content|
					if tag == :leon_cage_tag1 || tag == :leon_cage_tag2
						@map_tags[tag] = @map_tags[tag].colorize(:red)
					else
						@map_tags[tag] = @map_tags[tag].colorize(:white)
					end
				end
			when 3
				@map_tags.each do |tag, content|
					if tag == :crazy_wizard_room_tag1 || tag == :crazy_wizard_room_tag2
						@map_tags[tag] = @map_tags[tag].colorize(:red)
					else
						@map_tags[tag] = @map_tags[tag].colorize(:white)
					end
				end
			when 4
				@map_tags.each do |tag, content|
					if tag == :armoury_tag
						@map_tags[tag] = @map_tags[tag].colorize(:red)
					else
						@map_tags[tag] = @map_tags[tag].colorize(:white)
					end
				end
			when 5
				@map_tags.each do |tag, content|
					if tag == :boom_room_tag1 || tag == :boom_room_tag2
						@map_tags[tag] = @map_tags[tag].colorize(:red)
					else
						@map_tags[tag] = @map_tags[tag].colorize(:white)
					end
				end
		end
	end

	def show_map
		new_line
		puts '  _________ '
		puts ' |         |'
		puts ' |         |'
		puts ' | ' + @map_tags[:armoury_tag] + ' |'
		puts ' |         |'
		puts ' |         |'
		puts ' |___   ___| _________ _________'
		puts ' |         ||         |         |'
		puts ' |         ||         |         |'
		puts ' |   ' + @map_tags[:leon_cage_tag1] + '       ' + @map_tags[:main_room_tag1] + '     ' + @map_tags[:crazy_wizard_room_tag1] + '  |'
		puts ' |   ' + @map_tags[:leon_cage_tag2] + '       ' + @map_tags[:main_room_tag2] + '     ' + @map_tags[:crazy_wizard_room_tag2] + ' |'
		puts ' |         ||         |         |'
		puts ' |_________||_________|___   ___|'
		puts '                      |         |'
		puts '                      |         |'
		puts '                      |   ' + @map_tags[:boom_room_tag1] + '  |'
		puts '                      |   ' + @map_tags[:boom_room_tag2] + '  |'
		puts '                      |         |'
		puts '                      |_________|'
		new_line
		new_line
	end

	def show_current_room room_number
		current_room = get_current_room room_number
		print_room_name current_room.number
		show_map
	end

	def get_current_room room_number
		current_room = @rooms.find { |room| room.number == room_number }
	end

=begin
	def use_gps room_number
		current_room = get_current_room room_number
		room_paths = current_room.paths

		print ' You can go to the '

		room_paths.each do |direction, room_number|
			print "#{direction}".colorize(:red)
			print " or to the " unless room_number == room_paths[room_paths.keys.last]
		end

		new_line
	end
=end
	def enter_the_room
		new_line		
		puts ' Where do you want to go? (N, S, E, W)'
		print ' '
		new_position = gets.chomp.upcase
		clear_screen
		show_game_name

		if control_room_paths new_position
			show_current_room @character.position
			room_behaviour @character.position
			show_lives
			#use_gps @character.position			
		else
			show_current_room @character.position
			puts ' You hit your head against the wall!'
			@character.lives -= 1
			new_line
			show_lives			
			#use_gps @character.position
		end

		if @character.lives > 0
			if @win
				win
			else
				enter_the_room
			end
		else
			new_line
			puts ' You are dead! (Keep trying)'
		end
	end

	def control_room_paths new_position
		current_room = get_current_room @character.position
		room_paths = current_room.paths
		valid_direction = false

		room_paths.each do |direction, room_number|
			if new_position == direction.to_s
				@character.position = room_number
				valid_direction = true
			end
		end

		valid_direction
	end

	def room_behaviour room_number
		puts ' ' + get_current_room(room_number).message
		
		case room_number
			when 1
			when 2
				case @character.inventory
					when 'LASER GUN'
						@character.lives -= 2
						new_line						
						puts ' A monkey does not know how to use a laser gun, the lion bites you'
					when 'BAZOOKA'
						@character.lives = 0
						new_line
						puts ' You shoot the lion with the bazooka,'
						puts ' but the room is so small that both of you die'
					when 'PHONE'
						new_line
						puts ' You call the crazy wizard and he starts dancing breakdance'
						puts ' distracting the lion while you run away, you win!'
						@win = true
						sleep 5
					when 'BANANA'
						@character.lives -= 2
						new_line
						puts ' You begin to eat the banana, the lion bites you'
						puts ' but you do not care because you are no longer hungry'
					else
						@character.lives -= 2
						new_line
						puts ' The lion bites you, be sure to use an object the next time!'
				end
			when 3
				new_line
				puts ' A crazy wizard doing air guitar, WTF?!'
			when 4
				new_line
				puts ' Pick an object (LASER GUN, BAZOOKA, PHONE, BANANA)'
				print ' '
				@character.inventory = gets.chomp.upcase
				new_line
				puts ' Now you have a ' + @character.inventory + '!'
			when 5
				@character.lives -= 2
				new_line
				puts ' What is the point of enter in a room called BOOM ROOM!? Genius...'
		end

		new_line
	end
end

class Character
	attr_accessor :name, :position, :lives, :inventory

	def initialize name, position
		@name = name
		@position = position
		@lives = 5
		@inventory
	end
end

class Room
	attr_accessor :number, :paths, :message

	def initialize number, paths, message
		@number = number
		@paths = paths
		@message = message
	end
end

monkey_paradise = Game.new