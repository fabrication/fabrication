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
 
package org.puremvc.as3.multicore.utilities.fabrication.patterns.proxy {
	import flexunit.framework.SimpleTestCase;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.observer.Notification;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	import org.puremvc.as3.multicore.utilities.fabrication.components.FabricationMock;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.facade.FabricationFacadeMock;
	import org.puremvc.as3.multicore.utilities.fabrication.utils.HashMap;
	
	import flash.utils.getQualifiedClassName;	

	/**
	 * @author Darshan Sawardekar
	 */
	public class FabricationProxyTest extends SimpleTestCase {
		
		public var proxy:FabricationProxy;
		public var facade:FabricationFacadeMock;
		public var fabrication:FabricationMock;
		
		public function FabricationProxyTest(methodName:String) {
			super(methodName);
		}
		
		override public function setUp():void {
			fabrication = new FabricationMock();
			facade = FabricationFacadeMock.getInstance(methodName + "_setup");
			
			var cache:HashMap = new HashMap();
			facade.mock.method("hasInstance").withArgs(String).returns(cache);
			facade.mock.method("saveInstance").withArgs(String, Object).returns(cache);
			facade.mock.method("findInstance").withArgs(String).returns(cache);
			facade.mock.method("getFabrication").withNoArgs.returns(fabrication);

			proxy = new FabricationProxyTestMock(methodName + "_setup");
			proxy.initializeNotifier(methodName + "_setup");
		}
		
		override public function tearDown():void {
			proxy.dispose();
			proxy = null;
		}
		
		public function testFabricationProxyHasValidType():void {
			assertType(FabricationProxy, proxy);
			assertType(IDisposable, proxy);
			assertType(Proxy, proxy);
		}
		
		public function testFabricationProxyHasSystemNotificationFromProxy():void {
			assertNotNull(FabricationProxy.NOTIFICATION_FROM_PROXY);
			assertType(String, FabricationProxy.NOTIFICATION_FROM_PROXY);
		}
		
		public function testFabricationProxyHasDefaultName():void {
			assertNotNull(FabricationProxy.NAME);
			assertType(String, FabricationProxy.NAME);
		}
		
		public function testFabricationProxyStoresProxyNameCacheKey():void {
			assertNotNull(FabricationProxy.proxyNameCacheKey);
			assertType(String, FabricationProxy.proxyNameCacheKey);
		}
		
		public function testFabricatonProxyClassNameExtractionRegularExpressionIsValid():void {
			var classpath:String = getQualifiedClassName(this);
			assertMatch(FabricationProxy.classRegExp, classpath);
			
			var result:Object = FabricationProxy.classRegExp.exec(classpath);
			assertNotNull(result);
			assertEquals("FabricationProxyTest", result[1]);
		}
		
		public function testFabricationProxyCanSendNotificationsViaFacade():void {
			facade.mock.method("sendNotification").withArgs(String, nullarg, nullarg);
			proxy.sendNotification("n0");

			facade.mock.method("sendNotification").withArgs(String, Object, nullarg);
			proxy.sendNotification("n1", new Object());
			
			facade.mock.method("sendNotification").withArgs(String, Object, String);
			proxy.sendNotification("n2", new Object(), "t0");
			
			verifyMock(facade.mock);
		}
		
		public function testFabricationProxySendsSystemNotificationAfterCustomNotifications():void {
			facade.mock.method("sendNotification").withArgs(proxy.getNotificationName("customNote"), nullarg, nullarg).once;
			facade.mock.method("sendNotification").withArgs(FabricationProxy.NOTIFICATION_FROM_PROXY, INotification, proxy.getProxyName()).once;
			
			proxy.sendNotification("customNote");
			
			verifyMock(facade.mock);
		}
		
		public function testFabricationProxyCanRouteNotificationsViaFacade():void {
			facade.mock.method("routeNotification").withArgs(String, nullarg, nullarg);
			proxy.routeNotification("r0");

			facade.mock.method("routeNotification").withArgs(String, Object, nullarg);
			proxy.routeNotification("r1", new Object());
			
			facade.mock.method("routeNotification").withArgs(String, Object, String);
			proxy.routeNotification("r2", new Object(), "t0");
			
			facade.mock.method("routeNotification").withArgs(String, Object, String, String);
			proxy.routeNotification("r3", new Object(), "t0", "A/A0/INPUT");
			
			facade.mock.method("routeNotification").withArgs(INotification);
			proxy.routeNotification(new Notification("c0", new Object(), "ct0"));
			
			verifyMock(facade.mock);
		}
		
		public function testFabricationProxyExpandsNotificationsWhenExpansionIsOn():void {
			assertTrue(proxy.expansion);
			
			assertContained("/note", proxy.getNotificationName("note"));
			assertContained(proxy.getProxyName(), proxy.getNotificationName("note"));
			assertEquals(proxy.getProxyName() + "/note", proxy.getNotificationName("note"));
		}
		
		public function testFabricationProxyDoesNotExpandNotificationsWhenExpansionIsOff():void {
			proxy.expansion = false;
			
			assertNotContained("/note", proxy.getNotificationName("note"));
			assertNotContained(proxy.getProxyName(), proxy.getNotificationName("note"));
			assertNotEquals(proxy.getProxyName() + "/note", proxy.getNotificationName("note"));
			assertEquals("note", proxy.getNotificationName("note"));
		}
		
		public function testFabricationProxyFindsProxyNameFromNAMEConstantWhenPresent():void {
			proxy = new FabricationProxyTestMock();
			proxy.initializeNotifier(methodName + "_setup");
			
			assertEquals(FabricationProxyTestMock.NAME, proxy.getDefaultProxyName());
		}
		
		public function testFabricationProxyFindsProxyNameFromNameOfClassIfNAMEIsNotPresent():void {
			proxy = new UnnamedFabricationProxyTestMock();
			proxy.initializeNotifier(methodName + "_setup");
			
			assertEquals("UnnamedFabricationProxyTestMock", proxy.getDefaultProxyName()); 
		}
		
		public function testFabricationProxyCachesProxyNameReflection():void {
			proxy = new FabricationProxyTestMock();
			proxy.initializeNotifier(methodName + "_setup");			
			
			fabrication.mock.method("getClassByName").withArgs(String).returns(FabricationProxyTestMock).once;
			
			var sampleSize:int = 25;
			var proxyName:String = proxy.getDefaultProxyName(); 
			
			for (var i:int = 0; i < sampleSize; i++) {
				assertEquals(proxyName, proxy.getDefaultProxyName());
			}
			
			verifyMock(fabrication.mock);
		}
	}
}
