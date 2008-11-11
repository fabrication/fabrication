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
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IRouterMessage;	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.observer.Notification;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IRouter;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.AbstractFabricationCommandTest;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.SimpleFabricationCommand;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.observer.RouterNotification;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.observer.TransportNotification;
	import org.puremvc.as3.multicore.utilities.fabrication.routing.RouterMock;
	import org.puremvc.as3.multicore.utilities.fabrication.vo.ModuleAddress;	

	/**
	 * @author Darshan Sawardekar
	 */
	public class RouteNotificationCommandTest extends AbstractFabricationCommandTest {
		
		public var router:RouterMock;
		
		public function RouteNotificationCommandTest(method:String) {
			super(method);
		}
		
		override public function setUp():void {
			router = new RouterMock();
			super.setUp();
			
			facade.mock.method("getFabrication").withNoArgs.returns(fabrication).atLeast(1);
			fabrication.mock.property("moduleAddress").returns(new ModuleAddress("Z", "Z1")).atLeast(1);
			fabrication.mock.property("router").returns(router);
			fabrication.mock.property("router").withArgs(IRouter);
		}
		
		override public function createCommand():ICommand {
			return new RouteNotificationCommand();
		}
		
		override public function createNotification():INotification {
			var transport:TransportNotification = new TransportNotification(
				"changeNote", "changeBody", "changeType", "*"
			);
			
			return new Notification(RouterNotification.SEND_MESSAGE_VIA_ROUTER, transport);
		}
		
		public function testRouteNotificationCommandHasValidType():void {
			assertType(RouteNotificationCommand, command);
			assertType(SimpleFabricationCommand, command);
		}
		
		public function testRouteNotificationCommandPicksUpDefaultRouteFromFabricationIfDestinationIsNotSpecified():void {
			var transport:TransportNotification = notification.getBody() as TransportNotification;
			transport.setTo(null);
			
			fabrication.mock.property("defaultRoute").returns("R/R0/INPUT").once;
			router.mock.method("route").withArgs(
				function(message:IRouterMessage):Boolean {
					assertNotNull(message.getTo());
					assertType(String, message.getTo());
					assertEquals("R/R0/INPUT", message.getTo());
					return true;
				}
			).once;
			
			executeCommand();
			
			verifyMock(fabrication.mock);
			verifyMock(router.mock);
		}
		
		public function testRouteNotificationCommandUsesStaticAllRouteIfNoDestinationIsProvidedAndNoDefaultDestinationWasAlsoNotPresent():void {
			var transport:TransportNotification = notification.getBody() as TransportNotification;
			transport.setTo(null);
			
			fabrication.mock.property("defaultRoute").returns(null).once;
			router.mock.method("route").withArgs(
				function(message:IRouterMessage):Boolean {
					assertNotNull(message.getTo());
					assertType(String, message.getTo());
					assertEquals("*", message.getTo());
					return true;
				}
			).once;
			
			executeCommand();
			
			verifyMock(fabrication.mock);
			verifyMock(router.mock);			
		}
		
		
		public function testRouteNotificationCommandDoesNotSuffixInputPipeNameToAllRoute():void {
			var transport:TransportNotification = notification.getBody() as TransportNotification;
			transport.setTo("*");
			
			fabrication.mock.property("defaultRoute").returns(null).never;
			router.mock.method("route").withArgs(
				function(message:IRouterMessage):Boolean {
					assertNotNull(message.getTo());
					assertType(String, message.getTo());
					assertNotContained(ModuleAddress.INPUT_SUFFIX, message.getTo());
				assertEquals("*", message.getTo());
					return true;
				}
			).once;
			
			executeCommand();
			
			verifyMock(fabrication.mock);
			verifyMock(router.mock);
		}
		
		public function testRouteNotificationCommandDoesNotSuffixInputPipeNameIfInputPipeNameIsAlreadySpecified():void {
			var transport:TransportNotification = notification.getBody() as TransportNotification;
			transport.setTo("D/D0/INPUT");
			
			fabrication.mock.property("defaultRoute").returns(null).never;
			router.mock.method("route").withArgs(
				function(message:IRouterMessage):Boolean {
					assertNotNull(message.getTo());
					assertType(String, message.getTo());
					assertEquals("D/D0/INPUT", message.getTo());
					return true;
				}
			).once;
			
			executeCommand();
			
			verifyMock(fabrication.mock);
			verifyMock(router.mock);
		}
		
		public function testRouteNotificationCommandDoesNotSuffixInputPipeNameIfInstanceDestinationToAllIsPresent():void {
			var transport:TransportNotification = notification.getBody() as TransportNotification;
			transport.setTo("D/*");
			
			fabrication.mock.property("defaultRoute").returns(null).never;
			router.mock.method("route").withArgs(
				function(message:IRouterMessage):Boolean {
					assertNotNull(message.getTo());
					assertType(String, message.getTo());
					assertNotContained(ModuleAddress.INPUT_SUFFIX, message.getTo());
					assertEquals("D/*", message.getTo());
					return true;
				}
			).once;
			
			executeCommand();
			
			verifyMock(fabrication.mock);
			verifyMock(router.mock);
		}
		
		public function testRouteNotificationCommandAddsInputSuffixIfInputSuffixIsNotSpecifiedOnModuleAddressWithClassAndInstanceName():void {
			var transport:TransportNotification = notification.getBody() as TransportNotification;
			transport.setTo("D/D0");
			
			fabrication.mock.property("defaultRoute").returns(null).never;
			router.mock.method("route").withArgs(
				function(message:IRouterMessage):Boolean {
					assertNotNull(message.getTo());
					assertType(String, message.getTo());
					assertContained(ModuleAddress.INPUT_SUFFIX, message.getTo());
					assertEquals("D/D0/INPUT", message.getTo());
					return true;
				}
			).once;
			
			executeCommand();
			
			verifyMock(fabrication.mock);
			verifyMock(router.mock);
		}
		
		public function testRouteNotficationCommandUsesInputPipeFromModuleAddressObjectIfPresent():void {
			var transport:TransportNotification = notification.getBody() as TransportNotification;
			var moduleAddress:ModuleAddress = new ModuleAddress("R", "R0");
			transport.setTo(moduleAddress);
			
			fabrication.mock.property("defaultRoute").returns(null).never;
			router.mock.method("route").withArgs(
				function(message:IRouterMessage):Boolean {
					assertNotNull(message.getTo());
					assertType(String, message.getTo());
					assertContained(ModuleAddress.INPUT_SUFFIX, message.getTo());
					assertEquals(moduleAddress.getInputName(), message.getTo());
					return true;
				}
			).once;
			
			executeCommand();
			
			verifyMock(fabrication.mock);
			verifyMock(router.mock);
		}
		
		public function testRouteNotificationCommandSetsValidMessageFromSourceAddress():void {
			router.mock.method("route").withArgs(
				function(message:IRouterMessage):Boolean {
					assertNotNull(message.getFrom());
					assertType(String, message.getFrom());
					assertEquals("Z/Z1/OUTPUT", message.getFrom());
					return true;
				}
			).once;

			executeCommand();
			
			verifyMock(fabrication.mock);
			verifyMock(router.mock);
		}
		
		public function testRouteNotificationCommandSavesTransportNotificationOnTheRouterMessage():void {
			var transport:TransportNotification = notification.getBody() as TransportNotification;
			
			fabrication.mock.property("defaultRoute").returns(null).never;
			router.mock.method("route").withArgs(
				function(message:IRouterMessage):Boolean {
					assertNotNull(message.getTo());
					assertType(String, message.getTo());
					assertEquals(transport, message.getNotification());
					return true;
				}
			).once;
			
			executeCommand();
			
			verifyMock(fabrication.mock);
			verifyMock(router.mock);
		}
		
	}
}
