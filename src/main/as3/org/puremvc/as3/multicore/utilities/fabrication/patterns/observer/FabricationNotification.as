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
	
	/**
	 * Notification object used to send fabrication system notifications.
	 * 
	 * @author Darshan Sawardekar
	 */
	public class FabricationNotification extends Notification {

		/**
		 * Application startup notification
		 */
		static public const STARTUP:String = "startup";
		
		/**
		 * Application shutdown notification
		 */
		static public const SHUTDOWN:String = "shutdown";
		
		/**
		 * Application bootstrap notification. Notified immediately after
		 * the startup notification. It can be used to break the startup
		 * commands into Proxy, Mediator etc creation and an optional
		 * configuration load(from xml) etc stage. 
		 */
		static public const BOOTSTRAP:String = "bootstrap";
		
		/**
		 * Undo's the last command executed.
		 */
		static public const UNDO:String = "undo";
		
		/**
		 * Redo's the last command undone.
		 */
		static public const REDO:String = "redo";

		/**
		 * Creates a new FabricationNotification object.
		 */
		public function FabricationNotification(name:String, body:Object = null, type:String = null) {
			super(name, body, type);
		}
		
		/**
		 * Returns the number of steps to undo. Default is 1.
		 */
		public function steps():int {
			return getBody() as int;
		}
		
	}
}
