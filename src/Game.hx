import starling.display.Sprite;
//For the scrolling background
import starling.display.Sprite3D;

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

  //Creates the new instance of the Game class
  public function new(rootSprite:Sprite) {
    this.rootSprite = rootSprite;
    super();
  }

  //Starts the game
  public function start() {
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
    textField.y = 695;
    //Set the background and width
    textField.background = true;
    textField.backgroundColor = 0x50826e;
    textField.width = 700;
    Starling.current.nativeOverlay.addChild(textField);
    textField.stage.focus = textField;
    //Add event listener to check the input
    textField.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);

    //Spawn the initial textboxes
    generateInitialTextbox();
    //Add an event listener to determine when a box is falling
    rootSprite.addEventListener(Event.ENTER_FRAME, onFrame);

    //Spawn the scrolling background
    /*
    var background:ScrollImage;
    var movingSky:Sprite3D = new Sprite3D();
    movingSky.x = 0;
    movingSky.y = 0;
    movingSky.rotationY = -Math.PI / 2 + Math.PI / 2014;
    movingSky.z = 0;
    movingSky.addChild(background);*/

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
          if (Std.string(a + b) == textField.text) {
              //Remove the specified character from the stage            
              rootSprite.removeChild(characterArray[counter], true);
              //Remove that same character from the array using a splice method
              characterArray = null;
              //Remove the equation from the stage
              Starling.current.nativeOverlay.removeChild(equationArray[counter]);
              //Remove the same equation from that array
              equationArray= null;
              //Remove the position of that character/equation from the array
              positionArray= null;
              //Increment score by 10
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
    var character: Image = new Image(Root.assets.getTexture("character1"));
    //Randomly generate a new point on the x-axis for the character
    var randomX = Math.round(Math.random() * 1230);
    var randomY = Math.round(Math.random() * 50);
    //Check if the randomX coordinate is spawning on top of another box.
    var returnBoolean: Bool = checkSpawn(randomX, positionArray);
    //If it spawns on top of another box, then we generate a new X coordinate until it no longer spawns on another box.
    while (!returnBoolean) {
        randomX = Math.round(Math.random() * 1230);
        returnBoolean = checkSpawn(randomX, positionArray);
    }
    //Set the x-coord of the box to the randomly gen. number
    character.x = randomX;
    //Set the y-coord to 0
    character.y = randomY;

    //Create randomly generated numbers for the equation
    var number1: String = Std.string(Math.round(Math.random() * 9));
    var number2: String = Std.string(Math.round(Math.random() * 9));

    //Create the equation to be put inside of the textfield
    var equation: TextField = new flash.text.TextField();
    var equationFormat: TextFormat = new TextFormat("Arial", 18, 0xffffff);
    equation.defaultTextFormat = equationFormat;
    equation.text += number1;
    equation.text += "+";
    equation.text += number2;
    //Format the background and set all of the text formats.
    equation.background = false;
    equation.width = 50;
    equation.height = 50;
    equation.x = randomX;
    equation.y = randomY;
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

      var character: Image = new Image(Root.assets.getTexture("character1"));
      var randomX = Math.round(Math.random() * 1230);
      var randomY = Math.round(Math.random() * 50);
      while (!checkSpawn(randomX, positionArray)) {
          randomX = Math.round(Math.random() * 1230);
          checkSpawn(randomX, positionArray);
      }
      character.x = randomX;
      character.y = randomY;
      characterArray.push(character);

      var number1: String = Std.string(Math.round(Math.random() * 9));
      var number2: String = Std.string(Math.round(Math.random() * 9));

      //Create the equation to be put inside of the textfield
      var equation: TextField = new flash.text.TextField();
      var equationFormat: TextFormat = new TextFormat("Arial", 18, 0xffffff);
      equation.defaultTextFormat = equationFormat;
      equation.text += number1;
      equation.text += "+";
      equation.text += number2;
      equation.background = false;
      equation.width = 50;
      equation.height = 50;
      equation.x = randomX;
      equation.y = randomY;
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
    //Iterate over all of the images in the array
    for (character in characterArray) {
        //increment the countChar (we don't necessarily have to do it here)
        countChar++;
        //check the y-coord of the box to determine if it hit the bottom of the screen
        if (character.y <= 670) {
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
                trace("You Lose. Total Score: " + totalScore);
                //Then generate the end screen
                var gotoend = new EndGame(rootSprite);
                gotoend.start();
            }
        }
    }
  }
}
