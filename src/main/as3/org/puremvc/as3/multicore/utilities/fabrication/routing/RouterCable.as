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
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.INamedPipeFitting;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IRouterCable;		

	/**
	 * RouterCable wraps the input and output pipe fittings of an fabrication
	 * application.
	 * 
	 * @author Darshan Sawardekar
	 */
	public class RouterCable implements IRouterCable {

		/**
		 * The input message pipe fitting
		 * @private
		 */
		private var input:INamedPipeFitting;

		/**
		 * The output message pipe fitting
		 * @private
		 */
		private var output:INamedPipeFitting;

		/**
		 * Creates a new RouterCable object.
		 * 
		 * @param input The input message pipe fitting
		 * @param output The output message pipe fitting
		 */
		public function RouterCable(input:INamedPipeFitting, output:INamedPipeFitting) {
			this.input = input;
			this.output = output;
		}

		/**
		 * @see org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable#dispose()
		 */
		public function dispose():void {
			input = null;
			output = null;
		}

		/**
		 * Returns the input message pipe fitting
		 */
		public function getInput():INamedPipeFitting {
			return input;
		}

		/**
		 * Returns the output message pipe fitting
		 */
		public function getOutput():INamedPipeFitting {
			return output;
		}
	}
}
