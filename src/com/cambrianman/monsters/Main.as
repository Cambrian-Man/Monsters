package com.cambrianman.monsters
{
	import com.cambrianman.monsters.Level;
	import flash.display.Sprite;
	import flash.events.Event;
	import net.flashpunk.Engine;
	import net.flashpunk.FP;
	
	/**
	 * ...
	 * @author Evan Furchtgott
	 */
	public class Main extends Engine 
	{
		[Embed(source = "fonts/mini_serif.ttf", fontName="Mini-Serif", mimeType="application/x-font-truetype", embedAsCFF="false", advancedAntiAliasing="true")] public static const FONT:Class;
		
		public function Main():void 
		{
			super(256, 224, 60, false);
			FP.screen.scale = 2;
			FP.world = new Menu();
			//FP.console.enable();
		}
		
	}
	
}