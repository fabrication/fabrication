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
 
package org.puremvc.as3.multicore.utilities.fabrication.routing.firewall {
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IFirewallRule;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IRouterMessage;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.observer.FabricationNotification;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.observer.RouterNotification;	

	/**
	 * ReservedNotificationRule is a firewall rule to drop system notifications
	 * from a module from being routed to another module.
	 * 
	 * @author Darshan Sawardekar
	 */
	public class ReservedNotificationRule implements IFirewallRule {
		
		/**
		 * Stores the system notification names to drop.
		 */
		protected var reservedNotifications:Array;
		
		/**
		 * Creates a new ReserverNotificationRule object.
		 */
		public function ReservedNotificationRule() {
			this.reservedNotifications = new Array();
			
			addNotification(
				RouterNotification.SEND_MESSAGE_VIA_ROUTER, 
				RouterNotification.RECEIVED_MESSAGE_VIA_ROUTER, 
				FabricationNotification.STARTUP,
				FabricationNotification.SHUTDOWN,
				FabricationNotification.BOOTSTRAP,
				FabricationNotification.UNDO,
				FabricationNotification.REDO
			);
		}

		/**
		 * @see org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable#dispose()
		 */
		public function dispose():void {
			this.reservedNotifications.splice(0);
			this.reservedNotifications = null;
		}

		/**
		 * Adds the notifications names specified to the reserved notification
		 * store.
		 * 
		 * @param args Notification names to add. 
		 */
		public function addNotification(...args):void {
			var n:int = args.length;
			for (var i:int = 0; i < n; i++) {
				reservedNotifications.push(args[i]);
			}
		}
		
		/**
		 * Removes the specified notification names from the reserved
		 * notifications store.
		 * 
		 * @param args Notification names to removed. 
		 */
		public function removeNotification(...args):void {
			var n:int = args.length;
			var index:int;
			var note:String;
			for (var i:int = 0; i < n; i++) {
				note = args[i];
				index = findNoteIndex(note);
				if (index >= 0) {
					reservedNotifications.splice(index, 1);
				}
			}
		}
		
		/**
		 * Returns a boolean indicating if the notification is already reserved.
		 * 
		 * @param notification The notification to test.
		 */
		public function hasNotification(notification:String):Boolean {
			return findNoteIndex(notification) >= 0;
		}
		
		/**
		 * @see IFirewallRule#process
		 */
		public function process(notification:String, from:String, to:String, message:IRouterMessage):Boolean {
			return !hasNotification(notification);
		}
		
		/**
		 * Helper to get the index of a specific notification in the list
		 */
		private function findNoteIndex(note:String):int {
			var n:int = reservedNotifications.length;
			var noteItem:String;
			for (var i:int = 0; i < n; i++) {
				noteItem = reservedNotifications[i];
				if (noteItem == note) {
					return i;
				}
			}
			
			return -1;
		}
	}
}
