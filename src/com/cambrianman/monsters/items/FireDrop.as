package com.cambrianman.monsters.items 
{
	import com.cambrianman.monsters.Level;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.Entity;
	import com.cambrianman.monsters.monsters.Monster;
	
	/**
	 * ...
	 * @author Evan Furchtgott
	 */
	public class FireDrop extends FireSeed
	{
		
		public function FireDrop() 
		{
			super();
		}
		
		override public function spawn(spawner:Entity, level:Level):void
		{
			super.spawn(spawner, level);
			acceleration.y = 0.2;
			x -= 8;
		}
		
		override public function grab():void
		{
			// Don't respond to grabs.
		}
		
		override protected function onCollide(e:Entity):void
		{
			level.particles.burstAt(x, y, FIRE);
			level.recycle(this);
			
			if (e is Monster)
				(e as Monster).onFire();
		}
		
	}

}