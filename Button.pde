class Button {

  boolean circleOver = false;
  PVector pos;
  PVector size;
  String text;
  int textSize;
  Button(String text, PVector position, PVector size,int textSize) {
    this.textSize = textSize;
    this.text = text;
    pos = position;
    this.size = size;
    _draw();
  }

  void _draw() {


    update();

    stroke(255);

    if (circleOver) {
      fill(color(200));
    } else {
      fill(color(255));
    }
    stroke(0);
    rect((int)pos.x, (int)pos.y, (int)size.x, (int)size.y);


    fill(50);
    textSize(10);
    fill(50);
    textSize(textSize);
    text(text, (int)pos.x+10, (int)pos.y+5, size.x-10, size.y-2);
  }

  void update() {
    if (overRect((int)pos.x, (int)pos.y, size.x, size.y)) {
      circleOver = true;
    } else {
      circleOver = false;
    }
  }

  void setOnClickListener(OnButtonClickedListener listener) {
    if (circleOver) {
      listener.onClick();
    }
  }

  boolean overRect(int x, int y, float width, float height) {
    if (mouseX >= x && mouseX <= x+width && 
      mouseY >= y && mouseY <= y+height) {
      return true;
    } else {
      return false;
    }
  }
}
