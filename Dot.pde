class Dot {
  PVector pos;
  PVector vel;
  PVector acc;
  Brain brain;

  boolean dead = false;
  boolean reachedGoal = false;
  boolean isBest = false;//true if this dot is the best dot from the previous generation
  boolean isInLine = false;
  float fitness = 0;

  int dotSize = 4;


  Dot() {
    brain = new Brain(2000);

    pos = new PVector(width/2, height- 70);
    vel = new PVector(0, 0);
    acc = new PVector(0, 0);
  }


  void show() {
    if (isBest) {
      fill(0, 255, 0);
      ellipse(pos.x, pos.y, 8, 8);
    } else {
      fill(0, 0, 0);
      ellipse(pos.x, pos.y, dotSize, dotSize);
    }
  }

  void move() {

    if (brain.directions.length > brain.step) {
      acc = brain.directions[brain.step];
      brain.step++;
    } else {
      dead = true;
    }


    vel.add(acc);
    vel.limit(6);
    pos.add(vel);
  }

  void update() {
    if (!dead && !reachedGoal) {
      move();
      if (pos.x< 2|| pos.y<2 || pos.x>width-2 || pos.y>height -60) {//if near the edges of the window then kill it 
        dead = true;
      } else if (dist(pos.x, pos.y, goal.x, goal.y) < 5) {//if reached goal

        reachedGoal = true;
      } else if (isInLine(0, 300, 600, 10)) {//if hit obstacle
        isInLine = true;
        dead = true;
      } else if (isInLine(width-600, 100, 600, 10)) {
        isInLine = true;
        dead = true;
      } else if (isInLine(width-400, 500, 400, 10)) {
        isInLine = true;
        dead = true;
       
    }
    }else{
    dotSize =0;
    }
  }


  boolean isInLine(int xCoordinate, int yCoordinate, int objWidth, int objHeight) {
    return (pos.x< xCoordinate+objWidth && pos.y < objHeight+yCoordinate && pos.x > xCoordinate && pos.y > yCoordinate);
  }


  void calculateFitness() {
    if (reachedGoal) {
      fitness = 1.0/16.0 + 10000.0/(float)(brain.step * brain.step);
    } else {
      float distanceToGoal = dist(pos.x, pos.y, goal.x, goal.y);
      fitness = 1.0/(distanceToGoal * distanceToGoal);
    }
  }

  Dot gimmeBaby() {
    Dot baby = new Dot();
    baby.brain = brain.clone();
    return baby;
  }
}
