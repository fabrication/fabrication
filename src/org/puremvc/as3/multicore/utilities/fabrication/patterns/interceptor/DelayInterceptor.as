/**
 * Copyright (C) 2009 Darshan Sawardekar.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.puremvc.as3.multicore.utilities.fabrication.patterns.interceptor {
	import flash.events.Event;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;		

	/**
	 * The DelayInterceptor is a concrete interceptor that converts synchronous
	 * notification into asynchronous notification using an enterFrame or
	 * timer based interval.
	 * 
	 * @author Darshan Sawardekar
	 */
	public class DelayInterceptor extends AbstractInterceptor {

		/**
		 * Indicates that a frame based delay should be used.
		 */
		static public const FRAME_DELAY:String = "frameDelay";

		/**
		 * Indicates that an enterFrame delay should be used.
		 */
		static public const TIMER_DELAY:String = "timerDelay";

		/**
		 * The interval id if applicable.
		 */
		protected var intervalID:int = -1;

		/**
		 * Intercepts the notification and starts the corresponding interval.
		 * Accepted parameter object values are,
		 * 
		 * <ul>
		 * 	<li>{type:FRAME_DELAY} - This is assumed if no parameters are specified.</li>
		 * 	<li>{waitFor:1000}</li>
		 * </ul> 
		 */
		override public function intercept():void {
			if (parameters == null || parameters.type == FRAME_DELAY) {
				fabrication.addEventListener(Event.ENTER_FRAME, proceedAfterDelay);
			} else if (!isNaN(parameters.waitFor)) {
				intervalID = setTimeout(proceedAfterDelay, parameters.waitFor, null);
			}
		}

		/**
		 * @inheritDoc;
		 */
		override public function dispose():void {
			if (intervalID >= 0) {
				clearTimeout(intervalID);				
			} else {
				fabrication.removeEventListener(Event.ENTER_FRAME, proceedAfterDelay);
			}
			
			super.dispose();
		}
		
		protected function proceedAfterDelay(event:Event):void {
			proceed();
		}
		
	}
}
