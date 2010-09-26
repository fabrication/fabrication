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
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.INamedPipeFitting;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IRouter;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IRouterCable;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IRouterFirewall;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IRouterMessage;
	import org.puremvc.as3.multicore.utilities.fabrication.plumbing.DynamicJunction;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.Junction;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.PipeListener;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.TeeMerge;	

	/**
	 * Router transports messages between <code>IFabrications</code>. A firewall
	 * is used if assigned to verify the message being routed. 
	 * 
	 * @author Darshan Sawardekar
	 */
	public class Router implements IRouter {
		
		/**
		 * Pipes Junction used to send messages 
		 */
		protected var junction:DynamicJunction;
		
		/**
		 * Firewall used to verify message before being routed
		 */
		protected var firewall:IRouterFirewall;
		
		/**
		 * Pipes TeeMerge to connect to a module's input
		 */
		protected var teeMerge:TeeMerge;
		
		/**
		 * Pipes listener to listen to messages sent via the module's output pipe
		 */
		protected var teeMergeListener:PipeListener;
		
		/**
		 * Indicates if the firewall can be changed. 
		 */
		protected var firewallLocked:Boolean = false;
		
		/**
		 * Creates a new fabrication Router object
		 */
		public function Router() {
			junction = new DynamicJunction();
			teeMerge = new TeeMerge();
			//teeMerge.connect(new PipeListener(this, handlePipeMessage));
		}
		
		/**
         * @inheritDoc
         */
		public function dispose():void {
			if (junction is IDisposable) (junction as IDisposable).dispose(); 
			junction = null;
			
			if (teeMerge is IDisposable) (teeMerge as IDisposable).dispose(); 
			teeMerge = null;
			
			firewall = null;
		}
		
		/**
         * @inheritDoc
         */
		public function connect(cable:IRouterCable):void {
			var input:INamedPipeFitting = cable.getInput();
			var output:INamedPipeFitting = cable.getOutput();
			
			teeMerge.connectInput(output);
			junction.registerPipe(input.getName(), Junction.OUTPUT, input);
			junction.registerPipe(output.getName(), Junction.INPUT, input);
		}
		
		/**
         * @inheritDoc
         */
		public function disconnect(cable:IRouterCable):void {
			var input:INamedPipeFitting = cable.getInput();
			var output:INamedPipeFitting = cable.getOutput();
			
			junction.removePipe(output.getName());
			junction.removePipe(input.getName());
			output.disconnect();
		}

		/**
         * @inheritDoc
         */
		public function install(firewall:IRouterFirewall):void {
			if (!firewallLocked) {
				this.firewall = firewall;
			} else {
				throw new SecurityError("Cannot install firewall on a locked router.");
			}
		}
		
		/**
		 * Prevents the firewall from being reassigned. This provides simple
		 * security solution to prevent modules which do not have restricted
		 * access from modifying the router they have a reference to.
		 */
		public function lockFirewall():void {
			if (firewall == null) {
				throw new SecurityError("Cannot lock firewall, A router must be installed before lockFirewall can be called.");
			}
			
			firewallLocked = true;
		} 
		
		/**
		 * Routes a message from source to destination module after
		 * processing the message
		 * 
		 * @param message The message object to send from the source to the destination module.
		 */
		public function route(message:IRouterMessage):void {
			var from:String = message.getFrom();
			var to:String = message.getTo();

			var processedMessage:IRouterMessage = message;
			if (firewall != null) {
				processedMessage = firewall.process(message);
			}
			
			if (from != null && processedMessage != null) {
				junction.sendMessage(to, message);
			}
		}
		
		/**
		 * Routes a message received via a pipe fitting at the tee merge
		 * if it is a router message.
		 * 
		 * @throws SecurityError Routers can only handle messages of type IRouterMessage.
		 */
		/* * Deprecated :: Message transport now happens with the direct route call
		protected function handlePipeMessage(message:IPipeMessage):void {
			if (message is IRouterMessage) {
				var routerMessage:IRouterMessage = message as IRouterMessage;
				route(routerMessage);
			} else {
				throw new SecurityError("Routers can only handle messages of type IRouterMessage.");
			}
		}
		/* */
		
	}
}
