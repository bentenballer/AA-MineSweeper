class Tile
    attr_reader :bomb, :neighbors, :flagged, :revealed, :neighbors_bomb_count
    
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

    def flag
        @flagged = true
    end
    
    def reveal
        @revealed = true
    end

    def add_neighbors
        row, col = @pos[0], @pos[1]
        @neighbors << [row - 1, col]
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