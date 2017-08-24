/**
* FizzyAPIas3
* 
* 
* @created		21 May 2009
* @author		Julian David Munoz
* @language 	Actionscript 3.0
* @copyright	Copyright (C) 2008 3RD Sense. All rights reserved.
* 
*/

package fizzy
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.media.SoundMixer;
	import flash.net.URLRequest;
	import flash.system.Capabilities;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	public class FizzyAPIas3
	{
		private static var bridge:Object;
		private static var instance:FizzyAPIas3;
		private static var initialized:Boolean = false;
		
		private static var demoCodes:Array = null;
		private static var userGameData:Object;
		private static var userDetails:Object;
		
		private var game:DisplayObjectContainer;
		private var intervalId:uint;
		private var loader:Loader;
		private var callbacks:Object;
		
		function FizzyAPIas3(mc:*, pc:FizzyPrivateClass)
		{
			this.game = mc;
			this.intervalId = setInterval(this.interfaceInterval, 200);
			this.loader = null;
			
			this.callbacks = new Object();
		}
		
		public static function setBridge(bg:*):void
		{
			FizzyAPIas3.bridge = bg;
		}
		
		public static function initialize(mc:*,initCallback:Function, callbackScope:Object = null):void
		{
			trace("FizzyAPI.initialize");
			
			FizzyAPIas3.instance = new FizzyAPIas3(mc, new FizzyPrivateClass());
			FizzyAPIas3.instance.setCallback("init", initCallback, callbackScope);
		}
		
		private static function clear():Object
		{
			var brg:Object = FizzyAPIas3.bridge;
			
			FizzyAPIas3.initialized = false;
			FizzyAPIas3.instance = null;
			FizzyAPIas3.bridge = null;
			
			return brg;
		}
		
		public static function setPlayListener(callback:Function, callbackScope:Object = null):void
		{
			if ( !FizzyAPIas3.initialized ) return;
			if ( callback == null ) callback = function():void { FizzyAPIas3.reloadGame(); };
			
			FizzyAPIas3.instance.setCallback("playGame",callback, callbackScope);
		}
		
		public static function setGameDataListener(onData:Function, thisObj:Object = null):void
		{
			FizzyAPIas3.instance.setCallback("gameDataResult", onData, thisObj);
		}
		
		public static function saveGameData(data:Object, dataName:String = "data"):void
		{
			if ( !FizzyAPIas3.initialized )
			{
				if ( Capabilities.playerType == "External" ) // Allows testing
					FizzyAPIas3.instance.executeCallback("gameDataResult", true);
				return;
			}
			
			FizzyAPIas3.userGameData[dataName] = data;
			FizzyAPIas3.bridge.saveGameData(dataName, data);
		}
		
		public static function getGameData(dataName:String = "data"):Object
		{
			if ( !FizzyAPIas3.initialized ) return null;
			
			return (FizzyAPIas3.userGameData[dataName] != undefined ? FizzyAPIas3.userGameData[dataName] : null);
		}
		
		public static function getUserDetails():Object
		{
			if ( !FizzyAPIas3.initialized ) return null;
			
			return FizzyAPIas3.userDetails;
		}
		
		public static function getUserId():Number
		{
			if ( !FizzyAPIas3.initialized ) return 0;
			
			return FizzyAPIas3.userDetails.id;
		}
		
		public static function getUsername():String
		{
			if ( !FizzyAPIas3.initialized ) return "";
			
			return FizzyAPIas3.userDetails.username;
		}
		
		public static function getAvatar():String
		{
			if ( !FizzyAPIas3.initialized ) return "";
			
			return FizzyAPIas3.userDetails.avatar;
		}
		
		public static function log(arg:String):void
		{
			trace(arg);
		}

		public static function getGamePath():String
		{
			trace("FizzyAPI.getGamePath");
			if ( !FizzyAPIas3.initialized ) return "";
			
			var end:Number = FizzyAPIas3.instance.game.loaderInfo.url.lastIndexOf("/");
			
			return FizzyAPIas3.instance.game.loaderInfo.url.substr(0,end+1);
		}
		
		public static function isDemo():Boolean
		{
			trace("FizzyAPI.isDemo");
			if ( !FizzyAPIas3.initialized ) return (Capabilities.playerType != "External" ? true : false);
			if ( FizzyAPIas3.demoCodes == null ) return true;
			if ( FizzyAPIas3.demoCodes.length != 2 ) return true;
			
			var seedA:Number = FizzyAPIas3.instance.getRecursive(FizzyAPIas3.demoCodes[0]);
			var seedB:Number = FizzyAPIas3.instance.getRecursive(FizzyAPIas3.demoCodes[1]);
			
			return Boolean( (seedA != seedB) || seedA <= 0 || seedB <= 0 );
		}
		
		public static function reloadGame():void
		{
			trace("FizzyAPI.reloadGame");
			if ( !FizzyAPIas3.initialized ) return;
			
			var brg:Object = FizzyAPIas3.clear();
			
			brg.reloadGame();
		}
		
		public static function openDeveloperPage():void
		{
			trace("FizzyAPI.openDeveloperPage");
			if ( !FizzyAPIas3.initialized ) return;
			FizzyAPIas3.bridge.openDeveloperPage();
		}
		
		public static function openMoregamesPage():void
		{
			trace("FizzyAPI.openMoregamesrPage");
			if ( !FizzyAPIas3.initialized ) return;
			FizzyAPIas3.bridge.openMoregamesPage();
		}
		
		public static function openGamePage():void
		{
			trace("FizzyAPI.openGamePage");
			if ( !FizzyAPIas3.initialized ) return;
			FizzyAPIas3.bridge.openGamePage();
		}
		
		public static function submitScore(score:Number,callback:Function = null, callbackScope:Object = null):void
		{
			trace("FizzyAPI.submitScore");
			if ( !FizzyAPIas3.initialized )
			{
				if ( Capabilities.playerType == "External" ) // Allows testing
				{
					if (callback != null && callbackScope != null) callback.apply(callbackScope, [true]);
					else if (callback != null) callback(true);
					
					return;
				}
				else return;
			}
			
			FizzyAPIas3.instance.setCallback("submitResult", callback, callbackScope);
			FizzyAPIas3.bridge.submitScore(score);
		}
		
		public static function showCredits():void
		{
			trace("FizzyAPI.showCredits");
			if ( !FizzyAPIas3.initialized ) return;
			FizzyAPIas3.bridge.showCredits();
		}
		
		public static function showGameover(score:Number):void
		{
			trace("FizzyAPI.showGameover");
			if ( !FizzyAPIas3.initialized ) return;
			FizzyAPIas3.bridge.showGameover(score);
		}
		
		private function interfaceInterval():void
		{
			// Allows test mode
			if ( Capabilities.playerType == "External" )
			{
				clearInterval(this.intervalId);
				this.intervalId = 0;
				this.executeCallback("init");
				return;
			}
			
			if ( this.game.loaderInfo.bytesLoaded < this.game.loaderInfo.bytesTotal ) return;
			
			if ( FizzyAPIas3.bridge != null )
			{
				var gameUrl:String = this.game.loaderInfo.url;
				var loaderUrl:String = this.game.loaderInfo.loaderURL;
				
				if ( (gameUrl.indexOf("http://www.fizzy.com") != 0 || loaderUrl.indexOf("http://www.fizzy.com") != 0) && Capabilities.playerType != "External" )
				{
					FizzyAPIas3.instance = null;
					FizzyAPIas3.bridge = null;
				}
				else
				{
					FizzyAPIas3.bridge.connectionSetup(FizzyAPIas3.instance);
					return;
				}
			}
			
			// Protect your game from being used on unathorized websites
			if ( this.loader != null )
			{
				try
				{
					this.game.setChildIndex(this.loader, this.game.numChildren - 1);
				}
				catch(e:*)
				{
					this.game.addChild(this.loader);
				}
			}
			else
			{
				SoundMixer.stopAll();
				this.loader = new Loader();
				this.loader.name = "__fizzyUI_pirate__"
				this.loader.load(new URLRequest("http://www.fizzy.com/swf/gls/pirate.swf"));
				this.game.addChild(this.loader);
			}
		}
		
		private function getRecursive(val:Object):Number
		{
			if ( val == null ) return -1;
			
			if ( typeof val.next == "number" )
			{
				return val.next ^ val.mask;
			}
			
			return this.getRecursive(val.next) ^ val.mask;
		}
		
		public function setCallback(type:String, cb:Function, scope:Object):void
		{
			this.callbacks[type] = { procedure:cb, scope:scope };
		}
		
		public function executeCallback(type:String, param:* = null):void
		{
			trace("Execute callback");
			var scope:Object = this.callbacks[type].scope;
			var procedure:Function = this.callbacks[type].procedure;
			
			if ( scope != null && procedure != null )
			{
				if (param != null) procedure.apply(scope, [param]);
				else procedure.apply(scope);
			}
			else if ( procedure != null )
			{
				if (param != null) procedure(param);
				else procedure();
			}
		}
		
		public function initCompleted(data:Object):void
		{
			FizzyAPIas3.initialized = true;
			FizzyAPIas3.setPlayListener(null);
			FizzyAPIas3.userGameData = data.gameData;
			FizzyAPIas3.userDetails = data.userDetails;
			
			this.executeCallback("init");
		}
		
		public function setGameVars(data:Object):void
		{
			trace("Setting game vars...");
			trace("  data.demo = "+data.demo);
			
			clearInterval(this.intervalId);
			this.intervalId = 0;
			
			FizzyAPIas3.demoCodes = data.demo;
		}
	}
}

class FizzyPrivateClass
{
	function FizzyPrivateClass(){}
}