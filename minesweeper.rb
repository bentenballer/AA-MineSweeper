require_relative "board"
require 'io/console'
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
            system("clear")
            puts "This is a new game!"
            puts "How many bombs?"
            input = gets.chomp
            @board = Board.new(input.to_i)
            @cursor_pos = [0,0]
            @players_choice = []
        end
    end

    # Reads keypresses from the user including 2 and 3 escape character sequences.
    def read_char
        STDIN.echo = false
        STDIN.raw!
    
        input = STDIN.getc.chr
        if input == "\e" then
          input << STDIN.read_nonblock(3) rescue nil
          input << STDIN.read_nonblock(2) rescue nil
        end
      ensure
        STDIN.echo = true
        STDIN.cooked!
    
        return input
      end

      # oringal case statement from:
      # http://www.alecjacobson.com/weblog/?p=75
    def move
        puts "Please make your move (use arrow keys to move, 'r' for reveal, 'f' for flag, 's' to save your progress)"
        c = read_char
    
        case c
        when "q"
            exit
        when "r"
            @players_choice << @cursor_pos
            @board.reveal(@cursor_pos)
            self.render
        when "f"
            @board.flag(@cursor_pos)
            self.render
        when "s"
            print "Please enter the file name to save this game: "
            filename = gets.chomp
            self.save_game(filename)
            exit
        when "\e[A" # "UP ARROW"
           row, col = @cursor_pos[0] - 1, @cursor_pos[1]
           if valid_range?(row)
                @cursor_pos = [row, col]
           end
           self.render
        when "\e[B" # "DOWN ARROW"
            row, col = @cursor_pos[0] + 1, @cursor_pos[1]
           if valid_range?(row)
                @cursor_pos = [row, col]
           end
           self.render
        when "\e[C"  # "RIGHT ARROW"
            row, col = @cursor_pos[0], @cursor_pos[1] + 1
           if valid_range?(col)
                @cursor_pos = [row, col]
           end
           self.render
        when "\e[D" # "LEFT ARROW"
            row, col = @cursor_pos[0], @cursor_pos[1] - 1
           if valid_range?(col)
                @cursor_pos = [row, col]
           end
           self.render
        else
            self.render
        end
    end

    def valid_range?(range)
        range.between?(0, @board.length - 1)
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

    def start_the_game
        @board.create_tiles
        @board.set_bombs
        @board.find_neighbors
        @board.check_for_valid_neighbors
        @board.neighbors_for_bombs
        self.render
    end

    def play_turn
        self.move
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
                    if @cursor_pos == [row, col]
                        print "_".ljust(2)
                    else
                        print "_".ljust(2).colorize(:green)
                    end
                elsif @board[row, col].flagged == true
                    if @cursor_pos == [row, col]
                        print "f".ljust(2)
                    else
                        print "f".ljust(2).colorize(:blue)
                    end
                elsif  @board[row, col].revealed == true && @board[row, col].bomb == true
                   print "*".ljust(2).colorize(:red)
                else
                    if @cursor_pos == [row, col]
                        print "#{@board[row, col].neighbors_bomb_count}".ljust(2)
                    else
                        print "#{@board[row, col].neighbors_bomb_count}".ljust(2).colorize(:yellow)
                    end
                end
            end
            print"|".colorize(:green)
            puts
        end
        puts "Current position is #{@cursor_pos}"
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