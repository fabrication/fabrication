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
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.observer.Notification;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IModuleAddress;	

	/**
	 * Notification object used to transport a notification message to the current
	 * application router. This notification holds the details of the 
	 * source notification and the destination address.
	 * 
	 * @author Darshan Sawardekar
	 */
	public class TransportNotification extends Notification implements IDisposable {

		/**
		 * The destination address of this notification. This must be any the 
		 * different module address declarations like, A/*, A/A0/INPUT, and *.
		 */
		protected var to:Object;
		
		/**
		 * Stores the custom typed notification to transport. 
		 */
		protected var customNotification:INotification;
		
		/**
		 * Creates a new TransportNotification object.
		 */
		public function TransportNotification(noteName:Object, noteBody:Object = null, noteType:String = null, to:Object = null):void {
			super(calcNoteName(noteName), noteBody, noteType);
			
			if (customNotification == null) {
				this.to = to;
			} else if (customNotification != null && to != null) {
				this.to = to;
			} else if (to == null && (noteBody is IModuleAddress || noteBody is String)){
				this.to = noteBody;
				setBody(null);
			}
		}
		
		/**
		 * Calculates the note name from the custom notification and saves it to the transport.
		 */
		protected function calcNoteName(noteName:Object):String {
			if (noteName is String) {
				return noteName as String;
			} else {
				customNotification = noteName as INotification;
				return customNotification.getName();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function dispose():void {
			customNotification = null;
			setBody(null);
			setType(null);
			setTo(null);
		}

		/**
		 * Returns the current destination module address.
		 */
		public function getTo():Object {
			return to;
		}
		
		/**
		 * Changes the current destination module address.
		 */
		public function setTo(to:Object):void {
			this.to = to;
		}
		
		/**
		 * Returns the custom notification name if any specified on the notification
		 */
		public function getCustomNotification():INotification {
			return customNotification;
		}
		
	}
}
