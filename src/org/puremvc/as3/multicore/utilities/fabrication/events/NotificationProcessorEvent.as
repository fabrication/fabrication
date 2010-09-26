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

package org.puremvc.as3.multicore.utilities.fabrication.events {
	import flash.events.Event;

	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;		

	/**
	 * The NotificationProcessorEvent represents events objects related to the
	 * processing of events by interceptors.
	 * 
	 * @author Darshan Sawardekar
	 */
	public class NotificationProcessorEvent extends Event implements IDisposable {

		/**
		 * Dispatched when an intercepted notification was allowed to proceed forward.
		 */
		static public const PROCEED:String = "proceed";

		/**
		 * Dispatched when an intercepted notification was aborted by an interceptor.
		 */
		static public const ABORT:String = "abort";

		/**
		 * Dispatched when all interceptors have completed execution. The notification
		 * processor is disposed after this.
		 */
		static public const FINISH:String = "skip";

		/**
		 * Optional notification object used with the proceed event type.
		 */
		public var notification:INotification;

		/**
		 * Creates a new notification processor event object.
		 * 
		 * @param type The type name of the current event.
		 * @param processor The notification processor that send this event.
		 */
		public function NotificationProcessorEvent(type:String, notification:INotification = null) {
			super(type);
			
			this.notification = notification;
		}

		/**
         * @inheritDoc
         */
		public function dispose():void {
			notification = null;
		}
	}
}
