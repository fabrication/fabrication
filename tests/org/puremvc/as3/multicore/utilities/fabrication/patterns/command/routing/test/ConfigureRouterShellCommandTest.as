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
 
package org.puremvc.as3.multicore.utilities.fabrication.patterns.command.routing.test {
    import org.puremvc.as3.multicore.interfaces.ICommand;
    import org.puremvc.as3.multicore.interfaces.INotification;
    import org.puremvc.as3.multicore.patterns.observer.Notification;
    import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IRouter;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.SimpleFabricationCommand;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.routing.*;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.test.AbstractFabricationCommandTest;
    import org.puremvc.as3.multicore.utilities.fabrication.routing.firewall.MultiRuleFirewall;
    import org.puremvc.as3.multicore.utilities.fabrication.routing.mock.RouterMock;

    /**
	 * @author Darshan Sawardekar
	 */
	public class ConfigureRouterShellCommandTest extends AbstractFabricationCommandTest {
		
		
		override public function createCommand():ICommand {
			return new ConfigureRouterShellCommand();
		}

        [Test]
		public function configureRouterShellCommandHasValidType():void {
			assertType(ConfigureRouterShellCommand, command);
			assertType(SimpleFabricationCommand, command);
		}

        [Test]
		public function configureRouterShellCommandCreatesRouterWithFirewallAndConfiguresDefaultRouteToAll():void {
			var router:RouterMock = new RouterMock();

			facade.mock.method("getFabrication").withNoArgs.returns(fabrication).atLeast(1);
			facade.mock.method("executeCommandClass").withArgs(ConfigureRouterCommand, router, nullarg).once;
			fabrication.mock.property("router").withArgs(IRouter).atLeast(1);
			fabrication.mock.property("router").returns(router).atLeast(1);
			router.mock.method("install").withArgs(MultiRuleFirewall).once;
			fabrication.mock.property("defaultRoute").withArgs("*").atLeast(1);

			executeCommand();

			verifyMock(facade.mock);
			verifyMock(fabrication.mock);
			verifyMock(router.mock);
		}

		override public function createNotification():INotification {
			return new Notification("x");
		}


	}
}
