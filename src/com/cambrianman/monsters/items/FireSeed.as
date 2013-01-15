package com.cambrianman.monsters.items 
{
	import com.cambrianman.monsters.Level;
	import com.cambrianman.monsters.Mobile;
	import com.cambrianman.monsters.monsters.Monster;
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.Mask;
	import net.flashpunk.masks.Hitbox;
	
	/**
	 * Fire seed
	 * @author Evan Furchtgott
	 */
	public class FireSeed extends Item
	{
		[Embed(source = "../gfx/items/fire_seed.png")] private const IMGSEED:Class;

		public function FireSeed() 
		{
			super();
			graphic = new Spritemap(IMGSEED, 16, 16);
			(graphic as Spritemap).add("burn", [0, 1, 2, 3], 8, true);
			(graphic as Spritemap).play("burn");
			
			originX = -2;
			originY = -4;
		}
		
		override protected function onCollide(e:Entity):void
		{
			level.recycle(this);
			level.spawnSeed(spawner, Item.FIRE);
			
			if (e is Monster) {
				(e as Monster).onFire();
			}
		}
	}

}