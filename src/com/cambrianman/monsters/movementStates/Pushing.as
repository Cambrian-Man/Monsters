package com.cambrianman.monsters.movementStates 
{
	import com.cambrianman.monsters.IMovementState;
	import com.cambrianman.monsters.Player;
	import com.cambrianman.monsters.Mobile;
	import net.flashpunk.utils.Input;
	
	/**
	 * ...
	 * @author Evan Furchtgott
	 */
	public class Pushing implements IMovementState 
	{
		private var player:Player;
		private var pushDir:int;
		
		public function Pushing() 
		{
			
		}
		
		/* INTERFACE com.cambrianman.monsters.IMovementState */
		
		public function initialize(props:Object):void 
		{
			this.player = props.player;
		}
		
		public function update(keys:Object):Class 
		{
			if (!player.pushing)
				return Normal;
				
			if (pushDir == Mobile.RIGHT)
			{
				if (Input.pressed(keys.left))
					return Normal;
				else if(Input.check(keys.right))
				{
					player.pushing.push(player.facing, 0.6);
					player.speed.x = 0.6;
					return Pushing;
				}
			}
			else if (pushDir == Mobile.LEFT)
			{
				if (Input.check(keys.left))
				{
					player.pushing.push(player.facing, 1);
					player.speed.x = -1;
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
		}
		
		public function exit():void 
		{
			player.pushing = null;
		}
		
	}

}