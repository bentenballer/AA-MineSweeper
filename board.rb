require_relative "tile"
require "byebug"

class Board
    attr_reader :board

    def initialize
        @board = Array.new(9) {Array.new(9)}
    end

    def create_tiles
        (0...@board.length).each do |row|
            (0...@board.length).each do |col|
                pos = [row, col]
                self[row, col] = Tile.new(pos)
            end
        end
    end

    def set_bombs
        bombs = 10
        while bombs > 0
            row = rand(@board.length)
            col = rand(@board.length)
            if self[row, col].bomb == false
                self[row, col].set_bomb
                bombs -= 1
            end
        end
    end

    def [](*pos)
        @board[pos[0]][pos[1]]
    end

    def []=(*pos, value)
        @board[pos[0]][pos[1]] = value
    end
end