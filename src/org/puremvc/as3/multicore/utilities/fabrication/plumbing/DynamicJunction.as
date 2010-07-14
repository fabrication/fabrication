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
 
package org.puremvc.as3.multicore.utilities.fabrication.plumbing {
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.INamedPipeFitting;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IRouterMessage;
	import org.puremvc.as3.multicore.utilities.fabrication.utils.HashMap;
	import org.puremvc.as3.multicore.utilities.fabrication.vo.ModuleAddress;
	import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeFitting;
	import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeMessage;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.Junction;	

	/**
	 * DynamicJunction is a Pipes junction that transports a message
	 * from source module to destination module.
	 * 
	 * @author Darshan Sawardekar
	 */
	public class DynamicJunction extends Junction implements IDisposable {
		
		/**
		 * Regular expression used to test if the destination module is a module group.
		 */
		static public const MODULE_GROUP_REGEXP:RegExp = new RegExp("^[^\\*/]*$", "");

		/**
		 * Stores the output pipes in a hash map by their group name. 
		 */
		protected var moduleGroups:HashMap;

		/**
		 * Creates a new DynamicJunction object.
		 */
		public function DynamicJunction() {
			super();
			
			moduleGroups = new HashMap();
		}

		/**
		 * Sends the message to the output pipe. The message route is expanded
		 * from * to the target modules here. Messages are dropped if the source
		 * and destination module is the same.
		 * 
		 * @see org.puremvc.as3.multicore.utilities.pipes.plumbing.Junction#sendMessage
		 */
		override public function sendMessage(outputPipeName:String, message:IPipeMessage):Boolean {
			var descriptor:PipeDescriptor = describePipeName(outputPipeName);
			var routerMessage:IRouterMessage = message as IRouterMessage;
			var pipeName:String;
			var pipeNames:Array;
			var n:int;
			var i:int;
			
			if (outputPipeName == "*") {
				// send the message to everyone
				for (pipeName in pipesMap) {
					if (!isLoopback(pipeName, routerMessage.getFrom())) {
						super.sendMessage(pipeName, message);
					}
				}
				
				return true;
			} else if (isModuleGroup(outputPipeName)) {
				// send messages to module group
				pipeNames = retrieveOutputPipesByModuleGroup(outputPipeName);
				
				// no groups registered for the destination group 
				if (pipeNames == null) {
					return false;
				} 
				
				n = pipeNames.length;

				for (i = 0; i < n; i++) {
					pipeName = pipeNames[i];
					if (!isLoopback(pipeName, routerMessage.getFrom())) {
						super.sendMessage(pipeName, message);
					}
				}
				
				return n > 0;
			} else if (descriptor.groupName != null) {
				// send messages to modules of type class in group
				pipeNames = retrieveOutputPipesInModuleGroupByModuleName(descriptor.groupName, descriptor.className);
				n = pipeNames.length;

				for (i = 0; i < n; i++) {
					pipeName = pipeNames[i];

					if (!isLoopback(pipeName, routerMessage.getFrom())) {
						super.sendMessage(pipeName, message);
					}
				}
				
				return n > 0;
			} else if (descriptor.instanceName == "*") {
				// send messages to all instances
				pipeNames = retrieveOutputPipesByClassName(descriptor.className);
				n = pipeNames.length;

				for (i = 0; i < n; i++) {
					pipeName = pipeNames[i];

					if (!isLoopback(pipeName, routerMessage.getFrom())) {
						super.sendMessage(pipeName, message);
					}
				}
				
				return n > 0;
			} else {
				if (!isLoopback(outputPipeName, routerMessage.getFrom())) {
					return super.sendMessage(outputPipeName, message);
				} else {
					return false;
				}
			}
			
		}		

		/**
		 * @see org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable#dispose()
		 */
		public function dispose():void {
			pipesMap = null;
			outputPipes = null;
			pipeTypesMap = null;
			inputPipes = null;
			
			moduleGroups.dispose();
			moduleGroups = null;
		}
		
		/**
		 * If type is output and the pipe is a named pipe stores the pipe in an hashmap of groups.
		 * 
		 * @see org.puremvc.as3.multicore.utilities.pipes.plumbing.Junction#registerPipe()
		 */
		override public function registerPipe(name:String, type:String, pipe:IPipeFitting):Boolean {
			if (type == Junction.OUTPUT && pipe is INamedPipeFitting) {
				var namedPipe:INamedPipeFitting = pipe as INamedPipeFitting;
				var group:String = namedPipe.moduleGroup;
				
				if (group != null && group.length > 0) {
					var groupPipes:Array = moduleGroups.find(group) as Array;
					if (groupPipes == null) {
						groupPipes = moduleGroups.put(group, new Array()) as Array;
					} 
					
					groupPipes.push(name);
				}				
			}
			
			return super.registerPipe(name, type, pipe);
		}

		/**
		 * Removes the name of the pipe from the hashmap of groups if present.
		 * 
		 * @see org.puremvc.as3.multicore.utilities.pipes.plumbing.Junction#removePipe()
		 */
		override public function removePipe(name:String):void {
			var namedPipe:INamedPipeFitting = pipesMap[name] as INamedPipeFitting;
			var type:String = pipeTypesMap[name];
			if (namedPipe != null && type == Junction.OUTPUT) {
				var group:String = namedPipe.moduleGroup;
				if (group != null) {
					var groupPipes:Array = moduleGroups.find(group) as Array;
					if (groupPipes != null) {
						var index:int = findPipeIndex(groupPipes, name);
						if (index >= 0) {
							groupPipes.splice(index, 1);
						}
					}
				}
			}

			super.removePipe(name);
		}

		/**
		 * Returns an array of all output pipes for the specified classname.
		 * 
		 * @param classname The classname whose output pipes need to be looked up.  
		 */
		protected function retrieveOutputPipesByClassName(className:String):Array {
			var pipeNames:Array = new Array();
			var descriptor:PipeDescriptor;
			
			for (var pipeName:String in pipesMap) {
				descriptor = describePipeName(pipeName);
				if (descriptor.className == className) {
					pipeNames.push(pipeName);
				}
			}
			
			return pipeNames;
		}
		
		/**
		 * Returns an array of the output pipes for the specified group name.
		 */
		protected function retrieveOutputPipesByModuleGroup(groupName:String):Array {
			return moduleGroups.find(groupName) as Array;
		}
		
		/**
		 * Returns an array of the output pipes in the specified group of specified moduleName.
		 */
		protected function retrieveOutputPipesInModuleGroupByModuleName(groupName:String, className:String):Array {
			var groupPipes:Array = retrieveOutputPipesByModuleGroup(groupName);
			var n:int = groupPipes.length;
			var i:int;
			var pipeName:String;
			var descriptor:PipeDescriptor;
			var outputPipes:Array = new Array();
			
			for (i = 0; i < n; i++) {
				pipeName = groupPipes[i];
				descriptor = describePipeName(pipeName);
				if (descriptor.className == className) {
					outputPipes.push(pipeName);
				}
			}
			
			return outputPipes;
		}

		/**
		 * Splits a complete pipe name into its module address.
		 * 
		 * @param pipeName The full name of the pipe to split. 
		 */
		protected function describePipeName(pipeName:String):PipeDescriptor {
			var temp:Array = pipeName.split("/");
			var descriptor:PipeDescriptor = new PipeDescriptor();
			
			descriptor.className = temp[0];
			descriptor.instanceName = temp[1];
			
			var match:Object = ModuleAddress.groupNameRegExp.exec(descriptor.instanceName);
			if (match != null && match.length == 2) {
				descriptor.groupName = match[1];
			}			
			
			descriptor.type = temp[1];
			
			return descriptor;
		}

		/**
		 * Returns the classname of a pipe from its fullname.
		 * 
		 * @param pipeName The full name of the pipe.
		 */
		protected function calcPipeClassName(pipeName:String):String {
			return describePipeName(pipeName).className;
		}

		/**
		 * Returns the module address object from the full pipe name
		 * 
		 * @param pipeName The full name of the pipe.
		 * 
		 * @return The parsed module address object.
		 */
		protected function calcModuleAddress(pipeName:String):ModuleAddress {
			var moduleAddress:ModuleAddress = new ModuleAddress();
			moduleAddress.parse(pipeName);
			
			return moduleAddress;
		}

		/**
		 * Returns true if the output and input pipes are for the same module. 
		 */
		protected function isLoopback(outputPipeName:String, inputPipeName:String):Boolean {
			var outputModuleAddress:ModuleAddress = calcModuleAddress(outputPipeName);
			var inputModuleAddress:ModuleAddress = calcModuleAddress(inputPipeName);
			
			return outputModuleAddress.equals(inputModuleAddress);
		}
		
		/**
		 * Helper returns the index position of the pipe name in the specified array.
		 */
		protected function findPipeIndex(pipes:Array, name:String):int {
			var n:int = pipes.length;
			var item:String;
			for (var i:int = 0;i < n; i++) {
				item = pipes[i];
				if (item == name) {
					return i;
				}
			}
			
			return -1;
		}
		
		/**
		 * Helper returns a boolean depending on whether the destination is a module group. 
		 * 
		 * @param pipeName The name of the pipe to test.
		 */
		public function isModuleGroup(pipeName:String):Boolean {
			return pipeName != null && pipeName != "" && MODULE_GROUP_REGEXP.test(pipeName);
		}
	}
}

/**
 * @internal Internal class used to describe the component parts of a pipe name.
 */
internal class PipeDescriptor {

	public var className:String;
	public var instanceName:String;
	public var groupName:String; 
	public var type:String;
}