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
 
package org.puremvc.as3.multicore.utilities.fabrication.events {
	import flash.events.Event;
	
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IRouterMessage;		

	/**
	 * RouterFirewallEvent is the event object for events related to 
	 * router firewalls.
	 * 
	 * @author Darshan Sawardekar
	 */
	public class RouterFirewallEvent extends Event implements IDisposable {

		/**
		 * Dispatched when a message is allowed by the firewall. 
		 */
		static public const ALLOWED_MESSAGE:String = "allowedMessage";
		
		/**
		 * Dispatched when a message is blocked by the firewall
		 */
		static public const BLOCKED_MESSAGE:String = "blockedMessage";
		
		/**
		 * The message that was allowed or blocked
		 */
		public var message:IRouterMessage;
		
		public function RouterFirewallEvent(type:String, message:IRouterMessage) {
			super(type, false, false);
			
			this.message = message;
		}
		
		/**
         * @inheritDoc
         */
		public function dispose():void {
			this.message = null;
		}
		
	}
}
