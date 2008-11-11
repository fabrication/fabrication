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
 
package org.puremvc.as3.multicore.utilities.fabrication.core {
	import flexunit.framework.SimpleTestCase;
	
	import org.puremvc.as3.multicore.core.Model;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.facade.FabricationFacadeMock;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.proxy.FabricationProxy;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.proxy.FabricationProxyMock;
	import org.puremvc.as3.multicore.utilities.fabrication.utils.HashMap;	

	/**
	 * @author Darshan Sawardekar
	 */
	public class FabricationModelTest extends SimpleTestCase {
		
		/* *
		static public function suite():TestSuite {
			var suite:TestSuite = new TestSuite();
			suite.addTest(new FabricationModelTest("testFabricationModelDisposesProxiesOnItsDisposal"));
			return suite;
		}
		/* */
		
		private var facade:FabricationFacadeMock;
		private var fabricationModel:FabricationModel;
		
		public function FabricationModelTest(method:String) {
			super(method);
		}
		
		override public function setUp():void {
			facade = FabricationFacadeMock.getInstance(methodName + "_setup");
			fabricationModel = new FabricationModel(methodName + "_setup");
			
			var cache:HashMap = new HashMap();
			facade.mock.method("hasInstance").withArgs(String).returns(cache);
			facade.mock.method("saveInstance").withArgs(String, Object).returns(cache);
			facade.mock.method("findInstance").withArgs(String).returns(cache);
		}
		
		override public function tearDown():void {
			fabricationModel.dispose();
			fabricationModel = null;
		}
		
		public function testFabricationModelHasValidType():void {
			assertType(FabricationModel, fabricationModel);
			assertType(IDisposable, fabricationModel);
			assertType(Model, fabricationModel);
		}
		
		public function testFabricationModelIsCachedByItsMultitonKey():void {
			var sampleSize:int = 25;
			var model:FabricationModel;
			var i:int = 0;
			var j:int = 0;
			var key:String;
			
			for (i = 0; i < sampleSize; i++) {
				key = methodName + "_model" + i;
				model = FabricationModel.getInstance(key);
				for (j = 0; j < sampleSize; j++) {
					assertEquals(model, FabricationModel.getInstance(key));
				}
			}
		}
		
		public function testFabricationModelStoresProxiesAccurately():void {
			var sampleSize:int = 25;
			var i:int = 0;
			var j:int = 0;
			var key:String;
			var proxy:FabricationProxy;
			
			for (i = 0; i < sampleSize; i++) {
				key = methodName + "_proxy" + i;
				proxy = new FabricationProxy(key);
				fabricationModel.registerProxy(proxy);
				for (j = 0; j < sampleSize; j++) {
					assertTrue(fabricationModel.hasProxy(key));
					assertFalse(fabricationModel.hasProxy("no_such_key" + key));
				}
			}
		}
		
		public function testFabricationModelCanRemoveProxiesAccurately():void {
			var sampleSize:int = 25;
			var i:int = 0;
			var key:String;
			var proxy:FabricationProxy;
			
			for (i = 0; i < sampleSize; i++) {
				key = methodName + "_proxy" + i;
				proxy = new FabricationProxy(key);
				fabricationModel.registerProxy(proxy);
				
				assertTrue(fabricationModel.hasProxy(key));
				assertEquals(proxy, fabricationModel.removeProxy(key));
				assertFalse(fabricationModel.hasProxy(key));
			}
		}
		
		public function testFabricationModelDisposesProxiesOnItsDisposal():void {
			var fabricationModel:FabricationModel = new FabricationModel(methodName);
			var proxy:FabricationProxyMock;
			var sampleSize:int = 25;
			var proxyList:Array = new Array();
			var i:int;
			var proxyName:String; 
			
			for (i = 0; i < sampleSize; i++) {
				proxyName = methodName + "_proxy" + i;
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
				verifyMock(proxy.mock);
			}
		}
		
		public function testFabricationModelRemovesMultitonOnDisposal():void {
			var key:String = methodName;
			var fabricationModel:FabricationModel = FabricationModel.getInstance(key);
			assertEquals(fabricationModel, FabricationModel.getInstance(key));
			
			fabricationModel.dispose();
			
			assertNotEquals(fabricationModel, FabricationModel.getInstance(key));
		}
		
		public function testFabricationModelResetsAfterDisposal():void {
			var fabricationModel:FabricationModel = FabricationModel.getInstance(methodName);
			fabricationModel.dispose();
			
			assertThrows(Error);
			fabricationModel.registerProxy(new FabricationProxyMock("x"));
		}
		
	}
}
