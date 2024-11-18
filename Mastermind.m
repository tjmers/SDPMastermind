% Software Design Proect -- Mastermind game
% Group Q - Frank Adamo, Kanada Ma, Lainey Eckles, and Jacob Myers

clear

% Constants for the different sprites that appear on the spritesheet


% Numbers correspond to the index in the spritesheet
EMPTY = 1;
BLUE = 4;
GREEN = 5;
ORANGE = 6;
PINK = 7;
PURPLE = 8;
RED = 9;
CYAN = 10;
YELLOW = 11;
BLANK = 12;

% Least and Greatest out of all of the colors
MIN_COLOR = 4;
MAX_COLOR = 11;



N_ROWS = 12;
board = ones(N_ROWS, 4, 'int32');

% The correct sequence, randomly generated.
answer = randi(MAX_COLOR - MIN_COLOR + 1, [1, 4]) + MIN_COLOR - 1;


% Create simpleGameEngine object
ZOOM = 1.9;
SPRITE_WIDTH = 72;
SPRITE_HEIGHT = 58;
BACKGROUND_COLOR = [255, 255, 255];
current_scene = simpleGameEngine('Mastermind.png', SPRITE_HEIGHT, SPRITE_WIDTH, ZOOM, BACKGROUND_COLOR);


% The row that the player is currently adjusting
current_row = 1;

% The matrix that represents the right side of the game -- whether or not
% the player is correct in their final decisions
correct = ones(size(board));

% The matrix that represents the player's choices
board(1, :) = [MIN_COLOR, MIN_COLOR, MIN_COLOR, MIN_COLOR];
% Draw the screen once before getting input
update_screen(current_scene, board, correct);

% Game loop
while ~game_over(board, answer, current_row)
    
    % Try catch block to catch the error when the window is closed while
    % the game is still running
    try
        [mouse_row, mouse_column, mouse_button] = getMouseInput(current_scene);
    catch
        break
    end
    
    if mouse_row == current_row && mouse_column >= 1 && mouse_column <= 4 && mouse_button ~= 2
        % Mouse is clicked in the left hand side of the game area on the
        % current row
        
        % Increment the color if it is left clicked, decrement if right
        % clicked

        if mouse_button == 1
            board(current_row, mouse_column) = board(current_row, mouse_column) + 1;

            % Make sure that if the click puts the color out of bounds
            % (outside of the range [MIN_COLOR, MAX_COLOR]), reset to the
            % minimum or maximum color value
            if board(current_row, mouse_column) > MAX_COLOR
                board(current_row, mouse_column) = MIN_COLOR;
            end
        else
            board(current_row, mouse_column) = board(current_row, mouse_column) - 1;
            if board(current_row, mouse_column) < MIN_COLOR
                board(current_row, mouse_column) = MAX_COLOR;
            end
        end
    end

    % Condition to determine when the player is ready to move onto the next
    % row. Currently is clicking on the next row.
    % TODO - since the last row must be clicked in order to move on, the
    % last guess cannot be submitted
    if mouse_row == current_row + 1
        correct(current_row, :) = get_num_corrects(board, current_row, answer);
        current_row = current_row + 1;

        % Copy the row just submitted down to the next row if the game is
        % not over
        if ~game_over(board, answer, current_row)
            board(current_row, :) = board(current_row - 1, :);
        end
    end

    % Draw the screen again
    update_screen(current_scene, board, correct);

end


function update_screen(scene, board, correct)
    % Draws the current scene to the screen
    % scene - the simpleGameEngine object with the mastermind spritesheet
    % board - user game board
    % correct - the right hand side of the game board that shows how the
    %           user is correct with their guesses

    dividor = ones(length(board), 1) * 12;
    
    drawScene(scene, [board, dividor, correct]);
end

function corrects = get_num_corrects(board, row, answer)
    % Determines the number of correct user inputs
    % board - user game board
    % row - the row in the board to analyze
    % answer - the correct sequence
    % Returns the matrix of the same size as the board, with:
    % 1 indicating incorrect
    % 2 indicating correct color but not position
    % 3 indication correct color and position
    % The numbers above coorospond to their position in the spritesheet

    corrects = ones([1, 4]);
    

    % Index in the column array, we move left to right regardless of
    % where we find matches such that the corrects vector ends up being
    % sorted in non ascending order
    corrects_index = 1;

    % Logical array to make sure that nothing is double counted
    used_answer = zeros(1, 4);
    used_board = zeros(1, 4);

    % Take care of 3s.
    for column = 1:4
        if (board(row, column) == answer(column))
            corrects(corrects_index) = 3;
            corrects_index = corrects_index + 1;
            used_answer(column) = 1;
            used_board(column) = 1;
        end
    end
    
    % Take care of 2s
    for column_board = 1:4
        if used_board(column_board)
            continue;
        end

        % Use a linear search to determine if the current 
        correct = 0;
        for column_answers = 1:4
            % Do not double count
            if used_answer(column_answers)
                continue;
            end
            if board(row, column_board) == answer(column_answers)
                correct = 1;
                used_answer(column_answers) = 1;
                break;
            end
        end

        % If the linear search found the element, add it to the correct
        if correct
            corrects(corrects_index) = 2;
            corrects_index = corrects_index + 1;
        end

    end
end

function over = game_over(board, answer, row_number)
    % Determines whether or not the game is over
    % board - user game board
    % answer - the correct color sequence
    % row_number - the row that the player is currently editing
    % Returns whether or not the game is over

    % Case where the player loses
    if row_number >= length(board) + 1
        over = 1;
    elseif row_number == 1
        over = 0;
    % Case where the player wins
    else
        over = 1;
        for i = 1:4
            if board(row_number - 1, i) ~= answer(i)
                over = 0;
                break;
            end
        end
    end
    
end

clear
