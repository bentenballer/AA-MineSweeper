class Tile
    attr_reader :bomb
    attr_reader :neighbors

    def initialize(pos)
        @pos = pos
        @bomb = false
        @flagged = false
        @revealed = false
        @neighbors = []
        @neighbors_bomb_count = 0
    end

    def set_bomb
        @bomb = true
    end
    
    def reveal
        @revealed = true
    end

    def neighbors
        row, col = @pos[0], @pos[1]
        @neighbors << [row - 1, col + 1]
        @neighbors << [row, col + 1] 
        @neighbors <<  [row + 1, col + 1] 
        @neighbors <<  [row + 1, col] 
        @neighbors << [row + 1, col - 1] 
        @neighbors << [row, col - 1] 
        @neighbors <<  [row - 1, col - 1] 
    end

    def neighbors_bomb_count
        @neighbors_bomb_count += 1
    end
end