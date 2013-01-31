package com.cambrianman.monsters.movementStates 
{
	import com.cambrianman.monsters.IMovementState;
	import com.cambrianman.monsters.Player;
	import com.cambrianman.monsters.Mobile;
	import com.cambrianman.monsters.PlayerGraphic;
	import net.flashpunk.utils.Input;
	
	/**
	 * ...
	 * @author Evan Furchtgott
	 */
	public class Pushing implements IMovementState 
	{
		private var player:Player;
		private var pushDir:int;
		
		private var sprite:PlayerGraphic;
		
		public function Pushing() 
		{
			
		}
		
		/* INTERFACE com.cambrianman.monsters.IMovementState */
		
		public function initialize(props:Object):void 
		{
			this.player = props.player;
			sprite = player.graphic as PlayerGraphic;
		}
		
		public function update(keys:Object):Class 
		{
			if (!player.pushing)
				return Normal;
				
			if (player.bottom <= player.pushing.top)
				return Normal;
				
			if (Input.pressed(keys.jump))
				return Jumping;
				
			if (pushDir == Mobile.RIGHT)
			{
				if (Input.pressed(keys.left))
					return Normal;
				else if(Input.check(keys.right))
				{
					player.pushing.push(player.facing, 0.6);
					player.speed.x = 0.6;
					sprite.play("hop");
					sprite.flipped = false;
					
					return Pushing;
				}
			}
			else if (pushDir == Mobile.LEFT)
			{
				if (Input.check(keys.left))
				{
					player.pushing.push(player.facing, 1);
					player.speed.x = -1;
					sprite.play("hop");
					sprite.flipped = true;
					
					return Pushing;
				}
			}
			
			return Normal;
		}
		
		public function getClass():Class 
		{
			return Pushing;
		}
		
		public function enter():void 
		{
			player.speed.x = 0;
			pushDir = int(player.facing);
			
			if (!sprite.holding)
				sprite.holding = true;
		}
		
		public function exit():void 
		{
			player.pushing = null;
			sprite.holding = (player.held != null);
			if (player.facing == Mobile.RIGHT)
				sprite.flipped = false;
			else
				sprite.flipped = true;
		}
		
	}

}