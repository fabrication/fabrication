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

	/**
	 * @author Darshan Sawardekar
	 */
	public class SimpleTestSuite extends TestSuite {

		public function SimpleTestSuite() {
			super();
		}
		
		/**
		 * Adds a test case to the the suite. If the class has a suite method it is used
		 * else the test case is generated using reflection.
		 * 
		 * @param clazz The test case or test suite class
		 */
		public function addTestCase(clazz:Class):void {
			if (clazz.hasOwnProperty("suite")) {
				addSuite(clazz);				
			} else {
				addTest(TestUtils.suite(clazz));
			}
		}
		
		/**
		 * Adds the test cases from a class's suite method to the current test suite.
		 * 
		 * @param clazz The class with the suite method.
		 */
		public function addSuite(clazz:Class):void {
			addTest((clazz as Object)["suite"]());
		}
		
	}
}
