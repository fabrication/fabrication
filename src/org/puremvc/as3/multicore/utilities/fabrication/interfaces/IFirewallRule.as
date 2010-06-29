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
 
package org.puremvc.as3.multicore.utilities.fabrication.interfaces {

	/**
	 * This interface indicates how a rules based firewall should 
	 * process notification messages sent via a router.   
	 * 
	 * @author Darshan Sawardekar
	 */
	public interface IFirewallRule extends IDisposable {

		/**
		 * Processes the routed notification message and returns a boolean
		 * indicating whether the message can be routed forward or dropped.
		 * 
		 * @param notification The name of the routed notification
		 * @param from The address of the sender of this message
		 * @param to The address of the receiver of this message
		 * @param message The entire message object   
		 */		
		function process(notification:String, from:String, to:String, message:IRouterMessage):Boolean;
		
	}
}
