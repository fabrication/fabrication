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

package org.puremvc.as3.multicore.utilities.fabrication.patterns.command.startup.test {
    import org.puremvc.as3.multicore.interfaces.ICommand;
    import org.puremvc.as3.multicore.interfaces.INotification;
    import org.puremvc.as3.multicore.patterns.observer.Notification;
    import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IRouter;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.routing.ConfigureRouterCommand;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.routing.RouteMessageCommand;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.routing.RouteNotificationCommand;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.shutdown.ApplicationShutdownCommand;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.startup.*;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.test.AbstractFabricationCommandTest;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.observer.FabricationNotification;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.observer.RouterNotification;
    import org.puremvc.as3.multicore.utilities.fabrication.routing.mock.RouterMock;

    /**
     * @author Darshan Sawardekar
     */
    public class ModuleStartupCommandTest extends AbstractFabricationCommandTest {

        private var router:RouterMock;

        [Test]
        public function moduleStartupCommandHasValidType():void
        {
            assertType(ModuleStartupCommand, command);
        }

        [Test]
        public function moduleStartupCommandRegistersRoutingSystemNotificationsAndConnectsToRouter():void
        {
            facade.mock.method("registerCommand").withArgs(FabricationNotification.SHUTDOWN, ApplicationShutdownCommand);
            facade.mock.method("registerCommand").withArgs(RouterNotification.RECEIVED_MESSAGE_VIA_ROUTER, RouteMessageCommand);
            facade.mock.method("registerCommand").withArgs(RouterNotification.SEND_MESSAGE_VIA_ROUTER, RouteNotificationCommand);
            facade.mock.method("executeCommandClass").withArgs(ConfigureRouterCommand, router);

            executeCommand();

            verifyMock(facade.mock);
            verifyMock(fabrication.mock);
        }

        override public function initializeFacade():void
        {
            super.initializeFacade();
            facade.mock.method("getFabrication").withNoArgs.returns(fabrication).atLeast(1);
        }

        override public function initializeFabrication():void
        {
            super.initializeFabrication();

            if (router == null) {
                router = new RouterMock();
            }

            fabrication.mock.property("router").withArgs(IRouter);
            fabrication.mock.property("router").returns(router);
        }

        override public function createCommand():ICommand
        {
            return new ModuleStartupCommand();
        }

        override public function createNotification():INotification
        {
            return new Notification(FabricationNotification.STARTUP, fabrication);
        }


    }
}
