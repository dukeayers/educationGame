import starling.display.Sprite;
import starling.utils.*;
import starling.display.Image;
import starling.core.Starling;
import starling.animation.Transitions;
import starling.display.Quad;
import starling.events.Event;
import starling.events.KeyboardEvent;
import starling.events.*;

class EndGame extends Sprite {
  public var rootSprite:Sprite;
  public var gameOver:Image;
  public var endReplay:Image;
  public function new(rootSprite:Sprite) {
    this.rootSprite = rootSprite;
    super();
  }

  public function start() {
    gameOver = new Image(Root.assets.getTexture('GameOver'));
    gameOver.x = 0;
    gameOver.y = 0;
    rootSprite.addChild(gameOver);

    endReplay = new Image(Root.assets.getTexture('Replay'));
    endReplay.addEventListener("touch", keyDown2);
    endReplay.x = 580;
    endReplay.y = 360;
    rootSprite.addChild(endReplay);
    // endReplay.addEventListener(TouchEvent.TOUCH, keyDown2);
    rootSprite.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
  }
  private function keyDown(event:KeyboardEvent){
    var keycode = event.keyCode;
  if(keycode == 13){
    rootSprite.removeChildren();
    var newGame = new Game(rootSprite);
    newGame.start();
  }
  }
  private function keyDown2(e:TouchEvent){
     var touch:Touch = e.getTouch(rootSprite);
    if(touch != null){
      if(touch.phase == TouchPhase.BEGAN) {
        rootSprite.removeChildren();
        var newGame = new Game(rootSprite);
        newGame.start();
      }
    }
  }
}
