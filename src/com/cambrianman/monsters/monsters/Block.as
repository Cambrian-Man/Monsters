package com.cambrianman.monsters.monsters 
{
	import com.cambrianman.monsters.Level;
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.graphics.Tilemap;
	import net.flashpunk.Mask;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.tweens.misc.MultiVarTween;
	import net.flashpunk.tweens.misc.NumTween;
	/**
	 * ...
	 * @author Evan Furchtgott
	 */
	public class Block extends Monster 
	{
		[Embed(source = "../gfx/enemies/block_monster.png")] private const IMGBLOCK:Class;
		
		private var sizeTween:MultiVarTween;
		private var graphicTween:MultiVarTween;
		
		public function Block(level:Level, x:Number=0, y:Number=0, graphic:Graphic=null, mask:Mask=null) 
		{
			graphic = new Spritemap(IMGBLOCK, 48, 48)
			super(level, x, y, graphic, mask);
			(graphic as Spritemap).add("small", [0]);
			(graphic as Spritemap).add("medium", [1]);
			(graphic as Spritemap).add("large", [2]);
			pushable = true;
			
			sizeTween = new MultiVarTween(sizeComplete);
			addTween(sizeTween);
			
			graphicTween = new MultiVarTween();
			addTween(graphicTween);
			
			acceleration.y = 0.2;
			maxSpeed.y = 10;
			beNormal();
			(graphic as Spritemap).play("medium");
			
		}
		
		override public function update():void
		{
			 if (speed.y > 0 && collide("player", x, y + 1))
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
				beNormal();
				shrink();
				return;
			}
			
			shrink();
			width = 16;
			height = 16;
			state = FIRE;
		}
		
		override public function onWater():void
		{
			if (state == FIRE)
			{
				grow();
				beNormal();
				return;
			}
			else if (state == WATER)
				return;
			else if (!hasRoom())
			{
				return;
			}
			
			grow();
			
			width = 48;
			height = 48;
			state = WATER;
		}
		
		private function beNormal():void
		{	
			width = 32;
			height = 32;
			setOrigin(0, 0);
			state = NORMAL;
		}
		
		private function grow():void
		{
			sizeTween.tween(this, { x: x - 8, y: y - 16 }, 0.1);
			sizeTween.start();
			
			graphicTween.tween((graphic as Spritemap), { scale: 1.5 }, 0.1 );
			graphicTween.start();
		}
		
		private function shrink():void
		{
			sizeTween.tween(this, { x: x + 8, y: y + 16 }, 0.1);
			sizeTween.start();
			
			graphicTween.tween((graphic as Spritemap), { scale: 0.66 }, 0.1 );
			graphicTween.start();
		}
		
		private function sizeComplete():void
		{
			if (state == WATER)
				(graphic as Spritemap).play("large");
			else if (state == NORMAL)
				(graphic as Spritemap).play("medium");
			else if (state == FIRE)
				(graphic as Spritemap).play("small");
				
			(graphic as Spritemap).scale = 1;
		}
		
		/**
		 * Checks to see if it is possible to grow in the current location.
		 * @return
		 */
		private function hasRoom():Boolean
		{
			// The width of the hitbox plus the two corners.
			var topBlocks:int = (width / 16) + 2;
			var sideBlocks:int = (height / 16);
			
			for (var i:int = 0; i < topBlocks; i++) 
			{
				if (level.isSolidTile((x - 16) + (i * 16), top - 16))
					return false;
			}
			
			for (i = 0; i < sideBlocks; i++) 
			{
				if (level.isSolidTile((x - 16), top  + (i * 16)))
					return false;
				else if (level.isSolidTile((right + 16), top  + (i * 16)))
					return false;
			}
			
			return true;
		}
	}

}