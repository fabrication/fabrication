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
		 * The input pipe name suffix.
		 */
		static public const INPUT_SUFFIX:String = "/INPUT";
		
		/**
		 * The output pipe name suffix.
		 */
		static public const OUTPUT_SUFFIX:String = "/OUTPUT";
		
		/**
		 * Regular expression used to test if an input suffix is present
		 */
		static public const inputSuffixRegExp:RegExp = new RegExp("\\" + INPUT_SUFFIX + "$", "");

		/**
		 * Regular expression used to test if an output suffix is present 
		 */
		static public const outputSuffixRegExp:RegExp = new RegExp("\\" + OUTPUT_SUFFIX + "$", "");
		
		/**
		 * Regular expression used to extract group name from the module address source
		 */
		static public const groupNameRegExp:RegExp = new RegExp("^#(.+)$", "");

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
		 * The name of the group that this module belongs to.
		 * @private
		 */
		private var groupName:String;
		
		/**
		 * Creates a new ModuleAddress object
		 * 
		 * @param className The name of the module.
		 * @param instanceName The name the module instance.
		 */
		public function ModuleAddress(className:String = null, instanceName:String = null, groupName:String = null) {
			this.className = className;
			this.instanceName = instanceName;
			this.groupName = groupName;
		}
		
		/**
         * @inheritDoc
         */
		public function getClassName():String {
			return className;
		}
		
		/**
         * @inheritDoc
         */
		public function getInstanceName():String {
			return instanceName;
		}		
		
		/**
         * @inheritDoc
         */
		public function getGroupName():String {
			return groupName;
		}
		
		/**
         * @inheritDoc
         */
		public function getInputName():String {
			return getClassName() + "/" + getInstanceName() + INPUT_SUFFIX;
		}
		
		/**
         * @inheritDoc
         */
		public function getOutputName():String {
			return getClassName() + "/" + getInstanceName() + OUTPUT_SUFFIX;
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
				
				var match:Object = groupNameRegExp.exec(instanceName);
				if (match != null && match.length == 2) {
					groupName = match[1];
				}
			} else if (length == 1) {
				className = parts[0] as String;
				instanceName = null;
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
         * @inheritDoc
         */
		public function dispose():void {
			className = null;
			instanceName = null;
			groupName = null;
		}
		
	}
}
