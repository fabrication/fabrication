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
	import org.puremvc.as3.multicore.interfaces.INotification;	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IModuleAddress;	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IRouter;	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IRouterAwareModule;	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IRouterMessage;	import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.SimpleFabricationCommand;	import org.puremvc.as3.multicore.utilities.fabrication.patterns.observer.TransportNotification;	import org.puremvc.as3.multicore.utilities.fabrication.plumbing.DynamicJunction;	import org.puremvc.as3.multicore.utilities.fabrication.routing.RouterMessage;	import org.puremvc.as3.multicore.utilities.fabrication.vo.ModuleAddress;	import org.puremvc.as3.multicore.utilities.pipes.messages.Message;		/**
	 * RouteNotificationCommand transmit the source notification to route
	 * in a router message and sends across using the current application's
	 * router object.
	 * 
	 * @author Darshan Sawardekar
	 */
	public class RouteNotificationCommand extends SimpleFabricationCommand {

		/**
		 * Regular expression used to match a Module/* route
		 */
		static public const allInstanceRegExp:RegExp = new RegExp(".*\/\\*", "");
		
		/**
		 * Regular expression used to match a Module/# route
		 */
		static public const unqualifiedGroupRegExp:RegExp = new RegExp("^.*/#$", ""); 

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
			var transport:TransportNotification = note.getBody() as TransportNotification;
			var to:Object = transport.getTo();
			var toStr:String = to as String;
			var message:IRouterMessage = new RouterMessage(Message.NORMAL);
			
			if (to == null) {
				to = fabrication.defaultRoute;
				
				if (to == null) {
					to = "*";
				}
			} else if (
					to is String && 
					toStr != "*" && 
					!allInstanceRegExp.test(toStr) && 
					!ModuleAddress.inputSuffixRegExp.test(toStr) &&
					!DynamicJunction.MODULE_GROUP_REGEXP.test(toStr)
				) {
				if (unqualifiedGroupRegExp.test(toStr) && fabrication.moduleGroup != null) {
					to = toStr + fabrication.moduleGroup;
				} else {
					to = toStr + ModuleAddress.INPUT_SUFFIX;
				}
			} else if (to is IModuleAddress) {
				to = (to as IModuleAddress).getInputName();
			}
			
			message.setFrom(moduleAddress.getOutputName());
			message.setTo(to as String);
			message.setNotification(transport);
			
			router.route(message);
		}	
	}
}
