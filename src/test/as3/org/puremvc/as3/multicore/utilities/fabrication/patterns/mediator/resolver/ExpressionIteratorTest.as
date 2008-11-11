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
 
package org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.resolver {
	import flexunit.framework.SimpleTestCase;
	
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IIterator;		

	/**
	 * @author Darshan Sawardekar
	 */
	public class ExpressionIteratorTest extends SimpleTestCase {
		
		public var iterator:ExpressionIterator;
		
		public function ExpressionIteratorTest(method:String):void {
			super(method);
		}
		
		override public function setUp():void {
			iterator = new ExpressionIterator(new Expression(/start/));
		}
		
		public function testExpressionIteratorHasValidType():void {
			assertType(ExpressionIterator, iterator);
			assertType(IDisposable, iterator);
			assertType(IIterator, iterator);
		}
		
		public function testExpressionIteratorSavesValidDirection():void {
			assertEquals(ExpressionIterator.FORWARD, iterator.getDirection());
			
			iterator = new ExpressionIterator(new Expression(/start/), ExpressionIterator.BACKWARD);
			assertEquals(ExpressionIterator.BACKWARD, iterator.getDirection());
		}
		
		public function testExpressionIteratorForwardIterationIsValid():void {
			var expr:Expression = new Expression(new RegExp("a", ""));
			expr.b.c.d;
			
			var iterator:ExpressionIterator = new ExpressionIterator(expr, ExpressionIterator.FORWARD);
			assertArrayEquals(["a", "b", "c", "d"], iterationToArray(iterator));
		}
		
		public function testExpressionIteratorBackwardIterationIsValid():void {
			var expr:Expression = new Expression(new RegExp("a", ""));
			expr.b.c.d;
			
			var iterator:ExpressionIterator = new ExpressionIterator(expr, ExpressionIterator.BACKWARD);
			assertArrayEquals(["a", "b", "c", "d"].reverse(), iterationToArray(iterator));
		}
		
		public function testExpressionIteratorSavesValidSource():void {
			var expr:Expression;
			var iterator:ExpressionIterator;
			
			expr = new Expression(new RegExp("a", ""));
			expr.b.c.d;
			
			iterator = new ExpressionIterator(expr, ExpressionIterator.FORWARD);
			assertEquals("a.b.c.d", iterator.getSource());
						
			expr = new Expression(new RegExp("a", ""));
			expr.b.c.d;
			
			iterator = new ExpressionIterator(expr, ExpressionIterator.BACKWARD);
			assertEquals("d.c.b.a", iterator.getSource());			
		}
		
		public function iterationToArray(iterator:IIterator):Array {
			var result:Array = new Array();
			
			while (iterator.hasNext()) {
				result.push((iterator.next() as Expression).source);
			}
			
			return result;
		}
		
	}
}
