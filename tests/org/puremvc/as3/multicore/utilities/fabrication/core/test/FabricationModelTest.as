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

package org.puremvc.as3.multicore.utilities.fabrication.core.test {
    import org.puremvc.as3.multicore.core.Model;
    import org.puremvc.as3.multicore.utilities.fabrication.addons.BaseTestCase;
    import org.puremvc.as3.multicore.utilities.fabrication.core.*;
    import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.facade.mock.FacadeMock;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.proxy.FabricationProxy;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.proxy.mock.FabricationProxyMock;
    import org.puremvc.as3.multicore.utilities.fabrication.utils.HashMap;

    /**
     * @author Darshan Sawardekar
     */
    public class FabricationModelTest extends BaseTestCase{


        private var facade:FacadeMock;
        private var fabricationModel:FabricationModel;



        [Before]
        public function setUp():void
        {

            facade = FacadeMock.getInstance(instanceName + "_setup");
            fabricationModel = new FabricationModel(instanceName + "_setup");

            var cache:HashMap = new HashMap();
            facade.mock.method("hasInstance").withArgs(String).returns(cache);
            facade.mock.method("saveInstance").withArgs(String, Object).returns(cache);
            facade.mock.method("findInstance").withArgs(String).returns(cache);
        }

        [After]
        public function tearDown():void
        {

            fabricationModel.dispose();
            fabricationModel = null;
        }

        [Test]
        public function fabricationModelHasValidType():void
        {
            assertType(FabricationModel, fabricationModel);
            assertType(IDisposable, fabricationModel);
            assertType(Model, fabricationModel);
        }

        [Test]
        public function fabricationModelIsCachedByItsMultitonKey():void
        {
            var sampleSize:int = 25;
            var model:FabricationModel;
            var i:int = 0;
            var j:int = 0;
            var key:String;

            for (i = 0; i < sampleSize; i++) {
                key = instanceName + "_model" + i;
                model = FabricationModel.getInstance(key);
                for (j = 0; j < sampleSize; j++) {
                    assertEquals(model, FabricationModel.getInstance(key));
                }
            }
        }

        [Test]
        public function fabricationModelStoresProxiesAccurately():void
        {
            var sampleSize:int = 25;
            var i:int = 0;
            var j:int = 0;
            var key:String;
            var proxy:FabricationProxy;

            for (i = 0; i < sampleSize; i++) {
                key = instanceName + "_proxy" + i;
                proxy = new FabricationProxy(key);
                fabricationModel.registerProxy(proxy);
                for (j = 0; j < sampleSize; j++) {
                    assertTrue(fabricationModel.hasProxy(key));
                    assertFalse(fabricationModel.hasProxy("no_such_key" + key));
                }
            }
        }

        [Test]
        public function fabricationModelCanRemoveProxiesAccurately():void
        {
            var sampleSize:int = 25;
            var i:int = 0;
            var key:String;
            var proxy:FabricationProxy;

            for (i = 0; i < sampleSize; i++) {
                key = instanceName + "_proxy" + i;
                proxy = new FabricationProxy(key);
                fabricationModel.registerProxy(proxy);

                assertTrue(fabricationModel.hasProxy(key));
                assertEquals(proxy, fabricationModel.removeProxy(key));
                assertFalse(fabricationModel.hasProxy(key));
            }
        }

        [Test]
        public function fabricationModelDisposesProxiesOnItsDisposal():void
        {
            var fabricationModel:FabricationModel = new FabricationModel(instanceName);
            var proxy:FabricationProxyMock;
            var sampleSize:int = 25;
            var proxyList:Array = new Array();
            var i:int;
            var proxyName:String;

            for (i = 0; i < sampleSize; i++) {
                proxyName = instanceName + "_proxy" + i;
                proxy = new FabricationProxyMock(proxyName);
                proxy.mock.ignoreMissing = true;
                proxy.mock.method("dispose").withNoArgs.once;
                proxy.mock.method("getProxyName").withNoArgs.returns(proxyName);

                fabricationModel.registerProxy(proxy);
                proxyList.push(proxy);
            }

            fabricationModel.dispose();

            for (i = 0; i < sampleSize; i++) {
                proxy = proxyList[i];

                verifyMock( proxy.mock );
            }
        }

        [Test]
        public function fabricationModelRemovesMultitonOnDisposal():void
        {
            var key:String = instanceName;
            var fabricationModel:FabricationModel = FabricationModel.getInstance(key);
            assertEquals(fabricationModel, FabricationModel.getInstance(key));

            fabricationModel.dispose();

            assertObjectEquals( fabricationModel, FabricationModel.getInstance(key) );
        }

        [Test(expects="Error")]
        public function fabricationModelResetsAfterDisposal():void
        {
            
            var fabricationModel:FabricationModel = FabricationModel.getInstance(instanceName);
            fabricationModel.dispose();

            fabricationModel.registerProxy(new FabricationProxyMock("x"));
        }

    }
}
