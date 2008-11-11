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
 
package org.puremvc.as3.multicore.utilities.fabrication.routing {
	import flexunit.framework.SimpleTestCase;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IRouter;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IRouterMessage;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.facade.FabricationFacadeMock;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.observer.RouterNotification;
	import org.puremvc.as3.multicore.utilities.fabrication.plumbing.NamedPipe;
	import org.puremvc.as3.multicore.utilities.fabrication.plumbing.NamedPipeMock;
	import org.puremvc.as3.multicore.utilities.fabrication.routing.firewall.RouterFirewallMock;
	import org.puremvc.as3.multicore.utilities.pipes.messages.Message;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.TeeMerge;	

	/**
	 * @author Darshan Sawardekar
	 */
	public class RouterTest extends SimpleTestCase {
		
		private var router:Router = null;
		
		public function RouterTest(method:String) {
			super(method);
		}
		
		override public function setUp():void {
			router = new Router();
		}
		
		override public function tearDown():void {
			router.dispose();
			router = null;
		}
		
		public function testRouterHasValidType():void {
			assertType(Router, router);
			assertType(IRouter, router);
			assertType(IDisposable, router);
		}
		
		public function testRouterCanInstallFirewallWhenUnlocked():void {
			assertDoesNotThrow(SecurityError);
			
			router.install(new RouterFirewallMock());
			router.install(new RouterFirewallMock());
			router.install(new RouterFirewallMock());
		}
		
		public function testRouterCannotInstallFirewallAfterLocking():void {
			router.install(new RouterFirewallMock());
			router.lockFirewall();
			
			assertThrows(SecurityError);
			router.install(new RouterFirewallMock());
		}
		
		public function testRouterProcessesMessageWithFirewallBeforeSending():void {
			var message:RouterMessage = new RouterMessage(Message.NORMAL, null, "A/A0/OUTPUT", "B/B0/INPUT");
			var firewall:RouterFirewallMock = new RouterFirewallMock();
			firewall.mock.method("process").withArgs(message).returns(message).once;
			
			router.install(firewall);
			router.route(message);
			
			verifyMock(firewall.mock);
		}
		
		public function testRouterForwardsMessagesReceivedViaRouterCable():void {
			var message:RouterMessage = new RouterMessage(Message.NORMAL, null, "A/A0/OUTPUT", "B/B0/INPUT");
			var cableA:RouterCable = createRouterCableMock("A", "A0");
			var cableB:RouterCable = createRouterCableMock("B", "B0");
			
			router.connect(cableA);
			router.connect(cableB);
			
			//router.route(message);
			
			verifyRouterCableMock(cableA);
			verifyRouterCableMock(cableB);
		}
		
		public function testRouterSendsMessageUptoFacadeToAll():void {
			var sampleSize:int = 25;
			var cable:RouterCable;
			var cableListener:RouterCableListener;
			var facade:FabricationFacadeMock = new FabricationFacadeMock("Z");
			var message:RouterMessage = new RouterMessage(
				Message.NORMAL, null, "R/R0/OUTPUT", "*"
			);
			var i:int = 0;
			
			facade.mock.method("notifyObservers").withArgs(
				function(note:RouterNotification):Boolean {
					assertType(RouterNotification, note);
					assertEquals(note.getName(), RouterNotification.RECEIVED_MESSAGE_VIA_ROUTER);
					assertEquals(message, note.getMessage());
					return true;
				}
			).exactly(sampleSize);
			
			for (i = 0; i < sampleSize; i++) {
				cable = createRouterCable("X" + i, "X_" + i);
				cableListener = new RouterCableListener(facade);
				 
				cable.getInput().connect(cableListener);
				router.connect(cable);
			}
			
			router.route(message);
			
			verifyMock(facade.mock);
		}
		
		public function testRouterSendsMessageUptoFacadeToAllInstances():void {
			var sampleSize:int = 25;
			var cable:RouterCable;
			var cableListener:RouterCableListener;
			var facade:FabricationFacadeMock = new FabricationFacadeMock("Z");
			var message:RouterMessage = new RouterMessage(
				Message.NORMAL, null, "R/R0/OUTPUT", "X/*"
			);
			var i:int = 0;
			
			facade.mock.method("notifyObservers").withArgs(
				function(note:RouterNotification):Boolean {
					assertType(RouterNotification, note);
					assertEquals(note.getName(), RouterNotification.RECEIVED_MESSAGE_VIA_ROUTER);
					assertEquals(message, note.getMessage());
					return true;
				}
			).exactly(sampleSize);
			
			for (i = 0; i < sampleSize; i++) {
				cable = createRouterCable("X", "X" + i);
				cableListener = new RouterCableListener(facade);
				 
				cable.getInput().connect(cableListener);
				router.connect(cable);
			}
			
			router.route(message);
			
			verifyMock(facade.mock);
		}
		
		public function testRouterDropsLoopbackMessage():void {
			var sampleSize:int = 25;
			var cable:RouterCable;
			var cableListener:RouterCableListener;
			var facade:FabricationFacadeMock = new FabricationFacadeMock("Z");
			var message:RouterMessage = new RouterMessage(
				Message.NORMAL, null, null, null
			);
			var i:int = 0;
			
			facade.mock.method("notifyObservers").withArgs(INotification).never;
			
			for (i = 0; i < sampleSize; i++) {
				cable = createRouterCable("X", "X" + i);
				cableListener = new RouterCableListener(facade);
				 
				message.setFrom(cable.getOutput().getName());
				message.setTo(cable.getInput().getName());
				
				cable.getInput().connect(cableListener);
				router.connect(cable);
				
				router.route(message);
			}
			
			
			verifyMock(facade.mock);
		}
		
		public function testRouterResetsAfterDisposal():void {
			var sampleSize:int = 25;
			var cable:RouterCable;
			var cableListener:RouterCableListener;
			var facade:FabricationFacadeMock = new FabricationFacadeMock("Z");
			var message:RouterMessage = new RouterMessage(
				Message.NORMAL, null, null, null
			);
			var i:int = 0;
			
			facade.mock.method("notifyObservers").withArgs(INotification).never;
			
			for (i = 0; i < sampleSize; i++) {
				cable = createRouterCable("X", "X" + i);
				cableListener = new RouterCableListener(facade);
				 
				message.setFrom(cable.getOutput().getName());
				message.setTo(cable.getInput().getName());
				
				cable.getInput().connect(cableListener);
				router.connect(cable);
			}

			router.dispose();
			
			assertThrows(Error);
			router.route(message);			
		}
		
		public function testRouterCanDisconnectRouterCable():void {
			var sampleSize:int = 25;
			var cable:RouterCable;
			var cableListener:RouterCableListener;
			var facade:FabricationFacadeMock = new FabricationFacadeMock("Z");
			var message:RouterMessage = new RouterMessage(
				Message.NORMAL, null, null, null
			);
			var i:int = 0;
			
			facade.mock.method("notifyObservers").withArgs(INotification).never;
			
			for (i = 0; i < sampleSize; i++) {
				cable = createRouterCable("X", "X" + i);
				cableListener = new RouterCableListener(facade);
				 
				message.setFrom(cable.getOutput().getName());
				message.setTo(cable.getInput().getName());
				
				cable.getInput().connect(cableListener);
				router.disconnect(cable);
				
				router.route(message);
			}
			
			message.setTo("*");
			router.route(message);
			
			message.setTo("X/*");
			router.route(message);
			
			verifyMock(facade.mock);
		}
		
		private function createRouterCable(cname:String, iname:String):RouterCable {
			var inputPipe:NamedPipe = new NamedPipe(cname + "/" + iname + "/INPUT");
			var outputPipe:NamedPipe = new NamedPipe(cname + "/" + iname + "/OUTPUT");
			var cable:RouterCable = new RouterCable(inputPipe, outputPipe);
			
			return cable;
		}
		
		private function createRouterCableMock(cname:String, iname:String):RouterCable {
			var inputPipeMock:NamedPipeMock = new NamedPipeMock();
			var outputPipeMock:NamedPipeMock = new NamedPipeMock();
			
			inputPipeMock.mock.method("getName").withNoArgs.returns(cname + "/" + iname + "/INPUT");
			outputPipeMock.mock.method("getName").withNoArgs.returns(cname + "/" + iname + "/OUTPUT");
			
			outputPipeMock.mock.method("write").withArgs(IRouterMessage).returns(true);
			inputPipeMock.mock.method("write").withArgs(IRouterMessage).returns(true);
			
			outputPipeMock.mock.method("connect").withArgs(TeeMerge).returns(true);
			outputPipeMock.mock.method("disconnect").withNoArgs;
			
			var cable:RouterCable = new RouterCable(inputPipeMock, outputPipeMock);
			
			return cable;
		}
		
		private function verifyRouterCableMock(cable:RouterCable):void {
			var inputPipeMock:NamedPipeMock = cable.getInput() as NamedPipeMock;
			var outputPipeMock:NamedPipeMock = cable.getOutput() as NamedPipeMock;
			
			verifyMock(inputPipeMock.mock);
			verifyMock(outputPipeMock.mock);
		}
	}
}
