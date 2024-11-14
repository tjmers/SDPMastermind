# SDP -- Mastermind

## Group Q

### The game
Mastermind game where the player tries to guess the four color sequence that may or may not contain duplicates. The player is told after each guess how many of the colors that they have are in the correct position, and how many are in the correct sequence, but the wrong position.

### Our implementation
Our implementation of this game via MATLAB uses the *simpleGameEngine* class to represent the board graphically. The player's board is on the left side and they can click on the colors cycling through them until they reach their desired guess. The player then clicks on the next row in order to see how correct their guess was, as stated above. This information is outputted on the right side of the board, each black dot indicating a color in the correct position, and each white dot indicating a correct color in the wrong position. The game ends whenever the player wins or runs out of guesses.

### Mouse Controls

Left click - left click on a color to cycle forwards to the next color.

Right click - right click on a color to cycle backwards to the next color.

Any mouse button - clicking on the next row to submit your guess.

### Keyboard Controls

Our Mastermind ignores all keyboard inputs.