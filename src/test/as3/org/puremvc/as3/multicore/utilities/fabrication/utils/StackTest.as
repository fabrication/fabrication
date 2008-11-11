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
	import flexunit.framework.SimpleTestCase;
	
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IStack;		

	/**
	 * @author Darshan Sawardekar
	 */
	public class StackTest extends SimpleTestCase {
		
		private var stack:Stack = null;
		
		public function StackTest(method:String) {
			super(method);
		}
		
		override public function setUp():void {
			stack = new Stack();
		}
		
		override public function tearDown():void {
			stack.dispose();
			stack = null;
		}
		
		public function testInstantiation():void {
			assertType(Stack, stack);
			assertType(IStack, stack);
		}
		
		public function testStackAllowsAddingPrimitives():void {
			assertDoesNotThrow(Error);
			
			stack.push(0);
			stack.push("foo");
			stack.push(new Date());
			stack.push(["a"]);
			stack.push(0xFF000000);
			stack.push(Math.PI);
		}
		
		public function testStackAllowsAddingObjects():void {
			assertDoesNotThrow(Error);
			
			stack.push({a:1});
			stack.push({b:1});
		}
		
		public function testStackAllowsAddingItemToTop():void {
			stack.push(0);
			assertEquals(1, stack.length());
			assertFalse(stack.isEmpty());
			assertEquals(0, stack.peek());
		}
		
		public function testStackAllowsPeekingFromTop():void {
			stack.push(0);
			assertEquals(0, stack.peek());
		}
		
		public function testStackHasValidLength():void {
			assertEquals(0, stack.length());
			stack.push(0);
			assertEquals(1, stack.length());
			stack.push(1);
			assertEquals(2, stack.length());
			stack.clear();
			assertEquals(0, stack.length());
		}
		
		public function testStackReportsEmptinessCorrectly():void {
			assertTrue(stack.isEmpty());
			stack.push(0);
			assertFalse(stack.isEmpty());
			stack.clear();
			assertTrue(stack.isEmpty());
			stack.push(0);
			stack.pop();
			assertTrue(stack.isEmpty());
		}
		
		public function testStackAllowsRemovingItemsFromTop():void {
			stack.push(-2);
			stack.push(-1);
			stack.push(0);
			
			assertEquals(3, stack.length());
			assertEquals(0, stack.pop());
			assertEquals(2, stack.length());
		}
		
		public function testStackActsAsLIFO():void {
			var source:Array = [0, 1, 2, 3, 4, 5];
			var expected:Array = source.slice().reverse();
			var actual:Array = [];
			var n:int = source.length;
			var i:int;
			
			for (i = 0; i < n; i++) {
				stack.push(source[i]);
			}
			
			for (i = 0; i < n; i++) {
				actual.push(stack.pop());
			}
			
			assertArrayEquals(expected, actual);
			assertNotEquals(source, actual);
		}
		
		public function testStackProvidesAccessToInternalArray():void {
			var source:Array = [0, 1, 2, 3, 4, 5];
			
			var n:int = source.length;
			var i:int;
			
			for (i = 0; i < n; i++) {
				stack.push(source[i]);
			}
			
			assertArrayEquals(source, stack.getElements());
		}
		
		public function testStackResetsAfterDisposal():void {
			var stack:Stack = new Stack();
			
			stack.push(0);
			stack.push(1);
			stack.push(2);
			
			stack.dispose();
			
			assertThrows(Error);
			stack.push(0);
		}
		
	}
}
