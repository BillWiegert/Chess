# Chess

This project is a fully functional chess game built from the ground up using Ruby. It follows all the standard rules of chess and can be played by two players or versus the AI. Currently it is controlled and displayed entirely within the terminal.

## Getting Started

To play you will need to make a local copy of the project and run the 'game.rb' file. You will be prompted to choose if each color should be human or computer controlled and the game will begin. Use the arrow keys or WASD to move the cursor, indicated by the red square, to the piece you would like to move and press enter or space to select it. Then move the cursor to the space you would like the piece to move to and press enter again.

## Features and Implementation

### The AI

Currently the AI follows a simple priority system:

- If it can take any pieces it will take the vulnerable piece of the highest value with it's lowest value piece possible.

- If one of it's pieces is threatened it will move it out of harm's way if possible.

- Otherwise it will make a random move valid move.

### Move History

After each move is made an instance of the Move class is created to record that move. The main function of the Move class is to created a string that represents the move in Portable Game Notation.

The board keeps an array of these moves as a move history to be displayed when the game is completed. The moves displayed can then be copied and pasted into any other chess platform that processes PGN so that the game can be reviewed, replayed or analyzed by chess engines.
