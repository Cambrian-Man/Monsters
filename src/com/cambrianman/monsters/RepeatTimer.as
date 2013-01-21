package com.cambrianman.monsters 
{
	import net.flashpunk.FP;
	/**
	 * Timer which calls a function repeatedly as it is updated.
	 * @author Evan Furchtgott
	 */
	public class RepeatTimer 
	{
		public var delay:Number;
		public var callback:Function;
		public var callbackProps:Object;
		
		private var remaining:Number;
		
		// TODO: Maybe make this a tweener subclass.
		public function RepeatTimer(delay:Number, callback:Function, callbackProps:Object=null) 
		{
			this.delay = delay;
			remaining = delay;
			this.callback = callback;
			this.callbackProps = callbackProps;
		}
		
		public function update():void
		{
			remaining -= FP.elapsed;
			
			if (remaining <= 0)
			{
				if (callbackProps)
					callback(callbackProps);
				else
					callback();
					
				remaining = delay;
			}
		}
	}

}