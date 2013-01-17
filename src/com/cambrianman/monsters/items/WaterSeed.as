package com.cambrianman.monsters.items 
{
	import net.flashpunk.graphics.Image;
	import com.cambrianman.monsters.monsters.Monster;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Spritemap;
	import com.cambrianman.monsters.Level;
	
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
		
		override public function update():void
		{
			super.update();
			
			if (held)
				y = level.player.y + 8;
		}
		
		override protected function onCollide(e:Entity):void
		{
			level.recycle(this);
			level.spawnSeed(spawner, Item.WATER);
			
			if (e is Monster) {
				(e as Monster).onWater();
			}
		}
		
		override public function spawn(spawner:Entity, level:Level):void
		{
			super.spawn(spawner, level);
			x += 16;
			y += 9;
		}
	}

}