package com.cambrianman.monsters.movementStates 
{
	import com.cambrianman.monsters.IMovementState;
	import com.cambrianman.monsters.Player;
	import com.cambrianman.monsters.Mobile;
	import com.cambrianman.monsters.PlayerGraphic;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.utils.Input;
	
	/**
	 * ...
	 * @author Evan Furchtgott
	 */
	public class Clinging implements IMovementState 
	{
		private var player:Player;
		
		public function Clinging() 
		{
			
		}
		
		/* INTERFACE com.cambrianman.monsters.IMovementState */
		
		public function initialize(props:Object):void 
		{
			this.player = props.player;			
		}
		
		public function update(keys:Object):Class 
		{
			// If we're not clinging for some reason (say, the monster stop being grabbable)
			// return to normal.
			if (!player.clinging)
				return Normal;
				
			(player.graphic as PlayerGraphic).play("cling");
				
			// When we're clinging, we ignore our normal movement
			// and attach to the clung-to monster.
			player.y = player.clinging.bottom - 8;
			player.x = player.clinging.x - 8;
			
			player.speed.x = 0;
			player.speed.y = 0;
			
			// We can change our facing direction while holding on.
			if (Input.check(keys.left))
			{
				player.facing = Mobile.LEFT;
				(player.graphic as PlayerGraphic).flipped = true;
			}
			else if (Input.check(keys.right))
			{
				player.facing = Mobile.RIGHT;
				(player.graphic as PlayerGraphic).flipped = false;
			}
			
			// Jumping makes us jump off, while interact just lets go.
			if (Input.pressed(keys.jump))
			{				
				return Jumping;
			}
			else if (Input.pressed(keys.interact))
			{
				player.speed.y = 0;
				return Normal;
			}
			
			return Clinging;
		}
		
		public function enter():void
		{
			
		}
		
		public function exit():void
		{
			
		}
		
		public function getClass():Class 
		{
			return Clinging;
		}
		
	}

}