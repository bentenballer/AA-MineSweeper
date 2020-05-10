require_relative "board"
class MineSweeper

    def initialize
        puts "How many bombs?"
        input = gets.chomp
        @board = Board.new(input.to_i)
    end

    def valid_choice(input)
        input.downcase == 'r' || input.downcase == 'f'
    end

    def get_choice
        input = nil 
        while valid_choice?(input)
            print "Please make your make ('r' for reveal or 'f' for flag): "
            input = gets.chomp
        end
        input
    end

    def get_pos
        pos = nil
        until pos && valid_pos?(pos)
            puts "Please enter the position for this move (e.g., '3,4')"
            print "> "
      
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
        pos.split(",").select{ |i| i }
    end

    def play_turn
        choice = self.get_choice
        get_pos = self.get_pos
    end

    def reveal
    end

    def run
        @board.create_tiles
        @board.set_bombs
        @board.find_neighbors
        @board.check_for_valid_neighbors
        @board.neighbors_for_bombs
        self.render
    end

    def render
        (0...@board.length).each do |row|
            puts "".ljust(37, "-")
            (0...@board.length).each do |col|
                print "|".ljust(2)
                if @board[row, col].flagged == false && @board[row, col].revealed == false
                    print "*".ljust(2)
                elsif @board[row, col].flagged == true
                    print "f".ljust(2)
                else
                    print "#{@board[row, col].neighbor_bomb_count}".ljust(2)
                end
            end
            print"|"
            puts
        end
    end
end