class Brain {
  PVector[] directions;//series of vectors which get the dot to the goal (hopefully)
  int step = 0;

  Brain(int size) {
    directions = new PVector[size];
    randomize();
  }

  void randomize() {
    for (int i = 0; i< directions.length; i++) {
      float randomAngle = random(2*PI);
      directions[i] = PVector.fromAngle(randomAngle);
    }
  }

  Brain clone() {
    Brain clone = new Brain(directions.length);
    for (int i = 0; i < directions.length; i++) {
      clone.directions[i] = directions[i].copy();
    }

    return clone;
  }
  Brain clone(String jsonFile) {
    PVector pos = new PVector(width/2, height- 70);
    PVector vel = new PVector(0, 0);
    PVector acc = new PVector(0, 0);

    JSONArray vectors = loadJSONArray(jsonFile);
    Brain clone = new Brain(vectors.size());


    for (int i =0; i<vectors.size(); i++) {
      JSONObject vector = vectors.getJSONObject(i); 
      float x = vector.getFloat("x");
      float y = vector.getFloat("y");

      acc = new PVector(x,y);
      vel.add(acc);
      vel.limit(6);
      pos.add(vel);
      
      clone.directions[i]=pos;
      print(pos.x);
    }
    return clone;
  }

  void mutate() {

    float mutationRate = 0.02;
    for (int i =0; i< directions.length; i++) {
      float rand = random(1);
      if (rand < mutationRate) {
        //set this direction as a random direction 
        float randomAngle = random(2*PI);
        directions[i] = PVector.fromAngle(randomAngle);
      }
    }
  }
}
