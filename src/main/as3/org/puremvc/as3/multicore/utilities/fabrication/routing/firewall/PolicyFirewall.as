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
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IRouterFirewall;	
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IRouterMessage;	
	
	/**
	 * PolicyFirewall is a router firewall which allows a delegate function
	 * to verify a router message prior to transport. The delegate function
	 * must have the form,
	 * 
	 * <listing>
	 * public function policyFunctionName(message:IRouterMessage):IRouterMessage {
	 * 	// return true or false;
	 * }
	 * </listing>
	 * 
	 * @author Darshan Sawardekar
	 */
	public class PolicyFirewall implements IRouterFirewall {

		/**
		 * Stores the policy delegate function reference.
		 * @private
		 */
		private var _policyFunction:Function;
		
		/**
		 * Creates a new policy firewall object.
		 * 
		 * @param _policyFunction The delegate function used to process policies
		 */
		public function PolicyFirewall(_policyFunction:Function = null):void {
			if (_policyFunction != null) {
				this.policyFunction = _policyFunction;
			}
		}
		
		/**
		 * @see org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable#dispose()
		 */
		public function dispose():void {
			_policyFunction = null;
		}
		
		/**
		 * The delegate function to process the router message.
		 */
		public function get policyFunction():Function {
			return _policyFunction;
		}
		
		/**
		 * @private
		 */
		public function set policyFunction(_policyFunction:Function):void {
			this._policyFunction = _policyFunction;
		}

		/**
		 * @see IRouterFirewall#process
		 */
		public function process(message:IRouterMessage):IRouterMessage {
			if (policyFunction != null) {
				return policyFunction.apply(this, [message]);
			} else {
				return message;
			}
		}		
		
	}
}
