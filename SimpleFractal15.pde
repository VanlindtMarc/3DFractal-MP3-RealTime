import ddf.minim.analysis.*;
import ddf.minim.*;
Minim       minim;
AudioPlayer MaMusique;
FFT         fft;

String     fichiermp3            = "music3.mp3";

PImage Univers; 
PShape Spherique;

float     diametre                = 120; 

int       IterationMax            = 7;
int       IterationAff            = 2;

float     Redim                   = 0.5;//sqrt(0.5);

float     Angle                   = 0.05;

float     degre                   = 2*3.141592654/360;
float     evolution               =-1;

String    FondSpherique           = "117.png";

String    DossierCaptures         = "G:\\fractalvideo11";
String    NomCaptures             = "Fractale";
int       NombreDeCaptures        = 14400;
int       EnregistrementCaptures  = 0;

int       compteur                = 0;

float     ValeurMusique           = 0;

float[]   SmoothValeurMusique = new float[64];

void setup()
{
  //size(1920,1080, P3D);
    fullScreen(P3D);
    minim = new Minim(this);
    MaMusique = minim.loadFile(fichiermp3, 512);
    MaMusique.loop();
    fft = new FFT( MaMusique.bufferSize(), MaMusique.sampleRate() );

  Univers = loadImage(FondSpherique);
  
  Spherique = createShape(SPHERE, 10000); 
  Spherique.setTexture(Univers);
  Spherique.setStrokeWeight(0);
  
  sphereDetail(6);
  
  frameRate(60);
  
  smooth(1);
  
  noStroke();
  
}

void draw()
{
  fft.forward( MaMusique.mix );
  for(int i=1;i<= 1;i++)
  {
    ValeurMusique=(ValeurMusique+fft.getBand(i))/2;
  }
  for(int i=0;i<=62;i++)
  {
    SmoothValeurMusique[i]=SmoothValeurMusique[i+1];
    SmoothValeurMusique[62]=ValeurMusique;
  }
  for(int i=0;i<=62;i++)
  {
    SmoothValeurMusique[63]=(SmoothValeurMusique[i]+SmoothValeurMusique[i+1])/2;    
  }
  
  println(SmoothValeurMusique[63]);
  
  background(0);                
  
  pointLight(64+SmoothValeurMusique[63]*2, 32, 32, sin(evolution/8)*diametre*2.7, cos(evolution/8)*diametre*3, -sin(evolution/8)*diametre*3.2);
  
  fill(192, 32, 32);
  emissive(192,0,0);
  translate(sin(evolution/8)*diametre*2.7, cos(evolution/8)*diametre*3, -sin(evolution/8)*diametre*3.2);
  sphere(5*(1+SmoothValeurMusique[63]/50));

  pointLight(32, 32, 64+SmoothValeurMusique[63]*2, -sin(evolution/9)*diametre*3.1, -cos(evolution/9)*diametre*2.9, sin(evolution/9)*diametre*2.8);

  fill(32, 32, 192);
  emissive(0,0,192);
  translate(-sin(evolution/9)*diametre*3.1, -cos(evolution/9)*diametre*2.9, sin(evolution/9)*diametre*2.8);

  sphere(5*(1+SmoothValeurMusique[63]/50));

  pointLight(32, 64+SmoothValeurMusique[63]*2, 32, cos(evolution/10)*diametre*2.6, cos(evolution/10)*diametre*3.05, cos(evolution/10)*diametre*3.15);
  
  fill(32, 192, 32);
  emissive(0,192,0);
  translate(cos(evolution/10)*diametre*2.6, cos(evolution/10)*diametre*3.05, cos(evolution/10)*diametre*3.15);
  sphere(5*(1+SmoothValeurMusique[63]/50));
  lightSpecular(128,128,128);

  ambientLight(0,0,0);

  camera(sin((evolution/8)*SmoothValeurMusique[63]/10000)*500, cos((evolution/8))*500, 900+sin((evolution/8))*sin((evolution/32))*500, 16/9*sin((evolution)/16)*diametre, cos((evolution)/16)*diametre, 0.0, 0.0, 1.0, 0.0);
  emissive(0,0,0);
  fill(255,255,255);
  scale(1.25);
  maFractale(1, IterationMax);
  
  scale(0.2);
  strokeWeight(0);
  shape(Spherique);

  if(compteur<=NombreDeCaptures && EnregistrementCaptures==1)
  { 
    saveFrame(""+DossierCaptures+"/"+NomCaptures+"######.png");
  }

  evolution+=Angle;
  
  compteur+=1;
  
  //println(evolution);
  
  
}

void maFractale(int it, int IterationMax)
{
  if(it>=IterationAff)
  {
 sphere(diametre);
  }
 if(it<IterationMax)
 {
   pushMatrix();  
      translate(diametre*(Redim*2+1),0,0);
      scale(Redim,Redim,Redim);
      if(evolution<=7200 && evolution >=0)
      {
        rotateZ(sin(it*evolution/60)*evolution%360*degre);
      }

      maFractale(it+1,IterationMax);
  popMatrix();

  pushMatrix();  
      translate(-diametre*(Redim*2+1),0,0);
      scale(Redim,Redim,Redim);
      if(evolution<=7200 && evolution >=0)
      {
        rotateZ(sin(it*(evolution/60)*evolution%360*degre));
      }


      maFractale(it+1,IterationMax);
   popMatrix(); 
   
   pushMatrix();  
      translate(0,diametre*(Redim*2+1),0);
      scale(Redim,Redim,Redim);
      if(evolution<=7200 && evolution >=0)
      {
        rotateY(sin(it*evolution/60)*evolution%360*degre);
      }

      maFractale(it+1,IterationMax);
  popMatrix();

  pushMatrix();  
      translate(0,-diametre*(Redim*2+1),0);
      scale(Redim,Redim,Redim);
      if(evolution<=7200 && evolution >=0)
      {
        rotateY(sin(it*evolution/60)*evolution%360*degre);
      }

      maFractale(it+1,IterationMax);
    popMatrix(); 

 }
}