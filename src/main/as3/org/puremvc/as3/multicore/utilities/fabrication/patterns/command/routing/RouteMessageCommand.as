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
 
package org.puremvc.as3.multicore.utilities.fabrication.patterns.command.routing {
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IRouterMessageStore;	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IRouterMessage;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.SimpleFabricationCommand;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.observer.RouterNotification;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.observer.TransportNotification;	

	/**
	 * RouteMessageCommand translates an inter-module message into a
	 * system notification in the destination module. 
	 * 
	 * @author Darshan Sawardekar
	 */
	public class RouteMessageCommand extends SimpleFabricationCommand {

		/**
		 * Fetches the notification object carried by the router message
		 * and sends it as a system notification within this module.
		 */
		override public function execute(note:INotification):void {
			var routerNote:RouterNotification = note as RouterNotification;
			var message:IRouterMessage = routerNote.getMessage();
			var transport:TransportNotification = message.getNotification();
			var customNotification:INotification = transport.getCustomNotification();
			var notificationToSend:INotification;
			
			if (customNotification == null) {
				notificationToSend = new RouterNotification(
					transport.getName(),
					transport.getBody(),
					transport.getType(),
					message
				);
			} else {
				notificationToSend = customNotification;
				if (notificationToSend is IRouterMessageStore) {
					(notificationToSend as IRouterMessageStore).setMessage(message);
				}
			}
			
			fabFacade.notifyObservers(notificationToSend);
		}
	}
}
