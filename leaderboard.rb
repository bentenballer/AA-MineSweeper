require "yaml"

class LeaderBoard
    def initialize
        @leaderboard = []
    end

    def clear
        @leaderboard = []
        self.save
    end

    def add_to_leaderboard(turns)
        @leaderboard << turns
    end

    def save
        File.open("leaderboard", "w") {|file| file.write(self.to_yaml)}
    end

    def display
        @leaderboard.sort!
        @leaderboard = @leaderboard[0..9] if @leaderboard.length > 10
        if @leaderboard.length == 0
            puts "No Leader Board Available"
        else
            puts "Leader Board:"
            @leaderboard.each { |score| puts score }
        end
    end
end