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
	import net.flashpunk.Sfx;
	
	/**
	 * Normal movement state, when the player is on the ground.
	 * @author Evan Furchtgott
	 */
	public class Normal implements IMovementState 
	{
		[Embed(source = "../audio/pickup.mp3")] private const SNDPICKUP:Class;
		[Embed(source = "../audio/throw.mp3")] private const SNDTHROW:Class;
		
		private var pickup:Sfx;
		private var throwSound:Sfx;
		
		protected var player:Player;
		protected var sprite:PlayerGraphic;
		
		private var lookDownTimer:TriggerTimer;
		private var lookUpTimer:TriggerTimer;
		private var lookTween:NumTween;
		
		private var pushTimer:TriggerTimer;
		private var playerPushing:Boolean = false;
		
		public function Normal() 
		{
			lookTween = new NumTween();
			lookDownTimer = new TriggerTimer(1, lookDown);
			lookUpTimer = new TriggerTimer(1, lookUp);
			
			pushTimer = new TriggerTimer(0.25, push, unpush);
			
			pickup = new Sfx(SNDPICKUP);
			pickup.type = "effects";
			throwSound = new Sfx(SNDTHROW);
			throwSound.type = "effects";
		}
		
		/* INTERFACE com.cambrianman.monsters.IMovementState */
		
		public function initialize(props:Object):void
		{
			this.player = props.player;
			sprite = player.graphic as PlayerGraphic;
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
				
				pushTimer.check(checkPushing(keys));
				
				if (playerPushing)
					return Pushing;
				
				if (Input.pressed(keys.jump))
					return Jumping;
			}
			
			var _g:Entity = checkGrip();
			if (_g)
			{
				player.clinging = _g;
				
				if (player.held)
				{
					player.held.toss(Mobile.DOWN);
				}
				
				return Clinging;
			}
				
			return Normal;
		}
		
		public function enter():void
		{
			player.maxSpeed.x = 2.25;
			player.maxSpeed.y = 6.5;
			
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
		
		protected function checkGrip():Entity
		{
			if (player.clinging)
			{
				return null;
			}
				
			var m:Entity = player.collide("grip", player.x, player.y);

			return m;
		}
		
		/**
		 * Checks that we are still holding the key down to push in the right direction.
		 * @param	keys
		 * @return
		 */
		private function checkPushing(keys:Object):Boolean
		{
			if (player.pushing == null)
				return false;
				
			if (player.facing == Mobile.RIGHT)
			{
				if (Input.released(keys.right) || !Input.check(keys.right))
					return false;
				else if (player.x > player.pushing.x)
					return false;
				else
					return true;
			}
			else if (player.facing == Mobile.LEFT)
			{
				if (Input.released(keys.left) || !Input.check(keys.left))
					return false;
				else if (player.x < player.pushing.x)
					return false;
				else
					return true;
			}
			
			return false;
		}
		
		private function push():void
		{
			playerPushing = true;
		}
		
		private function unpush():void
		{
			playerPushing = false;
		}
		
		protected function handleAnimation(keys:Object):void
		{
			if (player.facing == Mobile.LEFT)
				sprite.flipped = true;
			else 
				sprite.flipped = false;
			
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
				{
					if (Input.check(keys.up))
						(player.held as Item).toss(Mobile.UP);
					else if (Input.check(keys.down))
						(player.held as Item).toss(Mobile.DOWN);
					else if (player.facing == Mobile.LEFT)
						(player.held as Item).toss(Mobile.LEFT);
					else if (player.facing == Mobile.RIGHT)
						(player.held as Item).toss(Mobile.RIGHT);
						
					sprite.holding = false;
					throwSound.play();
				}
				else
				{
					var i:Entity = player.collide("item", player.x, player.y);
					if (i)
					{
						(i as Item).grab();
						sprite.holding = true;
						pickup.play();
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