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
	import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeMessage;	
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IRouterMessage;	
	
	import flexunit.framework.SimpleTestCase;
	
	import org.puremvc.as3.multicore.utilities.pipes.messages.Message;		

	/**
	 * @author Darshan Sawardekar
	 */
	public class RouterMessageTest extends SimpleTestCase {
		
		private var routerMessage:RouterMessage = null;
		
		public function RouterMessageTest(message:String) {
			super(message);
		}
		
		override public function setUp():void {
			routerMessage = new RouterMessage(Message.NORMAL, null, "A/A0/OUTPUT", "B/B0/INPUT");
		}
		
		override public function tearDown():void {
			routerMessage.dispose();
			routerMessage = null;
		}
		
		public function testRouterMessageHasValidType():void {
			assertType(RouterMessage, routerMessage);
			assertType(IRouterMessage, routerMessage);
			assertType(Message, routerMessage);
			assertType(IPipeMessage, routerMessage);
		}
		
		public function testRouterMessageStoresFrom():void {
			assertType(String, routerMessage.getFrom());
			assertEquals("A/A0/OUTPUT", routerMessage.getFrom());

			assertGetterAndSetter(routerMessage, "to", String, "B/B0/OUTPUT", "X/X0/OUTPUT");
		}
		
		public function testRouterMessageStoresTo():void {
			assertType(String, routerMessage.getTo());
			assertEquals("B/B0/INPUT", routerMessage.getTo());
			
			assertGetterAndSetter(routerMessage, "to", String, "B/B0/INPUT", "X/X0/INPUT");
		}
		
		public function testRouterMessageResetsAfterDisposal():void {
			var routerMessage:RouterMessage = new RouterMessage(Message.NORMAL, null, "A/A0/OUTPUT", "B/B0/INPUT");
			routerMessage.dispose();
			
			assertNull(routerMessage.getFrom());
			assertNull(routerMessage.getTo());
			assertNull(routerMessage.getBody());
			assertNull(routerMessage.getHeader());
			assertNull(routerMessage.getType());
			
			assertThrows(Error);
			routerMessage.getBody().toString();
		}
		
	}
}
