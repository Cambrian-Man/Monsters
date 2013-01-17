package com.cambrianman.monsters.monsters 
{
	import com.cambrianman.monsters.Level;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.Mask;
	import net.flashpunk.graphics.Image;
	/**
	 * ...
	 * @author Evan Furchtgott
	 */
	public class Block extends Monster 
	{
		[Embed(source = "../gfx/enemies/block_monster.png")] private const IMGBLOCK:Class;
		
		public function Block(level:Level, x:Number=0, y:Number=0, graphic:Graphic=null, mask:Mask=null) 
		{
			graphic = new Spritemap(IMGBLOCK, 48, 48)
			super(level, x, y, graphic, mask);
			(graphic as Spritemap).add("small", [0]);
			(graphic as Spritemap).add("medium", [1]);
			(graphic as Spritemap).add("large", [2]);
			pushable = true;
			acceleration.y = 0.2;
			maxSpeed.y = 10;
			beNormal();
		}
		
		override public function onFire():void
		{
			if (state == FIRE)
				return;
			else if (state == WATER)
			{
				beNormal();
				return;
			}
			
			(graphic as Spritemap).play("small");
			x += 16;
			y += 16;
			width = 16;
			height = 16;
			state = FIRE;
		}
		
		override public function onWater():void
		{
			if (state == FIRE)
			{
				beNormal();
				return;
			}
			else if (state == WATER)
				return;
				
			y -= 16;
			
			(graphic as Spritemap).play("large");
			width = 48;
			height = 48;
			state = WATER;
		}
		
		private function beNormal():void
		{
			if (state == FIRE)
			{
				x -= 16;
				y -= 16;
			}
			(graphic as Spritemap).play("medium");
			width = 32;
			height = 32;
			setOrigin(0, 0);
			state = NORMAL;
		}
	}

}