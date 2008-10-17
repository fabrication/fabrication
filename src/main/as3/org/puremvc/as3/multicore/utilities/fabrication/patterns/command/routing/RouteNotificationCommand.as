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
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IModuleAddress;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IRouter;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IRouterAwareModule;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IRouterMessage;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.SimpleFabricationCommand;
	import org.puremvc.as3.multicore.utilities.fabrication.routing.RouterMessage;
	import org.puremvc.as3.multicore.utilities.pipes.messages.Message;	

	/**
	 * RouteNotificationCommand transmit the source notification to route
	 * in a router message and sends across using the current application's
	 * router object.
	 * 
	 * @author Darshan Sawardekar
	 */
	public class RouteNotificationCommand extends SimpleFabricationCommand {

		/**
		 * Extracts the wrapped source notification from the body of the
		 * main notification and attaches it to a router message object.
		 * If a destination is not provided the default route destination
		 * for the current module is used. The message is then routed to
		 * the destination module via the application's router object.
		 * 
		 * @see org.puremvc.as3.multicore.interfaces.ICommand#execute()
		 */
		override public function execute(note:INotification):void {
			var moduleAddress:IModuleAddress = fabrication.moduleAddress;
			var router:IRouter = fabrication.router;
			
			var wrapper:Object = note.getBody();
			var noteName:String = wrapper.noteName;
			var noteType:String = wrapper.noteType;
			var noteBody:Object = wrapper.noteBody;
			
			var message:IRouterMessage = new RouterMessage(Message.NORMAL);
			var to:String = wrapper.to;
			
			if (to == null) {
				to = fabrication.defaultRoute;
				
				if (to == null) {
					to = "*";
				}
			}
			
			//trace("Sending message " + noteName + ", from=" + moduleAddress.getOutputName() + ", to=" + to);
			message.setFrom(moduleAddress.getOutputName());
			message.setTo(to);
			
			message.setBody(wrapper.noteBody);
			message.setHeader({
				noteName : noteName,
				noteType : noteType
			});
			
			router.route(message);
		}	
		
	}
}
