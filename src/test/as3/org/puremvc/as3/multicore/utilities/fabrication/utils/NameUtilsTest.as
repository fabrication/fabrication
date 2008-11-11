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
	public class NameUtilsTest extends SimpleTestCase {

		public function NameUtilsTest(method:String) {
			super(method);
		}
		
		public function testNameUtilsHasNamesMap():void {
			assertNotNull(NameUtils.namesMap);
			assertType(Object, NameUtils.namesMap);
		}
		
		public function testNextNameContainsBaseName():void {
			assertContained("TestName", NameUtils.nextName("TestName"));
		}
		
		public function testNextNameIsValid():void {
			var re:RegExp = new RegExp("^A[0-9]+$", "");
			assertMatch(re, NameUtils.nextName("A"));
		}
		
		public function testNextNameIsUnique():void {
			var sample_size:int = 25;
			var sampleNames:Object = new Object();
			var sampleName:String;
			
			for (var i:int = 0; i < sample_size; i++) {
				sampleName = NameUtils.nextName("X");
				assertNull(sampleNames[sampleName]);
				sampleNames[sampleName] = true;
			}
		}
		
	}
}
