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
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IModuleAddress;		

	/**
	 * An interface that describes an application module that can send
	 * messages using the fabrication router.
	 * 
	 * @author Darshan Sawardekar
	 */
	public interface IRouterAwareModule extends IRouterAware, IDisposable {

		/**
		 * The IModuleAddress object describing the input and output message 
		 * ports for the current application module.
		 */
		function get moduleAddress():IModuleAddress;

		/**
		 * The default message route for an application.
		 * 
		 * Use <code>Asterisk(*)</code>for sending messages to all modules.
		 * <br></br>
		 * Use <code>ModuleName/*</code>for sending messages to any instance of a module.
		 * <br></br>
		 * Use <code>ModuleName/InstanceName</code>for sending message to a specific instance
		 * of a module.     
		 */
		function get defaultRoute():String;

		/**
		 * @private
		 */
		function set defaultRoute(route:String):void;
	}
}
