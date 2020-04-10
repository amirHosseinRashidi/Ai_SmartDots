class Population {
  Dot[] dots;
  boolean isSaving;

  boolean loadFromData;
  boolean onlyBestDot = false;

  float fitnessSum;
  int gen = 1;

  int bestDot = 0;
  int step  ;
  int minStep = 1000;
  int distanceToGoal;

  Population(int size) {
    dots = new Dot[size];
    for (int i = 0; i< size; i++) {
      dots[i] = new Dot();
    }
  }



  void onlyBestDot(boolean active) {
    for (int i=0; i <dots.length; i++) {
      if (active) {
        dots[i].dotSize =0;
      } else {
        dots[i].dotSize =4;
      }
    }
  }
  void show() {
    for (int i = 1; i< dots.length; i++) {
      dots[i].show();
      if (onlyBestDot) {
        dots[i].dotSize =0;
      } else {
        dots[i].dotSize = 4;
      }
    }
    dots[0].show();
  }

  void update() {
    for (int i = 0; i< dots.length; i++) {
      if (dots[i].brain.step > minStep) {
        dots[i].dead = true;
      } else {
        dots[i].update();
      }
    }
  }

  void calculateFitness() {
    for (int i = 0; i< dots.length; i++) {
      dots[i].calculateFitness();
    }
  }


  boolean allDotsDead() {
    for (int i = 0; i< dots.length; i++) {
      if (!dots[i].dead && !dots[i].reachedGoal) { 
        return false;
      }
    }

    return true;
  }




  void saveBrain() {

    int size =  dots[bestDot].brain.directions.length;
    float[] y = new float[size];
    float[] x =new float[size];
    JSONArray values;

    print("Saved");

    values = new JSONArray();

    for (int i = 0; i < x.length; i++) {

      JSONObject vectors = new JSONObject();
      x[i] = dots[bestDot].brain.directions[i].x;
      y[i] = dots[bestDot].brain.directions[i].y;
      
      step = i;
      vectors.setInt("step", i);
      vectors.setFloat("x", x[i]);
      vectors.setFloat("y", y[i]);

      values.setJSONObject(i, vectors);
    }

    saveJSONArray(values, "data/testDotBrain.json");
  }

  void naturalSelection() {
    Dot[] newDots = new Dot[dots.length];//next gen
    setBestDot();
    
    calculateFitnessSum();

    newDots[0] = dots[bestDot].gimmeBaby();
    newDots[0].isBest = true;
    for (int i = 1; i< newDots.length; i++) {
      //select parent based on fitness
      Dot parent = selectParent();


      newDots[i] = parent.gimmeBaby();
    }

    distanceToGoal =(int) dist(dots[bestDot].pos.x, dots[bestDot].pos.y, goal.x, goal.y);

    if (loadFromData) {
      dots[bestDot].brain = dots[bestDot].brain.clone("data/dotBrain.json");
      loadFromData = false;
    } else {
      dots = newDots.clone();
    }
    gen ++;
    if (isSaving) {
      saveBrain();
    isSaving = false;  
  }
  }




  void calculateFitnessSum() {
    fitnessSum = 0;
    for (int i = 0; i< dots.length; i++) {
      fitnessSum += dots[i].fitness;
    }
  }



  Dot selectParent() {
    float rand = random(fitnessSum);


    float runningSum = 0;

    for (int i = 0; i< dots.length; i++) {
      runningSum+= dots[i].fitness;
      if (runningSum > rand) {
        return dots[i];
      }
    }


    return null;
  }


  void mutateBabies() {
    for (int i = 1; i< dots.length; i++) {

      dots[i].brain.mutate();
    }
  }

  void setBestDot() {
    float max = 0;
    int maxIndex = 0;

    for (int i = 0; i< dots.length; i++) {
      if (dots[i].fitness > max&&!dots[i].isInLine) {
        max = dots[i].fitness;
        maxIndex = i;
      }
    }

    bestDot = maxIndex;

    if (dots[bestDot].reachedGoal) {
      minStep = dots[bestDot].brain.step;
      println("step:", minStep);
      
    }
  }
}
