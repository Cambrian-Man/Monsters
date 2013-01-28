package com.cambrianman.monsters.monsters 
{
	import com.cambrianman.monsters.Level;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.Mask;
	import com.cambrianman.monsters.items.Item;
	
	/**
	 * ...
	 * @author Evan Furchtgott
	 */
	public class Spitting extends Monster 
	{
		[Embed(source = "../gfx/enemies/spitting_monster.png")] private const IMGSPITTING:Class;
		
		public function Spitting(level:Level, x:Number=0, y:Number=0, graphic:Graphic=null, mask:Mask=null) 
		{
			
			graphic = new Spritemap(IMGSPITTING, 32, 32);
			super(level, x, y, graphic);
			type = "monster";
			width = 32;
			height = 32;			

			(graphic as Spritemap).add("normal", [0]);
			(graphic as Spritemap).add("water", [1]);
			(graphic as Spritemap).add("fire", [2]);
			
			
			acceleration.y = 0.2;
		}
		
		override public function update():void
		{
			if (facing == LEFT)
			{
				(graphic as Spritemap).flipped = true;
			}
			else
			{
				(graphic as Spritemap).flipped = false;
			}
			
			super.update();
		}
		
		override public function onWater():void
		{
			super.onWater();
			
			if (state == NORMAL)
			{
				level.particles.stopSpray(this);
				(graphic as Spritemap).play("normal");
			}
			else if (state == WATER)
			{
				level.particles.startSpray(this, Item.WATER);
				(graphic as Spritemap).play("water");
			}
		}
		
		override public function onFire():void
		{
			super.onFire();
			
			if (state == NORMAL)
			{
				level.particles.stopSpray(this);
				(graphic as Spritemap).play("normal");
			}
			else if (state == FIRE)
			{
				level.particles.startSpray(this, Item.FIRE);
				(graphic as Spritemap).play("fire");
			}
		}
	}

}