require_relative './board'

class GameRunner

# This class handles the game logic and the code to 
  PLAYER_PIECES = ["X", "O"]

  def initialize (computer_player_no = 1)
    @board = Board.new()
    @computer_player_no = computer_player_no
  end

  def game_over?()
    result = false
    for player_piece in PLAYER_PIECES
      result = result || @board.winner?(player_piece)
    end
    return result || (@board.free_cells.count == 0)
  end

  def get_enemy(player_no)
    return (player_no + 1) % PLAYER_PIECES.count
  end

  def max_move (moves)
    i = mark = 0
    count = moves.count
    m = moves.shuffle
    while i < count
      mark = i if m[i][:score] > m[mark][:score]
      i += 1
    end
    return m[mark]
  end

  def min_move (moves)
    i = mark = 0
    count = moves.count
    m = moves.shuffle
    while i < count
      mark = i if m[i][:score] < m[mark][:score]
      i += 1
    end
    return m[mark]
  end

  def compute_move(board, depth, player_no)
    free_cells = board.free_cells
    # Work out if the game is over and return the appropriate value
    if board.winner?(PLAYER_PIECES[@computer_player_no])
      return 10 - depth
    elsif board.winner?(PLAYER_PIECES[get_enemy(@computer_player_no)])
      return depth - 10
    elsif free_cells.count == 0
      # Tied game - no further moves possible
      return 0
    end
    # The game is not over so there must be some free cells to look at
    moves = []
    for free_cell in free_cells
      board.position_piece(free_cell, PLAYER_PIECES[player_no])
      # Have made an arbitrary move - find out the implications
      moves << { move: free_cell, score: compute_move(board.clone, depth + 1, get_enemy(player_no)) }
      # Undo the move
      board.position_piece(free_cell, free_cell.to_s)
    end

    if player_no == @computer_player_no
      move = max_move(moves)
      return move[:move] if depth == 1
      return move[:score]
    end
    move = min_move(moves)
    return move[:score]
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
        move = compute_move(@board.clone, 1, player_no)
        @board.position_piece(move, PLAYER_PIECES[player_no])
        puts @board.to_s
        puts "The computer played in cell #{move}"
      else
        print "Where would you like to play? "
        @board.position_piece( gets.chomp.to_i, PLAYER_PIECES[player_no])
      end
      move_count += 1
    end
    if @board.winner?(PLAYER_PIECES[@computer_player_no])
      puts("The computer is victorious!!!")
    elsif @board.winner?(PLAYER_PIECES[get_enemy(@computer_player_no)])
      puts("I didn't think I would ever say this but you win.")
    else
      puts("Cat's game. Are you bored yet?")
    end
  end
end

want_to_play = true
computer_player_no = 1
while want_to_play
  game = GameRunner.new(computer_player_no)
  game.play_one_game
  print "Do you want to play again (y/n)? "
  want_to_play = (gets.chomp.downcase == "y")
  if want_to_play
    computer_player_no = (computer_player_no + 1) % GameRunner::PLAYER_PIECES.count
    puts "Here we go again..."
  end
end