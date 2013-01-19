package com.cambrianman.monsters 
{
	import com.cambrianman.monsters.items.Item;
	import com.cambrianman.monsters.monsters.Monster;
	import flash.display.Graphics;
	import flash.geom.Point;
	import flash.net.getClassByAlias;
	import flash.utils.getQualifiedClassName;
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.Mask;
	import net.flashpunk.masks.Hitbox;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.FP;
	import com.cambrianman.monsters.movementStates.*;
	
	/**
	 * Player base class.
	 * @author Evan Furchtgott
	 */
	public class Player extends Mobile 
	{
		[Embed(source = "gfx/player.png")] private const PLAYER:Class;
		
		// The player's current movement state.
		private var movementState:IMovementState;
		
		// An array of valid movement state classes.
		private var movementClasses:Array = [Normal, Jumping, Clinging, Pushing];
		private var movementStates:Object = { };
		
		// A hash of integers representing the current control keys.
		// left, right, up, down
		// jump, interact
		private var controlKeys:Object = { };
		
		private var speedX:Number = 0;
		
		public var onGround:Boolean;
		
		public var facing:int = Mobile.RIGHT;
		
		public var held:Item;
		
		public var clinging:Monster;
		
		public var pushing:Mobile;
		
		public var cameraOffset:Number = 0;
		
		/**
		 * Constructor
		 * @param	level	Pass in a level reference, for convenience.
		 */
		public function Player(level:Level) 
		{	
			var spritemap:Spritemap = new Spritemap(PLAYER, 32, 32);
			
			spritemap.add("idle", [0]);
			spritemap.add("hop", [1, 2, 3, 4, 5], 12);
			spritemap.add("rise", [6]);
			spritemap.add("fall", [7]);
			
			super(level, 0, 0, spritemap);
			
			// Set up default keys.
			controlKeys.left = Key.LEFT;
			controlKeys.right = Key.RIGHT;
			controlKeys.up = Key.UP;
			controlKeys.down = Key.DOWN;
			controlKeys.interact = Key.C;
			controlKeys.jump = Key.X;
			
			// Instantiates the movement classes.
			for each (var s:Class in movementClasses) 
			{
				movementStates[getQualifiedClassName(s)] = new s();
				movementStates[getQualifiedClassName(s)].initialize({player: this});
			}
			
			setMovementStateByName("Normal");
				
			type = "player";
			mask = new Hitbox(18, 28, 6, 4);
			
			collidables = ["ground", "monster"];
		}
		
		override public function update():void {
			super.update();
			
			// Check if we're on the ground, or at least on a collidable object.
			if (collideTypes(collidables, x, y + 1))
				onGround = true;
			else
				onGround = false;
			
			// Update our movement state
			var s:Class = movementState.update(controlKeys);
			
			// Transition to a new state if we've gotten one.
			if (!(movementState.getClass() == s))
			{
				movementState.exit();
				setMovementStateByClass(s);
			}
			
			// If we're not facing the thing we're pushing, we can't be pushing.
			if (pushing)
			{
				if (facing == RIGHT && x > pushing.x)
					pushing = null;
				else if (facing == LEFT && x < pushing.x)
					pushing = null;
			}
		}
		
		/**
		 * Set movement state using a string.
		 * @param	name	The unqualified name of a movement class.
		 */
		public function setMovementStateByName(name:String):void {
			name = "com.cambrianman.monsters.movementStates::" + name;
			if (movementStates[name]) {
				movementState = movementStates[name];
				movementState.enter();
			}
			else {
				throw(new ArgumentError("No movement state " + name + " found"));
			}
		}
		
		
		/**
		 * Set the movement state using a class reference.
		 * @param	state	A reference to the class object.
		 */
		public function setMovementStateByClass(state:Class):void {
			for each (var o:Object in movementStates) {
				if (o.getClass() === state) {
					movementState = o as IMovementState;
					movementState.enter();
				}
			}
		}
		
		// Override
		override public function moveCollideX(e:Entity):Boolean
		{			
			// Check to see if we've bumped into something pushable.
			if (e is Mobile && (e as Mobile).pushable)
			{
				if (facing == RIGHT && e.x > x)
					pushing = (e as Mobile);
				else if (facing == LEFT && e.x < x)
					pushing = (e as Mobile);
				else
					pushing = null;
			}
			else
				pushing = null;
			super.moveCollideX(e);
			return true;
		}
	}

}