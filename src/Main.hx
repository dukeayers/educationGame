import starling.display.Sprite;
import starling.utils.*;
import starling.display.Image;
import starling.core.Starling;
import starling.animation.Transitions;
import starling.display.Quad;
import starling.events.Event;
import starling.events.KeyboardEvent;
import starling.events.*;
import flash.media.SoundChannel;

class Main extends Sprite {
  public var rootSprite:Sprite;
  public var mainMenu:Image;
  public var addition:Image;
  public var subtraction:Image;
  public var multiplication:Image;
  public var credits:Image; //Button to take you to the credits screen
  public function new(rootSprite:Sprite) {
    this.rootSprite = rootSprite;
    super();
  }

  public function start() {
    Root.assets.playSound("startmusic");
    mainMenu = new Image(Root.assets.getTexture('mainMenu'));
    mainMenu.x = 0;
    mainMenu.y = 0;
    rootSprite.addChild(mainMenu);

    addition = new Image(Root.assets.getTexture('addition'));
    addition.addEventListener("touch", addFunc);
    addition.x = 120;
    addition.y = 300;
    rootSprite.addChild(addition);

    subtraction = new Image(Root.assets.getTexture('subtraction'));
    subtraction.addEventListener("touch", subFunc);
    subtraction.x = 360;
    subtraction.y = 300;
    rootSprite.addChild(subtraction);

    multiplication = new Image(Root.assets.getTexture('multiplication'));
    multiplication.addEventListener("touch", multFunc);
    multiplication.x = 600;
    multiplication.y = 300;
    rootSprite.addChild(multiplication);

    credits = new Image(Root.assets.getTexture('credits'));
    credits.addEventListener("touch", creditsFunc);
    credits.x = 960 - credits.width;
    credits.y = 0;
    credits.scaleX = 0.8;
    credits.scaleY = 0.8;
    rootSprite.addChild(credits);

    //rootSprite.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
  }
  // private function keyDown(event:KeyboardEvent){
  //   var keycode = event.keyCode;
  // if(keycode == 13){
  //   rootSprite.removeChildren();
  //   Root.assets.removeSound("startmusic");
  //   var game = new Game(rootSprite);
  //   game.start();
  // }
  // }
  private function addFunc(e:TouchEvent)
  {
     var touch:Touch = e.getTouch(rootSprite);
    if(touch != null)
    {
      if(touch.phase == TouchPhase.BEGAN) 
      {
        rootSprite.removeChildren();
        Root.assets.removeSound("startmusic");
        var addgame = new Game(rootSprite);
        addgame.start();
      }
  
  //This is for the credits    
    }
  }

  private function subFunc(e:TouchEvent)
  {
          var touch:Touch = e.getTouch(rootSprite);
          if (touch != null)
          {
                  if (touch.phase == TouchPhase.BEGAN)
                  {
                          rootSprite.removeChildren();
                          Root.assets.removeSound("startmusic");
                          var subgame = new Subtraction(rootSprite);
                          subgame.start();
                  }
          }
  }

  private function multFunc(e:TouchEvent)
  {
          var touch:Touch = e.getTouch(rootSprite);
          if (touch != null)
          {
                  if (touch.phase == TouchPhase.BEGAN)
                  {
                          rootSprite.removeChildren();
                          Root.assets.removeSound("startmusic");
                          var multgame = new Multiplication(rootSprite);
                          multgame.start();
                  }
          }
  }

  private function creditsFunc(e:TouchEvent)
  {
          var touch:Touch = e.getTouch(rootSprite);
          if (touch != null)
          {
                  if (touch.phase == TouchPhase.BEGAN)
                  {
                          rootSprite.removeChildren();
                          Root.assets.removeSound("startmusic");
                          var game = new Main(rootSprite);
                          game.start();
                  }
          }
  }
}
