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
	import mx.utils.StringUtil;
	
	import flash.utils.getQualifiedClassName;		

	/**
	 * @author Darshan Sawardekar
	 */
	public class SimpleAssert extends Assert {
		
		static public const EXPECTED_NOT_EQUALS:String = "Expected inequality but was equal to <{0}>";
		static public const EXPECTED_TYPE_EQUALS:String = "Expected <{0}> but was <{1}>";
		static public const EXPECTED_ARRAY_EQUALS:String = "Expected <{0}> but was <{1}>";
		static public const EXPECTED_ARRAY_NOT_EQUALS:String = "Expected inequality but arrays were equal";

		public function SimpleAssert() {
			super();
		}

		static public function assertNotEquals(...rest):void {
			try {
				Assert.assertEquals.apply(Assert, rest);
				
				var failMessage:String;
				if (rest.length == 3) {
					failMessage = StringUtil.substitute(EXPECTED_NOT_EQUALS, rest[1], rest[2]);
					Assert.fail(rest[0] + failMessage);
				} else {
					failMessage = StringUtil.substitute(EXPECTED_NOT_EQUALS, rest[0], rest[1]);
					Assert.fail(failMessage);
				}
			} catch (error:AssertionFailedError) {
				// assertion failed indicates inequality 
			}
		}		
		
		static public function assertType(...rest):void {
			var failMessage:String;
			
			Assert.oneAssertionHasBeenMade();

			if (rest.length == 3) {
				if (!(rest[2] is rest[1])) {
					failMessage = StringUtil.substitute(EXPECTED_TYPE_EQUALS, getClassName(rest[1]), getClassName(rest[2]));
					Assert.fail(rest[0] + failMessage);
				}
			} else if (!(rest[1] is rest[0])){
				failMessage = StringUtil.substitute(EXPECTED_TYPE_EQUALS, getClassName(rest[0]), getClassName(rest[1]));
				Assert.fail(failMessage);
			}
		}
		
		static public function assertArrayEquals(...rest):void {
			var failMessage:String;
			
			if (rest.length == 3) {
				failMessage = StringUtil.substitute(EXPECTED_ARRAY_EQUALS, rest[1], rest[2]);
				testArrayEquality(rest[1], rest[2], failMessage + rest[0]);
			} else {
				failMessage = StringUtil.substitute(EXPECTED_ARRAY_EQUALS, rest[0], rest[1]);
				testArrayEquality(rest[0], rest[1]);
			}
		}
		
		static public function assertArrayNotEquals(...rest):void {
			try {
				assertArrayEquals.apply(Assert, rest);
				
				var failMessage:String;
				if (rest.length == 3) {
					failMessage = StringUtil.substitute(EXPECTED_ARRAY_NOT_EQUALS, rest[1], rest[2]);
					Assert.fail(rest[0] + failMessage);
				} else {
					failMessage = StringUtil.substitute(EXPECTED_ARRAY_NOT_EQUALS, rest[0], rest[1]);
					Assert.fail(failMessage);
				}
			} catch (error:AssertionFailedError) {
				// assertion failed indicates inequality 
			}
		}
		
		static public function assertThrows(...rest):void {
		}
		
		static public function getClassName(clazz:Object):String {
			var classpath:String = getQualifiedClassName(clazz);
			var re:RegExp = new RegExp("^.*::(.*)$", "");
			var result:Object = re.exec(classpath);
			
			if (result != null) {
				return result[1];
			} else {
				return classpath;
			}
		}
		
		static public function testArrayEquality(array1:Array, array2:Array, message:String = ""):void {
			assertEquals("Array length not equal", array1.length, array2.length);
			var n:int = array1.length;
			
			for (var i:int = 0; i < n; i++) {
				assertEquals(message, array1[i], array2[i]);
			}
		}
		
	}
}
