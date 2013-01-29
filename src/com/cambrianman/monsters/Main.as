package com.cambrianman.monsters
{
	import com.cambrianman.monsters.Level;
	import flash.display.Sprite;
	import flash.events.Event;
	import net.flashpunk.Engine;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Key;
	
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
			// Set up default keys.
			controlKeys.left = Key.LEFT;
			controlKeys.right = Key.RIGHT;
			controlKeys.up = Key.UP;
			controlKeys.down = Key.DOWN;
			controlKeys.interact = Key.C;
			controlKeys.jump = Key.X;
			controlKeys.reset = Key.R;
			
			super(256, 224, 60, false);
			FP.screen.scale = 2;
			FP.world = new Menu();
			//FP.console.enable();
		}
		
	}
	
}