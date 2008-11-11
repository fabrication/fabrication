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
	
	import com.anywebcam.mock.Mock;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.facade.FabricationFacadeMock;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.observer.RouterNotification;
	import org.puremvc.as3.multicore.utilities.pipes.messages.Message;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.Junction;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.PipeListener;	

	/**
	 * @author Darshan Sawardekar
	 */
	public class RouterCableListenerTest extends SimpleTestCase {
		
		private var routerCableListener:RouterCableListener;
		private var facade:FabricationFacadeMock;
		private var mock:Mock;
		
		public function RouterCableListenerTest(method:String) {
			super(method);
		}
		
		override public function setUp():void {
			facade = new FabricationFacadeMock("facade_" + methodName);
			routerCableListener = new RouterCableListener(facade);
			mock = facade.mock;
		}
		
		override public function tearDown():void {
			routerCableListener.dispose();
			routerCableListener = null;;
		}
		
		public function testRouterCableListenerHasValidType():void {
			assertType(RouterCableListener, routerCableListener);
			assertType(PipeListener, routerCableListener);
			assertType(IDisposable, routerCableListener);
		}
		
		public function testRouterCableListenerSendsNotificationOnHandleMessage():void {
			var junction:Junction = new Junction();
			var message:RouterMessage = new RouterMessage(Message.NORMAL);
			junction.registerPipe("routerCablePipe", Junction.OUTPUT, routerCableListener);
			
			mock.method("notifyObservers").withArgs(
				function(note:RouterNotification):Boolean {
					assertType(RouterNotification, note);
					assertEquals(note.getName(), RouterNotification.RECEIVED_MESSAGE_VIA_ROUTER);
					assertEquals(message, note.getMessage());
					return true;
				}
			);
			
			junction.sendMessage("routerCablePipe", message);
		}
		
		public function testRouterCableListenerResetsAfterDisposal():void {
			var junction:Junction = new Junction();
			var message:RouterMessage = new RouterMessage(Message.NORMAL);
			var routerCableListener:RouterCableListener = new RouterCableListener(facade);
			
			junction.registerPipe("routerCablePipe", Junction.OUTPUT, routerCableListener);
			mock.method("notifyObservers").withArgs(INotification);
			
			routerCableListener.dispose();			
			assertThrows(Error);
			junction.sendMessage("routerCablePipe", message);
		}
		
	}
}
