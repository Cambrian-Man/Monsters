package com.cambrianman.monsters 
{
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import flash.geom.Point;
	import net.flashpunk.FP;
	
	/**
	 * Mobile class, basically replicates the Flixel Sprite class, giving us
	 * speed, acceleration, drag, etc.
	 * @author Evan Furchtgott
	 */
	public class Mobile extends Entity 
	{
		// The speed of the sprite, a vector meaning the number of pixels to move per frame.
		public var speed:Point = new Point();
		
		// The maximum speed that we can move per frame.
		public var maxSpeed:Point = new Point();
		
		// An increase to the speed per frame.
		public var acceleration:Point = new Point();
		
		// Basic drag, a reduction in speed per frame.
		public var drag:Point = new Point();
		
		// Reference to the current level, for convenience.
		protected var level:Level;
		
		// Constants referring to various facing directions.
		public static const NONE:int = -1;
		public static const LEFT:int = 0;
		public static const UP:int = 1;
		public static const RIGHT:int = 2;
		public static const DOWN:int = 3;
		
		// An array of strings relating to types that
		// the mobile should collide with.
		public var collidables:Array;
		
		// Can we push this object and trigge the pushing state?
		public var pushable:Boolean = false;
		
		/**
		 * Constructor
		 * @param	level		A reference to the current level.
		 * @param	x
		 * @param	y
		 * @param	graphic
		 * @param	mask
		 */
		public function Mobile(level:Level, x:Number=0, y:Number=0, graphic:Graphic=null, mask:Mask=null) 
		{
			this.level = level;
			collidables = ["ground"];
			super(x, y, graphic, mask);
		}
		
		override public function update():void
		{
			var absX:Number = Math.abs(speed.x);
			var absY:Number = Math.abs(speed.y);

			speed.x = speed.x + acceleration.x;
			speed.x = FP.clamp(speed.x, (maxSpeed.x * -1), maxSpeed.x);
			
			speed.y = speed.y + acceleration.y;
			speed.y = FP.clamp(speed.y, (maxSpeed.y * -1), maxSpeed.y);
			
			if (absX > 0)
			{
				if (absX < drag.x)
					speed.x = 0;
				else
					speed.x = speed.x - (drag.x * FP.sign(speed.x));
			}
			
			if (absY > 0)
			{
				if (absY < drag.y)
					speed.y = 0;
				else
					speed.y = speed.y + (drag.y * FP.sign(speed.y));
			}
			
			moveBy(speed.x, speed.y, collidables, false);
			
			super.update();
		}
		
		override public function moveCollideX(e:Entity):Boolean {
			// Checks to see if we've bumped into any damaging tiles to the left or right.
			if (e == level.ground)
			{
				if (level.checkDamage(LEFT, this))
					damage(e, LEFT);
				else if (level.checkDamage(RIGHT, this))
					damage(e, RIGHT);
			}
			
			speed.x = 0;
			return true;
		}
		
		override public function moveCollideY(e:Entity):Boolean {
			// Check to see if we've bumped into any damaging tiles above or below.
			if (e == level.ground)
			{
				if (level.checkDamage(DOWN, this))
					damage(e, DOWN);
				else if (level.checkDamage(UP, this))
					damage(e, UP);
			}
			
			speed.y = 0;
			return true;
		}
		
		public function push(direction:int, amount:Number):void
		{
			switch (direction) 
			{
				case RIGHT:
					moveBy(amount, 0, collidables);
				break;
				case LEFT:
					moveBy((amount * -1), 0, collidables);
				break;
				default:
			}
		}
		
		/**
		 * Called when the mobile takes damage.
		 * @param	entity		The entity that damaged it.
		 * @param	direction	The direction that it took damage from.
		 */
		public function damage(entity:Entity, direction:int = 0):void
		{
			
		}
	}

}