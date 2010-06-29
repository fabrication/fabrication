/**
 * Copyright (C) 2008 Darshan Sawardekar.
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
 
package org.puremvc.as3.multicore.utilities.fabrication.patterns.observer {
	import org.puremvc.as3.multicore.patterns.observer.Notification;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IRouterMessage;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IRouterMessageStore;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IRouterNotification;		

	/**
	 * Notification object to send routing specific notifications
	 * 
	 * @author Darshan Sawardekar
	 */
	public class RouterNotification extends Notification implements IRouterNotification, IRouterMessageStore, IDisposable {

		/**
		 * Notification name to send a message to another module via the 
		 * application router 
		 */
		static public const SEND_MESSAGE_VIA_ROUTER:String = "sendMessageViaRouter";

		/**
		 * Notification name to translate a message from the router into 
		 * a system notification
		 */
		static public const RECEIVED_MESSAGE_VIA_ROUTER:String = "receivedMessageViaRouter";

		/**
		 * Stores the source router message over which the notification was
		 * sent.
		 */
		protected var message:IRouterMessage;

		/**
		 * Creates a new router notification object.
		 * 
		 */
		public function RouterNotification(name:String, body:Object = null, type:String = null, message:IRouterMessage = null) {
			super(name, body, type);
			
			setMessage(message);
		}

		/**
		 * Returns the router message over which this notification was sent.
		 */
		public function getMessage():IRouterMessage {
			return message;
		}

		/**
		 * Changes the router message over which this notification was sent.
		 */
		public function setMessage(message:IRouterMessage):void {
			this.message = message;
		}

		/**
		 * @see org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable#dispose()
		 */
		public function dispose():void {
			setMessage(null);
			setBody(null);
			setType(null);
		}
	}
}
