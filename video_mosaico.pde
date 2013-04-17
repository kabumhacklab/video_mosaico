/*
Copyright (c) 2012 Manuel Guerra

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated 
documentation files (the "Software"), to deal in the Software without restriction, including without limitation 
the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, 
and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO 
THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import codeanticode.gsvideo.*;

GSCapture cam;

PImage video[] = new PImage[500];

int nWrite;

int mWidth, mHeight, mSize;

int maxFrames;

boolean full[];
int nRead[];

void setup() {

  size(screen.width, screen.height, P2D);

  full = new boolean[300];
  nRead = new int[300];

  //mWidth = 2;
  //mHeight = 2;
  mSize = 15;
  
  for (int i = 0; i < 300; i++) {
    full[i] = false;
    nRead[i] = 0;
  }

  //cam = new GSCapture(this, 320, 240, "v4l2src", "/dev/video1");
  cam = new GSCapture(this, 320, 240);
  maxFrames = 15;
  cam.play();

  background(0);
}

void draw() {

  if (cam.available() == true) {

    cam.read();
    noTint();

    // translate(width/2-320,height/2-240);  
    video[nWrite] = cam.get(0, 0, 320, 240);

    nWrite++;
    println(nWrite + " " + nRead);

    for (int i = 0; i < mSize; i++) {
      if (nWrite > (i+1)*maxFrames && full[i] == false) {
        full[i] = true;
      }
    }
    nWrite%=(mSize+1)*maxFrames;

    for (int i = 0; i < mSize; i++) {
      if (full[i]) {

        if (nRead[i] > (mSize+1)*maxFrames-1) {
          nRead[i] = 0;
        }

        PImage img = video[nRead[i]];

        pushMatrix();
        translate( 160+(320*i)%width, 120+240*( (320*i)/width ) );
        //scale(1, 1);
        image(img, -160, -120);
        popMatrix();      

        nRead[i]++;
      }
    }
  }
}

