require_relative "board"
class MineSweeper

    def initialize
        puts "How many bombs?"
        input = gets.chomp
        @board = Board.new(input.to_i)
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
            puts "".ljust(20, "-")
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
        end
    end
end