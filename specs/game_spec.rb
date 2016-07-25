require('minitest/autorun')
require('minitest/rg')
require_relative('../game.rb')

class TestBoard < MiniTest::Test
  def test_get_row
    board = Board.new
    assert_equal(["4", "5", "6"], board.get_row(1))
    assert_equal(["1", "2", "3"], board.get_row(3))
    assert_equal("456", board.get_row_as_string(1))
    assert_equal("123", board.get_row_as_string(3))
  end

  def test_get_column
    board = Board.new
    assert_equal(["2", "5", "8"], board.get_column(1))
    assert_equal(["3", "6", "9"], board.get_column(5))
    assert_equal("258", board.get_column_as_string(1))
    assert_equal("369", board.get_column_as_string(5))
  end

  def test_get_diagonal
    board = Board.new
    assert_equal(["3", "5", "7"], board.get_diagonal(1))
    assert_equal(["1", "5", "9"], board.get_diagonal(0))
    assert_equal("357", board.get_diagonal_as_string(1))
    assert_equal("159", board.get_diagonal_as_string(0))
  end

  def test_make_move
    board = Board.new
    board.make_move(2, "X")
    assert_equal("1X3", board.get_row_as_string(0))
  end

  def test_get_piece
    board = Board.new
    assert_equal("X", board.get_player_piece())
    board.make_move(2)
    assert_equal("1X3", board.get_row_as_string(0)) 
    board.make_move(3)
    assert_equal("1XO", board.get_row_as_string(0)) 
    board.make_move(1)
    assert_equal("XXO", board.get_row_as_string(0)) 
  end


  def test_winner
    board = Board.new
    assert_equal(false, board.winner?("X"))
    board.make_move(1, "X")
    assert_equal(false, board.winner?("X"))
    board.make_move(9, "X")
    assert_equal(false, board.winner?("X"))
    board.make_move(5, "X")
    assert_equal(true, board.winner?("X"))
  end

  def test_to_s
    board = Board.new
    puts board.to_s
  end
end