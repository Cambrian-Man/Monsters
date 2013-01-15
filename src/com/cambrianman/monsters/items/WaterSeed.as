package com.cambrianman.monsters.items 
{
	import net.flashpunk.graphics.Image;
	import com.cambrianman.monsters.monsters.Monster;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Spritemap;
	
	/**
	 * ...
	 * @author Evan Furchtgott
	 */
	public class WaterSeed extends Item 
	{
		[Embed(source = "../gfx/items/water_seed.png")] private const IMGSEED:Class;
		public function WaterSeed() 
		{
			super();
			graphic = new Spritemap(IMGSEED, 16, 16);
			(graphic as Spritemap).add("drip", [0, 1, 2, 3], 8);
			(graphic as Spritemap).play("drip");
			
			originX = -2;
		}
		
		override protected function onCollide(e:Entity):void
		{
			level.recycle(this);
			level.spawnSeed(spawner, Item.WATER);
			
			if (e is Monster) {
				(e as Monster).onWater();
			}
		}
	}

}