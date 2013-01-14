package com.cambrianman.monsters 
{
	
	/**
	 * ...
	 * @author Evan Furchtgott
	 */
	public interface IMovementState 
	{
		/**
		 * Called when the state is first initialized by the level.
		 * 
		 * @param	props	An object containing properties needed by the movement
		 * 					state. Right now, it's just a player reference.
		 */
		function initialize(props:Object):void;
		
		/**
		 * Called each frame to determine what state we should be in.
		 * @param	keys
		 * @return	The state that we should be in.
		 */
		function update(keys:Object):Class;
		
		/**
		 * Simply returns the class of the state. Mostly for convenience.
		 * @return
		 */
		function getClass():Class;
		
		/**
		 * Called when we transition into the state.
		 */
		function enter():void;
		
		/**
		 * Called when we leave the state.
		 */
		function exit():void;
	}
	
}