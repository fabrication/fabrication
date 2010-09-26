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
 
package org.puremvc.as3.multicore.utilities.fabrication.utils {
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IStack;		

	/**
	 * A last-in-first-out(LIFO) stack.
	 * 
	 * @author Darshan Sawardekar
	 */
	public class Stack implements IStack {

		/**
		 * Stores the elements on the stack.
		 */
		protected var elements:Array;

		/**
		 * Creates a new stack object.
		 */
		public function Stack() {
			elements = new Array();
		}

		/**
         * @inheritDoc
         */
		public function dispose():void {
			clear();
			elements = null;
		}

		/**
         * @inheritDoc
         */
		public function push(element:Object):void {
			elements.push(element);
		}

		/**
         * @inheritDoc
         */
		public function peek():Object {
			return elements[length() - 1];
		}

		/**
         * @inheritDoc
         */
		public function pop():Object {
			var element:Object = peek();
			elements.pop();
			
			return element;
		}

		/**
         * @inheritDoc
         */
		public function clear():void {
			var n:int = elements.length;
			var element:Object;
			for (var i:int = 0;i < n; i++) {
				element = elements[i];
				if (element is IDisposable) {
					(element as IDisposable).dispose();
				}
			}
			
			elements.splice(0);
		}

		/**
         * @inheritDoc
         */
		public function isEmpty():Boolean {
			return length() == 0;
		}

		/**
         * @inheritDoc
         */
		public function length():int {
			return elements.length;
		}

		/**
		 * Returns a copy of the elements on the stack.
		 */
		public function getElements():Array {
			return elements.slice();
		}
	}
}
