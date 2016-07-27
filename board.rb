require ('colorize')

class Board
  PADDING = "   |   |   \n"
  BOARD_SIZE = 3

  def initialize()
    @board = [["1", "2", "3"], ["4", "5", "6"], ["7", "8", "9"]]
    @last_position = nil
  end

  def to_s
    c = p = 0
    s = ""
    for row in @board
      s += PADDING
      for cell in row
        p += 1
        color = (p == @last_position ? :red : :cyan)
        s += (occupied?(cell) ? " #{cell.colorize(color)} |" : " #{cell.colorize(:yellow)} |")
      end
      s[-1] = "\n" + PADDING
      s += ("-" * 11) + "\n" if c < BOARD_SIZE - 1
      c += 1
    end
    return s
  end

  def position_piece(position, player_piece)
    @last_position = position
    row, col = position_to_row_and_column(position)
    @board[row][col] = player_piece
  end

  def winner?(player_piece)
    s = player_piece * BOARD_SIZE
    c = 0
    result = false
    while c < BOARD_SIZE
      result = result || ((get_row(c) == s) || (get_column(c) == s))
      c += 1
    end
    result = result || ((get_diagonal(0) == s) || (get_diagonal(1) == s))
    return result
  end

  def free_cells
    cells = []
    for row in @board
      for cell in row
        cells << cell.to_i if !occupied?(cell)
      end
    end
    return cells
  end

  # private

  def occupied? (cell)
    return !(("1".."9").member?(cell))
  end

  def position_to_row_and_column(position)
    return (position - 1) / BOARD_SIZE, (position - 1) % BOARD_SIZE
  end

  def get_row(row_no)
    row_no = ((row_no ) % BOARD_SIZE)
    return @board[row_no].join
  end

  def get_column(col_no)
    col_no = ((col_no) % BOARD_SIZE)
    r = []
    for row in @board
      r.push row[col_no]
    end
    return r.join
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
    return r.join
  end
end