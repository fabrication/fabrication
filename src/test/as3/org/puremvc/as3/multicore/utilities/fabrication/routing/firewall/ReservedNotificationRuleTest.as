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
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IFirewallRule;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IRouterMessage;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.observer.FabricationNotification;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.observer.RouterNotification;
	import org.puremvc.as3.multicore.utilities.fabrication.routing.RouterMessage;
	import org.puremvc.as3.multicore.utilities.pipes.messages.Message;		

	/**
	 * @author Darshan Sawardekar
	 */
	public class ReservedNotificationRuleTest extends SimpleTestCase {
		
		private var rule:ReservedNotificationRule = null;
		
		public function ReservedNotificationRuleTest(method:String) {
			super(method);
		}
		
		override public function setUp():void {
			rule = new ReservedNotificationRule();
		}
		
		override public function tearDown():void {
			rule.dispose();
			rule = null;
		}
		
		public function testReservedNotificationRuleHasValidType():void {
			assertType(ReservedNotificationRule, rule);
			assertType(IFirewallRule, rule);
			assertType(IDisposable, rule);
		}
		
		public function testReservedNotificationRuleHasSystemNotifications():void {
			assertTrue(rule.hasNotification(FabricationNotification.STARTUP));
			assertTrue(rule.hasNotification(FabricationNotification.SHUTDOWN));
			assertTrue(rule.hasNotification(FabricationNotification.BOOTSTRAP));
			assertTrue(rule.hasNotification(FabricationNotification.UNDO));
			assertTrue(rule.hasNotification(FabricationNotification.REDO));
			
			assertTrue(rule.hasNotification(RouterNotification.SEND_MESSAGE_VIA_ROUTER));
			assertTrue(rule.hasNotification(RouterNotification.RECEIVED_MESSAGE_VIA_ROUTER));
		}
		
		public function testReservedNotificationRuleSupportsAddingNotifications():void {
			assertDoesNotThrow(Error);
			rule.addNotification("note1");
			rule.addNotification("note2");
			
			assertTrue(rule.hasNotification("note1"));
			assertTrue(rule.hasNotification("note2"));
			
			rule.addNotification("x1", "x2", "x3");
			assertTrue(rule.hasNotification("x1"));
			assertTrue(rule.hasNotification("x2"));
			assertTrue(rule.hasNotification("x3"));
		}
		
		public function testReservedNotificationRuleSupportsRemovingNotifications():void {
			assertDoesNotThrow(Error);
			
			var sampleSize:int = 25;
			var notePrefix:String = "note";
			var i:int = 0;
			 
			for (i = 0; i < sampleSize; i++) {
				rule.addNotification(notePrefix + i);
			}
			
			for (i = 0; i < sampleSize; i++) {
				assertTrue(rule.hasNotification(notePrefix + i));
			}
			
			for (i = 0; i < sampleSize; i++) {
				rule.removeNotification(notePrefix + i);
			}
			
			for (i = 0; i < sampleSize; i++) {
				assertFalse(rule.hasNotification(notePrefix + i));
			}
		}
		
		public function testReservedNotificationRuleDropsSystemNotifications():void {
			assertFalse(processRule(FabricationNotification.STARTUP));
			assertFalse(processRule(FabricationNotification.SHUTDOWN));
			assertFalse(processRule(FabricationNotification.BOOTSTRAP));
			assertFalse(processRule(FabricationNotification.UNDO));
			assertFalse(processRule(FabricationNotification.REDO));
			
			assertFalse(processRule(RouterNotification.SEND_MESSAGE_VIA_ROUTER));
			assertFalse(processRule(RouterNotification.RECEIVED_MESSAGE_VIA_ROUTER));			
		}
		
		public function testReservedNotificationRuleDropsAddedNotifications():void {
			var sampleSize:int = 25;
			var notePrefix:String = "note";
			var i:int = 0;
			 
			for (i = 0; i < sampleSize; i++) {
				rule.addNotification(notePrefix + i);
			}
			
			for (i = 0; i < sampleSize; i++) {
				assertFalse(processRule(notePrefix + i));
			}
		}
		
		public function testReservedNotificationRuleDoesNotDropUnmarkedNotifications():void {
			var sampleSize:int = 25;
			var notePrefix:String = "note";
			var i:int = 0;
			 
			for (i = 0; i < sampleSize; i++) {
				assertTrue(processRule(notePrefix + i));
			}
		}
		
		public function testReservedNotificationRuleResetsAfterDisposal():void {
			var rule:ReservedNotificationRule = new ReservedNotificationRule();
			rule.dispose();
			
			assertThrows(Error);
			rule.hasNotification("note1");
		}
		
		public function processRule(notification:String, from:String = "A/A0/OUTPUT", to:String = "B/B0/INPUT", message:IRouterMessage = null):Boolean {
			if (message == null) {
				message = new RouterMessage(Message.NORMAL);
			}
			
			return rule.process(notification, from, to, message);
		}
		
	}
}
