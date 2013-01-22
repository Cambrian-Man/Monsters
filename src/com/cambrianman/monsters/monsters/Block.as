package com.cambrianman.monsters.monsters 
{
	import com.cambrianman.monsters.Level;
	import com.cambrianman.monsters.items.Item;
	import com.cambrianman.monsters.Mobile;
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.graphics.Tilemap;
	import net.flashpunk.Mask;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.tweens.misc.MultiVarTween;
	import net.flashpunk.tweens.misc.NumTween;
	/**
	 * Block monster class.
	 * @author Evan Furchtgott
	 */
	public class Block extends Monster 
	{
		[Embed(source = "../gfx/enemies/block_monster.png")] private const IMGBLOCK:Class;
		
		private var sizeTween:MultiVarTween;
		private var graphicTween:MultiVarTween;
		
		public function Block(level:Level, x:Number=0, y:Number=0, graphic:Graphic=null, mask:Mask=null) 
		{
			graphic = new Spritemap(IMGBLOCK, 48, 48);
			super(level, x, y, graphic, mask);
			(graphic as Spritemap).add("small", [0]);
			(graphic as Spritemap).add("medium", [1]);
			(graphic as Spritemap).add("large", [2]);
			pushable = true;
			
			// Set up tweens for expanding size and graphics.
			// These operate on two different objects, so need to be diffrent
			// tweens.
			sizeTween = new MultiVarTween(sizeComplete);
			addTween(sizeTween);
			
			graphicTween = new MultiVarTween();
			addTween(graphicTween);
			
			acceleration.y = 0.2;
			maxSpeed.y = 10;
			setOrigin(0, 0);
			
			collidables = ["ground", "monster", "player"];
		}
		
		override public function update():void
		{
			 if (speed.y > 0.5 && collide("player", x, y + 1))
			{
				level.player.y = top - level.player.height;
			}
			
			super.update();
		}
		
		override public function onFire():void
		{
				
			if (state == FIRE)
				return;
			else if (state == WATER)
			{
				level.particles.smokeAt(centerX, centerY, Item.FIRE);
				setOrigin(0, 0);
				shrink();
				return;
			}
			
			level.particles.smokeAt(centerX, centerY, Item.FIRE);
			shrink();
		}
		
		/**
		 * Sets the size of the block without a tween.
		 * Used during loading.
		 * @param	size	A string. "small", "medium", "large". Just
		 * so we can pass in the level's value directly.
		 */
		public function setSize(size:String):void
		{
			switch (size) 
			{
				case "small":
					width = 16;
					height = 16;
					(graphic as Spritemap).play("small");
					state = FIRE;
				break;
				case "medium":
					width = 32;
					height = 32;
					(graphic as Spritemap).play("medium");
					state = NORMAL;
				break;
				case "large":
					width = 48;
					height = 48;
					(graphic as Spritemap).play("large");
					state = WATER;
				break;
			}
		}
		
		override public function onWater():void
		{
			if (state == WATER)
				return
			
			if (state == FIRE)
			{
				setOrigin(0, 0);
			}
				
			var growDir:int = canGrow();
			if (growDir == Mobile.NONE)
				return;
			
			level.particles.smokeAt(centerX, centerY, Item.WATER);
			grow(growDir);
		}
		
		/**
		 * Grows the block in a given direction. This starts
		 * a tween for the animation.
		 * @param	direction A Mobile constant direction.
		 */
		private function grow(direction:int):void
		{
			var _x:Number;
			if (direction == Mobile.UP)
				_x = x - 8;
			else if (direction == Mobile.RIGHT)
				_x = x;
			else if (direction == Mobile.LEFT)
				_x = x - 16;
			
			sizeTween.tween(this, { x: _x, y: y - 16 }, 0.1);
			sizeTween.start();
			
			graphicTween.tween((graphic as Spritemap), { scale: 1.5 }, 0.1 );
			graphicTween.start();
			
			state += 1;
		}
		
		/**
		 * Shrinks the block. Much simpler than grow because
		 * we don't need to check for collision.
		 */
		private function shrink():void
		{
			sizeTween.tween(this, { x: x + 8, y: y + 16 }, 0.1);
			sizeTween.start();
			
			graphicTween.tween((graphic as Spritemap), { scale: 0.66 }, 0.1 );
			graphicTween.start();
			
			state -= 1;
		}
		
		/**
		 * Called when we've completed tweening.
		 */
		private function sizeComplete():void
		{	
			if (state == WATER)
				setSize("large");
			else if (state == NORMAL)
				setSize("medium");
			else if (state == FIRE)
				setSize("small");
				
			(graphic as Spritemap).scale = 1;
		}
		
		/**
		 * Checks to see which way the object can grow.
		 * @return	A direction. UP, LEFT, RIGHT, or NONE.
		 */
		private function canGrow():int
		{
			var direction:int = Mobile.NONE;
			
			// Make ourselves bigger, temporarily.
			width += 16;
			height += 16;
			
			// By default, we should just grow from the middle
			// but if we can't, let's check either side.
			if (!collideTypes(collidables, x - 8, y - 16))
			{
				direction = Mobile.UP;
			}
			else if (!collideTypes(collidables, x, y - 16))
			{
				direction = Mobile.RIGHT;
			}
			else if (!collideTypes(collidables, x - 16, y - 16))
			{
				direction = Mobile.LEFT;
			}
			
			// And shrink back down. We'll grow properly by using
			// a tween.
			width -= 16;
			height -= 16;
			return direction;
		}
	}

}