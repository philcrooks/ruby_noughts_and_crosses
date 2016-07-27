require_relative './board'
require_relative './movemaker'

class GameRunner

  # This class handles the game logic

  PLAYER_PIECES = ["X", "O"]

  def initialize (computer_player_no = 1)
    @board = Board.new()
    @ai = MoveMaker.new(PLAYER_PIECES)
    @computer_player_no = computer_player_no
    @game_count = 0
    @computer_wins = 0
    @human_wins = 0
  end

  def next_player_no(current_player_no)
    return (current_player_no + 1) % PLAYER_PIECES.count
  end
  
  alias_method :get_enemy, :next_player_no

  def play_repeatedly
    want_to_play = true
    while want_to_play
      play_one_game
      print "Do you want to play again (y/n)? "
      want_to_play = (gets.chomp.downcase == "y")
      if want_to_play
        @computer_player_no = next_player_no(@computer_player_no)
        @board = Board.new()
        puts "Here we go again..."
      end
    end
  end

  private

  def game_over?()
    result = false
    for player_piece in PLAYER_PIECES
      result = result || @board.winner?(player_piece)
    end
    return result || (@board.free_cells.count == 0)
  end

  def play_one_game
    move_count = 0
    if @computer_player_no == 0
      puts "Computer to play first..."
    else
      puts @board.to_s
    end
    while !game_over?
      player_no = move_count % PLAYER_PIECES.count
      if player_no == @computer_player_no
        move = @ai.compute_move(@board.clone, player_no)
        @board.position_piece(move, PLAYER_PIECES[player_no])
        puts @board.to_s
        puts "The computer played in cell #{move}"
      else
        print "Where would you like to play? "
        move = gets.chomp.to_i
        while !@board.free_cells.include?(move)
          puts "That is not the number of a free cell."
          print "Where would you like to play? "
          move = gets.chomp.to_i
        end
        @board.position_piece(move , PLAYER_PIECES[player_no])
      end
      move_count += 1
    end
    @game_count += 1
    if @board.winner?(PLAYER_PIECES[@computer_player_no])
      @computer_wins += 1
      puts "The computer is victorious!!!"
      puts "We've played #{@game_count} games and I have won #{@computer_wins} of them." if (@computer_wins > 0) && (@game_count > 1)
    elsif @board.winner?(PLAYER_PIECES[get_enemy(@computer_player_no)])
      @human_wins += 1
      puts("I didn't think I would ever say this but you win.")
    else
      puts "Cat's game. Are you bored yet?"
      puts "We've played #{@game_count} games and have drawn #{@game_count - @computer_wins - @human_wins} of them." if @game_count > 2
    end
  end

end

game = GameRunner.new
game.play_repeatedly