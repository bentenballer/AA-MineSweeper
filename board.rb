require_relative "tile"

class Board
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
        (0...@board.length).each{|row| (0...@board.length).each{|col| self[row, col].add_neighbors}}
    end

    def check_for_valid_neighbors
        (0...@board.length).each do |row|
            (0...@board.length).each do |col|
                self[row, col].neighbors.select! do |neighbor| 
                    neighbor if (0...@board.length).include?(neighbor[0]) && (0...@board.length).include?(neighbor[1])
                end
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

    def safe_neighborhood?(pos)
        self[pos[0],pos[1]].neighbors.all? { |neighbor| self[neighbor[0], neighbor[1]].bomb == false }
    end

    def reveal_neighbors(pos)
        self[pos[0],pos[1]].neighbors.each { |neighbor| reveal(neighbor) if self[neighbor[0], neighbor[1]].revealed == false }
    end

    def reveal(pos)
        self[pos[0],pos[1]].reveal
        reveal_neighbors(pos) if safe_neighborhood?(pos)
    end

    def bomb?(pos)
        self[pos[0], pos[1]].bomb == true
    end

    def flag(pos)
        self[pos[0],pos[1]].flag
    end

    def win?
        (0...@board.length).each {|row| (0...@board.length).each {|col| return false if self[row, col].revealed == false && self[row, col].bomb == false}}
        true
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