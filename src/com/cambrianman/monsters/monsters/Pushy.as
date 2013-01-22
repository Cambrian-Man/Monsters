package com.cambrianman.monsters.monsters 
{
	import com.cambrianman.monsters.Level;
	import com.cambrianman.monsters.Mobile;
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.Mask;
	
	/**
	 * ...
	 * @author Evan Furchtgott
	 */
	public class Pushy extends Monster 
	{
		[Embed(source = "../gfx/enemies/pushy_monster.png")] private const IMGPUSHY:Class;
		public var facing:int;
		
		public function Pushy(level:Level, x:Number=0, y:Number=0, graphic:Graphic=null, mask:Mask=null) 
		{
			graphic = new Spritemap(IMGPUSHY, 32, 16);
			super(level, x, y, graphic);
			width = 32;
			height = 16;

			(graphic as Spritemap).add("normal", [0]);
			(graphic as Spritemap).add("water", [1]);
			(graphic as Spritemap).add("fire", [2]);
			
			
			maxSpeed.x = 3;
			maxSpeed.y = 6;
			
			acceleration.y = 0.2;
			
			state = NORMAL;
			collidables = ["ground", "monster", "player"];
		}
		
		override public function update():void
		{
			if (state == NORMAL)
				(graphic as Spritemap).play("normal");
			else if (state == WATER)
				(graphic as Spritemap).play("water");
			else if (state == FIRE)
				(graphic as Spritemap).play("fire");
			
			if (facing == Mobile.RIGHT)
				(graphic as Image).flipped = false;
			else
				(graphic as Image).flipped = true;
				
			if (state == NORMAL)
			{
				if (!checkFloorAhead()) 
					turn();
				
				if (facing == Mobile.RIGHT)
					speed.x = 0.3;
				else
					speed.x = -0.3;
			}
			else if (state == FIRE)
			{
				if (facing == Mobile.RIGHT)
					speed.x = 1;
				else
					speed.x = -1;
			}
			else if (state == WATER)
				speed.x = 0;
			
			super.update();
		}
		
		override public function moveCollideX(e:Entity):Boolean
		{
			if (checkPush(e))
			{
				(e as Mobile).push(facing, 2);
			}
			else if (state == NORMAL)
				turn();
			
			super.moveCollideX(e);
			
			return true;
		}
		
		private function turn():void
		{
			(facing == Mobile.RIGHT) ? facing = Mobile.LEFT : facing = Mobile.RIGHT;
		}
		
		private function checkFloorAhead():Boolean
		{
			var _x:int;
			if (facing == Mobile.RIGHT)
				_x = right + 1;
			else
				_x = x - 1;
				
			var _fx:Number = (facing == LEFT) ? x - 1 : x + 1;
			if (!collide("monster", _fx, y))
			{
				if (collide("monster", _fx, y + 1))
				{
					return true;
				}
			}
				
			return (level.isSolidTile(_x, bottom + 1));
		}
		
		/**
		 * Check to see if we should push the entity.
		 * @param	e
		 */
		private function checkPush(e:Entity):Boolean
		{			
			if (!(e is Mobile) || !(e as Mobile).canPush(facing))
				return false;
				
			if (facing == RIGHT && x < e.x)
				return true;
			else if (facing == LEFT && x > e.x)
				return true;
				
			return false;
		}
	}

}