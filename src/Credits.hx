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

class Credits extends Sprite
{
        public var rootSprite:Sprite;
        public var creditsScreen:Image;
        public var menuButton:Image;

        public function new(rootSprite:Sprite)
        {
                this.rootSprite = rootSprite;
                super();
        }

        public function start()
        {
                creditsScreen = new Image(Root.assets.getTexture('creditsScreen'));
                creditsScreen.x = 0;
                creditsScreen.y = 0;
                rootSprite.addChild(creditsScreen);

                menuButton = new Image(Root.assets.getTexture('menuButton'));
                menuButton.addEventListener("touch", menuFunc);
                menuButton.x = 960-menuButton.width;
                menuButton.y = 0;
                rootSprite.addChild(menuButton);
        }


        private function creditFunc(e:TouchEvent)
        {
                var touch:Touch = e.getTouch(rootSprite);
                if (touch!= null)
                {
                        if (touch.phase == TouchPhase.BEGAN)
                        {
                                rootSprite.removeChildren();
                                Root.assets.removeSound("startmusic");
                                var game = new Credits(rootSprite);
                                game.start();
                        }
                }
        }

        private function menuFunc(e:TouchEvent)
        {
                var touch:Touch = e.getTouch(rootSprite);
                if (touch!= null)
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
