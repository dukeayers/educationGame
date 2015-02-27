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
import flash.media.SoundChannel;


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
    //Enqueueing the background here
    assets.textureRepeat = true;
    assets.enqueue("assets/background.png");
    assets.textureRepeat = false;

    assets.enqueue("assets/character1.png");
    assets.enqueue("assets/GameOver.png");
    assets.enqueue("assets/mainMenu.png");
    assets.enqueue("assets/Replay.png");
    assets.enqueue("assets/addition.png");
    assets.enqueue("assets/subtraction.png");
    assets.enqueue("assets/multiplication.png");
    assets.enqueue("assets/meteor1.png");
    assets.enqueue("assets/meteor2.png");
    assets.enqueue("assets/meteor3.png");
    assets.enqueue("assets/meteor4.png");
    assets.enqueue("assets/meteor5.png");
    assets.enqueue("assets/meteor6.png");
    assets.enqueue("assets/credits.png");
    assets.enqueue("assets/creditsScreen.png");
    assets.enqueue("assets/menuButton.png");
    
    assets.enqueue("assets/startmusic.mp3");
    assets.enqueue("assets/bgmusic.mp3");
    assets.enqueue("assets/correct.mp3");
    assets.enqueue("assets/gameOver.mp3");
    assets.enqueue("assets/fail.mp3");

    assets.loadQueue(function onProgress(ratio:Float) {
        if (ratio == 1) {
        // loading completed animation

        Starling.juggler.tween(startup.loadingBitmap, 2.0, {transition:Transitions.EASE_OUT, delay:0, alpha: 0, onComplete: function(){
            // cleaning up the loadingScreen after it has already faded 
            startup.removeChild(startup.loadingBitmap);
              var main = new Main(rootSprite);
              main.start();
            
        }});

            
    }


    });

  }

}
