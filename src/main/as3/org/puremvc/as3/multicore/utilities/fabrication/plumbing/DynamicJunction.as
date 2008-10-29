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
	import org.puremvc.as3.multicore.utilities.fabrication.vo.ModuleAddress;	
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IRouterMessage;	
	import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeMessage;	
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.Junction;	

	/**
	 * DynamicJunction is a Pipes junction that transports a message
	 * from source module to destination module.
	 * 
	 * @author Darshan Sawardekar
	 */
	public class DynamicJunction extends Junction {

		/**
		 * Creates a new DynamicJunction object.
		 */
		public function DynamicJunction() {
			super();
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
			//trace("DynamicJunction.sendMessage " + outputPipeName + ", from : " + (message as IRouterMessage).getFrom());
			if (outputPipeName == "*") {
				// send the message to everyone
				for (pipeName in pipesMap) {
					if (!isLoopback(pipeName, routerMessage.getFrom())) {
						super.sendMessage(pipeName, message);
					} else {
						//trace("Dropped message to self");
					}
				}
				
				return true;
			} else if (descriptor.instanceName == "*") {
				// send messages to all instances
				var pipeNames:Array = retrieveOutputPipesByClassName(descriptor.className);
				var n:int = pipeNames.length;

				for (var i:int = 0;i < n; i++) {
					pipeName = pipeNames[i];

					if (!isLoopback(pipeName, routerMessage.getFrom())) {
						super.sendMessage(pipeName, message);
					} else {
						//trace("Dropped message from module to module");
					}
				}
				
				return n > 0;
			} else {
				return super.sendMessage(outputPipeName, message);
			}
			
			return false;
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
		 * Splits a complete pipe name into its module address.
		 * 
		 * @param pipeName The full name of the pipe to split. 
		 */
		protected function describePipeName(pipeName:String):PipeDescriptor {
			var temp:Array = pipeName.split("/");
			var descriptor:PipeDescriptor = new PipeDescriptor();
			
			descriptor.className = temp[0];
			descriptor.instanceName = temp[1];
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
		 * Returs true if the output and input pipes are for the same module. 
		 */
		protected function isLoopback(outputPipeName:String, inputPipeName:String):Boolean {
			var outputModuleAddress:ModuleAddress = calcModuleAddress(outputPipeName);
			var inputModuleAddress:ModuleAddress = calcModuleAddress(inputPipeName);
			
			return outputModuleAddress.equals(inputModuleAddress);
		}
	}
}

/**
 * @internal Internal class used to describe the component parts of a pipe name.
 */
internal class PipeDescriptor {

	public var className:String;
	public var instanceName:String;
	public var type:String; // not used anymore 
}