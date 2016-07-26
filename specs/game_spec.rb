require('minitest/autorun')
require('minitest/rg')
require_relative('../game.rb')

class TestBoard < MiniTest::Test
  def test_get_row
    board = Board.new(["X", "O"])
    assert_equal("456", board.get_row(1))
    assert_equal("123", board.get_row(3))
  end

  def test_get_column
    board = Board.new(["X", "O"])
    assert_equal("258", board.get_column(1))
    assert_equal("369", board.get_column(5))
  end

  def test_get_diagonal
    board = Board.new(["X", "O"])
    assert_equal("357", board.get_diagonal(1))
    assert_equal("159", board.get_diagonal(0))
  end

  def test_position_piece
    board = Board.new(["X", "O"])
    board.position_piece(2, "X")
    assert_equal("1X3", board.get_row(0))
  end

  def test_get_piece
    board = Board.new(["X", "O"])
    assert_equal("X", board.get_player_piece())
    board.position_piece(2)
    assert_equal("1X3", board.get_row(0)) 
    board.position_piece(3)
    assert_equal("1XO", board.get_row(0)) 
    board.position_piece(1)
    assert_equal("XXO", board.get_row(0)) 
  end

  def test_winner
    board = Board.new(["X", "O"])
    assert_equal(false, board.winner?("X"))
    board.position_piece(1, "X")
    assert_equal(false, board.winner?("X"))
    board.position_piece(9, "X")
    assert_equal(false, board.winner?("X"))
    board.position_piece(5, "X")
    assert_equal(true, board.winner?("X"))
  end

  def test_to_s
    board = Board.new(["X", "O"])
    puts board.to_s
  end
end