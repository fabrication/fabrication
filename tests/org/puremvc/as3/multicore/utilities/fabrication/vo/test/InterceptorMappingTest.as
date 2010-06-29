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
    import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.interceptor.mock.InterceptorMock;
    import org.puremvc.as3.multicore.utilities.fabrication.vo.*;

    /**
     * @author Darshan Sawardekar
     */
    public class InterceptorMappingTest extends BaseTestCase {

        public var interceptorMapping:InterceptorMapping;


        [Before]
        public function setUp():void
        {
            interceptorMapping = new InterceptorMapping(instanceName, InterceptorMock);
        }

        [After]
        public function tearDown():void
        {
            interceptorMapping = null;
        }

        [Test]
        public function interceptorMappingHasValidType():void
        {
            assertType(InterceptorMapping, interceptorMapping);
            assertType(IDisposable, interceptorMapping);
        }

        [Test]
        public function interceptorMappingConstructorStoresValuesCorrectly():void
        {
            var noteName:String = "fooNote";
            var clazz:Class = InterceptorMock;
            var parameters:Object = new Object();

            var interceptorMapping:InterceptorMapping = new InterceptorMapping(noteName, clazz, parameters);

            assertEquals(noteName, interceptorMapping.noteName);
            assertEquals(clazz, interceptorMapping.clazz);
            assertEquals(parameters, interceptorMapping.parameters);
        }

        [Test]
        public function interceptorMappingConstructorAllowOptionalParameters():void
        {
            var interceptorMapping:InterceptorMapping = new InterceptorMapping("fooNote", InterceptorMock);
            assertNull(interceptorMapping.parameters);
        }

        [Test]
        public function interceptorMappingResetsOnDisposal():void
        {
            var noteName:String = "fooNote";
            var clazz:Class = InterceptorMock;
            var parameters:Object = new Object();

            var interceptorMapping:InterceptorMapping = new InterceptorMapping(noteName, clazz, parameters);

            interceptorMapping.dispose();

            assertNull(interceptorMapping.noteName);
            assertNull(interceptorMapping.clazz);
            assertNull(interceptorMapping.parameters);
        }

    }
}
