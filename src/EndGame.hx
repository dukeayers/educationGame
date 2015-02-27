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
    endReplay.x = 420;
    endReplay.y = 360;
    rootSprite.addChild(endReplay);
  }
  private function keyDown2(e:TouchEvent){
     var touch:Touch = e.getTouch(rootSprite);
    if(touch != null){
      if(touch.phase == TouchPhase.BEGAN) {
        rootSprite.removeChildren();
        var newGame = new Main(rootSprite);
        newGame.start();
      }
    }
  }
}
