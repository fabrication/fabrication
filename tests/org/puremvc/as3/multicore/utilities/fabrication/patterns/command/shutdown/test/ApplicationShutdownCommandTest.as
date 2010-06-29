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

package org.puremvc.as3.multicore.utilities.fabrication.patterns.command.shutdown.test {
    import org.puremvc.as3.multicore.interfaces.ICommand;
    import org.puremvc.as3.multicore.interfaces.INotification;
    import org.puremvc.as3.multicore.patterns.observer.Notification;
    import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IRouter;
    import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IRouterCable;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.routing.ConfigureRouterCommand;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.shutdown.*;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.test.AbstractFabricationCommandTest;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.observer.FabricationNotification;
    import org.puremvc.as3.multicore.utilities.fabrication.routing.mock.RouterCableListenerMock;
    import org.puremvc.as3.multicore.utilities.fabrication.routing.mock.RouterMock;
    import org.puremvc.as3.multicore.utilities.fabrication.vo.ModuleAddress;

    /**
     * @author Darshan Sawardekar
     */
    public class ApplicationShutdownCommandTest extends AbstractFabricationCommandTest {


        private var router:RouterMock;

        [Test]
        public function applicationShutdownCommandHasValidType():void
        {
            assertType(ApplicationShutdownCommand, command);
        }

        [Test]
        public function applicationShutdownCommandRemovesCableListenerAndDisconnectsFromRouter():void
        {
            var cableListener:RouterCableListenerMock = new RouterCableListenerMock(facade);
            cableListener.mock.method("dispose").withNoArgs.once;
            facade.mock.method("removeInstance").withArgs(ConfigureRouterCommand.routerCableListenerKey).returns(cableListener).once;
            router.mock.method("disconnect").withArgs(IRouterCable);

            executeCommand();

            verifyMock(cableListener.mock);
            verifyMock(facade.mock);
            verifyMock(router.mock);
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
            fabrication.mock.property("moduleAddress").returns(new ModuleAddress("X", "X0"));
        }

        override public function createCommand():ICommand
        {
            return new ApplicationShutdownCommand();
        }

        override public function createNotification():INotification
        {
            return new Notification(FabricationNotification.SHUTDOWN);
        }


    }
}
