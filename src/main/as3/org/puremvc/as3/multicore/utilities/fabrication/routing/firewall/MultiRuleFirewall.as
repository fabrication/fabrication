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
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.utilities.fabrication.events.RouterFirewallEvent;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IFirewallRule;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IRouterFirewall;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IRouterMessage;
	
	import flash.events.EventDispatcher;	

	/**
	 * Dispatched when a message is allowed to be forwarded after checking
	 * against all rules in the firewall.
	 * 
	 * @eventType org.puremvc.as3.multicore.utilities.fabrication.events.RouterFirewallEvent.ALLOWED_MESSAGE
	 */
	[Event(name="allowedMessage", type="org.puremvc.as3.multicore.utilities.fabrication.events.RouterFirewallEvent")]

	/**
	 * Dispatched when a message is blocked by any one of the rules in 
	 * the firewall.
	 * 
	 * @eventType org.puremvc.as3.multicore.utilities.fabrication.events.RouterFirewallEvent.BLOCKED_MESSAGE
	 */
	[Event(name="blockedMessage", type="org.puremvc.as3.multicore.utilities.fabrication.events.RouterFirewallEvent")]

	/**
	 * MultiRuleFirewall is a router firewall to process a router message 
	 * against multiple application rules before forwarding it to the target
	 * module.
	 * 
	 * Rules can be added using the addRule method and removed using the
	 * removeRule method. Rules must implement the IFirewallRule interface.
	 * The message will be forwared only if all rules were validated 
	 *   
	 * @author Darshan Sawardekar
	 */
	public class MultiRuleFirewall extends EventDispatcher implements IRouterFirewall {

		/**
		 * Stores the rules of the firewall.
		 */
		protected var rules:Array;

		/**
		 * Creates a new multirule firewal object.
		 */
		public function MultiRuleFirewall() {
			rules = new Array();
		}

		/**
		 * @see org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable#dispose()
		 */
		public function dispose():void {
			rules.splice(0);
			rules = null;
		}

		/**
		 * Adds a new firewall rule to the rules store.
		 * 
		 * @param rule The firewall rule to add
		 */
		public function addRule(rule:IFirewallRule):void {
			rules.push(rule);
		}

		/**
		 * Removes the firewall rule from the rules store if present.
		 * 
		 * @param rule The firewall rule to remove
		 */
		public function removeRule(rule:IFirewallRule):void {
			var index:int = findRuleIndex(rule);
			if (index >= 0) {
				rules.splice(index, 1);
			}
		}

		/**
		 * Returns a boolean indicating if the rule is currently present
		 * in the rules store.
		 * 
		 * @param rule The rule to test
		 */
		public function hasRule(rule:IFirewallRule):Boolean {
			return findRuleIndex(rule) >= 0;
		}

		/**
		 * @see IRouterFirewall#process
		 */
		public function process(message:IRouterMessage):IRouterMessage {
			var n:int = rules.length;
			var rule:IFirewallRule;
			var notificationToRoute:INotification = message.getNotification();
			var notification:String = notificationToRoute.getName();
			var from:String = message.getFrom();
			var to:String = message.getTo();
			var result:Boolean = true;
			var ruleResult:Boolean;
			
			for (var i:int = 0;i < n; i++) {
				rule = rules[i] as IFirewallRule;
				ruleResult = rule.process(notification, from, to, message);
				result = result && ruleResult;
			}
			
			if (result) {
				dispatchEvent(new RouterFirewallEvent(RouterFirewallEvent.ALLOWED_MESSAGE, message));
				return message;
			} else {
				dispatchEvent(new RouterFirewallEvent(RouterFirewallEvent.BLOCKED_MESSAGE, message));
				return null;
			}
		}

		/**
		 * Helper to get the index of a specific rule in the rules
		 */
		private function findRuleIndex(rule:IFirewallRule):int {
			var n:int = rules.length;
			var ruleItem:IFirewallRule;
			for (var i:int = 0;i < n; i++) {
				ruleItem = rules[i];
				if (ruleItem == rule) {
					return i;
				}
			}
			
			return -1;
		}
	}
}
