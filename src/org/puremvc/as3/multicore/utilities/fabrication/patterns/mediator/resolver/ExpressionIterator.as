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
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;	
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IIterator;	
	
	/**
	 * ExpressionIterator is the concrete iterator for walking through
	 * the component expression chains.
	 * 
	 * @author Darshan Sawardekar
	 */
	public class ExpressionIterator implements IIterator, IDisposable {

		/**
		 * Indicates forward expression iteration.
		 */
		static public const FORWARD:String = "forward";
		
		/**
		 * Indicates backward expression iteration.
		 */
		static public const BACKWARD:String = "backward";
		
		/**
		 * The root expression to iterate. 
		 */
		private var expression:Expression;
		
		/**
		 * Current position in the iteration.
		 */
		private var index:int;
		
		/**
		 * Current iteration array.
		 */
		private var iteration:Array;
		
		/**
		 * Current component expression source.
		 */
		private var source:String;
		
		/**
		 * Direction of the iteration.
		 */
		private var direction:String;
		
		/**
		 * Creates a new ExpressionIterator
		 * 
		 * @param expression The root expression to iterate
		 * @param direction The iteration direction. 
		 */
		public function ExpressionIterator(expression:Expression, direction:String = FORWARD) {
			this.expression = expression;
			this.direction = direction;
			
			index = 0;
			iteration = calcIteration();
		}
		
		/**
		 * @see org.puremvc.as3.multicore.utilities.fabrication.interfacase.IDisposable#dispose()
		 */
		public function dispose():void {
			iteration = null;
			expression = null;
			source = null;
			direction = null;
		}		
		
		/**
		 * @see org.puremvc.as3.multicore.utilities.fabrication.interfaces.IStack#hasNext()
		 */
		public function hasNext():Boolean {
			return index < iteration.length;
		}

		/**
		 * @see org.puremvc.as3.multicore.utilities.fabrication.interfaces.IStack#next()
		 */		
		public function next():* {
			return iteration[index++];
		}

		/**
		 * Returns the expression source upto the current iteration. 
		 */		
		public function getSource():String {
			return source;
		}
		
		/**
		 * Returns the current expression evaluation direction 
		 */
		public function getDirection():String {
			return direction;
		}
		
		/**
		 * Builds the iteration array from the expression chain
		 * @private
		 */
		private function calcIteration():Array {
			var expressions:Array = new Array();
			var nextExpression:Expression = expression;
			source = "";
			
			while (nextExpression != null) {
				expressions.push(nextExpression);
				if (direction == FORWARD) {
					source += source != "" ? "." + nextExpression.source : nextExpression.source;
				}
				nextExpression = nextExpression.child;
			}
			
			if (direction == BACKWARD) {
				expressions.reverse();
				source = "";
				var n:int = expressions.length;
				for (var i:int = 0; i < n; i++) {
					nextExpression = expressions[i];
					source += source != "" ? "." + nextExpression.source : nextExpression.source;
				}
			}
			
			return expressions;
		}
		
		
	}
}
