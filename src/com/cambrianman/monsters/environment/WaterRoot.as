package com.cambrianman.monsters.environment 
{
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.Mask;
	import com.cambrianman.monsters.items.Item;
	
	/**
	 * ...
	 * @author Evan Furchtgott
	 */
	public class WaterRoot extends Root 
	{
		[Embed(source = "../gfx/environment/water_root.png")] private const IMGWATERROOT:Class;
		
		public function WaterRoot(x:Number=0, y:Number=0, graphic:Graphic=null, mask:Mask=null) 
		{
			super(x, y, new Image(IMGWATERROOT), mask);
			
		}
		
		override protected function drip():void
		{
			level.spawnSeed(this, Item.WATERDROP);
		}
	}

}