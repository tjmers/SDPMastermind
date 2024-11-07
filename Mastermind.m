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
board = enter_row(board, [MIN_COLOR, MIN_COLOR, MIN_COLOR, MIN_COLOR], current_row);

% Draw the screen once before getting input
update_screen(current_scene, board, correct);

% Game loop
while ~game_over(board, answer, current_row)
    
    [mouse_row, mouse_column, mouse_button] = getMouseInput(current_scene);

    if mouse_row == current_row && mouse_column >= 1 && mouse_column <= 4 && mouse_button ~= 2
        % Mouse is clicked in the left hand side of the game area on the
        % current row
        
        % Increment the color if it is left clicked, decrement if right
        % clicked

        if mouse_button == 1
            board(current_row, mouse_column) = board(current_row, mouse_column) + 1;
            if board(current_row, mouse_column) > YELLOW
                board(current_row, mouse_column) = BLUE;
            end
        else
            board(current_row, mouse_column) = board(current_row, mouse_column) - 1;
            if board(current_row, mouse_column) < BLUE
                board(current_row, mouse_column) = YELLOW;
            end
        end
    end

    % Condition to determine when the player is ready to move onto the next
    % row. Currently is clicking on the next row
    if mouse_row == current_row + 1
        correct = get_num_corrects(board, answer);
        current_row = current_row + 1;

        % Copy the row just submitted down to the next row
        if current_row <= length(board)
            board(current_row, :) = board(current_row - 1, :);
        end
    end


    update_screen(current_scene, board, correct);

end


function update_screen(scene, board, correct)
    % Draws the current scene to the screen

    dividor = ones(length(board), 1) * 12;
    
    drawScene(scene, [board, dividor, correct]);
end

function new_board = enter_row(board, input, current_row)
    % Enters the row data into the board matrix

    new_board = board;

    for i = 1:4
        new_board(current_row, i) = input(i);
    end

end

function corrects = get_num_corrects(board, answer)
    % Determines the number of correct user inputs
    % Returns the matrix of the same size as the board, with:
    % 1 indicating incorrect
    % 2 indicating correct color but not position
    % 3 indication correct color and position


    corrects = ones(size(board));
    
    % Repeat over each row
    for row = 1:length(corrects)

        % Index in the column array, we move left to right regardless of
        % where we find matches
        column_corrects = 1;

        % Makes sure that nothing is double counted
        used_answer = zeros(1, 4);
        used_board = zeros(1, 4);

        % Take care of 3s.
        for column = 1:4
            if (board(row, column) == answer(column))
                corrects(row, column_corrects) = 3;
                column_corrects = column_corrects + 1;
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
                corrects(row, column_corrects) = 2;
                column_corrects = column_corrects + 1;
            end

        end

    end
end

function over = game_over(board, answer, row_number)
    % Determines whether or not the game is over

    % Case where the player loses
    if row_number >= length(board)
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
