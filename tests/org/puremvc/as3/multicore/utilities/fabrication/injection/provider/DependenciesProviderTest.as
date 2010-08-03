/**
 * Copyright (C) 2010 Rafał Szemraj.
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

package org.puremvc.as3.multicore.utilities.fabrication.injection.provider {
    import org.puremvc.as3.multicore.utilities.fabrication.addons.BaseTestCase;
    import org.puremvc.as3.multicore.utilities.fabrication.injection.provider.mock.ActionScriptProvider;
    import org.puremvc.as3.multicore.utilities.fabrication.injection.provider.mock.MXMLProvider;

    public class DependenciesProviderTest extends BaseTestCase {

        private var asProvider:ActionScriptProvider;
        private var mxmlProvider:MXMLProvider;

        [Before]
        public function setUp():void
        {

            asProvider = new ActionScriptProvider();
            mxmlProvider = new MXMLProvider();

        }

        [After]
        public function tearDown():void
        {

            asProvider.dispose();
            asProvider = null;
            mxmlProvider.dispose();
            mxmlProvider = null;

        }

        [Test]
        public function dependenciesProviderGetDependencyTest():void
        {

            assertNotNull(mxmlProvider.getDependency("array"));
            assertType(Array, mxmlProvider.getDependency("array") );

            assertNotNull(asProvider.getDependency("array"));
            assertType(Array, asProvider.getDependency("array") );

            var testObject:Object = { test:"test" };

            asProvider.addDependency( testObject, "testObject" );
            mxmlProvider.addDependency( testObject, "testObject" );

            assertEquals( testObject, mxmlProvider.getDependency("testObject"));
            assertEquals( testObject, asProvider.getDependency("testObject"));

        }
    }
}