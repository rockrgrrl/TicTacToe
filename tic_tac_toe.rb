class Game

  def initialize(gameboard, player, computer)
    @gameboard = gameboard
    @player = player
    @computer = computer
    @turn_count = 1
  end

  def start
    clear_screen
    puts "\n\n+++++++++++++Tic Tac Toe+++++++++++++\n\n"
    puts "You will be playing against the computer. Here's a sample board: \n\n"
    @gameboard.sample_board
    puts"\n\nWhen prompted, enter the space number that you would like to occupy. You are 'X' and the computer is 'O'. You go first. Press the enter key to begin. Good luck!\n\n"
    gets
    clear_screen
    @gameboard.display 
    puts "\n\n"
  end

  def clear_screen
    print %x{clear}
  end

  def play
    start
    while @turn_count <= 9
      if @turn_count % 2 == 1
        player_move
      else
        computer_move
        sleep(6)
      end
      clear_screen
      @gameboard.display
      puts "\n\n"
      if @turn_count > 5
        check_for_winner
      end
    end
  end

  def player_move
    print "Your move: " 
    player_choice = gets.chomp    
    if player_choice.to_i >= 1 && player_choice.to_i <= 9 && valid_move?(player_choice)
      @gameboard.update_board(player_choice, @player)
      @turn_count += 1
    else
      puts "Please enter a number 1-9. Try again."
      player_move
    end
  end

  def computer_move
    puts "Computer's move"
    sleep(2)
    @gameboard.board.replace(best_choice)
    @turn_count += 1
  end

  # def player_can_win?(directions)
  #   # directions = [rows(@gameboard.board), columns(@gameboard.board), diagonals(@gameboard.board)]
  #   p directions
  #   directions.each do |direction|
  #     if (direction.count(@player) == 2 && direction.count(" ") == 1)
  #       @space_for_block = (direction.index(" ") + 1)
  #       p @space_for_block
  #     end
  #   end
  # end

  # def computer_can_win?(directions)
  #   directions.each do |direction|
  #     if (direction.count(@computer) == 2 && direction.count(" ") == 1)
  #       @space_for_win = (direction.index(" ") + 1)
  #       p @space_for_win
  #     end
  #   end
  # end
  # def computer_can_win?
  #   @gameboard.winning_combos.any? do |combo|
  #     (combo.count(@computer) == 2 && combo.count(" ") == 1)
  #     @space_for_win = (@gameboard.board.index(" ") + 1)
  #     p @space_for_win
  #   end
  # end

  # def take_the_win
  #   @gameboard.update_board(@space_for_win, @computer)
  # end

  # def block_the_win 
  #   @gameboard.update_board(@space_for_block, @computer)
  # end


  def valid_move?(space)
    @gameboard.board[space.to_i - 1] == " "
  end

  def available_spaces(board)
    blank_spaces = @gameboard.board.count(" ")
  end

  def possible_boards
    boards = []
    available_indices = []
    @gameboard.board.map.with_index do |space, index|
      if space == " "
        available_indices << index
      end
    end
    until boards.length == available_spaces(@gameboard)
      possible_board = @gameboard.board.clone
      possible_move = available_indices.first
      available_indices.shift
      possible_board[possible_move] = @computer
      boards << possible_board
    end
    boards
  end

  def scores_list
    possibilities_list = {}
    score = 0
    possible_boards.each do |board|
        possibilities_list[board] = board_scores[score]
        score += 1
    end
    possibilities_list
    p possibilities_list
  end

  def best_choice
    scores_list.max_by { |board, score| score}[0]
  end

  def possible_wins(directions, player)
    win_counter = 0
    directions.each do |direction|
      if direction.count(" ") == 3 || (direction.count(" ") == 2 && direction.count(player) == 1) || (direction.count(" ") == 1 && direction.count(player) == 2)
       win_counter += 1
      end
    end
    win_counter
  end

  def board_scores
    scores = []
    possible_boards.each do |possible_board|
      @computer_total = possible_wins(rows(possible_board), @computer) + possible_wins(columns(possible_board), @computer) + possible_wins(diagonals(possible_board), @computer)
      @player_total = possible_wins(rows(possible_board), @player) + possible_wins(columns(possible_board), @player) + possible_wins(diagonals(possible_board), @player)
      @board_score = @computer_total - @player_total
      scores << @board_score
    end
    scores
  end

  def check_for_winner
    check_board(rows(@gameboard.board))
    check_board(columns(@gameboard.board))
    check_board(diagonals(@gameboard.board))
  end

  def diagonals(current_board)
    diagonal1 = current_board[0], current_board[4], current_board[8]
    diagonal2 = current_board[2], current_board[4], current_board[6]
    diagonals = [diagonal1, diagonal2] 
  end

  def rows(current_board)
    rows = current_board[0..2], current_board[3..5], current_board[6..8]
  end

  def columns(current_board)
    column1 = current_board[0], current_board[3], current_board[6]
    column2 = current_board[1], current_board[4], current_board[7]
    column3 = current_board[2], current_board[5], current_board[8]
    columns = [column1, column2, column3]
  end

  def check_board(directions)
    
    directions.each do |direction|
      if direction.count(@player) == 3
        player_win
      elsif direction.count(@computer) == 3
        computer_win
      end
    end
  end

   def player_win
    puts "You win!!"
    game_over
  end

  def computer_win
    puts "Computer win!!"
    game_over
  end

  def game_over
    @turn_count = 10  
  end
end

class Board 

   attr_reader :board
  #  attr_accessor :winning_combos

  # WINNERS = [ [0, 1, 2],
  #             [3, 4, 5],
  #             [6, 7, 8],
  #             [0, 3, 6], 
  #             [1, 4, 7],
  #             [2, 5, 8],
  #             [0, 4, 8],
  #             [2, 4, 6] ]
  

  def initialize
    @board = Array.new(9, " ")
    # @winning_combos = WINNERS
  end
  

  def display
    puts [
      " #{@board[0]} | #{@board[1]} | #{@board[2]}  ",
      "---+---+---",
      " #{@board[3]} | #{@board[4]} | #{@board[5]}  ",
      "---+---+---",
      " #{@board[6]} | #{@board[7]} | #{@board[8]}  "
    ]
  end 

  def sample_board
    puts [
      " 1 | 2 | 3  ",
      "---+---+---",
      " 4 | 5 | 6  ",
      "---+---+---",
      " 7 | 8 | 9  "
    ]
  end

  def update_board(space, player)
    @board[space.to_i - 1] = player  
  end

end


class Play
  def initialize
  end

  def begin_game
    @board = Board.new
    @player = "X"
    @computer = "O"
    @game = Game.new(@board, @player, @computer)
    @game.play
  end
end


new_game = Play.new
new_game.begin_game





