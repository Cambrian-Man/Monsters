package com.cambrianman.monsters
{
	import com.cambrianman.monsters.Level;
	import flash.display.Sprite;
	import flash.events.Event;
	import net.flashpunk.Engine;
	import net.flashpunk.FP;
	import net.flashpunk.Sfx;
	import net.flashpunk.utils.Key;
	import net.flashpunk.utils.Data;
	
	/**
	 * ...
	 * @author Evan Furchtgott
	 */
	public class Main extends Engine 
	{
		[Embed(source = "fonts/mini_serif.ttf", fontName="Mini-Serif", mimeType="application/x-font-truetype", embedAsCFF="false", advancedAntiAliasing="true")] public static const FONT:Class;
		
		public static var controlKeys:Object = { };
		
		public function Main():void 
		{
			Data.load("monstersSaveData");
			loadKeys();
			
			setSound(Data.readBool("sound"));
			
			Level.music = new Sfx(Level.SNDMUSIC);
			
			super(256, 224, 60, false);
			FP.screen.scale = 2;
			FP.world = new Menu();
			FP.console.enable();
		}
		
		public static function loadKeys():void
		{
			controlKeys.left = Data.readInt("left", Key.LEFT);
			controlKeys.right = Data.readInt("right", Key.RIGHT);
			controlKeys.up = Data.readInt("up", Key.UP);
			controlKeys.down = Data.readInt("down", Key.DOWN);
			controlKeys.jump = Data.readInt("jump", Key.X);
			controlKeys.interact = Data.readInt("interact", Key.C);
			controlKeys.reset = Data.readInt("reset", Key.R);
		}
		
		public static function setDefaultKeys():void
		{
			controlKeys.left = Key.LEFT;
			controlKeys.right = Key.RIGHT;
			controlKeys.up = Key.UP;
			controlKeys.down = Key.DOWN;
			controlKeys.interact = Key.C;
			controlKeys.jump = Key.X;
			controlKeys.reset = Key.R;
		}
		
		public static function saveKeys():void
		{
			Data.writeInt("left", controlKeys.left);
			Data.writeInt("right", controlKeys.right);
			Data.writeInt("up", controlKeys.up);
			Data.writeInt("down", controlKeys.down);
			Data.writeInt("interact", controlKeys.interact);
			Data.writeInt("jump", controlKeys.jump);
			Data.writeInt("reset", controlKeys.reset);
			Data.save("monstersSaveData");
		}
		
		public static function setSound(enabled:Boolean):void
		{
			if (enabled)
			{
				Sfx.setVolume("music", 1.0);
				Sfx.setVolume("effects", 1.0);
			}
			else
			{
				Sfx.setVolume("music", 0);
				Sfx.setVolume("effects", 0);
			}
			
			Data.writeBool("sound", enabled);
		}
	}
	
}