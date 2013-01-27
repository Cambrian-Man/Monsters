package com.cambrianman.monsters.monsters 
{
	import com.cambrianman.monsters.Level;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Image;
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
			super(level, x, y, new Image(IMGSPITTING), mask);
			type = "monster";
			width = 32;
			height = 32;
			acceleration.y = 0.2;
		}
		
		override public function update():void
		{
			if (facing == LEFT)
			{
				(graphic as Image).flipped = true;
			}
			else
			{
				(graphic as Image).flipped = false;
			}
			
			super.update();
		}
		
		override public function onWater():void
		{
			super.onWater();
			
			if (state == NORMAL)
				level.particles.stopSpray(this);
			else if (state == WATER)
				level.particles.startSpray(this, Item.WATER);
		}
		
		override public function onFire():void
		{
			super.onFire();
			
			if (state == NORMAL)
				level.particles.stopSpray(this);
			else if (state == FIRE)
				level.particles.startSpray(this, Item.FIRE);
		}
	}

}