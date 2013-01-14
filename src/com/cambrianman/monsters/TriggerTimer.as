package com.cambrianman.monsters 
{
	import net.flashpunk.FP;
	/**
	 * Class that provides timers that trigger a function when they run down.
	 * @author Evan Furchtgott
	 */
	public class TriggerTimer 
	{
		// The amount of time before the trigger trips.
		private var delay:Number;
		
		// The callback called when the timer runs out.
		private var callback:Function;
		
		// An optional callback called if the timer untrips.
		private var unTrigger:Function;
		
		// Is this trigger running?
		public var isRunning:Boolean;
		
		// The amount of time remaining on the trigger.
		private var remaining:Number;
		
		/**
		 * Constructor
		 * @param	delay		Time in seconds until the trigger trips.
		 * @param	callback	Callback when the trigger trips.
		 * @param	unTrigger	Optional callback when the trigger resets.
		 */
		public function TriggerTimer(delay:Number, callback:Function, unTrigger:Function=null) 
		{
			this.delay = delay;
			this.callback = callback;
			this.unTrigger = unTrigger;
		}
		
		/**
		 * Should be called each frame to progress the timer.
		 * @param	eval	Boolean to check if the trigger should decrease.
		 */
		public function check(eval:Boolean):void
		{
			if (eval)
			{
				if (!isRunning)
				{
					isRunning = true;
					remaining = delay;
				}
				else
				{
					remaining -= FP.elapsed;
					if (remaining <= 0)
					{
						isRunning = false;
						callback();
					}
				}
				
			}
			else
			{
				isRunning = false;
				if (unTrigger != null)
					unTrigger();
			}
		}
		
	}

}