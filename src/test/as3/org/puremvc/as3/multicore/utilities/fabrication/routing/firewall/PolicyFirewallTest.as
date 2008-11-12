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
 
package org.puremvc.as3.multicore.utilities.fabrication.routing.firewall {
	import flexunit.framework.SimpleTestCase;
	
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IRouterFirewall;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IRouterMessage;
	import org.puremvc.as3.multicore.utilities.fabrication.routing.RouterMessage;
	import org.puremvc.as3.multicore.utilities.pipes.messages.Message;	

	/**
	 * @author Darshan Sawardekar
	 */
	public class PolicyFirewallTest extends SimpleTestCase {
		
		private var policyFirewall:PolicyFirewall = null;
		private var policyFunc:Function;
		private var allowedCount:int = 0;
		private var droppedCount:int = 0;
		
		public function PolicyFirewallTest(method:String) {
			super(method);
		}
		
		override public function setUp():void {
			policyFunc = function(message:IRouterMessage):IRouterMessage { return message; };
			policyFirewall = new PolicyFirewall(policyFunc);
		}
		
		override public function tearDown():void {
			policyFirewall.dispose();
			policyFirewall = null;
			
			policyFunc = null;
		}
		
		public function testPolicyFirewallHasValidType():void {
			assertType(PolicyFirewall, policyFirewall);
			assertType(IRouterFirewall, policyFirewall);
			assertType(IDisposable, policyFirewall);
		}
		
		public function testPolicyFirewallStoresPolicyFunction():void {
			var newPolicyFunc:Function = function(message:IRouterMessage):IRouterMessage { return message; };
			assertProperty(policyFirewall, "policyFunction", Function, policyFunc, newPolicyFunc);
		}
		
		public function testPolicyFirewallExecutesPolicyFunction():void {
			var message:RouterMessage = new RouterMessage(Message.NORMAL);
			
			policyFirewall.policyFunction = allowedPolicyFunction;
			policyFirewall.process(message);
			
			assertEquals(1, allowedCount);
		}
		
		public function testPolicyFirewallObeysAllowedPolicyFunction():void {
			var message:RouterMessage = new RouterMessage(Message.NORMAL);
			
			policyFirewall.policyFunction = allowedPolicyFunction;
			assertEquals(message, policyFirewall.process(message));
		}
		
		public function testPolicyFirewallObeysDroppedPolicyFunction():void {
			var message:RouterMessage = new RouterMessage(Message.NORMAL);
			
			policyFirewall.policyFunction = droppedPolicyFunction;
			assertNull(policyFirewall.process(message));
		}
		
		public function testPolicyFirewallResetsAfterDisposal():void {
			var message:RouterMessage = new RouterMessage(Message.NORMAL);
			var policyFirewall:PolicyFirewall = new PolicyFirewall(policyFunc);
			policyFirewall.dispose();
			
			assertNull(policyFirewall.policyFunction);
			assertThrows(Error);
			policyFirewall.policyFunction.call(message);
		}
		
		public function allowedPolicyFunction(message:IRouterMessage):IRouterMessage {
			allowedCount++;
			return message;
		}
		
		public function droppedPolicyFunction(message:IRouterMessage):IRouterMessage {
			droppedCount++;
			return null;
		}
		
	}
}
