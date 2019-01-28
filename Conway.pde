Cell[][] grid;
int gridWidth;
int gridHeight;
int cellSize;

void setup(){
  //frameRate(60);
  size(2000,1500);
  cellSize = 15;
  
  gridWidth = width/cellSize;
  gridHeight = height/cellSize;
  
  grid = new Cell[gridHeight][gridWidth];
  for(int i = 0; i < gridHeight; i++){
    for(int j = 0; j < gridWidth; j++){
      grid[i][j] = new Cell(false);
    }
  }
  //grid[1][1] = new Cell(true);
}

class Cell{
  //int[] coords = new int[]{0,0};
  boolean isAlive;
  int cellAge;
  
  Cell(boolean isAlive){
    this.isAlive = isAlive;
    cellAge = 0;
  }
  
  void change(){
    isAlive = !isAlive;
  }
}

//void drawLine(int xCoord, int yCoord){drawLine(xCoord,yCoord);}
void drawLine(int xCoord, int yCoord/*, boolean setAlive*/){
  float xTo = mouseX/cellSize-(xCoord);
  float yTo = mouseY/cellSize-(yCoord);
  float dist = sqrt(sq(xTo)+sq(yTo));
  
  float xDraw = xCoord;
  float yDraw = yCoord;
  for(int i = 0; i < dist-1; i++){
    xDraw += xTo/dist;
    yDraw += yTo/dist;
    if(!(Math.round(yDraw) > gridHeight-1) && !(Math.round(xDraw) > gridWidth-1) && !(Math.round(yDraw) < 0) && !(Math.round(xDraw) < 0)){
      grid[Math.round(yDraw)][Math.round(xDraw)].isAlive = true;
    }
  }
  
  lineStart[0] = (mouseX/cellSize);
  lineStart[1] = (mouseY/cellSize);
}

void mousePressed(){
  if(mouseX < gridWidth * cellSize && mouseX > 0 && mouseY < gridHeight * cellSize && mouseY > 0){
    if(grid[mouseY/cellSize][mouseX/cellSize].isAlive){
      dragMode = "ERASE";
      grid[mouseY/cellSize][mouseX/cellSize].isAlive = false;
    } else{
      dragMode = "ADD";
      grid[mouseY/cellSize][mouseX/cellSize].isAlive = true;
    }
  }
  if(drawingLine){    
    drawLine(lineStart[0],lineStart[1]);
  }
}

void mouseReleased(){
  lineStart[0] = (mouseX/cellSize);
  lineStart[1] = (mouseY/cellSize);
  dragMode = "";
}

void keyReleased(){
  if(keyCode == SHIFT){
    drawingLine = false;
  }
}

void keyPressed(){
  if(key == ' '){
    iterate = !iterate;
  }
  if(keyCode == SHIFT){
    drawingLine = true;
  }
  if(key == 'r'){
    for(int i = 0; i < gridHeight; i++){
      for(int j = 0; j < gridWidth; j++){
        grid[i][j].isAlive = false;
      }
    }
  }
  if(keyCode == RIGHT){
    update();
  }
}

boolean drawingLine = false;
void update(){
  Cell[][] newGrid = new Cell[gridHeight][gridWidth];
  
  for(int i = 0; i < gridHeight; i++){
    for(int j = 0; j < gridWidth; j++){
      newGrid[i][j] = new Cell(false);
    }
  }
  
  for(int i = 1; i < gridHeight-1; i++){
    for(int j = 1; j < gridWidth-1; j++){
      Cell[] neighbors = new Cell[8];
      neighbors[0] = grid[i-1][j+1];
      neighbors[1] = grid[i-1][j];
      neighbors[2] = grid[i-1][j-1];
      neighbors[3] = grid[i][j+1];
      neighbors[4] = grid[i][j-1];
      neighbors[5] = grid[i+1][j+1];
      neighbors[6] = grid[i+1][j];
      neighbors[7] = grid[i+1][j-1];
      
      int num = 0;
      for(Cell cell : neighbors){
        if(cell.isAlive){
          num++;
          //stroke(color(200,20,20));
          //line(i*cellSize+cellSize*.5,j*cellSize+cellSize*.5,cell.coords[0]*cellSize+cellSize*.5,cell.coords[1]*cellSize+cellSize*.5);
        }
      }
      //stroke(color(0));
      
      //STAYS ALIVE IF
      if(grid[i][j].isAlive && (num == 2 || num == 3)){
        newGrid[i][j].isAlive = true;
        //grid[i][j].cellAge++;
      }
      //IS BORN IF
      if((!grid[i][j].isAlive) && (num == 3)){
        newGrid[i][j].isAlive = true;
      }
      
      //COMPENDIUM OF INTERESTING COMBINATIONS
      // A23B45 - a virus that consumes anything it touches (needs a little push to get going)
      // A234B567 - looks cool
      // A23 B>=3 - creates ovals
    }
  }
  
  grid = newGrid;
}

String dragMode = "";
boolean iterate = false;
int[] lineStart = new int[]{0,0};
int prevCoordX;
int prevCoordY;
void draw(){
  background(color(150));
  
  if(mouseX < gridWidth * cellSize && mouseX > 0 && mouseY < gridHeight * cellSize && mouseY > 0){
    if(dragMode.equals("ADD")){
      grid[mouseY/cellSize][mouseX/cellSize].isAlive = true;
    } else if(dragMode.equals("ERASE")){
      grid[mouseY/cellSize][mouseX/cellSize].isAlive = false;
    }
  }
  

  
  if(mousePressed && !dragMode.equals("ERASE")){
    //if(dragMode.equals("ERASE")){
    //  //drawLine(prevCoordX,prevCoordY,false);
    //}else {
      drawLine(prevCoordX,prevCoordY);
    //}
  }
  prevCoordX = (mouseX/cellSize);
  prevCoordY = (mouseY/cellSize);
  
  //DRAW THE GRID, THIS SHOULD BE CLOSE TO THE BOTTOM !!!
  strokeWeight(1);
  int total = 0;
  for(int i = 0; i < gridHeight; i++){
    for(int j = 0; j < gridWidth; j++){
      if(grid[i][j].isAlive == true){
        total++;
        fill(color(20+grid[i][j].cellAge));
        rect(j*cellSize,i*cellSize,cellSize,cellSize);
      } else{
        fill(color(250));
        rect(j*cellSize,i*cellSize,cellSize,cellSize);
      }
    }
  }
  stroke(color(0));
  strokeWeight(cellSize);
  //strokeCap(SQUARE);
  if(drawingLine && !mousePressed){
    line(lineStart[0]*cellSize+(cellSize/2),lineStart[1]*cellSize+(cellSize/2),(mouseX/cellSize)*cellSize+(cellSize/2),(mouseY/cellSize)*cellSize+(cellSize/2));
    //System.out.println(lineStart[0]+", "+lineStart[1]);
  }
  
  strokeWeight(1);
  if(iterate){
    update();
  }
  textSize(30);
  fill(0, 0, 0);
  text("Number of alive cells: "+total,0,30);
  if(!iterate){
    fill(200, 20, 20);
    text("PAUSED",0,60);
  }
  delay(10);
}