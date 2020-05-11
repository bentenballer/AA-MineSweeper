require_relative "board"
require "colorize"
require "yaml"

class MineSweeper
    def initialize
        system("clear")
        if load_game?
            print "Please enter the file name: "
            filename = gets.chomp
            self.load_game(filename).continue
        else
            puts "How many bombs?"
            input = gets.chomp
            @board = Board.new(input.to_i)
            @players_choice = []
        end
    end

    def load_game?
        load = "a"
        while load.downcase != "y" && load.downcase != "n"
            print "Load game? (Y/N): "
            load = gets.chomp
        end
        return true if load.downcase == "y"
        false
    end

    def get_choice
        input = nil 
        while !valid_choice?(input)
            print "Please make your move ('r' for reveal, 'f' for flag, 's' to save your progress): "
            input = gets.chomp
        end
        input
    end

    def valid_choice?(input)
        return false if input == nil
        input.downcase == 'r' || input.downcase == 'f' || input.downcase == 's'
    end

    def get_pos
        pos = nil
        until pos && valid_pos?(pos)
            print "Please enter the position for this move (e.g., '3,4'): "
      
            begin
              pos = parse_pos(gets.chomp)
            rescue
              puts "Invalid position entered (did you use a comma?)"
              puts ""
      
              pos = nil
            end
        end
        pos  
    end

    def valid_pos?(pos)
        pos.length == 2 && pos.is_a?(Array) && pos.all?{|i| i > -1 && i < @board.length }
    end

    def parse_pos(pos)
        pos.split(",").map{ |i| i.to_i }
    end

    def start_the_game
        @board.create_tiles
        @board.set_bombs
        @board.find_neighbors
        @board.check_for_valid_neighbors
        @board.neighbors_for_bombs
        self.render
    end

    def play_turn
        choice = self.get_choice
        if choice == "r"
            get_pos = self.get_pos
            @players_choice << get_pos
            @board.reveal(get_pos)
            self.render
        elsif choice == "f"
            get_pos = self.get_pos
            @board.flag(get_pos)
            self.render
        else
            print "Please enter the file name to save this game: "
            filename = gets.chomp
            self.save_game(filename)
            exit
        end
    end

    def game_over?
        if self.bomb?
            puts "You stepped on a bomb!"
            true
        elsif self.win?
            puts "You win!"
            true
        else
            false
        end
    end

    def win?
        @board.win?
    end

    def bomb?
        last_pos = @players_choice[-1]
        return false if last_pos == nil
        @board.bomb?(last_pos)
    end

    def run
        self.start_the_game
        self.play_turn until self.game_over?
    end

    def continue
        self.render
        self.play_turn until self.game_over?
    end

    def render
        system("clear")
        (0...@board.length).each do |row|
            (0...@board.length).each do |col|
                print "|".ljust(2).colorize(:green)
                if @board[row, col].flagged == false && @board[row, col].revealed == false
                    print "_".ljust(2).colorize(:green)
                elsif @board[row, col].flagged == true
                    print "f".ljust(2).colorize(:blue)
                elsif  @board[row, col].revealed == true && @board[row, col].bomb == true
                   print "*".ljust(2).colorize(:red)
                else
                    print "#{@board[row, col].neighbors_bomb_count}".ljust(2).colorize(:yellow)
                end
            end
            print"|".colorize(:green)
            puts
        end
    end

    def save_game(filename)
        File.open(filename, "w") {|file| file.write(self.to_yaml)}
    end
    
    def load_game(filename)
        YAML.load(File.read(filename))
    end
end

m = MineSweeper.new
m.run