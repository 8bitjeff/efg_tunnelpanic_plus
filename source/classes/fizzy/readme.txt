______________________________________________________________________________________________

Fizzy GLS readme file

This file explains how to integrate the GLS into your ONLINE game. There are 4 steps to the process:

STEP 1 - GETTING ALL THE FILES IN THE RIGHT PLACE AND PREPARING YOUR GAME FILE
STEP 2 - IMPORT AND INITIALIZE THE API REQUIRED TO USE THE FUNCTIONS AVAILABLE IN THE GLS
Step 3 - ENABLE SCORE SUBMISSION
Step 4 - PUBLISH YOUR GAME


Once you have published your ONLINE game for Fizzy, you will need to upload it along with the FULL DOWNLOAD game at  http://developers.fizzy.com


* If this is your first time, please take a moment to read through these instruction fully.

The files included in the SDK are:

- readme.txt (This file)
- FizzyAPIas2.as (API for AS2 games)
- FizzyAPIas3.as (API for AS3 games)
- com (Folder containing additional utilities)

______________________________________________________________________________________________




Background

The Fizzy Game Loading System (GLS) is piece of Flash Software that we use to load our games on Fizzy.com and other sites.
In order to make use of the Fizzy GLS you need to include an one ow two additioal AS files (depending on whether you game
is AS2 or AS3) when you publish you game in Flash and you need to call a minimum of two of the available functions. The first
initiates the GLS and the second is to submit a score, a minimum requirement for enhanced games. There are several additional
functions which you can optionally call too, which allow you to pull in a players username, check if the game is a demo version
(only applies to pay to play games), save game data and more.

List of functions:

initialize() method
public static function initialize(mc:MovieClip, onInit:Function, [thisObj:Object = null])


setPlayListener() method
public static function setPlayListener(onPlay:Function, [thisObj:Object = null])


isDemo() method
public static function isDemo():Boolean


reloadGame() method
public static function reloadGame()


openDeveloperPage() method
public static function openDeveloperPage()


openGamePage() method
public static function openGamePage()


openMoregamesPage() method
public static function openMoregamesPage()


showCredits() method
public static function showCredits()


setGameDataListener() method
public static function setGameDataListener(onData:Function, thisObj:Object)


saveGameData() method
public static function saveGameData(data:Object):void


getGameData() method
public static function getGameData([dataName:String = "data"]):Object


getUserDetails() method
public static function getUserDetails():Object
	

getUserId() method
public static function getUserId():Number

	
getUsername() method
public static function getUsername():String


getAvatar() method
public static function getAvatar():String
	

submitScore() method
public static function submitScore(score:Number, onSubmit:Function, [thisObj:Object])


showGameover() method
public static function showGameover(score:Number)




STEP 1 - GETTING ALL THE FILES IN THE RIGHT PLACE AND PREPARING YOUR GAME FILE

- Copy all of the above files into the same folder as your ONLINE game





STEP 2 - IMPORT AND INITIALIZE THE API REQUIRED TO USE THE FUNCTIONS AVAILABLE IN THE GLS

You must ensure that the Fizzy API is imported on to your game movie and then initialized in order to access its methods.
Below is an example of how this could be done on the first frame of your game movie.


<code>

// Stop the playhead until the Fizzy API has been initialized
stop();

// Import the Interface so that it can be used
import FizzyAPIas2/as3;

FizzyAPIas2/as3.initialize(this, this.interfaceReady);

function interfaceReady()
{
   // Set your play action if you want....
   // Set other variables...
   play();   // Start your game on the next frames.
}

</code>



Step 3 - ENABLE SCORE SUBMISSION

On your game over screen you must include a button that allows playes submitting their score. For instance, say you have
a button named submitScoreButton, then you can enable score submission by using the following AS2 code

<code>

var totalScore:Number;

submitScoreButton.onRelease = function()
{
   FizzyAPIas2.submitScore(totalScore, scoreSubmitted);
}

function scoreSubmitted(success:Boolean)
{
   if( success ) trace("Score submitted");
   else trace("Submit error")
}

</code>


For an AS3 game you c ould use the followind code:

<code>
import flash.events.MouseEvent;

var totalScore:Number;

submitScoreButton.addEventListener(MouseEvent.CLICK, submitScore);

function submitScore(evt:MouseEvent)
{
   FizzyAPIas3.submitScore(totalScore, scoreSubmitted);
}

function scoreSubmitted(success:Boolean)
{
   if( success ) trace("Score submitted");
   else trace("Submit error")
}
</code>



Step 4 - PUBLISH YOUR GAME

You should now be ready to publish your ONLINE game in Flash.

Please remember to contact us if you have any questions 

