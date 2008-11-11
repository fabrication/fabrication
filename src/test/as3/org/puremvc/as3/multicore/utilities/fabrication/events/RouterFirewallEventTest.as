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
 
package org.puremvc.as3.multicore.utilities.fabrication.events {
	import flexunit.framework.SimpleTestCase;
	
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IRouterMessage;
	import org.puremvc.as3.multicore.utilities.fabrication.routing.RouterMessage;
	import org.puremvc.as3.multicore.utilities.pipes.messages.Message;		

	/**
	 * @author Darshan Sawardekar
	 */
	public class RouterFirewallEventTest extends SimpleTestCase {
		
		private var routerFirewallEvent:RouterFirewallEvent;
		
		public function RouterFirewallEventTest(method:String) {
			super(method);
		}
		
		override public function setUp():void {
			routerFirewallEvent = new RouterFirewallEvent(RouterFirewallEvent.ALLOWED_MESSAGE, new RouterMessage(Message.NORMAL));
		}
		
		override public function tearDown():void {
			routerFirewallEvent.dispose();
			routerFirewallEvent = null;
		}
		
		public function testInstantiation():void {
			assertType(RouterFirewallEvent, routerFirewallEvent);
			assertType(IDisposable, routerFirewallEvent);
		}
		
		public function testRouterFirewallEventHasAllowedType():void {
			assertNotNull(RouterFirewallEvent.ALLOWED_MESSAGE);
			assertType(String, RouterFirewallEvent.ALLOWED_MESSAGE);
		}
		
		public function testRouterFirewallEventHasBlockedType():void {
			assertNotNull(RouterFirewallEvent.BLOCKED_MESSAGE);
			assertType(String, RouterFirewallEvent.BLOCKED_MESSAGE);
		}
		
		public function testRouterFirewallEventStoresType():void {
			assertEquals(RouterFirewallEvent.ALLOWED_MESSAGE, routerFirewallEvent.type);
		}
		
		public function testRouterFirewallEventStoresMessage():void {
			var message:RouterMessage = new RouterMessage(Message.NORMAL);
			routerFirewallEvent = new RouterFirewallEvent(RouterFirewallEvent.BLOCKED_MESSAGE, message);
			assertEquals(message, routerFirewallEvent.message);
			assertType(IRouterMessage, routerFirewallEvent.message);	
		}
		
		public function testRouterFirewallEventResetsAfterDisposal():void {
			routerFirewallEvent = new RouterFirewallEvent(RouterFirewallEvent.ALLOWED_MESSAGE, new RouterMessage(Message.NORMAL));
			routerFirewallEvent.dispose();
			
			assertNull(routerFirewallEvent.dispose());
			assertThrows(Error);
			routerFirewallEvent.message.getType();
		}
	}
}
