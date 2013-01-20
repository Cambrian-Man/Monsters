package com.cambrianman.monsters.monsters 
{
	import com.cambrianman.monsters.Level;
	import com.cambrianman.monsters.Mobile;
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Image;
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
			super(level, x, y, new Image(IMGPUSHY), mask);
			width = 32;
			height = 32;
			
			maxSpeed.x = 3;
			maxSpeed.y = 6;
			
			acceleration.y = 0.2;
			
			state = NORMAL;
			collidables = ["ground", "monster"];
		}
		
		override public function update():void
		{
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
				(e as Mobile).push(facing, 1);
			}
			else if (e == level.ground && state == NORMAL)
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
				
			return (level.isSolidTile(_x, bottom + 1));
		}
		
		/**
		 * Check to see if we should push the entity.
		 * @param	e
		 */
		private function checkPush(e:Entity):Boolean
		{			
			if (!(e is Mobile) || !(e as Mobile).pushable)
				return false;
				
			if (facing == RIGHT && x < e.x)
				return true;
			else if (facing == LEFT && x > e.x)
				return true;
				
			return false;
		}
	}

}