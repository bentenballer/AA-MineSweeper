require_relative "tile"
require "byebug"

class Board
    attr_reader :board

    def initialize(bombs)
        @board = Array.new(9) {Array.new(9)}
        @bombs = bombs
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
        bombs = @bombs
        while bombs > 0
            row = rand(@board.length)
            col = rand(@board.length)
            if self[row, col].bomb == false
                self[row, col].set_bomb
                bombs -= 1
            end
        end
    end

    def find_neighbors
        (0...@board.length).each do |row|
            (0...@board.length).each do |col|
                self[row, col].add_neighbors
            end
        end
    end

    def check_for_valid_neighbors
        (0...@board.length).each do |row|
            (0...@board.length).each do |col|
                self[row, col].neighbors.select! { |neighbor| neighbor if (0...@board.length).include?(neighbor[0]) && (0...@board.length).include?(neighbor[1]) }
            end
        end
    end

    def neighbors_for_bombs
        (0...@board.length).each do |row|
            (0...@board.length).each do |col|
                self[row, col].neighbors.each { |neighbor| self[row, col].bomb_count if self[neighbor[0], neighbor[1]].bomb == true } 
            end
        end
    end

    def reveal(pos)
        self[pos[0],pos[1]].reveal
    end

    def flag(pos)
        self[pos[0],pos[1]].flag
    end
    def length
        @board.length
    end

    def [](*pos)
        @board[pos[0]][pos[1]]
    end

    def []=(*pos, value)
        @board[pos[0]][pos[1]] = value
    end
end