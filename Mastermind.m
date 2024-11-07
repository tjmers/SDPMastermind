% Software Design Proect -- Mastermind game
% Group Q - Frank Adamo, Kanada Ma, Lainey Eckles, and Jacob Myers

clear


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



N_ROWS = 12;
board = ones(N_ROWS, 4, 'int32');

% The correct sequence. In real game this will be randomly generated.
answer = [BLUE, RED, PURPLE, PINK];

% Create simpleGameEngine object
ZOOM = 1.9;
SPRITE_WIDTH = 72;
SPRITE_HEIGHT = 58;
BACKGROUND_COLOR = [255, 255, 255];
current_scene = simpleGameEngine('Mastermind.png', SPRITE_HEIGHT, SPRITE_WIDTH, ZOOM, BACKGROUND_COLOR);

current_row = 1;

% Initial board where nothing is correct
board = enter_row(board, [CYAN, GREEN, ORANGE, YELLOW], current_row);
current_row = current_row + 1;


update_screen(current_scene, board, get_num_corrects(board, answer));
xlabel('Correct sequence: BLUE, RED, PURPLE, PINK');

% Comment for the scene
title('First image: board where nothing is correct');


% Wait for any mouse input to proceed to next step
getMouseInput(current_scene);

% Show a board where there is two correct, but in the wrong spot
board = enter_row(board, [YELLOW, CYAN, RED, BLUE], current_row);
current_row = current_row + 1;
update_screen(current_scene, board, get_num_corrects(board, answer));

% Comment the scene
title('Second image: board where there is two correct, but in the wrong spot');

% Wait for mouse input to proceed to next step
getMouseInput(current_scene);

% Show a board with the correct sequence
board = enter_row(board, [BLUE, RED, PURPLE, PINK], current_row);
current_row = current_row + 1;
update_screen(current_scene, board, get_num_corrects(board, answer));

% Comment the scene
title('Third image: board where all colors are in the correct spot');



function update_screen(scene, board, correct)
    % Draws the current scene to the screen

    dividor = ones(length(board), 1) * 12;
    
    drawScene(scene, [board, dividor, correct]);
end

function new_board = enter_row(board, input, current_row)
    % Enters the row data into the board

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
        used = zeros(1, 4);

        % Take care of 3s.
        for column = 1:4
            if (board(row, column) == answer(column))
                corrects(row, column_corrects) = 3;
                column_corrects = column_corrects + 1;
                used(column) = 1;
            end
        end
        
        % Take care of 2s
        for column_board = 1:4

            % Use a linear search to determine if the current 
            correct = 0;
            for column_answers = 1:4
                if used(column_answers)
                    continue;
                end
                if board(row, column_board) == answer(column_answers)
                    correct = 1;
                    used(column_answers) = 1;
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


clear


% Evaulate step:
% This task ended up being fairly unchallenging, largely beacuse I already
% have experience designing games in other programming languages. Although
% I still had to look at the documentation for certain functions in the
% simpleGameEngine.m file, this was just a small setback and the final
% production of the game should go smoothly. For this reason, I do not at
% the time have any questions for my teams members or instructional team.
% I do not envision changing any part of the current plan, but I will if
% needed.