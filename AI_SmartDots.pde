Population population;
PVector goal  = new PVector(400, 10);
boolean isBestMode;


Button bestModeButton;
Button loadButton;
Button saveButton;

JSONObject brain ;

void setup() {
  size(800, 800); //size of the window
  frameRate(100);//increase this to make the dots go faster
  population = new Population(2000);//create a new population with 1000 members



  ellipseMode(CENTER);
}



void draw() { 
  background(255);
  text("GEN : "+population.gen, (int)10, (int)10, 200, 20);
  text("ReachRecord : "+population.dots[population.bestDot].brain.step, (int)10, (int)25, 200, 20);
  text("Distance to Goal : "+population.distanceToGoal, (int)10, (int)40, 200, 20);
  //draw goal
  fill(0, 255, 0);
  ellipse(goal.x, goal.y, 10, 10);

  //draw obstacle(s)
  fill(255, 0, 0);


  rect(width-400, 500, 400, 10);
  rect(width-600, 100, 600, 10);
  rect(0, 300, 600, 10);
  //rect(0, 300, 600, 10);
  //rect(0, 300, 600, 10);
  //rect(width-600, 100, 600, 10);


  if (population.allDotsDead()) {
    //genetic algorithm
    population.calculateFitness();
    population.naturalSelection();
    population.mutateBabies();
  } else {
    //if any of the dots are still alive then update and then show them

    population.update();
    population.show();
  }

  setupGUI();
}

void setupGUI() {

  fill(230);
  rect(0, height-60, width, 60);
  bestModeButton = new Button("Only Best Dot", new PVector(width-145, height-45), new PVector(130, 30), 15);
  loadButton = new Button("Load", new PVector(145, height-45), new PVector(130, 30), 15);
  saveButton = new Button("Save ", new PVector(15, height-45), new PVector(130, 30), 15);
}


void mousePressed() {

  bestModeButton.setOnClickListener(new OnButtonClickedListener() {
    public void onClick() {
      if (isBestMode) {
        isBestMode = false;
        population.onlyBestDot = false;
      } else {
        isBestMode = true;
        population.onlyBestDot = true;
      }
    }
  }
  );

  loadButton.setOnClickListener(new OnButtonClickedListener() {
    public void onClick() {
      population.loadFromData = true;
    }
  }
  );

  saveButton.setOnClickListener(new OnButtonClickedListener() {
    public void onClick() {
      population.isSaving = true;
    }
  }
  );
}
