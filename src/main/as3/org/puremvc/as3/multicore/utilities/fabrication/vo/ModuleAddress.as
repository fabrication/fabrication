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
 
package org.puremvc.as3.multicore.utilities.fabrication.vo {
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IModuleAddress;	
	
	/**
	 * ModuleAddress represents the parts of an application module name
	 * that fully qualify it for message routing.
	 * 
	 * @author Darshan Sawardekar
	 */
	public class ModuleAddress implements IModuleAddress {
		
		/**
		 * The name of the module
		 * @private
		 */
		private var className:String;
		
		/**
		 * The name of the module instance.
		 * @private
		 */
		private var instanceName:String;
		
		/**
		 * Creates a new ModuleAddress object
		 * 
		 * @param className The name of the module.
		 * @param instanceName The name the module instance.
		 */
		public function ModuleAddress(className:String = null, instanceName:String = null) {
			this.className = className;
			this.instanceName = instanceName;
		}
		
		/**
		 * Returns the name of the module.
		 */
		public function getClassName():String {
			return className;
		}
		
		/**
		 * Returns the name of the module instance.
		 */
		public function getInstanceName():String {
			return instanceName;
		}		
		
		/**
		 * Returns the name of the input message pipe.
		 */
		public function getInputName():String {
			return getClassName() + "/" + getInstanceName() + "/INPUT";
		}
		
		/**
		 * Returns the name of the output message pipe.
		 */
		public function getOutputName():String {
			return getClassName() + "/" + getInstanceName() + "/OUTPUT";
		}
		
		/**
		 * Parses the module address string into its parts.
		 * 
		 * @param source The full module name
		 */
		public function parse(source:String):void {
			var parts:Array = source.split("/");
			var length:int = parts.length;
			if (length >= 2) {
				className = parts[0] as String;
				instanceName = parts[1] as String;
			} else if (length == 1) {
				className = parts[0] as String;
			}
		}
		
		/**
		 * Returns true if the parts of the specified ModuleAddress
		 * match with this ModuleAddress
		 */
		public function equals(moduleAddress:ModuleAddress):Boolean {
			return moduleAddress.getClassName() == getClassName() &&
					moduleAddress.getInstanceName() == getInstanceName();
		}
		
		/**
		 * @see org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable#dispose()
		 */
		public function dispose():void {
			className = null;
			instanceName = null;
		}
		
	}
}
