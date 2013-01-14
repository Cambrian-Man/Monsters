package com.cambrianman.monsters.movementStates 
{
	import adobe.utils.CustomActions;
	import com.cambrianman.monsters.items.*;
	import com.cambrianman.monsters.monsters.*;
	import com.cambrianman.monsters.*;
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.tweens.misc.NumTween;
	import net.flashpunk.utils.Input;
	import net.flashpunk.FP;
	
	/**
	 * ...
	 * @author Evan Furchtgott
	 */
	public class Normal implements IMovementState 
	{
		protected var player:Player;
		protected var sprite:Spritemap;
		
		private var lookDownTimer:TriggerTimer;
		private var lookUpTimer:TriggerTimer;
		private var lookTween:NumTween;
		
		public function Normal() 
		{
			lookTween = new NumTween();
			lookDownTimer = new TriggerTimer(1, lookDown);
			lookUpTimer = new TriggerTimer(1, lookUp);
		}
		
		/* INTERFACE com.cambrianman.monsters.IMovementState */
		
		public function initialize(props:Object):void
		{
			this.player = props.player;
			sprite = player.graphic as Spritemap;
		}
		
		public function update(keys:Object):Class
		{
			if (lookTween.active)
			{
				lookTween.update();
				player.cameraOffset = lookTween.value;
			}
				

			moveSides(keys);
			
			var _ic:Class = handleInteract(keys);
			
			if (_ic)
				return _ic;
			
			handleAnimation(keys);

			if (player.onGround) 
			{
				if (Input.check(keys.up))
					lookUpTimer.check(true);
				else if (Input.check(keys.down))
					lookDownTimer.check(true);
				else
				{
					lookUpTimer.check(false);
					lookDownTimer.check(false);
					lookNormal();
				}
					
				
				
				if (Input.pressed(keys.jump))
					return Jumping;
			}
			
			return Normal;
		}
		
		public function enter():void
		{
			player.maxSpeed.x = 2.25;
			player.maxSpeed.y = 8;
			
			player.drag.x = 0.3;
			
			player.acceleration.y = 0.2;
		}
		
		public function exit():void
		{
			
		}
		
		private function lookUp():void
		{
			lookTween.tween(player.cameraOffset, -80, 0.4);
			lookTween.start();
		}
		
		private function lookDown():void
		{
			lookTween.tween(player.cameraOffset, 80, 0.4);
			lookTween.start();
		}
		
		private function lookNormal():void
		{
			lookTween.active = false;
			player.cameraOffset = 0;
		}
		
		protected function handleAnimation(keys:Object):void
		{
			if (player.facing == Mobile.LEFT)
				sprite.flipped = true;
			else sprite.flipped = false;
			
			if (Math.abs(player.speed.x) > 0.5)
				sprite.play("hop");
			else
				sprite.play("idle");
				
						
			if (!player.onGround)
			{
				if (player.speed.y <= 0)
					sprite.play("rise");
				else if (player.speed.y > 0)
					sprite.play("fall");
			}
			
		}
		
		protected function handleInteract(keys:Object):Class
		{
			if (Input.pressed(keys.interact))
			{
				if (player.held)
					(player.held as Item).toss();
				else
				{
					var i:Entity = player.collide("item", player.x, player.y);
					if (i)
						(i as Item).grab();
						
					var m:Entity = player.collideTypes(["monster", "backgroundMonster"], player.x, player.y);
					if (m && !player.held)
					{
						if (m is Balloon && (m as Monster).state == Monster.FIRE)
						{
							player.clinging = m as Monster;
							return Clinging;
						}
					}
				}
			}
			
			return null;
		}
		
		protected function moveSides(keys:Object):void
		{
			if (Input.check(keys.left))
			{
				if (Input.pressed(keys.left))
					player.speed.x = 0;
				
				player.acceleration.x = -0.5;

				player.facing = Mobile.LEFT;
			}
			else if (Input.check(keys.right)) 
			{
				if (Input.pressed(keys.right))
					player.speed.x = 0;
					
				player.acceleration.x = 0.5;
				player.facing = Mobile.RIGHT;
			}
			else
			{
				player.acceleration.x = 0;
			}
		}
		
		public function getClass():Class
		{
			return Normal;
		}
	}

}