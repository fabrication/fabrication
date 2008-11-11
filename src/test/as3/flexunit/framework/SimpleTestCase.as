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
 
package flexunit.framework {
	import com.anywebcam.mock.Mock;	
	
	/**
	 * @author Darshan Sawardekar
	 */
	public class SimpleTestCase extends EventfulTestCase {

		protected var exceptionToThrow:Error = null;
		protected var hasAssertThrows:Boolean = false;
		protected var exceptionToCatch:Class = null;
		protected var hasAssertDoesNotThrow:Boolean = false;

		public function SimpleTestCase(method:String) {
			super(method);
		}

		public function assertNotEquals(...rest):void {
			SimpleAssert.assertNotEquals.apply(SimpleAssert, rest);	
		}

		public function assertType(...rest):void {
			SimpleAssert.assertType.apply(SimpleAssert, rest);
		}

		public function assertArrayEquals(...rest):void {
			SimpleAssert.assertArrayEquals.apply(SimpleAssert, rest);
		}

		public function assertArrayNotEquals(...rest):void {
			SimpleAssert.assertArrayNotEquals(SimpleAssert, rest);
		}
		
		public function assertProperty(...rest):void {
			var propertyName:String;
			var propertyValue:*;
			var source:Object;
			var failMessage:String = "";
			var getterName:String;
			var setterName:String;
			var expectedType:Class;
			var defaultValue:*;
			
			if (rest.length == 6) {
				failMessage = rest[0];
				source = rest[1];
				propertyName = rest[2];
				expectedType = rest[3];
				defaultValue = rest[4];
				propertyValue = rest[5];
			} else {
				source = rest[0];
				propertyName = rest[1];
				expectedType = rest[2];
				defaultValue = rest[3];
				propertyValue = rest[4];
			}
			
			var typeName:String = SimpleAssert.getClassName(expectedType);

			getterName = propertyName;
			setterName = propertyName;
			
			assertTrue(failMessage + "Expected property named " + getterName + ".", source.hasOwnProperty(getterName));

			if (defaultValue != null) {
				assertType(failMessage + "Expected property to return " + typeName + ".", expectedType, source[getterName]);
			}
			
			assertTrue(failMessage + "Expected property named " + setterName + ".", source.hasOwnProperty(setterName));
			
			source[setterName] = propertyValue;
			
			if (defaultValue == null && propertyValue != null) {
				assertType(failMessage + "Expected property to return " + typeName + ".", expectedType, source[getterName]);
			}
			
			assertEquals(failMessage + "Expected property (" + setterName + ") to be saved ", propertyValue, source[getterName]);
		}

		public function assertGetterAndSetter(...rest):void {
			var propertyName:String;
			var propertyValue:Object;
			var source:Object;
			var failMessage:String = "";
			var getterName:String;
			var setterName:String;
			var expectedType:Class;
			var defaultValue:Object;
			
			if (rest.length == 6) {
				failMessage = rest[0];
				source = rest[1];
				propertyName = rest[2];
				expectedType = rest[3];
				defaultValue = rest[4];
				propertyValue = rest[5];
			} else {
				source = rest[0];
				propertyName = rest[1];
				expectedType = rest[2];
				defaultValue = rest[3];
				propertyValue = rest[4];
			}
			
			var typeName:String = SimpleAssert.getClassName(expectedType);

			getterName = "get" + propertyName.charAt(0).toUpperCase() + propertyName.substring(1);
			setterName = "set" + propertyName.charAt(0).toUpperCase() + propertyName.substring(1);
			
			assertTrue(failMessage + "Expected getter named " + getterName, source.hasOwnProperty(getterName));
			
			if (defaultValue != null) {
				assertType(failMessage + "Expected getter to return " + typeName, expectedType, source[getterName]());
			}
			
			assertTrue(failMessage + "Expected setter named " + setterName, source.hasOwnProperty(setterName));
			
			source[setterName](propertyValue);
			
			if (defaultValue == null && propertyValue != null) {
				assertType(failMessage + "Expected getter to return " + typeName, expectedType, source[getterName]());
			}
			
			assertEquals(failMessage + "Expected setter (" + setterName + ") to save " + propertyValue, propertyValue, source[getterName]());
		}

		public function assertThrows(clazz:Class):void {
			Assert.oneAssertionHasBeenMade();
			hasAssertThrows = true;
			exceptionToCatch = clazz;
		}

		public function assertDoesNotThrow(clazz:Class):void {
			Assert.oneAssertionHasBeenMade();
			hasAssertDoesNotThrow = true;
			exceptionToCatch = clazz;
		}
		
		public function verifyMock(mock:Mock):void {
			Assert.oneAssertionHasBeenMade();
			mock.verify();
		}

		override public function runMiddle():void {
			try {
				super.runMiddle();
			} catch (e:Error) {
				exceptionToThrow = e;
			} finally {
				
				if (hasAssertThrows) {
					if (exceptionToThrow == null) {
						// no exception was thrown when one was expected
						fail("Expected exception of type " + SimpleAssert.getClassName(exceptionToCatch));
					} else if (exceptionToThrow != null) {
						assertType("Unexpected exception of type", exceptionToCatch, exceptionToThrow);
					}
				} else if (exceptionToThrow != null) {
					// some other exception, throw it up	
					throw exceptionToThrow;
				}
				
				if (hasAssertDoesNotThrow) {
					if (exceptionToThrow != null) {
						fail("Unexpected exception of type " + SimpleAssert.getClassName(exceptionToThrow));
					}
				}
			}
		}
		
		public function nullarg(arg:Object = null):Boolean {
			return arg == null;
		}
		
	}
}
