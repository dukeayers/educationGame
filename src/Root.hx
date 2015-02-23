import starling.display.Sprite;
import starling.utils.AssetManager;
import starling.display.Image;
import starling.core.Starling;
import starling.animation.Transitions;
import starling.display.Quad;
class Root extends Sprite {

  public static var assets:AssetManager;
  public var character:Image;
  public var rootSprite:Sprite;
  public var quad: Quad;

  public function new() {
    rootSprite = this;
    super();
  }

  public function start(startup:Startup) {
    assets = new AssetManager();
    assets.enqueue("../assets/character1.png");
    assets.enqueue("../assets/GameOver.png");
    assets.enqueue("../assets/Replay.png");

    assets.loadQueue(function onProgress(ratio:Float) {
        if (ratio == 1) {
        // loading completed animation

        Starling.juggler.tween(startup.loadingBitmap, 2.0, {transition:Transitions.EASE_OUT, delay:0, alpha: 0, onComplete: function(){
            // cleaning up the loadingScreen after it has already faded 
            startup.removeChild(startup.loadingBitmap);
              var game = new Game(rootSprite);
              game.start();
            
        }});

            
    }


    });

  }

}
