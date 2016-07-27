require_relative ('./board')

class MoveMaker

  # This class provides one method called compute_move() which calculates the best move for the computer
  
  def initialize(player_pieces)
    @player_pieces = player_pieces
    @computer_player_no = nil
  end

  def compute_move(board, player_no)
    # Only ever called to determine the next move for the computer
    @computer_player_no = player_no
    return find_best_move(board, 1, player_no)
  end

  private

  def get_enemy(player_no)
    return (player_no + 1) % @player_pieces.count
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

  def find_best_move(board, depth, player_no)
    free_cells = board.free_cells
    # Work out if the game is over and return the appropriate value
    if board.winner?(@player_pieces[@computer_player_no])
      return 10 - depth
    elsif board.winner?(@player_pieces[get_enemy(@computer_player_no)])
      return depth - 10
    elsif free_cells.count == 0
      # Tied game - no further moves possible
      return 0
    end
    # The game is not over so there must be some free cells to look at
    moves = []
    for free_cell in free_cells
      board.position_piece(free_cell, @player_pieces[player_no])
      # Have made an arbitrary move - find out the implications
      moves << { move: free_cell, score: find_best_move(board.clone, depth + 1, get_enemy(player_no)) }
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

end