#!/bin/bash/env ruby

class Board
  def initialize(player1 = 'Player One',player2 = 'Player Two')
    @P1, @P2 = player1, player2

    ai_names = Array.new
    ai_names = ["Minmus", "Mark V", "Epic", "Vulcan"]

    @AI = false
    if @P2.downcase == "ai"
      @AI = true
      @P2 = ai_names[rand(ai_names.length)]
    end

    @marks = Hash.new
    @marks[@P1.to_sym] = "X"
    @marks[@P2.to_sym] = "O"

    @board = [[],[]]
    3.times do |row|
      @board[row] = Array.new(3, "_")
    end
  end

  def print_board
    label = 'ABC'
    i = 0
    champions = @P1 + " VS " + @P2

    puts " "*(40 - champions.length / 2) << champions
    puts " "*35 + "   1 2 3"
    @board.each do |board|
      puts " "*35 + "#{label[i]} |#{board.join("|")}|"
      i += 1
    end
  end

  def checker player
    #vertical
    #
    3.times do |i|
      map = @board.map { |column| column[i] }
      case map.join
      when "XXX"
        puts "!!!Congratulations #{player}!!!"
        return false
      when "OOO"
        puts "!!!Congratulations #{player}!!!"
        return false
      end
    end

    #horrizontal
    #
    3.times do |i|
      map = @board[i].join
      case map
      when "XXX"
        puts "!!!Congratulations #{player}!!!"
        return false
      when "OOO"
        puts "!!!Congratulations #{player}!!!"
        return false
      end
    end

    #diagonal
    #
    map0 = Array.new
    map1 = Array.new
    3.times do |i|
      map0 << @board[i][i]
      map1 << @board[i][2-i]
    end
    mapper = [map0,map1]
    mapper.each do |map|
      case map.join
      when "XXX"
        puts "!!!Congratulations #{player}!!!"
        return false
      when "OOO"
        puts "!!!Congratulations #{player}!!!"
        return false
      end
    end
    #end diagnal

    true
  end

  def update player
    c_to_i = { :a => 0,
               :b => 1,
               :c => 2
    }
    anti_cheat = true
    while anti_cheat
      #Get cell
      #
      unless (player == @P2) && @AI
        print "#{player} place #{@marks[player.to_sym]} were?:"
        location = gets.chomp
      else
        update_ai
        break
      end

      if location.length != 2
        puts "Please put #{@marks[player.to_sym]} in a valid entry"
        anti_cheat = true
        next
      end

      #make sure row is correct
      #
      row = location[0]
      unless row < 'd' && row >= 'a'
        puts "Please put #{@marks[player.to_sym]} in a valid entry"
        anti_cheat = true
        next
      end

      #make sure column is correct
      #
      column = location[1].to_i - 1 
      unless 0 <= column && column <= 2
        puts "Please put #{@marks[player.to_sym]} in a valid entry"
        anti_cheat = true
        next
      end

      #place cell
      #
      case @board[c_to_i[row.to_sym]][column]
      when "_"
        @board[c_to_i[row.to_sym]][column] = @marks[player.to_sym]
        anti_cheat = false
      else 
        puts "Please pick an empty cell"
        anti_cheat = true
      end
    end
  end

  def update_ai
    while true
      row = rand(3)
      column = rand(3)
      if @board[row][column] == '_'
        @board[row][column] = @marks[@P2.to_sym]
        break
      else
        next
      end
    end
  end
  
  def run_game 
    print_board
    game_on = true
    randomizer = rand(100)
    while game_on
      9.times do |i|
        n = (i + randomizer) % 2
        player = n == 1 ? @P1 : @P2

        update player
        print_board
        game_on = checker(player)
        unless game_on 
          break
        end
        if i == 8
          puts "Tie Game"
          game_on = false
        end
      end
    end
  end
end


game_on = true
while game_on
  puts "Who is Player One?"
  player_one = gets.chomp
  puts "Who is Player Two?"
  player_two = gets.chomp

  tick_tac_toe = Board.new(player_one,player_two)
  tick_tac_toe.run_game

  print "Would you like to play another game (Y/N):"
  input = gets.chomp
  game_on = input.downcase == "y" ? true : false
end

