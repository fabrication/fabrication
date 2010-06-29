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
 
package org.puremvc.as3.multicore.utilities.fabrication.interfaces {
	import org.puremvc.as3.multicore.interfaces.INotification;	
	
	/**
	 * An interface for a PureMVC notification that was routed 
	 * from a module via the fabrication router.
	 * 
	 * @author Darshan Sawardekar
	 */
	public interface IRouterNotification extends INotification {

		/**
		 * Returns the router message that this notification was
		 * sent on.
		 */
		function getMessage():IRouterMessage;
		
		/**
		 * Changes the router message that this notification was 
		 * sent on.
		 */
		function setMessage(message:IRouterMessage):void;
		
	}
}
