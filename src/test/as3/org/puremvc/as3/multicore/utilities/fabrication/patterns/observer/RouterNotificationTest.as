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
 
package org.puremvc.as3.multicore.utilities.fabrication.patterns.observer {
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IRouterMessage;	
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;	
	import org.puremvc.as3.multicore.interfaces.INotification;	
	
	import flexunit.framework.SimpleTestCase;
	
	import org.puremvc.as3.multicore.utilities.fabrication.routing.RouterMessage;
	import org.puremvc.as3.multicore.utilities.pipes.messages.Message;	

	/**
	 * @author Darshan Sawardekar
	 */
	public class RouterNotificationTest extends SimpleTestCase {
		
		private var routerNotification:RouterNotification = null;
		private var body:Object = new Object();
		private var message:RouterMessage = new RouterMessage(Message.NORMAL);
		
		public function RouterNotificationTest(method:String):void {
			super(method);
		}
		
		override public function setUp():void {
			routerNotification = new RouterNotification("test_note", body, "test_type", message);
		}
		
		override public function tearDown():void {
			routerNotification.dispose();
			routerNotification = null;
		}
		
		public function testInstantiation():void {
			assertType(RouterNotification, routerNotification);
			assertType(INotification, routerNotification);
			assertType(IDisposable, routerNotification);
		}
		
		public function testRouterNotificationHasSendMessageName():void {
			assertNotNull(RouterNotification.SEND_MESSAGE_VIA_ROUTER);
			assertType(String, RouterNotification.SEND_MESSAGE_VIA_ROUTER);
		}
		
		public function testRouterNotificationHasReceivedMessageName():void {
			assertNotNull(RouterNotification.RECEIVED_MESSAGE_VIA_ROUTER);
			assertType(String, RouterNotification.RECEIVED_MESSAGE_VIA_ROUTER);
		}
		
		public function testRouterNotificationStoresName():void {
			assertEquals("test_note", routerNotification.getName());
			assertType(String, routerNotification.getType());
		}
		
		public function testRouterNotificationStoresBody():void {
			assertEquals(body, routerNotification.getBody());
			assertType(Object, routerNotification.getBody());
		}
		
		public function testRouterNotificationStoresType():void {
			assertEquals("test_type", routerNotification.getType());
			assertType(String, routerNotification.getType());
		}
		
		public function testRouterNotificationStoresMessage():void {
			assertEquals(message, routerNotification.getMessage());
			assertType(IRouterMessage, routerNotification.getMessage());
		}
		
		public function testRouterNotificationResetsAfterDisposal():void {
			var routerNotification:RouterNotification = new RouterNotification("test_note", body, "test_type", message);
			routerNotification.dispose();
			
			assertNull(routerNotification.getMessage());
			assertNull(routerNotification.getBody());
			assertNull(routerNotification.getType());
			
			assertThrows(Error);
			routerNotification.getMessage().getType();
		}
	}
}
