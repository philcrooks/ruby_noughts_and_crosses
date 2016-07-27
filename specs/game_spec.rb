require('minitest/autorun')
require('minitest/rg')
require_relative('../game.rb')

class TestBoard < MiniTest::Test
  def test_get_row
    board = Board.new()
    assert_equal("456", board.get_row(1))
    assert_equal("123", board.get_row(3))
  end

  def test_get_column
    board = Board.new()
    assert_equal("258", board.get_column(1))
    assert_equal("369", board.get_column(5))
  end

  def test_get_diagonal
    board = Board.new()
    assert_equal("357", board.get_diagonal(1))
    assert_equal("159", board.get_diagonal(0))
  end

  def test_occupied
    board = Board.new()
    assert_equal(false, board.occupied?("1"))
  end

  def test_position_piece
    board = Board.new()
    board.position_piece(2, "X")
    assert_equal("1X3", board.get_row(0))
  end

  def test_get_piece
    board = Board.new()
    board.position_piece(2, "X")
    assert_equal("1X3", board.get_row(0)) 
    board.position_piece(3, "O")
    assert_equal("1XO", board.get_row(0)) 
    board.position_piece(1, "X")
    assert_equal("XXO", board.get_row(0)) 
  end

  def test_winner
    board = Board.new()
    assert_equal(false, board.winner?("X"))
    board.position_piece(1, "X")
    assert_equal(false, board.winner?("X"))
    board.position_piece(9, "X")
    assert_equal(false, board.winner?("X"))
    board.position_piece(5, "X")
    assert_equal(true, board.winner?("X"))
  end

  # def test_retrieval
  #   board = Board.new()
  #   board.position_piece(9, "X")
  #   assert_equal("X", board.retrieve_piece(9))
  #   assert_equal(nil, board.retrieve_piece(8))
  # end

  def test_free_cells
    board = Board.new()
    board.position_piece(9, "X")
    board.position_piece(8, "0")
    assert_equal([1, 2, 3, 4, 5, 6, 7], board.free_cells)
  end 
end