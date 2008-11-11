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

import flash.utils.describeType;	/**
	 * @author Darshan Sawardekar
	 */
	public class TestUtils {
		
		
		static public const testMethodRegExp:RegExp = new RegExp("^test.*", "");
		
		static public function suite(clazz:Class, re:RegExp = null):TestSuite {
			if (re == null) {
				re = testMethodRegExp;
			}
			var testSuite:TestSuite = new TestSuite();
			var clazzInfo:XML = describeType(clazz);
			var constructorNode:XMLList = clazzInfo..constructor as XMLList; 
			var requiredParameters:XMLList = constructorNode.parameter.(@optional = "false"); 
			var requiredParametersCount:int = requiredParameters.length();
			var testMethods:XMLList = clazzInfo..method.((re as RegExp).test(@name));
			var n:int = testMethods.length();
			var method:XML;

			/* *
			if (requiredParametersCount == 1) {
				trace("Added TestSuite for " + clazz);
			}
			/* */

			for (var i:int = 0; i < n; i++) {
				method = testMethods[i];
				if (requiredParametersCount == 1) {
					testSuite.addTest(new clazz(method.@name));
				} else if (requiredParametersCount == 0) {
					testSuite.addTest(new clazz());
				}
			}
			
			return testSuite;
		}
		
	}
}
