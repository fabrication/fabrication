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

package org.puremvc.as3.multicore.utilities.fabrication.vo.test {
    import org.puremvc.as3.multicore.utilities.fabrication.addons.BaseTestCase;
    import org.puremvc.as3.multicore.utilities.fabrication.vo.*;

    /**
     * @author Darshan Sawardekar
     */
    public class ModuleAddressTest extends BaseTestCase {

        private var moduleAddress:ModuleAddress;
        private var moduleClassName:String = "MyModule";
        private var moduleInstanceName:String = moduleClassName + "0";

        [Before]
        public function setUp():void
        {
            moduleAddress = new ModuleAddress(moduleClassName, moduleInstanceName);
        }

        [After]
        public function tearDown():void
        {
            moduleAddress.dispose();
            moduleAddress = null;
        }

        [Test]
        public function testInstantiation():void
        {
            assertTrue(moduleAddress is ModuleAddress);
        }

        [Test]
        public function moduleAddressHasClassName():void
        {
            assertEquals(moduleClassName, moduleAddress.getClassName());
        }

        [Test]
        public function moduleAddressHasInstanceName():void
        {
            assertEquals(moduleInstanceName, moduleAddress.getInstanceName());
        }

        [Test]
        public function moduleAddressHasValidInputName():void
        {
            assertEquals(moduleClassName + "/" + moduleInstanceName + ModuleAddress.INPUT_SUFFIX, moduleAddress.getInputName());
        }

        [Test]
        public function moduleAddressHasValidOutputName():void
        {
            assertEquals(moduleClassName + "/" + moduleInstanceName + ModuleAddress.OUTPUT_SUFFIX, moduleAddress.getOutputName());
        }

        [Test]
        public function moduleAddressCanParse2PartSource():void
        {
            moduleAddress.parse("A/A0");
            assertEquals("A", moduleAddress.getClassName());
            assertEquals("A0", moduleAddress.getInstanceName());
        }

        [Test]
        public function moduleAddressCanParse1PartSource():void
        {
            moduleAddress.parse("B");
            assertEquals("B", moduleAddress.getClassName());
        }

        [Test]
        public function moduleAddressGroupNameRegularExpressionIsValid():void
        {
            var re:RegExp = ModuleAddress.groupNameRegExp;

            assertMatch(re, "#myGroup");
            assertNoMatch(re, "#");
            assertNoMatch(re, "A/A0");
            assertNoMatch(re, "A/*");
        }

        [Test]
        public function moduleAddressCanParseGroupNameSource():void
        {
            moduleAddress.parse("A/#myGroup");
            assertEquals("A", moduleAddress.getClassName());
            assertEquals("myGroup", moduleAddress.getGroupName());
        }

        [Test]
        public function moduleAddresHasNullGroupNameWhenSourceHasNoGroup():void
        {
            moduleAddress.parse("A/A0");
            assertEquals("A", moduleAddress.getClassName());
            assertEquals("A0", moduleAddress.getInstanceName());
            assertNull(moduleAddress.getGroupName());
        }

        [Test]
        public function moduleAddressResetsStateAfterParse():void
        {
            moduleAddress.parse("C");
            assertEquals("C", moduleAddress.getClassName());
            assertFalse(moduleInstanceName == moduleAddress.getInstanceName());
            assertNull(moduleAddress.getInstanceName());
        }

        [Test]
        public function moduleAddressIsEqualWithAttributes():void
        {
            var moduleAddress1:ModuleAddress = new ModuleAddress("A", "A0");
            var moduleAddress2:ModuleAddress = new ModuleAddress("A", "A0");
            var moduleAddress3:ModuleAddress = new ModuleAddress("A");
            var moduleAddress4:ModuleAddress = new ModuleAddress("A", "A1");

            assertTrue(moduleAddress1.equals(moduleAddress2));
            assertFalse(moduleAddress1.equals(moduleAddress));
            assertFalse(moduleAddress1.equals(moduleAddress3));
            assertFalse(moduleAddress1.equals(moduleAddress4));
        }

        [Test]
        public function moduleAddressResetsAfterDisposal():void
        {
            var moduleAddress1:ModuleAddress = new ModuleAddress("B", "B0");
            moduleAddress1.dispose();

            assertNull(moduleAddress1.getClassName());
            assertNull(moduleAddress1.getInstanceName());
        }

        [Test]
        public function moduleAddressInputRegExpIsValid():void
        {
            var re:RegExp = ModuleAddress.inputSuffixRegExp;

            assertMatch(re, "A/A0/INPUT");
            assertNoMatch(re, "A/A0");
            assertMatch(re, "A/*/INPUT");
            assertNoMatch(re, "A/*");

            assertNoMatch(re, "A/A0/INPUT/foo");
            assertNoMatch(re, "A/A0INPUT/foo");
        }

        [Test]
        public function moduleAddressOutputRegExpIsValid():void
        {
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
