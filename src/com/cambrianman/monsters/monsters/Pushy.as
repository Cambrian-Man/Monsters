package com.cambrianman.monsters.monsters 
{
	import com.cambrianman.monsters.Level;
	import com.cambrianman.monsters.Mobile;
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	
	/**
	 * ...
	 * @author Evan Furchtgott
	 */
	public class Pushy extends Monster 
	{
		public var facing:int;
		
		public function Pushy(level:Level, x:Number=0, y:Number=0, graphic:Graphic=null, mask:Mask=null) 
		{
			super(level, x, y, graphic, mask);
			
		}
		
		override public function update():void
		{
			facing = RIGHT;
			super.update();
		}
		
		override public function moveCollideX(e:Entity):Boolean
		{
			if (checkPush(e))
			{
				(e as Mobile).push(facing, Math.abs(speed.x));
			}
			
			super.moveCollideX(e);
			return true;
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