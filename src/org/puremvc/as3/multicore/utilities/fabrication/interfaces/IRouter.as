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
	 * An interface that describes the capabilities of a fabrication 
	 * router object. IRouter is used to send messages between
	 * different modules.
	 * 
	 * @author Darshan Sawardekar
	 */
	public interface IRouter extends IDisposable {

		/**
		 * Connects the router cable to the router. The router
		 * cable describes the input and output pipe names of the module.
		 * These are used to connect to the junction.
		 * 
		 * @param cable The router cable for the module to connect
		 */
		function connect(cable:IRouterCable):void;

		/**
		 * Disconnects the router cable from the router. The router cable
		 * need not be the same object but must have the same input and
		 * output names.
		 */
		function disconnect(cable:IRouterCable):void;

		/**
		 * Sends the message from the specified module to the target
		 * as described in the router message
		 * 
		 * @param message The details of the message to send
		 */
		function route(message:IRouterMessage):void;

		/**
		 * Installs a firewall on the router. Firewalls are used to limit
		 * communication between different modules.
		 */
		function install(firewall:IRouterFirewall):void;
	}
}
