import starling.display.Sprite;
import starling.utils.AssetManager;
import starling.display.Image;
import starling.core.Starling;
import starling.animation.Transitions;
import starling.display.Quad;
import starling.display.Sprite3D;
import flash.geom.Point;
import flash.geom.Rectangle;
import starling.textures.TextureSmoothing;
import starling.textures.Texture;

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
    assets.enqueue("assets/character1.png");
    assets.enqueue("assets/GameOver.png");
    assets.enqueue("assets/Replay.png");
    assets.enqueue("assets/meteor1.png");
    assets.enqueue("assets/meteor2.png");
    assets.enqueue("assets/meteor3.png");
    assets.enqueue("assets/meteor4.png");
    assets.enqueue("assets/meteor5.png");
    assets.enqueue("assets/meteor6.png");

    //Enqueueing the background here
    assets.textureRepeat = true;
    assets.enqueue("assets/background.png");
    assets.textureRepeat = false;

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
