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


class Game extends Sprite {
  public var rootSprite:Sprite;
  public var equationFormat:TextFormat;
  private var textField:TextField;
  private var textFormat:TextFormat;
  public var newGenerate:Int;
  public var characterArray:Array<Image>;
  public var equationArray:Array<TextField>;

  public var life:Int;
  public var lifeFormat:TextFormat;
  public var totalScore:Int;

  public var positionArray:Array<Int>;
  public function new(rootSprite:Sprite) {
    this.rootSprite = rootSprite;
    super();
  }

  public function start() {
    newGenerate = 0;
    totalScore = 0;
    life = 3;
    //Create the command line input box
    textField = new flash.text.TextField();
    textFormat = new TextFormat("Arial", 18, 0xffffff);
    textFormat.align = TextFormatAlign.LEFT;
    textField.defaultTextFormat = textFormat;
    //Accept the ability for input
    textField.type = TextFieldType.INPUT;
    textField.height = 25;
    textField.x = 0;
    textField.y = 695;
    //Set the background and width
    textField.background = true;
    textField.backgroundColor = 0x50826e;
    textField.width = 700;
    Starling.current.nativeOverlay.addChild(textField);
    textField.stage.focus = textField;
    textField.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);

    //Spawn the initial textboxes
    generateInitialTextbox();
    rootSprite.addEventListener(Event.ENTER_FRAME, onFrame);
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
        rootSprite.removeChild(characterArray[counter]);
        characterArray.splice(counter, 1);
        Starling.current.nativeOverlay.removeChild(equationArray[counter]);
        equationArray.splice(counter, 1);
        positionArray.splice(counter, 1);
        totalScore += 10;
        generateNewBox();
        newGenerate++;
        if(newGenerate == 8){
          generateNewBox();
          newGenerate = 0;
        }
        
      }

      counter++;
    }
    textField.text = "";
  }
}

private function generateNewBox(){
    var character:Image = new Image(Root.assets.getTexture("character1"));
    var randomX =Math.round(Math.random() * 1230);
    var returnBoolean:Bool = checkSpawn(randomX, positionArray);
     while( !returnBoolean){
      randomX = Math.round(Math.random() * 1230);
      returnBoolean = checkSpawn(randomX, positionArray);
    }
    character.x = randomX;
    character.y = 0;
   

   var number1:String = Std.string(Math.round(Math.random() * 9));
   var number2:String = Std.string(Math.round(Math.random() * 9));

    //Create the equation to be put inside of the textfield
    var equation:TextField = new flash.text.TextField();
    var equationFormat:TextFormat = new TextFormat("Arial", 18, 0xffffff);
    equation.defaultTextFormat = equationFormat;
    equation.text += number1;
    equation.text += "+";
    equation.text += number2;
    equation.background = false;
    equation.width = 50;
    equation.height = 50;
    equation.x = randomX;
    equation.y = 10;
    characterArray.push(character); 
    equationArray.push(equation);

    Starling.current.nativeOverlay.addChild(equation);
    rootSprite.addChild(character);
    positionArray.push(randomX);
  }

private function checkSpawn(currentPosition:Int, lastPosition:Array<Int>):Bool{
  
  var positionHolder = currentPosition;
  for(lastPosition1 in lastPosition ){
    var greaterThanTest = 0;
    if(positionHolder == lastPosition1){
      return false;
      break;
    }
    while(greaterThanTest <= 50){
      positionHolder++;
      if(positionHolder == lastPosition1){
        return false;
        break;
      }
      greaterThanTest++;
    }
    positionHolder = currentPosition;
    var lessThanTest = 0;
    while(lessThanTest <= 50){
      positionHolder--;
      if(positionHolder == lastPosition1){
        return false;
        break;
      }
      lessThanTest++;
    }
    positionHolder = currentPosition;
  }
  return true;
}

private function generateInitialTextbox(){
  var i = 0;

  //Initialize the array that will hold the images
  characterArray = new Array();
  //Initiliaze the array that will hold the equations
  equationArray = new Array();
  positionArray = new Array();

  var lastXValue:Int = 0;
  while(i <= 2){

    var character:Image = new Image(Root.assets.getTexture("character1"));
    var randomX = Math.round(Math.random() * 1230);

    while(!checkSpawn(randomX, positionArray)){
      randomX = Math.round(Math.random() * 1230);
    }
    character.x = randomX;
    character.y = 0;
    characterArray.push(character);
   
   var number1:String = Std.string(Math.round(Math.random() * 9));
   var number2:String = Std.string(Math.round(Math.random() * 9));

    //Create the equation to be put inside of the textfield
    var equation:TextField = new flash.text.TextField();
    var equationFormat:TextFormat = new TextFormat("Arial", 18, 0xffffff);
    equation.defaultTextFormat = equationFormat;
    equation.text += number1;
    equation.text += "+";
    equation.text += number2;
    equation.background = false;
    equation.width = 50;
    equation.height = 50;
    equation.x = randomX;
    equation.y = 10;
    equationArray.push(equation);

    Starling.current.nativeOverlay.addChild(equation);
    rootSprite.addChild(character);
    positionArray.push(randomX);
    i++;
  }
}

    private function onFrame(e:Event)
  {
    var countChar = 0;
    for(character in characterArray){
      countChar++;
      if(character.y <= 670){
       character.y += 1;
       equationArray[countChar-1].y += 1;
      }
      else{
        Starling.current.nativeOverlay.removeChild(equationArray[countChar-1]);
        equationArray.splice(countChar-1, 1);
        rootSprite.removeChild(characterArray[countChar-1], true);
        characterArray.splice(countChar-1, 1);
        positionArray.splice(countChar -1, 1);
        life--;
        if(life == 0){
          rootSprite.removeChildren();
          rootSprite.removeEventListeners();
          removeEventListeners();
          //characterArray.empty();
          Starling.current.nativeOverlay.removeChildren();
          trace("You Lose. Total Score: " + totalScore);
          var gotoend = new EndGame(rootSprite);
          gotoend.start();
        }
      }
    }
  }
}
