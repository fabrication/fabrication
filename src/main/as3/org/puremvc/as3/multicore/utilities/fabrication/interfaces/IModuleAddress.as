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

	/**
	 * This interface describes the router address of a module and its
	 * input and output pipe names. 
	 * 
	 * @author Darshan Sawardekar
	 */
	public interface IModuleAddress extends IDisposable {

		/**
		 * Returns the name of the current module. It is calculated from
		 * the startup command class's name. For the startup command 
		 * MyApplicationStartupCommand the class name is MyApplication
		 */
		function getClassName():String;
		
		/**
		 * Returns the name of the current instance of the module. It is 
		 * a guid created by the ApplicationFabricator.
		 */
		function getInstanceName():String;
		
		/**
		 * Returns the name of the input pipe fitting for the current module
		 */
		function getInputName():String;
		
		/**
		 * Returns the name of the output pipe fitting for the current module.
		 */
		function getOutputName():String;
		
		/**
		 * Returns the optional group name of the current module
		 */
		function getGroupName():String;
		
	}
}
