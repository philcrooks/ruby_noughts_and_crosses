class Board
  PADDING = "   |   |   \n"
  BOARD_SIZE = 3
  PIECES = ["X", "O"]

  def initialize()
    @board = [["1", "2", "3"], ["4", "5", "6"], ["7", "8", "9"]]
    @move_count = 0
  end

  def to_s
    c = 0
    s = ""
    for row in @board
      s += PADDING
      for cell in row
        s += " #{cell} |"
      end
      s[-1] = "\n" + PADDING
      s += ("-" * 11) + "\n" if c < BOARD_SIZE - 1
      c += 1
    end
    return s
  end

  def to_ary
    return @board
  end

  def get_player_piece()
    return PIECES[@move_count % 2]
  end

  def make_move(position, player_piece = nil)
    row = (position - 1) / BOARD_SIZE
    col = (position - 1) % BOARD_SIZE
    player_piece = get_player_piece() if !player_piece
    @board[row][col] = player_piece
    @move_count += 1
  end

  def get_row(row_no)
    row_no = ((row_no ) % BOARD_SIZE)
    return @board[row_no]
  end

  def get_column(col_no)
    col_no = ((col_no) % BOARD_SIZE)
    r = []
    for row in @board
      r.push row[col_no]
    end
    return r
  end

  def get_diagonal(diag_no)
    diag_no = ((diag_no) % 2)
    if diag_no == 0
      cells = [{row: 0, col: 0},{row: 1, col: 1},{row: 2, col: 2}]
    else
      cells = [{row: 0, col: 2},{row: 1, col: 1},{row: 2, col: 0}]
    end
    r = []
    for c in cells
      r.push @board[c[:row]][c[:col]]
    end
    return r
  end

  def get_row_as_string(row_no)
    return get_row(row_no).join
  end

  def get_column_as_string(col_no)
    return get_column(col_no).join
  end

  def get_diagonal_as_string(diag_no)
    return get_diagonal(diag_no).join
  end

  def winner?(player_piece)
    s = player_piece * BOARD_SIZE
    c = 0
    result = false
    while c < BOARD_SIZE
      result ||= ((get_row_as_string(c) == s) || (get_column_as_string(c) == s))
      c += 1
    end
    result ||= ((get_diagonal_as_string(0) == s) || (get_diagonal_as_string(1) == s))
    return result
  end
end
