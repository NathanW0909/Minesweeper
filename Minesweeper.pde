import java.util.ArrayList;

private static final int NUM_ROWS = 10;
private static final int NUM_COLS = 10;
private static final int MINE_COUNT = (NUM_ROWS * NUM_COLS) / 5; // 20% mines
private MSButton[][] buttons;
private ArrayList<MSButton> mines;

void setup() {
    size(600, 600);
    textAlign(CENTER, CENTER);
    Interactive.make(this);
    initializeGame();
}

void initializeGame() {
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    mines = new ArrayList<MSButton>();

    for (int r = 0; r < NUM_ROWS; r++) {
        for (int c = 0; c < NUM_COLS; c++) {
            buttons[r][c] = new MSButton(r, c);
        }
    }

    setMines();
}

public void setMines() {
    mines.clear();
    while (mines.size() < MINE_COUNT) {
        int r = (int) (Math.random() * NUM_ROWS);
        int c = (int) (Math.random() * NUM_COLS);
        if (!mines.contains(buttons[r][c])) {
            mines.add(buttons[r][c]);
        }
    }
}

public void draw() {
    background(0);
    if (isWon()) displayWinningMessage();
}

public boolean isWon() {
    for (int r = 0; r < NUM_ROWS; r++) {
        for (int c = 0; c < NUM_COLS; c++) {
            MSButton btn = buttons[r][c];
            if (!mines.contains(btn) && !btn.clicked) return false;
        }
    }
    return true;
}

public void displayLosingMessage() {
    for (MSButton mine : mines) {
        mine.setLabel("X");
    }
}

public void displayWinningMessage() {
    for (int r = 0; r < NUM_ROWS; r++) {
        for (int c = 0; c < NUM_COLS; c++) {
            buttons[r][c].setLabel("W");
        }
    }
}

public boolean isValid(int r, int c) {
    return r >= 0 && r < NUM_ROWS && c >= 0 && c < NUM_COLS;
}

public int countMines(int row, int col) {
    int numMines = 0;
    for (int dr = -1; dr <= 1; dr++) {
        for (int dc = -1; dc <= 1; dc++) {
            int newRow = row + dr;
            int newCol = col + dc;
            if (isValid(newRow, newCol) && mines.contains(buttons[newRow][newCol])) {
                numMines++;
            }
        }
    }
    return numMines;
}

void keyPressed() {
    if (key == ' ') {
        initializeGame();
    }
}

public class MSButton {
    private int myRow, myCol;
    private float x, y, width, height;
    private boolean clicked, flagged;
    private String myLabel;

    public MSButton(int row, int col) {
        width = 600 / NUM_COLS;
        height = 600 / NUM_ROWS;
        myRow = row;
        myCol = col;
        x = myCol * width;
        y = myRow * height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add(this);
    }

    public void mousePressed() {
        if (flagged) return;

        clicked = true;
        if (mouseButton == RIGHT) {
            flagged = !flagged;
            clicked = !flagged;
        } else if (mines.contains(this)) {
            displayLosingMessage();
        } else {
            int mineCount = countMines(myRow, myCol);
            if (mineCount > 0) {
                setLabel(mineCount);
            } else {
                for (int dr = -1; dr <= 1; dr++) {
                    for (int dc = -1; dc <= 1; dc++) {
                        int newRow = myRow + dr;
                        int newCol = myCol + dc;
                        if (isValid(newRow, newCol) && !buttons[newRow][newCol].clicked) {
                            buttons[newRow][newCol].mousePressed();
                        }
                    }
                }
            }
        }
    }

    public void draw() {
        if (flagged) fill(0);
        else if (clicked && mines.contains(this)) fill(255, 0, 0);
        else if (clicked) fill(200);
        else fill(100);

        rect(x, y, width, height);
        fill(0);
        text(myLabel, x + width / 2, y + height / 2);
    }

    public void setLabel(String newLabel) {
        myLabel = newLabel;
    }

    public void setLabel(int newLabel) {
        myLabel = "" + newLabel;
    }

    public boolean isFlagged() {
        return flagged;
    }
} 
