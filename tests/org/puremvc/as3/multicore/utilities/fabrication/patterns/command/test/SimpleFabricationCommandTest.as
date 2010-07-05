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
 
package org.puremvc.as3.multicore.utilities.fabrication.patterns.command.test {
    import mx.utils.UIDUtil;

    import org.puremvc.as3.multicore.interfaces.ICommand;
    import org.puremvc.as3.multicore.interfaces.IMediator;
    import org.puremvc.as3.multicore.interfaces.IProxy;
    import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
    import org.puremvc.as3.multicore.patterns.mediator.Mediator;
    import org.puremvc.as3.multicore.patterns.proxy.Proxy;
    import org.puremvc.as3.multicore.utilities.fabrication.interfaces.ICommandProcessor;
    import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.*;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.mock.SimpleFabricationCommandMock;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.mock.SimpleFabricationCommandTestMock;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.interceptor.mock.InterceptorMock;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.FabricationMediator;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.FlexMediator;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.mock.FlexMediatorTestMock;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.proxy.FabricationProxy;
    import org.puremvc.as3.multicore.utilities.fabrication.routing.mock.RouterMock;

    /**
	 * @author Darshan Sawardekar
	 */
	public class SimpleFabricationCommandTest extends AbstractFabricationCommandTest {
		

		override public function createCommand():ICommand {
			return new SimpleFabricationCommandTestMock();
		}

        [Test]
		public function simpleFabricationCommandHasValidType():void {
			assertType(SimpleFabricationCommand, command);
			assertType(SimpleCommand, command);
			assertType(IDisposable, command);
			assertType(ICommandProcessor, command);
		}

        [Test]
		public function simpleFabricationCommandAliasMethodsAreValid():void {
			var command:SimpleFabricationCommand = this.command as SimpleFabricationCommand;
			var router:RouterMock = new RouterMock();
			var proxy0:Proxy = new Proxy("p0");
			var proxy1:Proxy = new Proxy("p1");
			var mediator0:Mediator = new Mediator("m0");
			var mediator1:Mediator = new Mediator("m1");
			var body:Object = new Object();
			var parameters:Object = new Object();
			
			facade.mock.method("getFabrication").withNoArgs.returns(fabrication).atLeast(1);
			fabrication.mock.property("router").returns(router);
			
			facade.mock.method("registerCommand").withArgs("znote1", SimpleFabricationCommandMock).once;
			facade.mock.method("removeCommand").withArgs("znote2").once;
			facade.mock.method("hasCommand").withArgs("znote3").returns(false).once;
			
			facade.mock.method("registerProxy").withArgs(proxy0).returns(proxy0).once;
			facade.mock.method("retrieveProxy").withArgs("p0").returns(proxy0).once;
			facade.mock.method("removeProxy").withArgs("p1").returns(proxy1).once;
			facade.mock.method("hasProxy").withArgs("p2").returns(false).once;
			
			facade.mock.method("registerMediator").withArgs(mediator0).returns(mediator0).once;
			facade.mock.method("retrieveMediator").withArgs("m0").returns(mediator0).once;
			facade.mock.method("removeMediator").withArgs("m1").returns(mediator1).once;
			facade.mock.method("hasMediator").withArgs("m2").returns(false).once;
			
			facade.mock.method("routeNotification").withArgs("n0", nullarg, nullarg, nullarg).once;	
			facade.mock.method("routeNotification").withArgs("n0", "b0", nullarg, nullarg).once;	
			facade.mock.method("routeNotification").withArgs("n0", "b0", "t0", nullarg).once;	
			facade.mock.method("routeNotification").withArgs("n0", "b0", "t0", "A/*").once;
			
			facade.mock.method("executeCommandClass").withArgs(SimpleFabricationCommandMock, nullarg, nullarg).returns(new SimpleFabricationCommandMock()).once;
			facade.mock.method("executeCommandClass").withArgs(SimpleFabricationCommandMock, body, nullarg).returns(new SimpleFabricationCommandMock()).once;
			facade.mock.method("executeCommandClass").withArgs(SimpleFabricationCommandMock, nullarg, notification).returns(new SimpleFabricationCommandMock()).once;
			
			facade.mock.method("registerInterceptor").withArgs("n0", InterceptorMock, nullarg).once;
			facade.mock.method("registerInterceptor").withArgs("n0", InterceptorMock, parameters).once;
			
			executeCommand();
			
			assertEquals(command.fabFacade, facade);
			assertEquals(command.fabrication, fabrication);
			assertEquals(command.applicationRouter, router);
			
			command.registerCommand("znote1", SimpleFabricationCommandMock);
			command.removeCommand("znote2");
			assertFalse(command.hasCommand("znote3"));
			
			assertEquals(proxy0, command.registerProxy(proxy0));
			assertEquals(proxy0, command.retrieveProxy("p0"));
			assertEquals(proxy1, command.removeProxy("p1"));
			assertFalse(command.hasProxy("p2"));
			
			assertEquals(mediator0, command.registerMediator(mediator0));
			assertEquals(mediator0, command.retrieveMediator("m0"));
			assertEquals(mediator1, command.removeMediator("m1"));
			assertFalse(command.hasMediator("m2"));
			
			command.routeNotification("n0");
			command.routeNotification("n0", "b0");
			command.routeNotification("n0", "b0", "t0");
			command.routeNotification("n0", "b0", "t0", "A/*");	
			
			assertType(SimpleFabricationCommandMock, command.executeCommand(SimpleFabricationCommandMock));
			assertType(SimpleFabricationCommandMock, command.executeCommand(SimpleFabricationCommandMock, body));
			assertType(SimpleFabricationCommandMock, command.executeCommand(SimpleFabricationCommandMock, null, notification));
			
			command.registerInterceptor("n0", InterceptorMock);
			command.registerInterceptor("n0", InterceptorMock, parameters);
			
			verifyMock(facade.mock);
			verifyMock(fabrication.mock);
		}

        [Test]
        public function simpleCommandInjection():void {

            facade.mock.method( "hasProxy" ).withArgs( "MyProxy" ).returns( true );
            facade.mock.method( "retrieveProxy" ).withArgs( "MyProxy" ).returns( new FabricationProxy( instanceName + UIDUtil.createUID() ) );
            facade.mock.method( "hasMediator" ).withArgs( "MyMediator" ).returns( true );
            facade.mock.method( "hasMediator" ).withArgs( "FlexMediator" ).returns( true );
            facade.mock.method( "retrieveMediator" ).withArgs( "MyMediator" ).returns( new FlexMediator( instanceName + UIDUtil.createUID() ) );
            facade.mock.method( "retrieveMediator" ).withArgs( "FlexMediator" ).returns( new FlexMediator( instanceName + UIDUtil.createUID() ) );

            var simpleCommandWithInjections:SimpleFabricationCommandTestMock = new SimpleFabricationCommandTestMock();
            simpleCommandWithInjections.initializeNotifier(multitonKey);
            simpleCommandWithInjections.execute( null );
            assertNotNull( simpleCommandWithInjections.injectedProxy );
            assertTrue( FabricationProxy, simpleCommandWithInjections.injectedProxy );

            assertNotNull( simpleCommandWithInjections.injectedMediator );
            assertTrue( FabricationMediator, simpleCommandWithInjections.injectedMediator );

            assertNotNull( simpleCommandWithInjections.injectedProxyByName );
            assertTrue( IProxy, simpleCommandWithInjections.injectedProxy );

            assertNotNull( simpleCommandWithInjections.injectedMediatorByName );
            assertTrue( IMediator, simpleCommandWithInjections.injectedMediatorByName );

            simpleCommandWithInjections.dispose();
            assertNull( simpleCommandWithInjections.injectedProxy );
            assertNull( simpleCommandWithInjections.injectedProxyByName );
            assertNull( simpleCommandWithInjections.injectedMediator );
            assertNull( simpleCommandWithInjections.injectedMediatorByName );

            verifyMock( facade.mock );
        }
		
	}
}
