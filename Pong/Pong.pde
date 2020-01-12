/* @pjs preload="Pong/PongBall.png"; */
/* @pjs preload="Pong/pongbackground.jpg"; */
//flash screen or ball after round has been going on for a long time
//Matthew Paulin
//April 25, 2016
//Pong with a twist
int x = 10;//left paddle's x value
int y = (height/2)-65;//left paddle's y value
int x1 = width-28;//right paddle's x value
int y1 = (height/2)-65;//right paddle's y value
int ballx;//ball's x value
int bally;//ball's y value
//RGB values of the fills of both paddles/scores
int colorR=255;
int colorG=255;
int colorB=255;
int colorR1=255;
int colorG1=255;
int colorB1=255;
int intro= 1;//variable used for intro screen or to draw the field
int score = 0;//left score
int score1 = 0;//right score
boolean[] keys;  // add this array of keys to hold the state of all keys used in the game
int ballpos=0;//balls spawning point
float speedx;//horizontal speed
int speedy;//vertical speed
boolean start=false;//when game is started start = true
boolean cheat = true;//when cheat has not been used, cheat = true
int invisibleBall=255;//tint/transparency for ball cheat
PImage ball;//ball
PImage background;//background
//congragulatory messages
String p1Wins="Left Side Wins!!!";
String p2Wins="Right Side Wins!!!";
boolean selectors=true;//color selectors
float addSpeed = 1.05;//speed multiplier
boolean sound=false;//boolean that tells sound affects to trigger
boolean cheat1=false;//disables cheat
import ddf.minim.*;
Minim minim;
//AudioPlayer player;//main song
AudioPlayer fatality;//sound after every point
AudioPlayer finishHim;//spund at 6 points
void setup() {
  frameRate(60);
  size(1280, 730);
  minim=new Minim(this);
  //player=minim.loadFile("Mortal Kombat SONG.mp3");
  fatality=minim.loadFile("Pong/Fatality.ogg");
  finishHim=minim.loadFile("Pong/Mortal.ogg");
  fatality.volume(0.05);
  finishHim.volume(0.05);
  keys=new boolean[4]; 
  keys[0]=false;
  keys[1]=false;
  keys[2]=false;
  keys[3]=false;
  x = 10;
  y = (height/2)-65;
  x1 = width-28;
  y1 = (height/2)-65;
  ballx=width/2;
  bally=height/2;
  ball=loadImage("Pong/PongBall.png");
  background=loadImage("Pong/pongbackground.jpg");
}

void draw() 
{
  if (intro>0)
  {
    fill(0, 0, 255);
    smooth();
    rect(0, 0, width, height);
    textSize(75);
    textAlign(CENTER);
    fill(255);
    text("Welcome to the New Pong", width/2, 101);
    textSize(30);
    text("Left paddle controls are Q(up) and A(down)", width/2, 250);
    text("Right paddle controls are P(up) and L(down)", width/2, 350);
    text("Spacebar releases the ball", width/2, 450);
    text("Press any key to start!", width/2, 550);
    if (keyPressed)
    {
      intro=0;
    }
  }
  if (intro==0)
  {
    redrawGameField();
    /*player.play();
    if(!player.isPlaying())
    {
      player.rewind();
      player.play();
    }*/
    if (ballx<0)
    {
      fatality.rewind();
      fatality.play();
      score1+=1;
      ballpos=1;
      speedy=0;
      speedx=0;
      start=false;
      castNewBall();
    }
    if (ballx>width)
    {
      score+=1;
      fatality.rewind();
      fatality.play();
      ballpos=2;
      speedy=0;
      speedx=0;
      start=false;
      castNewBall();
    }
    if (y>height)
    {
      y=-130;
    }
    if (y+130<0)
    {
      y=height;
    }
    if (y1>height)
    {
      y1=-130;
    }
    if (y1+130<0)
    {
      y1=height;
    }
    ballx+=speedx;
    bally+=speedy;
    playerOne();
    playerTwo();
    bounceBall();
    moveBall();
    if (score==7)
    {
      fill(0);
      rect(0, 0, width, height);
      fill(random(255), random(255), random(255));
      textSize(80);
      text(p1Wins, width/2, height/3);
      fill(255);
      rect(540, 600, 200, 100);
      fill(0);
      textSize(40);
      text("RESTART", 640, 650);
      if (mousePressed)
      {
        if (mouseX>=540&&mouseX<=740&&mouseY>=600&&mouseY<=700)
        {
          cheat=true;
          colorR=0;
          colorG=0;
          colorB=0;
          colorR1=0;
          colorG1=0;
          colorB1=0;
          score=0;
          score1=0;
          selectors=true;
          intro=1;
        }
      }
    }
    if (score1==7)
    {
      fill(0);
      rect(0, 0, width, height);
      fill(random(255), random(255), random(255));
      textSize(80);
      text(p2Wins, width/2, height/3);
      fill(255);
      rect(540, 600, 200, 100);
      fill(0);
      textSize(40);
      text("RESTART", 640, 650);
      if (mousePressed)
      {
        if (mouseX>=540&&mouseX<=740&&mouseY>=600&&mouseY<=700)
        {
          cheat=true;
          colorR=0;
          colorG=0;
          colorB=0;
          colorR1=0;
          colorG1=0;
          colorB1=0;
          score1=0;
          score=0;
          selectors=true;
          intro=1;
        }
      }
    }
  }
}




void playerTwo()
{  
  if ( keys[2]) 
  {
    y1-=10;
  }
  if ( keys[3]) 
  {
    y1+=10;
  }
}
void playerOne()
{ 

  if ( keys[0])
  {  
    y+=10;
  }
  if ( keys[1]) 
  {
    y-=10;
  }
}
void redrawGameField()
{
  background.resize(1280, 730);
  image(background, 0, 0);
  stroke(0);
  strokeWeight(6);
  line(width/2, 0, width/2, height);
  stroke(0);
  strokeWeight(5);
  fill(colorR, colorG, colorB);
  rect(x, y, 18, 130);
  fill(colorR1, colorG1, colorB1);
  rect(x1, y1, 18, 130);
  textSize(80);
  fill(colorR, colorG, colorB);
  text(score, width/2-60, 65);
  fill(colorR1, colorG1, colorB1);
  text(score1, width/2+60, 65);
  fill(random(255), random(255), random(255));
  ball.resize(30, 30);
  tint(255, invisibleBall);
  image(ball, ballx-15, bally-15);
  noTint();
  //ellipse(ballx, bally, 30, 30); 
  if (keyPressed && key == 'w'&& ballpos!=0 && cheat==true) {
    invisibleBall=5;
    cheat1=true;
  }
  if (cheat1==true&&(ballx>width||ballx<0)) {
    cheat=false;
    invisibleBall=255;
  }
  if (selectors==true)
  {
    if (key==' ')
    {
      key ='3';
    }
    fill(0);
    text("Pick Your Colors!", width/2, height/3);
    textSize(60);
    rect(width/2-300, height/2, 80, 80);
    fill(random(255), random(255), random(255));
    text("???", width/2-260, height/2+60);
    fill(0);
    rect(width/2+220, height/2, 80, 80);
    fill(random(255), random(255), random(255));
    text("???", width/2+260, height/2+60);
    fill(0);
    rect(width/2-90, height-180, 180, 80);
    fill(255);
    textSize(55);
    text("START", width/2, height-120);
    if (mousePressed)
    {
      if (mouseX>=width/2-300&&mouseX<=width/2-220&&mouseY>=height/2&&mouseY<=height/2+80)
      {
        colors();
      }
      if (mouseX>=width/2+220&&mouseX<=width/2+300&&mouseY>=height/2&&mouseY<=height/2+80)
      {
        colors1();
      }
      if (mouseX>=width/2-90&&mouseX<=width/2+90&&mouseY>=height-180&&mouseY<=height-100)
      {
        selectors=false;
      }
    }
  }
}
void colors()
{
  colorR=int(random(255));
  colorG=int(random(255));
  colorB=int(random(255));
}
void colors1()
{
  colorR1=int(random(255));
  colorG1=int(random(255));
  colorB1=int(random(255));
}
void bounceBall()
{
  if (bally>=height-15||bally<=15)
  {
    speedy = -speedy;
  }
  if (bally>=y-15&&bally<=y+145&&ballx<=x+33)
  {
    ballx=x+33;
    speedx = -speedx;
    speedx=speedx*addSpeed;
    speedy=int(random(-6,7));
  }
  if (bally>=y1-15&&bally<=y1+145&&ballx>=x1-15)
  {
    ballx=x1-15;
    speedx = -speedx;
    speedx=speedx*addSpeed;
    speedy=int(random(-6,7));
  }
}
void moveBall()
{
  if (keyPressed&&key==' ')
  {
    start=true;
    if (score==6)
    {
      finishHim.rewind();
      finishHim.play();
    }
    if (score1==6)
    {
      finishHim.rewind();
      finishHim.play();
    }
  }
  if (start==true)
  {
    if (ballpos==0)
    {
      speedx=int(random(-6, 7));
      if (speedx>-6&&speedx<6)
      {
        speedx=6;
      }
      speedy=int(random(-6, 7));
      if (speedy>-1&&speedy<1)
      {
        speedy++;
      }
      ballpos=3;
    }
    if (ballpos==1)
    {
      speedx=-6;
      speedy=int(random(-6, 7));
      if (speedy>-1&&speedy<1)
      {
        speedy++;
      }
      ballpos=3;
    }
    if (ballpos==2)
    {
      speedx=6;
      speedy=int(random(-6, 7));
      if (speedy>-1&&speedy<1)
      {
        speedy++;
      }
      ballpos=3;
    }
  }
}
void castNewBall()
{
  if (ballpos==0)
  {
    ballx=width/2;
    bally=height/2;
    ellipse(ballx, bally, 30, 30);
  }
  if (ballpos==1)
  {
    ballx=width/2-30;
    bally=height/2;
    ellipse(ballx, bally, 30, 30);
  } 
  if (ballpos==2)
  {
    ballx=width/2+30;
    bally=height/2;
    ellipse(ballx, bally, 30, 30);
  }
}
void keyPressed()
{ 
  if (key=='a'||key=='A')  keys[0]=true; 
  if (key=='q'||key=='Q')  keys[1]=true;   
  if (key=='p'||key=='P')  keys[2]=true;
  if (key=='l'||key=='L')  keys[3]=true;
}

void keyReleased()
{  
  if (key=='a'||key=='A') keys[0]=false;
  if (key=='q'||key=='Q') keys[1]=false;
  if (key=='p'||key=='P') keys[2]=false;
  if (key=='l'||key=='L') keys[3]=false;
} 
