package com.cambrianman.monsters.monsters 
{
	import com.cambrianman.monsters.Level;
	import flash.display.Sprite;
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.Mask;
	
	/**
	 * Balloon Monster
	 * @author Evan Furchtgott
	 */
	public class Balloon extends Monster 
	{
		[Embed(source = "../gfx/enemies/balloon_monster.png")] private const IMGBALLOON:Class;
		
		public function Balloon(level:Level, x:Number=0, y:Number=0) 
		{			
			graphic = new Spritemap(IMGBALLOON, 32, 32);
			(graphic as Spritemap).add("idle", [0, 0, 0, 0, 0, 1], 2, true);
			(graphic as Spritemap).add("inflated", [2]);
			(graphic as Spritemap).add("squish", [1]);
			(graphic as Spritemap).add("frozen", [3]);
			(graphic as Spritemap).play("idle");
			
			super(level, x, y, graphic, mask);
			
			maxSpeed.x = 10;
			maxSpeed.y = 8;
			
			width = 32;
			
			beNormal();
		}
		
		override public function update():void
		{
			super.update();
			
			if (state == NORMAL)
			{
				if (collide("player", x, y - 1))
					(graphic as Spritemap).play("squish");
				else if (speed.y > 0 && collide("player", x, y + 1))
				{
					level.player.y = top - level.player.height;
				}
				else
					(graphic as Spritemap).play("idle");
			}
		}
		
		override public function onFire():void
		{
			if (state == WATER)
			{
				beNormal();
				return;
			}
			else if (state == FIRE)
				return;
				
			y -= 16;
			height = 32;
			acceleration.y = 0;
			setOrigin();
			state = FIRE;
			type = "backgroundMonster";
			(graphic as Spritemap).play("inflated");
			speed.y = -0.6;
			pushable = false;
		}
		
		private function beNormal():void
		{
			state = NORMAL;
			originX = -2;
			height = 16;
			originY = -16;
			
			acceleration.y = 0.2;
			pushable = false;
			if (level.player.clinging == this)
				level.player.clinging = null;
			type = "monster";
		}
		
		override public function onWater():void
		{
			(graphic as Spritemap).play("frozen");
			originX = 0;
			if (state == WATER)
				return;
			else if (state == FIRE)
			{
				beNormal();
				return;
			}
			
			state = WATER;
			pushable = true;
		}
		
		override public function damage(e:Entity, direction:int = 0):void
		{
			if (state == FIRE)
			{
				beNormal();
			}
			else if (state == NORMAL)
			{
				// Should do something to delete.
			}
		}
	}

}