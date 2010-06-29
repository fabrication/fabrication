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
	import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeFitting;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.Pipe;		

	/**
	 * NamedPipe is a custom pipe fitting which can be assigned a name for
	 * later retrieval.
	 * 
	 * @author Darshan Sawardekar
	 */
	public class NamedPipe extends Pipe implements INamedPipeFitting, IDisposable {

		/**
		 * Stores the pipe name
		 */
		protected var name:String;
		
		/**
		 * Stores the module group's name.
		 */
		protected var _moduleGroup:String = null;
		
		/**
		 * Creates a new NamedPipe object.
		 * 
		 * @param name The name of the pipe
		 * @param ouput The pipes connected output fitting.
		 */
		public function NamedPipe(name:String = null, output:IPipeFitting = null) {
			super(output);
			
			setName(name);
		} 
		
		/**
		 * Returns the pipe name.
		 */
		public function getName():String {
			return name;
		}
		
		/**
		 * Changes the pipe name.
		 */
		public function setName(name:String):void {
			this.name = name;
		}
		
		/**
		 * Optional name of the group that this pipe fitting's module belongs to.
		 */
		public function get moduleGroup():String {
			return _moduleGroup;
		}
		 
		/**
		 * @private
		 */
		public function set moduleGroup(moduleGroup:String):void {
			_moduleGroup = moduleGroup;
		}
		
		/**
		 * @see org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable#dispose()
		 */
		public function dispose():void {
			name = null;
			_moduleGroup = null;
			
			disconnect();
		}
	}
}
