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
	 * Pushy monster class.
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
				
			// In the normal state, check to see if we can' go
			// on because of a cliff or blocking monster.
			// In the fire state, we just push on ahead.
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
			// If we can push something, push it. Otherwise, turn around.
			if (checkPush(e))
			{
				(e as Mobile).push(facing, 1);
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
		
		/**
		 * Checks to see if the floor one tile ahead and below is
		 * solid or not.
		 * @return
		 */
		private function checkFloorAhead():Boolean
		{
			// The x position of the next tile.
			// Changing facing doesn't actually switch the origin,
			// So we look at the right or left side.
			var _tx:int = (facing == Mobile.RIGHT) ? _tx = right : _tx = x;

			// The next x in the direction we're facing.
			var _fx:Number = (facing == LEFT) ? x - 1 : x + 1;
			if (!collide("monster", _fx, y))
			{
				if (collide("monster", _fx, y + 1))
				{
					return true;
				}
			}
				
			return (level.isSolidTile(_tx, bottom + 1));
		}
		
		/**
		 * Check to see if we should push the entity.
		 * Different from looking at pushable because
		 * we're seeing if there's actual room to move.
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