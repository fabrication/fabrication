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
 
package org.puremvc.as3.multicore.utilities.fabrication.routing {
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IRouterMessage;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.observer.TransportNotification;
	import org.puremvc.as3.multicore.utilities.pipes.messages.Message;		

	/**
	 * RouterMessage is the object used to send messages between modules
	 *  
	 * @author Darshan Sawardekar
	 */
	public class RouterMessage extends Message implements IRouterMessage {

		/**
		 * Stores the source module address
		 * @private
		 */
		private var from:String;

		/**
		 * Stores the target module address
		 * @private
		 */
		private var to:String;
		
		/**
		 * Stores the source notification object that triggered this message
		 * @private
		 */
		private var notification:TransportNotification;

		/**
		 * Creates a new RouterMessage object.
		 */
		public function RouterMessage(type:String, body:Object = null, from:String = null, to:String = null, notification:TransportNotification = null) {
			super(type, null, body);
			
			setFrom(from);
			setTo(to);
			setNotification(notification);
		}

		/**
         * @inheritDoc
         */
		public function dispose():void {
			setFrom(null);
			setTo(null);
			
			setBody(null);
			setType(null);
			setHeader(null);
		}

		/**
         * @inheritDoc
         */
		public function getFrom():String {
			return from;
		}

		/**
         * @inheritDoc
         */
		public function setFrom(from:String):void {
			this.from = from;
		}

		/**
         * @inheritDoc
         */
		public function getTo():String {
			return to;
		}

		/**
         * @inheritDoc
         */
		public function setTo(to:String):void {
			this.to = to;
		}
		
		/**
         * @inheritDoc
         */
		public function getNotification():TransportNotification {
			return notification;
		}
		
		/**
         * @inheritDoc
         */
		public function setNotification(notification:TransportNotification):void {
			this.notification = notification;
		}
	}
}
