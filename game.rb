class Game

  BLANK_BOARD_SPACE = " "
  HUMAN = "X"
  COMPUTER = "O"
  WINNING_COMBOS = [ [0, 1, 2],
                     [3, 4, 5],
                     [6, 7, 8],
                     [0, 3, 6], 
                     [1, 4, 7],
                     [2, 5, 8],
                     [0, 4, 8],
                     [2, 4, 6] ]

  def initialize
    @board = Array.new(9, BLANK_BOARD_SPACE)
    @turn_count = 1
  end

  def sample_board
    puts [ " 1 | 2 | 3  ",
           "---+---+---",
           " 4 | 5 | 6  ",
           "---+---+---",
           " 7 | 8 | 9  " ]
  end

  def display
    puts [ " #{@board[0]} | #{@board[1]} | #{@board[2]}  ",
           "---+---+---",
           " #{@board[3]} | #{@board[4]} | #{@board[5]}  ",
           "---+---+---",
           " #{@board[6]} | #{@board[7]} | #{@board[8]}  \n\n" ]
  end

  def welcome
    clear_screen
    puts "\n\n+++++++++++++Tic Tac Toe+++++++++++++\n\n"
    puts "You will be playing against the computer. Here's a sample board: \n\n"
    sample_board
    puts"\n\nWhen prompted, enter the space number that you would like to occupy. You are 'X' and the computer is 'O'. You go first. Press the enter key to begin. Good luck!\n\n"
    gets
    clear_screen
    display 
  end

  def clear_screen
    print %x{clear}
  end

  def play
    welcome 
    while @turn_count <= 9
      switch_player
      clear_screen
      display
      if winner?(HUMAN) || winner?(COMPUTER)
        break
      end
    end
    final_results
  end

  def player1
    print "Your move: "
    player1_choice = gets.chomp.to_i - 1
    if valid_move?(player1_choice)
      make_move(player1_choice, HUMAN)
      @turn_count += 1
    else
      puts "Please choose an empty space by entering a number 1-9"
      player1
    end
  end

  def computer
    print "Computer move..."
    computer_choice = possible_moves.sample
    sleep(2)
    make_best_move
    @turn_count += 1
  end

  def valid_move?(move)
    (0..8).include?(move) && @board[move] == BLANK_BOARD_SPACE
  end

  def switch_player
    if @turn_count % 2 == 1
      player1
    else
      computer
    end
  end

  def make_move(space, player)
    @board[space] = player
  end

  def possible_moves
    @board.each_index.select { |index| @board[index] == BLANK_BOARD_SPACE }
  end

  def possible_boards
    boards = []
      possible_moves.each do |move|
      possible_board = @board.dup 
        possible_board[move] = COMPUTER
        boards << possible_board
      end
    boards 
  end

  def possible_wins(current_board, player)
    win_counter = 0
    WINNING_COMBOS.each do |index1, index2, index3|
      if [BLANK_BOARD_SPACE, BLANK_BOARD_SPACE, BLANK_BOARD_SPACE] == [current_board[index1], current_board[index2], current_board[index3]] ||
         [player, player, BLANK_BOARD_SPACE].sort == [current_board[index1], current_board[index2], current_board[index3]].sort ||
         [player, BLANK_BOARD_SPACE, BLANK_BOARD_SPACE].sort == [current_board[index1], current_board[index2], current_board[index3]].sort 
         win_counter += 1
      end
    end
    win_counter
  end

  def board_scores
    scores = []
    possible_boards.each do |possible_board|
      computer_total = possible_wins(possible_board, COMPUTER)
      player1_total = possible_wins(possible_board, HUMAN)
      board_score = computer_total - player1_total
      scores << board_score
    end
    scores
  end

  def scores_list
    possibilities_list = {}
    score = 0
    possible_boards.each do |possible_board|
      possibilities_list[possible_board] = board_scores[score]
      score += 1
    end
    possibilities_list
  end

  def best_choice
    scores_list.max_by { |board, score| score }[0]
  end

  def computer_opening_move?
    @turn_count == 2
  end

  def computer_second_move?
    @turn_count == 4
  end

  def player1_on_corner?
    @board[0] == HUMAN || @board[2] == HUMAN || @board[6] == HUMAN || @board[8] == HUMAN
  end

  def player1_on_edge?
    @board[1] == HUMAN || @board[3] == HUMAN || @board[5] == HUMAN || @board[7] == HUMAN
  end

  def center_taken?(player)
    @board[4] == player
  end

  def select_center_space
    @board[4] = COMPUTER 
  end

  def select_edge_space
    edges = [1, 3, 5, 7]
    if (@board[0] == HUMAN || @board[2] == HUMAN) && @board[7] == HUMAN
      edges.shift
      edges.any? do |edge|
        if @board[edge] == BLANK_BOARD_SPACE
          @board[edge] = COMPUTER
        end
      end
    else
      edges.any? do |edge|
        if @board[edge] == BLANK_BOARD_SPACE
          @board[edge] = COMPUTER
        end
      end
    end
  end

  def block_win
    WINNING_COMBOS.each do |index1, index2, index3|
      if [BLANK_BOARD_SPACE, HUMAN, HUMAN] == [@board[index1], @board[index2], @board[index3]] 
        @board[index1] = COMPUTER
      elsif [HUMAN, HUMAN, BLANK_BOARD_SPACE] == [@board[index1], @board[index2], @board[index3]] 
        @board[index3] = COMPUTER
      elsif [HUMAN, BLANK_BOARD_SPACE, HUMAN] == [@board[index1], @board[index2], @board[index3]]
        @board[index2] = COMPUTER
      end    
    end 
  end

  def take_win
    WINNING_COMBOS.each do |index1, index2, index3|
      if [BLANK_BOARD_SPACE, COMPUTER, COMPUTER] == [@board[index1], @board[index2], @board[index3]] 
        @board[index1] = COMPUTER
      elsif [COMPUTER, COMPUTER, BLANK_BOARD_SPACE] == [@board[index1], @board[index2], @board[index3]] 
        @board[index3] = COMPUTER
      elsif [COMPUTER, BLANK_BOARD_SPACE, COMPUTER] == [@board[index1], @board[index2], @board[index3]]
        @board[index2] = COMPUTER
      end    
    end 
  end

  def can_win?(player)
    WINNING_COMBOS.any? do |index1, index2, index3|
      [BLANK_BOARD_SPACE, player, player] == [@board[index1], @board[index2], @board[index3]] || 
      [player, player, BLANK_BOARD_SPACE] == [@board[index1], @board[index2], @board[index3]] ||
      [player, BLANK_BOARD_SPACE, player] == [@board[index1], @board[index2], @board[index3]]    
    end  
  end

  def make_best_move
    if can_win?(COMPUTER)
      take_win
    elsif can_win?(HUMAN) 
      block_win
    else
      if computer_opening_move? && (player1_on_corner? || player1_on_edge?)
        select_center_space
      elsif computer_second_move? && player1_on_corner? && center_taken?(COMPUTER) 
        select_edge_space
      else
        @board.replace(best_choice)
      end
    end
  end

  def winner?(player)
    WINNING_COMBOS.any? do |index1, index2, index3|
      [player, player, player] == [@board[index1], @board[index2], @board[index3]]
    end
  end

  def draw?
    !winner?(COMPUTER) && !winner?(HUMAN) && possible_moves.empty?
  end

  def final_results
    if winner?(COMPUTER)
      puts "Computer wins!!"
    elsif winner?(HUMAN)
      puts "You win!!"
    elsif draw?
      puts "The game is a draw."
    end
  end

end

game = Game.new
game.play