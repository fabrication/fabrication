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
 
package org.puremvc.as3.multicore.utilities.fabrication.vo {
	import flexunit.framework.SimpleTestCase;		

	/**
	 * @author Darshan Sawardekar
	 */
	public class ModuleAddressTest extends SimpleTestCase {

		private var moduleAddress:ModuleAddress;
		private var moduleClassName:String = "MyModule";
		private var moduleInstanceName:String = moduleClassName + "0";

		public function ModuleAddressTest(method:String) {
			super(method);
		}

		override public function setUp():void {
			moduleAddress = new ModuleAddress(moduleClassName, moduleInstanceName);
		}

		override public function tearDown():void {
			moduleAddress.dispose();
			moduleAddress = null;
		}

		public function testInstantiation():void {
			assertTrue(moduleAddress is ModuleAddress);
		}

		public function testModuleAddressHasClassName():void {
			assertEquals(moduleClassName, moduleAddress.getClassName());
		}

		public function testModuleAddressHasInstanceName():void {
			assertEquals(moduleInstanceName, moduleAddress.getInstanceName());
		}

		public function testModuleAddressHasValidInputName():void {
			assertEquals(moduleClassName + "/" + moduleInstanceName + ModuleAddress.INPUT_SUFFIX, moduleAddress.getInputName());
		}

		public function testModuleAddressHasValidOutputName():void {
			assertEquals(moduleClassName + "/" + moduleInstanceName + ModuleAddress.OUTPUT_SUFFIX, moduleAddress.getOutputName());
		}

		public function testModuleAddressCanParse2PartSource():void {
			moduleAddress.parse("A/A0");
			assertEquals("A", moduleAddress.getClassName());
			assertEquals("A0", moduleAddress.getInstanceName());
		}

		public function testModuleAddressCanParse1PartSource():void {
			moduleAddress.parse("B");
			assertEquals("B", moduleAddress.getClassName());			
		}
		
		public function testModuleAddressGroupNameRegularExpressionIsValid():void {
			var re:RegExp = ModuleAddress.groupNameRegExp;
			
			assertMatch(re, "#myGroup");
			assertNoMatch(re, "#");
			assertNoMatch(re, "A/A0");
			assertNoMatch(re, "A/*");
		}
		
		public function testModuleAddressCanParseGroupNameSource():void {
			moduleAddress.parse("A/#myGroup");
			assertEquals("A", moduleAddress.getClassName());
			assertEquals("myGroup", moduleAddress.getGroupName());
		}
		
		public function testModuleAddresHasNullGroupNameWhenSourceHasNoGroup():void {
			moduleAddress.parse("A/A0");
			assertEquals("A", moduleAddress.getClassName());
			assertEquals("A0", moduleAddress.getInstanceName());
			assertNull(moduleAddress.getGroupName());
		}

		public function testModuleAddressResetsStateAfterParse():void {
			moduleAddress.parse("C");
			assertEquals("C", moduleAddress.getClassName());
			assertNotEquals(moduleInstanceName, moduleAddress.getInstanceName());
			assertNull(moduleAddress.getInstanceName());
		}

		public function testModuleAddressIsEqualWithAttributes():void {
			var moduleAddress1:ModuleAddress = new ModuleAddress("A", "A0");
			var moduleAddress2:ModuleAddress = new ModuleAddress("A", "A0");
			var moduleAddress3:ModuleAddress = new ModuleAddress("A");
			var moduleAddress4:ModuleAddress = new ModuleAddress("A", "A1");
			
			assertTrue(moduleAddress1.equals(moduleAddress2));
			assertFalse(moduleAddress1.equals(moduleAddress));
			assertFalse(moduleAddress1.equals(moduleAddress3));
			assertFalse(moduleAddress1.equals(moduleAddress4));
		}

		public function testModuleAddressResetsAfterDisposal():void {
			var moduleAddress1:ModuleAddress = new ModuleAddress("B", "B0");
			moduleAddress1.dispose();
			
			assertNull(moduleAddress1.getClassName());
			assertNull(moduleAddress1.getInstanceName());
		}

		public function testModuleAddressInputRegExpIsValid():void {
			var re:RegExp = ModuleAddress.inputSuffixRegExp;
			
			assertMatch(re, "A/A0/INPUT");
			assertNoMatch(re, "A/A0");
			assertMatch(re, "A/*/INPUT");
			assertNoMatch(re, "A/*");
			
			assertNoMatch(re, "A/A0/INPUT/foo");
			assertNoMatch(re, "A/A0INPUT/foo");
		}

		public function testModuleAddressOutputRegExpIsValid():void {
			var re:RegExp = ModuleAddress.outputSuffixRegExp;
			
			assertMatch(re, "A/A0/OUTPUT");
			assertNoMatch(re, "A/A0");
			assertMatch(re, "A/*/OUTPUT");
			assertNoMatch(re, "A/*");
			
			assertNoMatch(re, "A/A0/OUTPUT/foo");
			assertNoMatch(re, "A/A0OUTPUT/foo");
		}
	}
}
