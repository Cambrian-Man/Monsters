package com.cambrianman.monsters.items 
{
	import com.cambrianman.monsters.Level;
	import com.cambrianman.monsters.Mobile;
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	
	/**
	 * Base class for held items.
	 * @author Evan Furchtgott
	 */
	public class Item extends Mobile 
	{
		public static var FIRE:int = 0;
		public static var WATER:int = 0;
		
				
		protected var held:Boolean = false;
		protected var spawner:Entity;
		
		public function Item(level:Level=null, x:Number=0, y:Number=0, graphic:Graphic=null, mask:Mask=null) 
		{
			super(level, x, y, graphic, mask);
			
			collidables = ["ground", "monster", "backgroundMonster"];
		}
		
		override public function update():void
		{
			if (held)
			{
				y = level.player.y + 4;
				
				if (level.player.facing == RIGHT)
					x = level.player.x + width;
				else
					x = level.player.x;		
			}
			super.update();
		}
		
		public function spawn(spawner:Entity, level:Level):void
		{
			this.level = level;
			this.spawner = spawner;
			x = spawner.x + 16;
			y = spawner.y + 6;
			speed.x = 0;
			speed.y = 0;
			acceleration.y = 0;
		}
		
		public function grab():void
		{
			level.player.held = this;
			held = true;
		}
		
		public function toss():void
		{
			held = false;
			level.player.held = null;
			if (level.player.facing == RIGHT)
				speed.x = 6;
			else
				speed.x = -6;
				
			acceleration.y = 0.1;
		}
		
		override public function moveCollideX(e:Entity):Boolean
		{
			super.moveCollideX(e);
			onCollide(e);
			
			return true;
		}
		
		override public function moveCollideY(e:Entity):Boolean
		{
			super.moveCollideY(e);
			onCollide(e);
			
			return true;
		}
		
		/**
		 * Generic collision handling for the seed.
		 * @param	e
		 */
		protected function onCollide(e:Entity):void
		{
			
		}
		
		override public function removed():void
		{
			level.recycle(this);
		}
	}

}