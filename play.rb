require_relative './game'

class Play
  PLAYER_PIECES = ["X", "O"]

  def initialize (computer_player_no = 1)
    @board = Board.new()
    @computer_player_no = computer_player_no
    @debug = true
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
    while i < count
      mark = i if moves[i][:score] > moves[mark][:score]
      i += 1
    end
    return moves[i]
  end

  def min_move (moves)
    i = mark = 0
    count = moves.count
    while i < count
      mark = i if moves[i][:score] < moves[mark][:score]
      i += 1
    end
    return moves[i]
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
      if @debug
        puts "At recursion depth #{depth}"
        puts "Number of free cells = #{free_cells.count}"
        puts "Playing in position #{free_cell}"
      end
      board.position_piece(free_cell, PLAYER_PIECES[player_no])
      # Have made an arbitrary move - find out the implications
      puts board.debug_to_s if @debug
      moves << { move: free_cell, score: compute_move(board.clone, depth + 1, get_enemy(player_no)) }
      # Undo the move
      board.position_piece(free_cell, free_cell.to_s)
    end
    if @debug
      puts "Returning from recursion depth #{depth}"
      puts "Found these moves:\n#{moves}"
      puts
    end
    if player_no == @computer_player_no
      move = max_move(moves)
      return move[:move] if depth == 0
      return move[:score]
    end
    move = min_move(moves)
    return move[:score]
  end

  def take_turns
    move_count = 0
    while !game_over?
      puts @board.to_s
      player_no = move_count % PLAYER_PIECES.count
      if player_no == @computer_player_no
        @board.position_piece(compute_move(@board.clone, 0, player_no), PLAYER_PIECES[player_no])
      else
        print "Where would you like to play? "
        @board.position_piece( gets.chomp.to_i, PLAYER_PIECES[player_no])
      end
      move_count += 1
    end
  end
end

game = Play.new
game.take_turns