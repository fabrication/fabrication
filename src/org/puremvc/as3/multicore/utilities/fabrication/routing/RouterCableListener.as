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
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.observer.RouterNotification;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IRouterMessage;	
	import org.puremvc.as3.multicore.interfaces.IFacade;	
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;	
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.PipeListener;	
	
	/**
	 * RouterCableListener is a pipe listener object that translates a pipe
	 * message into a RECEIVED_MESSAGE_VIA_ROUTER system notification. 
	 * @author Darshan Sawardekar
	 */
	public class RouterCableListener extends PipeListener implements IDisposable {
		
		/**
		 * The current application's fabrication facade.
		 */
		protected var facade:IFacade;
		
		/**
		 * Creates a new RouterCableListener object.
		 * 
		 * @param facade The current application's fabrication facade.
		 */
		public function RouterCableListener(facade:IFacade) {
			super(this, handleMessage);
			
			this.facade = facade;
		}
		
		/**
		 * @see org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable#dispose()
		 */
		public function dispose():void {
			disconnect();
			
			facade = null;
		}
		
		/**
		 * Converts the pipe message into a system notification
		 * 
		 * @param message The message object to translate
		 */
		protected function handleMessage(message:IRouterMessage):void {
			facade.notifyObservers(new RouterNotification(RouterNotification.RECEIVED_MESSAGE_VIA_ROUTER, null, null, message));
		}
		
	}
}
