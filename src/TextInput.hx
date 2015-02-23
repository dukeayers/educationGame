import starling.display.Sprite;
import starling.utils.*;
import starling.display.Image;
import starling.core.Starling;
import starling.animation.Transitions;
import starling.display.Quad;
import starling.events.Event;
import flash.events.KeyboardEvent;

import starling.text.TextField;

import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFieldType;
import flash.text.TextFieldAutoSize;
import flash.text.TextFieldType;
import flash.text.TextFormatAlign;


class TextInput extends Sprite {
  // public var rootSprite:Sprite;
  // public var equationFormat:TextFormat;
  private var textField:TextField;
  private var textFormat:TextFormat;

  // public var characterArray:Array<Image>;
  // public var equationArray:Array<TextField>;

  // public var life:Int;
  // public var lifeFormat:TextFormat;

  // public var positionArray:Array<Int>;
  public function new() {
    super();
  }

  public function start() {
    // life = 3;
    //Create the command line input box
    textField = new flash.text.TextField();
    textFormat = new TextFormat("Arial", 18, 0xffffff);
    textFormat.align = TextFormatAlign.LEFT;
    textField.defaultTextFormat = textFormat;
    //Accept the ability for input
    textField.type = TextFieldType.INPUT;
    textField.height = 25;
    textField.x = 0;
    textField.y = 700;
    //Set the background and width
    textField.background = true;
    textField.backgroundColor = 0x50826e;
    textField.width = 700;
    Starling.current.nativeOverlay.addChild(textField);
    textField.stage.focus = textField;
    textField.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);

    //Spawn the initial textboxes
    // generateInitialTextbox();
  }
  public function keyDown(event:KeyboardEvent ){
  var keycode = event.keyCode;
  if(keycode == 13){
    var counter = 0;
    for(equation in equationArray){
      var containWords:Array<String> = new Array();
      containWords = equation.text.split("");
      var a:Int = Std.parseInt(containWords[0]);
      var b:Int = Std.parseInt(containWords[2]);
      if(Std.string(a + b) == textField.text){

        trace("Correct");
                
        // rootSprite.removeChild(characterArray[counter]);
      //   characterArray.splice(counter, 1);
      //   Starling.current.nativeOverlay.removeChild(equationArray[counter]);
      //   equationArray.splice(counter, 1);
      // generateNewBox();
      
      }

      counter++;
    }
    textField.text = "";
  }
}

}
