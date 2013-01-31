package com.cambrianman.monsters.movementStates 
{
	import com.cambrianman.monsters.IMovementState;
	import com.cambrianman.monsters.Player;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.Sfx;
	import net.flashpunk.utils.Input;
	import com.cambrianman.monsters.movementStates.*;
	import net.flashpunk.FP;
	
	/**
	 * ...
	 * @author Evan Furchtgott
	 */
	public class Jumping extends Normal
	{
		// The number of frames we are allowed to keep holding jump to increase
		// height. Tweak to change how sensitive we are to jumping.
		// 10 frames = 1/20th of a second, at 60 FPS.
		private var maxUpTicks:int = 10;
		
		// How much longer we can hold the button down.
		private var upTicks:int;
		
		// Use a boolean to turn off height increase if we release the button
		// or start moving down for whatever reason.
		private var canIncrease:Boolean;
		
		[Embed(source = "../audio/jump.mp3")] private var SNDJUMP:Class;
		private var jump:Sfx;
		
		public function Jumping() 
		{
			jump = new Sfx(SNDJUMP);
			jump.type = "effects";
		}
		
		override public function update(keys:Object):Class
		{
			// If we've start moving down, released the key or ran out of ticks,
			// we can no longer increase. Otherwise increase our speed and take
			// away ticks.
			if (player.speed.y >= 0 || Input.released(keys.jump) || upTicks == 0)
				canIncrease = false;
			else if (canIncrease && Input.check(keys.jump))
			{
				player.speed.y -= 0.2;
				upTicks--;
			}
			
			moveSides(keys);
			
			var _ic:Class = handleInteract(keys);
			
			if (_ic)
				return _ic;	
			
			handleAnimation(keys);
			
			if (player.onGround && player.speed.y >= 0)
				return Normal;
			else
				return Jumping;
		}
		
		override public function enter():void
		{
			canIncrease = true;
			upTicks = maxUpTicks;
			player.speed.y = -4;
			jump.play();
		}
		
		override public function getClass():Class
		{
			return Jumping;
		}
	}

}