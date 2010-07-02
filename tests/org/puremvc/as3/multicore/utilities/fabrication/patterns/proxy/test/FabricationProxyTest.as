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

package org.puremvc.as3.multicore.utilities.fabrication.patterns.proxy.test {
    import flash.utils.getQualifiedClassName;

    import mx.utils.UIDUtil;

    import org.puremvc.as3.multicore.interfaces.INotification;
    import org.puremvc.as3.multicore.interfaces.IProxy;
    import org.puremvc.as3.multicore.patterns.observer.Notification;
    import org.puremvc.as3.multicore.patterns.proxy.Proxy;
    import org.puremvc.as3.multicore.utilities.fabrication.addons.BaseTestCase;
    import org.puremvc.as3.multicore.utilities.fabrication.components.mock.FabricationMock;
    import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.facade.mock.FacadeMock;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.proxy.*;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.proxy.mock.FabricationProxyTestMock;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.proxy.mock.UnnamedFabricationProxyTestMock;
    import org.puremvc.as3.multicore.utilities.fabrication.utils.HashMap;

    /**
     * @author Darshan Sawardekar
     */
    public class FabricationProxyTest extends BaseTestCase {

        public var proxy:FabricationProxyTestMock;
        public var facade:FacadeMock;
        public var fabrication:FabricationMock;

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

            proxy = new FabricationProxyTestMock(instanceName + "_setup");
            proxy.initializeNotifier(instanceName + "_setup");
        }

        [After]
        public function tearDown():void
        {
            proxy.dispose();
            proxy = null;
        }

        [Test]
        public function testFabricationProxyHasValidType():void
        {
            assertType(FabricationProxy, proxy);
            assertType(IDisposable, proxy);
            assertType(Proxy, proxy);
        }

        [Test]
        public function testFabricationProxyHasSystemNotificationFromProxy():void
        {
            assertNotNull(FabricationProxy.NOTIFICATION_FROM_PROXY);
            assertType(String, FabricationProxy.NOTIFICATION_FROM_PROXY);
        }

        [Test]
        public function testFabricationProxyHasDefaultName():void
        {
            assertNotNull(FabricationProxy.NAME);
            assertType(String, FabricationProxy.NAME);
        }

        [Test]
        public function testFabricationProxyStoresProxyNameCacheKey():void
        {
            assertNotNull(FabricationProxy.proxyNameCacheKey);
            assertType(String, FabricationProxy.proxyNameCacheKey);
        }

        [Test]
        public function testFabricatonProxyClassNameExtractionRegularExpressionIsValid():void
        {
            var classpath:String = getQualifiedClassName(this);
            assertMatch(FabricationProxy.classRegExp, classpath);

            var result:Object = FabricationProxy.classRegExp.exec(classpath);
            assertNotNull(result);
            assertEquals("FabricationProxyTest", result[1]);
        }

        [Test]
        public function testFabricationProxyCanSendNotificationsViaFacade():void
        {
            facade.mock.method("sendNotification").withArgs(String, nullarg, nullarg);
            proxy.sendNotification("n0");

            facade.mock.method("sendNotification").withArgs(String, Object, nullarg);
            proxy.sendNotification("n1", new Object());

            facade.mock.method("sendNotification").withArgs(String, Object, String);
            proxy.sendNotification("n2", new Object(), "t0");

            verifyMock(facade.mock);
        }

        [Test]
        public function testFabricationProxySendsSystemNotificationAfterCustomNotifications():void
        {
            facade.mock.method("sendNotification").withArgs(proxy.getNotificationName("customNote"), nullarg, nullarg).once;
            facade.mock.method("sendNotification").withArgs(FabricationProxy.NOTIFICATION_FROM_PROXY, INotification, proxy.getProxyName()).once;

            proxy.sendNotification("customNote");

            verifyMock(facade.mock);
        }

        [Test]
        public function testFabricationProxyCanRouteNotificationsViaFacade():void
        {
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

        [Test]
        public function testFabricationProxyExpandsNotificationsWhenExpansionIsOn():void
        {
            assertTrue(proxy.expansion);

            assertContained("/note", proxy.getNotificationName("note"));
            assertContained(proxy.getProxyName(), proxy.getNotificationName("note"));
            assertEquals(proxy.getProxyName() + "/note", proxy.getNotificationName("note"));
        }

        [Test]
        public function testFabricationProxyDoesNotExpandNotificationsWhenExpansionIsOff():void
        {
            proxy.expansion = false;

            assertNotContained("/note", proxy.getNotificationName("note"));
            assertNotContained(proxy.getProxyName(), proxy.getNotificationName("note"));
            assertNotEquals(proxy.getProxyName() + "/note", proxy.getNotificationName("note"));
            assertEquals("note", proxy.getNotificationName("note"));
        }

        [Test]
        public function testFabricationProxyFindsProxyNameFromNAMEConstantWhenPresent():void
        {
            proxy = new FabricationProxyTestMock();
            proxy.initializeNotifier(instanceName + "_setup");

            assertEquals(FabricationProxyTestMock.NAME, proxy.getDefaultProxyName());
        }

        [Test]
        public function testFabricationProxyFindsProxyNameFromNameOfClassIfNAMEIsNotPresent():void
        {
            proxy = new UnnamedFabricationProxyTestMock();
            proxy.initializeNotifier(instanceName + "_setup");

            assertEquals("UnnamedFabricationProxyTestMock", proxy.getDefaultProxyName());
        }

        [Test]
        public function testFabricationProxyCachesProxyNameReflection():void
        {
            proxy = new FabricationProxyTestMock();
            proxy.initializeNotifier(instanceName + "_setup");

            fabrication.mock.method("getClassByName").withArgs(String).returns(FabricationProxyTestMock).once;

            var sampleSize:int = 25;
            var proxyName:String = proxy.getDefaultProxyName();

            for (var i:int = 0; i < sampleSize; i++) {
                assertEquals(proxyName, proxy.getDefaultProxyName());
            }

            verifyMock(fabrication.mock);
        }

        [Test]
        public function proxyInjection():void {

            facade.mock.method( "hasProxy" ).withArgs( "MyProxy" ).returns( true );
            facade.mock.method( "retrieveProxy" ).withArgs( "MyProxy" ).returns( new FabricationProxy( instanceName + UIDUtil.createUID() ) );

            var proxyWithInjection:FabricationProxyTestMock = new FabricationProxyTestMock( instanceName );
            proxyWithInjection.initializeNotifier(instanceName + "_setup");
            proxyWithInjection.onRegister();
            assertNotNull( proxyWithInjection.injectedProxy );
            assertTrue( FabricationProxy, proxyWithInjection.injectedProxy );

            assertNotNull( proxyWithInjection.injectedProxyByName );
            assertTrue( IProxy, proxyWithInjection.injectedProxy );

            proxyWithInjection.dispose();
            assertNull( proxyWithInjection.injectedProxy );
            assertNull( proxyWithInjection.injectedProxyByName );

            verifyMock( facade.mock );
        }
    }
}
