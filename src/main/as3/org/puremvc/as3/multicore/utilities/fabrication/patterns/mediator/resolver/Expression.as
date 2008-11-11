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
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.resolver.ComponentResolver;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;		

	/**
	 * Expression is a dynamic class used to build the path to a UI component.
	 * wrt to its DisplayObject hierarchy. Expressions can be attached to 
	 * a root component resolver which specifies the base expression.
	 * 
	 * Expressions can be named, descendant, regular expressions or
	 * descendant with regular expressions. 
	 * 
	 * <ul>
	 * 	<li>named : .componentName</li>
	 * 	<li>descendant : ..componentName</li>
	 * 	<li>regular expression : .re(/componentName/)</li>
	 * 	<li>descendant with regular expression : ..rex(/componentName/)</li>
	 * </ul>
	 * 
	 * <p>
	 * The implementation uses regular expressions for all types of expressions.
	 * The named and descendant expressions are converted into regular expressions
	 * internally.
	 * </p>
	 * 
	 * @author Darshan Sawardekar
	 */
	dynamic public class Expression extends Proxy implements IDisposable {

		/**
		 * Regular expression pattern used to match descendants
		 */
		static public const DESCENDANT_PATTERN:String = ".*";
		
		/**
		 * Regular expression pattern used to for expression separators
		 */
		static public const SEPARATOR_PATTERN:String = "\\.";
		
		/**
		 * Regular expression used to match descendants
		 */		
		static public const descendantRegExp:RegExp = new RegExp(DESCENDANT_PATTERN, "");
		
		/**
		 * Creates a new expression of type RegExp using the regular expression specified
		 * 
		 * @param baseExpression The base expression of the new expression
		 * @param pattern The regular expression for the component expression.
		 */
		static public function reExpression(baseExpression:Expression, pattern:RegExp):Expression {
			var expression:Expression = new Expression(pattern);
			if (baseExpression != null) {
				baseExpression.child = expression;
			}
			
			return expression;
		}
		
		/**
		 * Creates a regular expression from the name specified and creates
		 * a new Expression from it.
		 * 
		 * @param baseExpression The base expression of the new expression
		 * @param name The name of the component  
		 */
		static public function nameExpression(baseExpression:Expression, name:String):Expression {
			var namePattern:RegExp = new RegExp(name, "");
			return reExpression(baseExpression, namePattern);			
		}
		
		/**
		 * Creates a descendants Expression to the component name specified.
		 * Descendants are created using 2 linked expressions, a descendant
		 * pattern expression and a named component expression.
		 * 
		 * @param baseExpression The base expression of the new expression
		 * @param name The name of the descendant component 
		 */
		static public function descendantsExpression(baseExpression:Expression, name:String):Expression {
			var descendantsExpression:Expression = reExpression(baseExpression, descendantRegExp);
			nameExpression(descendantsExpression, name);
			
			return descendantsExpression; 		
		}
		
		/**
		 * The child expression of the current expression.
		 */
		public var child:Expression;
		
		/**
		 * The root component resolver for the current expression.
		 */
		public var root:ComponentResolver;
		
		/**
		 * The regular expression for the current component expression.
		 */
		private var pattern:RegExp;

		/**
		 * Creates a new component expression.
		 * 
		 * @param pattern The regular expression for this component expression
		 * @param root The optional root component resolver.
		 */
		public function Expression(pattern:RegExp, root:ComponentResolver = null) {
			this.pattern = pattern;
			this.root = root;
		}
		
		/**
		 * @see org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable#dispose()
		 */
		public function dispose():void {
			pattern = null;
			root = null;
			
			if (child != null) {
				child.dispose();
				child = null;
			}
		}

		/**
		 * @see Object#toString
		 */		
		public function toString():String {
			return "[object Expression(" + source + ")]";
		}
		
		/**
		 * Creates a new child expression linked to this expression.
		 * 
		 * @param pattern The regular expression pattern string
		 * @param multimode Optional multimode specifier if multiple components correspond to this expression. Default is true.
		 */
		public function re(pattern:String, multimode:Boolean = true):Expression {
			var expr:Expression = reExpression(this, new RegExp(pattern, ""));
			expr.root = root;
			
			if (root != null) {
				root.setMultimode(multimode);
			}
			
			return expr;
		}

		/**
		 * Creates a new descendant child expression with a regular expression
		 * and links it to this expression.
		 * 
		 * @param pattern The regular expression pattern string
		 * @param multimode Optional multimode specifier if multiple components correspond to this expression. Default is true.
		 */
		public function rex(pattern:String, multimode:Boolean = true):Expression {
			var descendantsExpression:Expression = Expression.reExpression(this, Expression.descendantRegExp);
			var reExpression:Expression = Expression.reExpression(descendantsExpression, new RegExp(pattern, ""));
			
			descendantsExpression.root = root;
			reExpression.root = root;
			
			if (root != null) {
				root.setMultimode(multimode);
			}
			
			return descendantsExpression;
		}

		/**
		 * Creates a new descendant expression and links it to this expression
		 * 
		 * @param name The name of the descendant component.
		 */
		public function descendants(name:String):Expression {
			var expr:Expression = descendantsExpression(this, name);
			expr.root = root;
			
			return expr;
		}
		
		/**
		 * Creates a named expression and links it to this expression.
		 * 
		 * @param name The name of the component
		 * @param multimode Optional multimode specifier if multiple components correspond to this expression. Default is false.
		 */
		public function resolve(name:String, multimode:Boolean = false):Expression {
			var expr:Expression = nameExpression(this, name);
			expr.root = root;
			
			if (root != null) {
				root.setMultimode(multimode);
			}
			
			return expr;
		}

		/**
		 * Links the specified expression to this expression.
		 * 
		 * @param expression The expression to link to the current expression.
		 */
		public function link(expression:Expression):void {
			child = expression;
		}
		
		/**
		 * Tests the specified component name with the current expressions pattern
		 * 
		 * @param content The component name to match
		 */
		public function match(content:String):Boolean {
			return pattern.test(content);
		}
		
		/**
		 * Returns the iterator for the current expression. Default direction
		 * is backward. 
		 * 
		 * @param direction The direction of the iteration. Can be forward or backward.
		 */
		public function getIterator(direction:String = null):ExpressionIterator {
			if (direction == null) {
				direction = ExpressionIterator.BACKWARD; 
			}
			
			return new ExpressionIterator(this, direction);
		}
		
		/**
		 * Expands the current expression into a composite regular expression.
		 * 
		 */
		public function expand():RegExp {
			var iterator:ExpressionIterator = getIterator(ExpressionIterator.FORWARD);
			var fullPattern:String = "";
			var nextExpression:Expression;
			
			while (iterator.hasNext()) {
				nextExpression = iterator.next() as Expression;
				if (fullPattern != "") {
					fullPattern += SEPARATOR_PATTERN + nextExpression.source;
				} else {
					fullPattern += nextExpression.source;
				}
			}
			
			fullPattern = "(" + fullPattern + ")";
			
			iterator.dispose();
			iterator = null;
			
			return new RegExp(fullPattern, "");
		}

		/**
		 * Returns the source of the current expression's regular expression.
		 */		
		public function get source():String {
			return pattern.source;
		}
		
		/**
		 * For named component resolution with multimode true. Typically 
		 * the property operation is used. If .componentName() or 
		 * .componentName(true) is used multimode gets turn on.
		 */
		override flash_proxy function callProperty(name:*, ...args):* {
			var multimode:Boolean = (args.length == 1 && args[0] == true) || (args.length == 0);
			return resolve(name.toString(), multimode);
		}
		
		/**
		 * For named component resolution with multimode false. This is
		 * the most common usage.
		 */
		override flash_proxy function getProperty(name:*):* {
			return resolve(name.toString());
		}
		
		/**
		 * For descendant component resolution with multimode false.
		 */
		override flash_proxy function getDescendants(name:*):* {
			return descendants(name.toString());
		}
		
	}
}
