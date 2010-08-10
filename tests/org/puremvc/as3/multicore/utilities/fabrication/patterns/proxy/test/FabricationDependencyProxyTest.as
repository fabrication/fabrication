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

package org.puremvc.as3.multicore.utilities.fabrication.patterns.proxy.test {
    import org.puremvc.as3.multicore.utilities.fabrication.addons.BaseTestCase;
    import org.puremvc.as3.multicore.utilities.fabrication.components.mock.FabricationMock;
    import org.puremvc.as3.multicore.utilities.fabrication.fabrication_internal;
    import org.puremvc.as3.multicore.utilities.fabrication.injection.provider.DependencyProvider;
    import org.puremvc.as3.multicore.utilities.fabrication.logging.Log;
    import org.puremvc.as3.multicore.utilities.fabrication.logging.Logger;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.facade.mock.FacadeMock;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.proxy.*;
    import org.puremvc.as3.multicore.utilities.fabrication.utils.HashMap;

    /**
     * @author Darshan Sawardekar
     */
    public class FabricationDependencyProxyTest extends BaseTestCase {

        use namespace fabrication_internal;

        public var proxy:FabricationDependencyProxy;
        public var facade:FacadeMock;
        public var fabrication:FabricationMock;
        private var dependenciesProvider1:DependencyProvider;
        private var dependenciesProvider2:DependencyProvider;

        [Before]
        public function setUp():void
        {
            fabrication = new FabricationMock();
            facade = FacadeMock.getInstance(instanceName + "_setup");

            var cache:HashMap = new HashMap();
            facade.mock.method("hasInstance").withArgs(String).returns(cache);
            facade.mock.method("saveInstance").withArgs(String, Object).returns(cache);
            facade.mock.method("findInstance").withArgs(String).returns(cache);
            facade.mock.method("getFabrication").withNoArgs.returns(fabrication);

            dependenciesProvider1 = new DependencyProvider();
            dependenciesProvider1.addDependency("DP1", "string");
            dependenciesProvider1.addDependency([ 1,2,3,4], "array");

            dependenciesProvider2 = new DependencyProvider();
            dependenciesProvider2.addDependency( Log.getLogger(), "logger");

            proxy = new FabricationDependencyProxy();
            proxy.initializeNotifier(instanceName + "_setup");
            proxy.addDependecyProvider( dependenciesProvider1 );
            proxy.addDependecyProvider( dependenciesProvider2 );


        }

        [After]
        public function tearDown():void
        {
            proxy.dispose();
            proxy = null;
        }

        [Test]
        public function fabricationDependencyTest():void
        {

            assertType(FabricationDependencyProxy, proxy);

        }

        [Test]
        public function fabricationDependencyProxyGetDependencyTest():void {


            assertType( String, proxy.getDependency( "string" ) );
            assertType( Array, proxy.getDependency( "array" ) );
            assertType( Logger, proxy.getDependency( "logger" ) );

        }
    }
}
