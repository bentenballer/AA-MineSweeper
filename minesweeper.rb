require_relative "board"
require "byebug"
class MineSweeper

    def initialize
        puts "How many bombs?"
        input = gets.chomp
        @board = Board.new(input.to_i)
        @players_choice = []
        @flagged = []
    end

    def get_choice
        input = nil 
        while !valid_choice?(input)
            print "Please make your make ('r' for reveal or 'f' for flag): "
            input = gets.chomp
        end
        input
    end

    def valid_choice?(input)
        return false if input == nil
        input.downcase == 'r' || input.downcase == 'f'
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
        get_pos = self.get_pos

        if choice == "r"
            @players_choice << get_pos
            @board.reveal(get_pos)
            self.render
        else
            @flagged << get_pos
            @board.flag(get_pos)
            self.render
        end
    end

    def game_over?
        if self.bomb?
            puts "You stepped on a bomb!"
            return true
        end
    end

    def bomb?
        last_pos = @players_choice[-1]
        @board.bomb?(last_pos)
    end

    def run
        self.start_the_game
        self.play_turn until self.game_over?
    end

    def render
        (0...@board.length).each do |row|
            puts "".ljust(37, "-")
            (0...@board.length).each do |col|
                print "|".ljust(2)
                if @board[row, col].flagged == false && @board[row, col].revealed == false
                    print "_".ljust(2)
                elsif @board[row, col].flagged == true
                    print "f".ljust(2)
                elsif  @board[row, col].revealed == true && @board[row, col].bomb == true
                   print "*".ljust(2)
                else
                    print "#{@board[row, col].neighbors_bomb_count}".ljust(2)
                end
            end
            print"|"
            puts
        end
    end
end