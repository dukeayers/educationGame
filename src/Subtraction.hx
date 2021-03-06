import starling.display.Sprite;
import starling.display.Sprite3D;

import starling.utils.*;
import starling.display.Image;
import starling.core.Starling;
import starling.animation.Transitions;
import starling.display.Quad;
import starling.events.Event;
import flash.events.KeyboardEvent;
import flash.media.SoundChannel;

import starling.text.TextField;
//import starling.events.KeyboardEvent;
//import starling.events.EnterFrameEvent;
import starling.animation.Tween;
import starling.animation.Juggler;

import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFieldType;
import flash.text.TextFieldAutoSize;
import flash.text.TextFieldType;
import flash.text.TextFormatAlign;

//These imports are for the scrolling background
import starling.events.EnterFrameEvent;
import starling.textures.Texture;
import flash.geom.Point;
import flash.geom.Rectangle;
import starling.textures.TextureSmoothing;
import Math;


class Subtraction extends Sprite {
  //RootSprite for reference to the currrent stage
  public var rootSprite:Sprite;
  public var equationFormat:TextFormat; //Stores the current equation in each box
  private var textField:TextField; //Stores the input textfield
  private var textFormat:TextFormat; //formats the input field
  public var newGenerate:Int; //Determines when to generate a new box
  public var characterArray:Array<Image>; //Holds all of the current boxes on the screen in an array
  public var equationArray:Array<TextField>; //Holds all of the current equations on the screen in an array
  public var positionArray:Array<Int>; //Stores the current x-position of each box on the screen
  public var life:Int; //Determines the number of lives you have
  public var totalScore:Int; //Stores the total score, not actually implemented yet
  public var background:ScrollImage1; //The background image
  public var meteor:Image; //The meteors for dem equations
  public var scoreText:TextField; //To display dat score
  public var meteor_textures = Root.assets.getTextures("meteor"); //Getting the different meteor textures
  public var bgmusic:SoundChannel;
  public var startmusic:SoundChannel;
  public var correct:SoundChannel;
  public var gameOver:SoundChannel;
  public var fail:SoundChannel;


  //Creates the new instance of the Game class
  public function new(rootSprite:Sprite) {
    this.rootSprite = rootSprite;
    super();
  }

  //Starts the game
  public function start() {
    Root.assets.playSound("bgmusic");
    newGenerate = 0; //Initialize to 0 for start
    totalScore = 0; //Set total score to 0
    life = 3; //set # off lives to 3

    /*
     * Below creates the input field and then styles it
     * This is also where we grab the input and store it for later.
     */
    //Create the command line input box
    textField = new flash.text.TextField();
    textFormat = new TextFormat("Arial", 18, 0x000000);
    textFormat.align = TextFormatAlign.LEFT;
    textField.defaultTextFormat = textFormat;
    //Accept the ability for input
    textField.type = TextFieldType.INPUT;
    textField.height = 25;
    textField.x = 0;
    textField.y = 455;
    //Set the background and width
    textField.background = true;
    textField.backgroundColor = 0xEFEFEF;
    textField.width = 960;
    Starling.current.nativeOverlay.addChild(textField);
    textField.stage.focus = textField;
    //Add event listener to check the input
    textField.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);

    //Spawn the initial textboxes
    //Add an event listener to determine when a box is falling
    rootSprite.addEventListener(Event.ENTER_FRAME, onFrame);

    //Spawn the scrolling background 
    var movingSky:Sprite3D = new Sprite3D();
    movingSky.x = -4;
    movingSky.y = 0;
    //movingSky.rotationY = -Math.PI / 2 + Math.PI / 2014;
    movingSky.z = 0;
    rootSprite.addChild(movingSky);

    background = new ScrollImage1(Root.assets.getTexture("background"));
    background.x = 0;
    background.y = 0;
    background.smoothing = TextureSmoothing.NONE;
    roll_background();
    movingSky.addChild(background);

    //Generating initial textbox after background because it works that way
    generateInitialTextbox();

    //TODO Setting up the score
    /*
    scoreText = new TextField(50, 50, "0", "System", 6, 0x000993);
    scoreText.x = 72;
    scoreText.y = -2;
    scoreText.hAlign = starling.utils.HAlign.RIGHT;
    scoreText.vAlign = starling.utils.VALIGN.TOP;
    rootSprite.addChild(scoreText);
    scoreText.redraw();
    cast(scoreText.getChildAt(0), Image).smoothing = TextureSmoothing.NONE;
    */
  }

  //This function rolls the background
  public function roll_background()
  {
          background.scrollX = 0;
          var speed = (3.0/123)*background.width;
          Starling.juggler.tween(background, speed, {
                  scrollX: 1.0,
                  onComplete: roll_background
          });
  }

  //Function will essentially check for "enter" on the command line input we made earlier
public function keyDown(event:KeyboardEvent ){
  var keycode = event.keyCode; //set the key-press to a variable
  if (keycode == 13) { //check the variable
      //Create a counter to help reference where we should remove elements in the three arrays we created.trace
      //We will continue to increment the counter to determine where we should remove elements in the equation, position, and character arrays
      var counter = 0;
      //A foreach loop that iterates over all equations, to determine if the input matches any of the equations
      for (equation in equationArray) {
          //Create a new array that will essentially break apart all of the equations into number1, operator, number2
          var containWords: Array < String > = new Array();
          //split the text with a splitter method, which is built in
          containWords = equation.text.split("");
          //Set the first number to the variable a
          var a: Int = Std.parseInt(containWords[0]);
          //Set the second number to the variable b
          var b: Int = Std.parseInt(containWords[2]);
          //If variable a plus variable b equal the input then we remove items
          if (Std.string(a - b) == textField.text) {
              //Remove the specified character from the stage            
              rootSprite.removeChild(characterArray[counter], true);
              //Remove that same character from the array using a splice method
              characterArray.splice(counter, 1);
            Starling.current.nativeOverlay.removeChild(equationArray[counter]);
             equationArray.splice(counter, 1);
             positionArray.splice(counter, 1);
              //Increment score by 10
              Root.assets.playSound("correct");
              totalScore += 10;
              //Generate a new box
               if(characterArray.length <= 20){
              generateNewBox();
              //increment the newGenerate variable
              newGenerate++;
              //For every 8th box removed, we will add another box (essentially increasing the difficulty)
              if (newGenerate == 3) {
                  generateNewBox();
                  //reset the variable to 0
                  newGenerate = 0;
               }
            }
            continue;
          }
          //Increment the counter at the end of each iteration of the for loop
          counter++;
      }
      //Reset the commandline input to nothing.
      textField.text = "";
  }
}

//The following functions will generate new boxes
private function generateNewBox(){
    
    //Create a new variable to hold the new image being used.
    var character: Image = new Image(meteor_textures[Std.random(meteor_textures.length)]);

    //Randomly generate a new point on the x-axis for the character
    var randomX = Math.round(Math.random() * 910);
    //Check if the randomX coordinate is spawning on top of another box.
    var returnBoolean: Bool = checkSpawn(randomX, positionArray);
    //If it spawns on top of another box, then we generate a new X coordinate until it no longer spawns on another box.
    while (!returnBoolean) {
        randomX = Math.round(Math.random() * 910);
        returnBoolean = checkSpawn(randomX, positionArray);
    }
    //Set the x-coord of the box to the randomly gen. number
    character.x = randomX;
    //Set the y-coord to 0
    character.y = 0;

    //Create randomly generated numbers for the equation
    var number1: String = Std.string(Math.round(Math.random() * 9));
    var number2: String = Std.string(Math.round(Math.random() * 9));

    //Create the equation to be put inside of the textfield
    var equation: TextField = new flash.text.TextField();
    var equationFormat: TextFormat = new TextFormat("Arial", 18, 0xffffff);
    equation.defaultTextFormat = equationFormat;
    equation.text += number1;
    equation.text += "-";
    equation.text += number2;
    //Format the background and set all of the text formats.
    equation.background = false;
    equation.width = 50;
    equation.height = 50;
    equation.x = randomX + 5;
    equation.y = 15;
    //Add the new image to the array of images
    characterArray.push(character);
    //add the new equation to the array of equations
    equationArray.push(equation);

    //Add the equation to the stage
    Starling.current.nativeOverlay.addChild(equation);
    //add the image to the stage
    rootSprite.addChild(character);
    //add the x-coord to the array of positions
    positionArray.push(randomX);
  }

//We now want to check if the boxes are literally right on top of one another.
private function checkSpawn(currentPosition:Int, lastPosition:Array<Int>):Bool{
  //Set a new variable equal to the current position that was passed (we don't want to lose the number)
  var positionHolder = currentPosition;
  var counter = 0;
  var breakLoop = false;
  //We then run a for each loop over each position in the array.
  for (lastPosition1 in lastPosition) {
      //Set a variable to determine if any of the boxes are 50pixels to the right
      var greaterThanTest = 0;
      if(characterArray[counter].y >= 60){
        //counter++;
        counter+=1;
        continue;
      }
      else{
      //we can first check to make sure that the current image did not have the same x-coord as any of the last positions
      if (positionHolder == lastPosition1) {
          //if so, we return false and break the loops
          return false;
      }
      //Create a while loop to check 50 pixels to the right
      while (greaterThanTest <= 50) {
          //increment the current positionHolder before we test
          positionHolder++;
          //check if the current position is equal to the last position
          if (positionHolder == lastPosition1) {
              //break and return false if so
              return false;
          }
          //increment the test variable to eventually end the while loop
          greaterThanTest++;
      }
      //reset the position before we run the next while loop
      positionHolder = currentPosition;
      //does the exact same thing as the last while loop but checks 50 pixels to the left
      var lessThanTest = 0;
      while (lessThanTest <= 50) {
          positionHolder--;
          if (positionHolder == lastPosition1) {
              return false;
          }
          //increment the counter to eventually end the while loop
          lessThanTest++;
      }
    }
      //reset the position before the next iteration of the loop
      positionHolder = currentPosition;
      counter++;
  }
  //if we exit both loops then we return true
  //This could also be the reasoning as to why we are running O(n^2) so often
  return true;
}

//This function generates the initial 3 boxes.
//It is the exact same as the method above but with a while loop to generate the boxes
private function generateInitialTextbox(){
  var i = 0;

  //Initialize the array that will hold the images
  characterArray = new Array();
  //Initiliaze the array that will hold the equations
  equationArray = new Array();
  //Initialize the array that will hold the x-coords
  positionArray = new Array();
  
  var lastXValue: Int = 0;
  while (i <= 2) {

      var character: Image = new Image(meteor_textures[Std.random(meteor_textures.length)]);
      var randomX = Math.round(Math.random() * 910);
      while (!checkSpawn(randomX, positionArray)) {
          randomX = Math.round(Math.random() * 910);
          checkSpawn(randomX, positionArray);
      }
      character.x = randomX;
      character.y = 0;
      characterArray.push(character);
      

      var number1: String = Std.string(Math.round(Math.random() * 9));
      var number2: String = Std.string(Math.round(Math.random() * 9));

      //Create the equation to be put inside of the textfield
      var equation: TextField = new flash.text.TextField();
      var equationFormat: TextFormat = new TextFormat("Arial", 18, 0xffffff);
      equation.defaultTextFormat = equationFormat;
      equation.text += number1;
      equation.text += "-";
      equation.text += number2;
      equation.background = false;
      equation.width = 50;
      equation.height = 50;
      equation.x = randomX + 5;
      equation.y = 15;
      equationArray.push(equation);

      Starling.current.nativeOverlay.addChild(equation);
      rootSprite.addChild(character);
      positionArray.push(randomX);
      i++;
  }
}

  //The last method will basically monitor the falling of the boxes
  private function onFrame(e: Event) {
    //Start by creating a counter that will check where we are and is used later
    var countChar = 0;

    //This is for the background scrolling
    //roll_background();
    background.scrollX = background.scrollX;
    //background.resolve_scroll();
    //Iterate over all of the images in the array
    for (character in characterArray) {
        //increment the countChar (we don't necessarily have to do it here)
        countChar++;
        //check the y-coord of the box to determine if it hit the bottom of the screen
        if (character.y <= 405) {
            //if it did not, then we let it continue to fall
            character.y += 1;
            //We also let the equation continue to fall
            equationArray[countChar - 1].y += 1;
        }
        //If it is as the bottom...
        else {
            //remove the equation from the stage
            Starling.current.nativeOverlay.removeChild(equationArray[countChar - 1]);
            //remove the equation from the array
            equationArray.splice(countChar - 1, 1);
            //remove the image from the stage and dispose it
            rootSprite.removeChild(characterArray[countChar - 1], true);
            //remove the image from the array
            characterArray.splice(countChar - 1, 1);
            //remove its position from the array
            positionArray.splice(countChar - 1, 1);
            //Decrement the # of lives
            Root.assets.playSound("fail");
            life--;
            //check if we ran out of lives
            if (life == 0) {
                //if so, remove all Starling elements from the stage
                rootSprite.removeChildren();
                //remove all starling event listeners
                rootSprite.removeEventListeners();
                //remove all event listeners in general
                removeEventListeners();
                //remove all flash objects on teh stage
                Starling.current.nativeOverlay.removeChildren();
                //Send a message notifying their loss
                Root.assets.playSound("gameOver");
                trace("You Lose. Total Score: " + totalScore);

                //TODO This displays the score and updates it and all that
                //scoreText.text = "" + totalScore;
                //Then generate the end screen
                var gotoend = new EndGame(rootSprite);
                gotoend.start();
            }
        }
    }
  }
}
class ScrollImage1 extends Image
{
        public var scrollX(default, set):Float = 0;
        public var scrollY(default, set):Float = 0;

        public function set_scrollX(value)
        {
                scrollX = value;
                resolve_scroll();
                return scrollX;
        }

        public function set_scrollY(value:Float)
        {
                scrollY = value;
                resolve_scroll;
                return scrollY;
        }

        public function resolve_scroll()
        {
                setTexCoords(0, new Point(scrollX, scrollY));
                setTexCoords(1, new Point(scrollX+1, scrollY));
                setTexCoords(3, new Point(scrollX+1, scrollY+1));
                setTexCoords(2, new Point(scrollX, scrollY+1));
        }
}
