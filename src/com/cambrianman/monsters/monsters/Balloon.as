package com.cambrianman.monsters.monsters 
{
	import com.cambrianman.monsters.Level;
	import flash.display.Sprite;
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.Mask;
	import com.cambrianman.monsters.items.Item;
	
	/**
	 * Balloon Monster
	 * @author Evan Furchtgott
	 */
	public class Balloon extends Monster 
	{
		[Embed(source = "../gfx/enemies/balloon_monster.png")] private const IMGBALLOON:Class;
		
		public var grip:Entity;
		
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
				else if (collide("player", x, y + 1) != null)
				{
					level.player.y = top - level.player.height;
				}
				else
					(graphic as Spritemap).play("idle");
			}
			else if (state == WATER)
			{
				if (collideWith(level.player, x, y - 1) && level.player.bottom <= top)
				{
					level.player.x += speed.x;
				}
			}
			else if (state == FIRE)
			{
				grip.x = x + 8;
				grip.y = y + 16;
			}
		}
		
		override public function onFire():void
		{
			if (state == WATER)
			{
				level.particles.smokeAt(centerX, centerY, Item.FIRE);
				beNormal();
				return;
			}
			else if (state == FIRE)
				return;
				
			y -= 16;
			height = 32;
			acceleration.y = 0;
			drag.x = 0.001;
			
			setOrigin();
			state = FIRE;
			type = "backgroundMonster";
			collidables = ["ground", "monster"];
			(graphic as Spritemap).play("inflated");
			level.particles.smokeAt(centerX, centerY, Item.FIRE);
			speed.y = -0.6;
			pushable = false;
			grip.collidable = true;
		}
		
		override public function moveCollideX(e:Entity):Boolean 
		{
			super.moveCollideX(e);
			
			if (state == FIRE)
				speed.y = -0.6;
				
			return true;
		}
		
		private function beNormal():void
		{
			state = NORMAL;
			height = 16;
			originY = -16;
			
			acceleration.y = 0.2;
			speed.x = 0;
			pushable = false;
			
			if (level.player.clinging == grip)
				level.player.clinging = null;
				
			type = "monster";
			collidables = ["ground", "monster"];
			
			if (grip)
				grip.collidable = false;
		}
		
		override public function onWater():void
		{
			(graphic as Spritemap).play("frozen");
			originX = 0;
			if (state == WATER)
				return;
			else if (state == FIRE)
			{
				level.particles.smokeAt(centerX, centerY, Item.WATER);
				beNormal();
				return;
			}
			
			level.particles.smokeAt(centerX, centerY, Item.WATER);
			state = WATER;
			pushable = true;
			drag.x = 0.002;
			grip.collidable = false;
			collidables = ["ground", "monster", "player"];
		}
		
		override public function damage(e:Entity, direction:int = 0):void
		{
			if (state == FIRE)
			{
				beNormal();
			}
		}
		
		public function getGrip():Entity
		{
			grip = new Entity(x, y);
			grip.width = 16;
			grip.height = 16;
			grip.type = "grip";
			grip.collidable = false;
			
			return grip;
		}
	}

}