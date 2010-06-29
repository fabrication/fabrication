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
    import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IRouterCable;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.SimpleFabricationCommand;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.routing.*;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.test.AbstractFabricationCommandTest;
    import org.puremvc.as3.multicore.utilities.fabrication.routing.RouterCableListener;
    import org.puremvc.as3.multicore.utilities.fabrication.routing.mock.RouterMock;
    import org.puremvc.as3.multicore.utilities.fabrication.vo.ModuleAddress;

    /**
	 * @author Darshan Sawardekar
	 */
	public class ConfigureRouterCommandTest extends AbstractFabricationCommandTest {
		
		public var router:RouterMock;

        [Before]
		override public function setUp():void {
            router = new RouterMock();
            super.setUp();
        }

        [Test]
		public function configureRouterCommandHasValidType():void {
            
			assertType(ConfigureRouterCommand, command);
			assertType(SimpleFabricationCommand, command);
		}

        [Test]
		public function configureRouterCommandConnectsToRouterAndSavesCableListener():void {
			facade.mock.method("getFabrication").withNoArgs.returns(fabrication).atLeast(1);
			fabrication.mock.property("moduleAddress").returns(new ModuleAddress("X", "X0")).atLeast(1);
			fabrication.mock.property("moduleGroup").returns("myGroup");
			facade.mock.method("saveInstance").withArgs(String, RouterCableListener).once;
			router.mock.method("connect").withArgs(
				function(cable:IRouterCable):Boolean {
					return cable.getOutput().moduleGroup == "myGroup";
				}
			).once;

			executeCommand();

			verifyMock(facade.mock);
			verifyMock(fabrication.mock);
			verifyMock(router.mock);
		}
		
		override public function createCommand():ICommand {
			return new ConfigureRouterCommand();
		}
		
		override public function createNotification():INotification {
			return new Notification(null, router);
		}


	}
}
