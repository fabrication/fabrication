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
	
	/**
	 * @author Darshan Sawardekar
	 */
	public class CloneUtilsTest extends SimpleTestCase {
		
		public function CloneUtilsTest(method:String) {
			super(method);
		}
		
		public function testNewInstanceWith0Arguments():void {
			var instance:ClassWith0Arguments = CloneUtils.newInstance(ClassWith0Arguments, 0) as ClassWith0Arguments;
			assertType(ClassWith0Arguments, instance);
		}
		
		public function testNewInstanceWith1Argument():void {
			var instance:ClassWith1Argument = CloneUtils.newInstance(ClassWith1Argument, 1) as ClassWith1Argument;
			assertType(ClassWith1Argument, instance);
		}
		
		public function testNewInstanceWith2Arguments():void {
			var instance:ClassWith2Arguments = CloneUtils.newInstance(ClassWith2Arguments, 2) as ClassWith2Arguments;
			assertType(ClassWith2Arguments, instance);
		}
		
		public function testNewInstanceWith3Arguments():void {
			var instance:ClassWith3Arguments = CloneUtils.newInstance(ClassWith3Arguments, 3) as ClassWith3Arguments;
			assertType(ClassWith3Arguments, instance);
		}
		
		public function testNewInstanceWith4Arguments():void {
			var instance:ClassWith4Arguments = CloneUtils.newInstance(ClassWith4Arguments, 4) as ClassWith4Arguments;
			assertType(ClassWith4Arguments, instance);
		}
		
		public function testNewInstanceWith5Argument():void {
			var instance:ClassWith5Arguments = CloneUtils.newInstance(ClassWith5Arguments, 5) as ClassWith5Arguments;
			assertType(ClassWith5Arguments, instance);
		}
		
		public function testNewInstanceWithOptionalArgument():void {
			var instance:ClassWithOptionalArguments = CloneUtils.newInstance(ClassWithOptionalArguments, 0) as ClassWithOptionalArguments;
			assertType(ClassWithOptionalArguments, instance);
		}
	}
}
