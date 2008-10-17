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
 
package org.puremvc.as3.multicore.utilities.fabrication.patterns.command.startup {
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.SimpleFabricationCommand;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.routing.ConfigureRouterShellCommand;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.routing.RouteMessageCommand;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.routing.RouteNotificationCommand;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.observer.RouterNotification;	

	/**
	 * ApplicationStartupCommand registers fabrication system specific
	 * commands with the facade and configures the main application router. 
	 * 
	 * @author Darshan Sawardekar
	 */
	public class ApplicationStartupCommand extends SimpleFabricationCommand {
		
		/**
		 * Creates the application router object using a subcommand and 
		 * registers commands to allow the application to interpret messages
		 * from the application router
		 * 
		 * @see org.puremvc.as3.multicore.interfaces.ICommand#execute()
		 */
		override public function execute(note:INotification):void {
			registerCommand(RouterNotification.RECEIVED_MESSAGE_VIA_ROUTER, RouteMessageCommand);
			registerCommand(RouterNotification.SEND_MESSAGE_VIA_ROUTER, RouteNotificationCommand);
			
			executeCommand(ConfigureRouterShellCommand, null, note);
		}
		 
	}
}
