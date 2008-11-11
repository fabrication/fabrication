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
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.observer.TransportNotification;
	import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeMessage;			

	/**
	 * An interface to describe a message sent from a module to another
	 * via the fabrication router. 
	 * 
	 * @author Darshan Sawardekar
	 */
	public interface IRouterMessage extends IPipeMessage, IDisposable {

		/**
		 * Returns the module that is sending this message.
		 */
		function getFrom():String;

		/**
		 * Changes the module that is sending this message.
		 */
		function setFrom(from:String):void;

		/**
		 * Returns the module that will receive this message.  
		 */
		function getTo():String;

		/**
		 * Changes the module that will receive this message.
		 */
		function setTo(to:String):void;

		/**
		 * Saves the source notification that triggered this message.
		 */
		function setNotification(notification:TransportNotification):void;

		/**
		 * Returns the source notification that triggered this message. 
		 */
		function getNotification():TransportNotification;
	}
}
