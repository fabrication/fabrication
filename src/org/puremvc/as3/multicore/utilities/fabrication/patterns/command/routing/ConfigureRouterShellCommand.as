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
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IRouter;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IRouterAwareModule;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.SimpleFabricationCommand;
	import org.puremvc.as3.multicore.utilities.fabrication.routing.Router;
	import org.puremvc.as3.multicore.utilities.fabrication.routing.firewall.MultiRuleFirewall;
	import org.puremvc.as3.multicore.utilities.fabrication.routing.firewall.ReservedNotificationRule;	

	/**
	 * ConfigureRouterShellCommand creates and configures the router for 
	 * the main application/shell. A MultiRuleFirewall is installed
	 * on the router to prevent system notifications from being 
	 * routed. 
	 * 
	 * @author Darshan Sawardekar
	 */
	public class ConfigureRouterShellCommand extends SimpleFabricationCommand {

		/**
		 * Creates the application router and assigns a firewall to it.
		 * The defaultRoute is set to asterisk(*) to ensure that the
		 * shell can send messages to any module. 
		 * 
		 * @see org.puremvc.as3.multicore.interfaces.ICommand#execute()
		 */
		override public function execute(note:INotification):void {
			var firewall:MultiRuleFirewall = new MultiRuleFirewall();
			var reservedNotificationRule:ReservedNotificationRule = new ReservedNotificationRule();
			firewall.addRule(reservedNotificationRule);			
			
			fabrication.router = new Router();
			executeCommand(ConfigureRouterCommand, fabrication.router);
			fabrication.router.install(firewall);
			
			// shell sends to everyone by default
			fabrication.defaultRoute = "*";
		}
	}
}
