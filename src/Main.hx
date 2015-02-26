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
    addition.addEventListener("touch", keyDown2);
    addition.x = 120;
    addition.y = 300;
    rootSprite.addChild(addition);

    subtraction = new Image(Root.assets.getTexture('subtraction'));
    subtraction.addEventListener("touch", keyDown2);
    subtraction.x = 360;
    subtraction.y = 300;
    rootSprite.addChild(subtraction);

    multiplication = new Image(Root.assets.getTexture('multiplication'));
    multiplication.addEventListener("touch", keyDown2);
    multiplication.x = 600;
    multiplication.y = 300;
    rootSprite.addChild(multiplication);



    rootSprite.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
  }
  private function keyDown(event:KeyboardEvent){
    var keycode = event.keyCode;
  if(keycode == 13){
    rootSprite.removeChildren();
    Root.assets.removeSound("startmusic");
    var game = new Game(rootSprite);
    game.start();
  }
  }
  private function keyDown2(e:TouchEvent){
     var touch:Touch = e.getTouch(rootSprite);
    if(touch != null){
      if(touch.phase == TouchPhase.BEGAN) {
        rootSprite.removeChildren();
        Root.assets.removeSound("startmusic");
        var game = new Game(rootSprite);
        game.start();
      }
    }
  }
}
