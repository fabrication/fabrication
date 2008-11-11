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
 
package org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator {
	import flexunit.framework.SimpleTestCase;
	
	import com.anywebcam.mock.Mock;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	import org.puremvc.as3.multicore.patterns.observer.Notification;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	import org.puremvc.as3.multicore.utilities.fabrication.components.FabricationMock;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IMockable;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.facade.FabricationFacadeMock;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.resolver.ComponentRouteMapper;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.proxy.FabricationProxy;
	import org.puremvc.as3.multicore.utilities.fabrication.routing.RouterMock;
	import org.puremvc.as3.multicore.utilities.fabrication.utils.HashMap;		

	/**
	 * @author Darshan Sawardekar
	 */
	public class FabricationMediatorTest extends SimpleTestCase {

		static public var count:int = 0;
		
		public var multitonKey:String;
		public var mediator:FabricationMediator;
		public var facade:FabricationFacadeMock;
		public var fabrication:FabricationMock;
		
		public function FabricationMediatorTest(method:String) {
			super(method);
		}
		
		override public function setUp():void {
			multitonKey = methodName + "_setup" + (count++);
			fabrication = new FabricationMock();
			facade = FabricationFacadeMock.getInstance(multitonKey);
			mediator = createMediator();
		}
		
		override public function tearDown():void {
			mediator = null;
		}
		
		public function createMediator():FabricationMediator {
			return new FabricationMediatorTestMock();
		}
		
		public function testFabricationMediatorHasValidType():void {
			assertType(FabricationMediator, mediator);
			assertType(Mediator, mediator);
			assertType(IDisposable, mediator);
		}
		
		public function testSimpleFabricationMediatorAliasMethodsAreValid():void {
			var router:RouterMock = new RouterMock();
			var proxy0:Proxy = new Proxy("p0");
			var proxy1:Proxy = new Proxy("p1");
			var mediator0:Mediator = new Mediator("m0");
			var mediator1:Mediator = new Mediator("m1");
			var body:Object = new Object();
			
			facade.mock.method("getFabrication").withNoArgs.returns(fabrication).atLeast(1);
			fabrication.mock.property("router").returns(router);
			
			facade.mock.method("retrieveProxy").withArgs("p0").returns(proxy0).once;
			facade.mock.method("hasProxy").withArgs("p2").returns(false).once;
			
			facade.mock.method("registerMediator").withArgs(mediator0).returns(mediator0).once;
			facade.mock.method("retrieveMediator").withArgs("m0").returns(mediator0).once;
			facade.mock.method("removeMediator").withArgs("m1").returns(mediator1).once;
			facade.mock.method("hasMediator").withArgs("m2").returns(false).once;
			
			facade.mock.method("routeNotification").withArgs("n0", nullarg, nullarg, nullarg).once;	
			facade.mock.method("routeNotification").withArgs("n0", "b0", nullarg, nullarg).once;	
			facade.mock.method("routeNotification").withArgs("n0", "b0", "t0", nullarg).once;	
			facade.mock.method("routeNotification").withArgs("n0", "b0", "t0", "A/*").once;
			
			mediator.initializeNotifier(multitonKey);
			
			assertEquals(mediator.fabFacade, facade);
			assertEquals(mediator.fabrication, fabrication);
			assertEquals(mediator.applicationRouter, router);
			
			assertEquals(proxy0, mediator.retrieveProxy("p0"));
			assertFalse(mediator.hasProxy("p2"));
			
			assertEquals(mediator0, mediator.registerMediator(mediator0));
			assertEquals(mediator0, mediator.retrieveMediator("m0"));
			assertEquals(mediator1, mediator.removeMediator("m1"));
			assertFalse(mediator.hasMediator("m2"));
			
			mediator.routeNotification("n0");
			mediator.routeNotification("n0", "b0");
			mediator.routeNotification("n0", "b0", "t0");
			mediator.routeNotification("n0", "b0", "t0", "A/*");	
			
			verifyMock(facade.mock);
			verifyMock(fabrication.mock);
		}
		
		public function testFabricationMediatorHasDefaultNotificationHandlerPrefix():void {
			assertNotNull(FabricationMediator.DEFAULT_NOTIFICATION_HANDLER_PREFIX);
			assertType(String, FabricationMediator.DEFAULT_NOTIFICATION_HANDLER_PREFIX);
		}
		
		public function testFabricationMediatorFirstCharacterRegularExpressionIsValid():void {
			var re:RegExp = FabricationMediator.firstCharRegExp;
			assertMatch(re, "xyz");
			assertEquals("a", re.exec("abcd")[1]);
			assertEquals("t", re.exec(methodName)[1]);
			assertEquals("0", re.exec("012345")[1]);
		}
		
		public function testFabricationMediatorNotePartRegularExpressionIsValid():void {
			var re:RegExp = FabricationMediator.notePartRegExp;
			assertMatch(re, "a/b");
			assertNoMatch(re, "abc");
			assertMatch(re, "Proxy/Note");
			assertNoMatch(re, "Note");
		}
		
		public function testFabricationMediatorProxyNameRegularExpressionIsValid():void {
			var re:RegExp = FabricationMediator.proxyNameRegExp;
			assertMatch(re, "respondToMyProxy");
			assertNoMatch(re, "respondToMyNote");
			assertMatch(re, "respondToProxy1");
			assertMatch(re, "respondToProxyValue");
		}
		
		public function testFabricationMediatorHasNotificationCacheKey():void {
			assertNotNull(FabricationMediator.notificationCacheKey);
			assertType(String, FabricationMediator.notificationCacheKey);
		}
		
		public function testFabricationMediatorHasRouteMapperKey():void {
			assertNotNull(FabricationMediator.routeMapperKey);
			assertType(String, FabricationMediator.routeMapperKey);
		}
		
		public function testFabricationMediatorNotificationReflectionIsValidWithRespondToNoteAndRespondToProxySyntax():void {
			var notificationCache:HashMap = new HashMap();
			var routeMapper:ComponentRouteMapper = new ComponentRouteMapper();
			
			facade.mock.method("hasInstance").withArgs(String).returns(true).atLeast(1);
			facade.mock.method("findInstance").withArgs(FabricationMediator.notificationCacheKey).returns(notificationCache).atLeast(1);
			facade.mock.method("findInstance").withArgs(FabricationMediator.routeMapperKey).returns(routeMapper).atLeast(1);
			facade.mock.method("getFabrication").withNoArgs.returns(fabrication);
			fabrication.mock.method("getClassByName").withArgs(String).returns(FabricationMediatorTestMock).atLeast(1);
			
			var expectedInterests:Array = [
				"note",
				"note1",
				"note2",
				FabricationProxy.NOTIFICATION_FROM_PROXY
			];

			mediator.initializeNotifier(multitonKey);			
			var actualInterests:Array = mediator.listNotificationInterests();
			
			expectedInterests.sort();
			actualInterests.sort();
			
			assertArrayEquals(expectedInterests, actualInterests);
			
			verifyMock(facade.mock);
			verifyMock(fabrication.mock);
		}
		
		public function testFabricationMediatorNotificationReflectionIsValidWithOnlyRespondToNoteSyntax():void {
			var mediator:FabricationMediator = new FabricationMediatorTestMockWithoutProxyInterests(methodName);
			var notificationCache:HashMap = new HashMap();
			var routeMapper:ComponentRouteMapper = new ComponentRouteMapper();
			
			facade.mock.method("hasInstance").withArgs(String).returns(true).atLeast(1);
			facade.mock.method("findInstance").withArgs(FabricationMediator.notificationCacheKey).returns(notificationCache).atLeast(1);
			facade.mock.method("findInstance").withArgs(FabricationMediator.routeMapperKey).returns(routeMapper).atLeast(1);
			facade.mock.method("getFabrication").withNoArgs.returns(fabrication);
			fabrication.mock.method("getClassByName").withArgs(String).returns(FabricationMediatorTestMock).atLeast(1);
			
			var expectedInterests:Array = [
				"note",
				"note1",
				"note2",
			];

			mediator.initializeNotifier(multitonKey);			
			var actualInterests:Array = mediator.listNotificationInterests();
			
			expectedInterests.sort();
			actualInterests.sort();
			
			assertArrayEquals(expectedInterests, actualInterests);
			
			verifyMock(facade.mock);
			verifyMock(fabrication.mock);
		}
		
		public function testFabricationMediatorNotificationReflectionIsValidWithOnlyRespondToProxySyntax():void {
			var mediator:FabricationMediator = new FabricationMediatorTestMockWithOnlyProxyInterests(methodName);
			var notificationCache:HashMap = new HashMap();
			var routeMapper:ComponentRouteMapper = new ComponentRouteMapper();
			
			facade.mock.method("hasInstance").withArgs(String).returns(true).atLeast(1);
			facade.mock.method("findInstance").withArgs(FabricationMediator.notificationCacheKey).returns(notificationCache).atLeast(1);
			facade.mock.method("findInstance").withArgs(FabricationMediator.routeMapperKey).returns(routeMapper).atLeast(1);
			facade.mock.method("getFabrication").withNoArgs.returns(fabrication);
			fabrication.mock.method("getClassByName").withArgs(String).returns(FabricationMediatorTestMock).atLeast(1);
			
			var expectedInterests:Array = [
				FabricationProxy.NOTIFICATION_FROM_PROXY
			];

			mediator.initializeNotifier(multitonKey);			
			var actualInterests:Array = mediator.listNotificationInterests();
			
			assertArrayEquals(expectedInterests, actualInterests);
			
			verifyMock(facade.mock);
			verifyMock(fabrication.mock);
		}
		
		public function testFabricationMediatorNotificationReflectionIsValidWithoutAnyNotificationInterests():void {
			var mediator:FabricationMediator = new FabricationMediatorTestMockWithoutAnyInterests(methodName);
			var notificationCache:HashMap = new HashMap();
			var routeMapper:ComponentRouteMapper = new ComponentRouteMapper();
			
			facade.mock.method("hasInstance").withArgs(String).returns(true).atLeast(1);
			facade.mock.method("findInstance").withArgs(FabricationMediator.notificationCacheKey).returns(notificationCache).atLeast(1);
			facade.mock.method("findInstance").withArgs(FabricationMediator.routeMapperKey).returns(routeMapper).atLeast(1);
			facade.mock.method("getFabrication").withNoArgs.returns(fabrication);
			fabrication.mock.method("getClassByName").withArgs(String).returns(FabricationMediatorTestMock).atLeast(1);
			
			mediator.initializeNotifier(multitonKey);			
			var actualInterests:Array = mediator.listNotificationInterests();
			
			assertTrue(actualInterests.length == 0);
			
			verifyMock(facade.mock);
			verifyMock(fabrication.mock);
		}
		
		public function testFabricationMediatorNotificationReflectionIsValidWithQualifiedProxyNotifications():void {
			var mediator:FabricationMediator = new FabricationMediatorTestMockWithQualifiedProxyInterests(methodName);
			var notificationCache:HashMap = new HashMap();
			var routeMapper:ComponentRouteMapper = new ComponentRouteMapper();
			
			facade.mock.method("hasInstance").withArgs(String).returns(true).atLeast(1);
			facade.mock.method("findInstance").withArgs(FabricationMediator.notificationCacheKey).returns(notificationCache).atLeast(1);
			facade.mock.method("findInstance").withArgs(FabricationMediator.routeMapperKey).returns(routeMapper).atLeast(1);
			facade.mock.method("getFabrication").withNoArgs.returns(fabrication);
			fabrication.mock.method("getClassByName").withArgs(String).returns(FabricationMediatorTestMock).atLeast(1);
			
			var expectedInterests:Array = [
				FabricationProxy.NOTIFICATION_FROM_PROXY
			];
			
			var qualifications:Object = {
				note1:"Proxy1",
				note2:"Proxy2",
				note3:"Proxy3"	
			};

			mediator.initializeNotifier(multitonKey);
			var mediatorMock:Mock = (mediator as IMockable).mock;
			
			mediatorMock.method("qualifyNotificationInterests").withNoArgs.returns(qualifications);			
			var actualInterests:Array = mediator.listNotificationInterests();
			
			expectedInterests.sort();
			actualInterests.sort();
			
			assertArrayEquals(expectedInterests, actualInterests);
			
			verifyMock(facade.mock);
			verifyMock(fabrication.mock);
		}
		
		public function testFabricationMediatorExecutesRespondToProxySyntax():void {
			var mediator:FabricationMediator = new FabricationMediatorTestMockWithQualifiedProxyInterests(methodName);
			var notificationCache:HashMap = new HashMap();
			var routeMapper:ComponentRouteMapper = new ComponentRouteMapper();
			
			facade.mock.method("hasInstance").withArgs(String).returns(true).atLeast(1);
			facade.mock.method("findInstance").withArgs(FabricationMediator.notificationCacheKey).returns(notificationCache).atLeast(1);
			facade.mock.method("findInstance").withArgs(FabricationMediator.routeMapperKey).returns(routeMapper).atLeast(1);
			facade.mock.method("getFabrication").withNoArgs.returns(fabrication);
			
			var qualifications:Object = {
				note1:"Proxy1",
				note2:"Proxy2",
				note3:"Proxy3"	
			};

			mediator.initializeNotifier(multitonKey);
			var mediatorMock:Mock = (mediator as IMockable).mock;
			
			mediatorMock.method("qualifyNotificationInterests").withNoArgs.returns(qualifications);
			mediatorMock.method("respondToProxy1").withArgs(
				function(note:INotification):Boolean {
					assertEquals("Proxy1/note1", note.getName());
					return true;
				}
			).once;
			mediatorMock.method("respondToProxy2").withArgs(
				function(note:INotification):Boolean {
					assertEquals("Proxy2/note2", note.getName());
					return true;
				}
			).once;
			mediatorMock.method("respondToProxy3").withArgs(
				function(note:INotification):Boolean {
					assertEquals("Proxy3/note3", note.getName());
					return true;
				}
			).once;
						
			invokeHandleNotification(mediator, "Proxy1", "note1");
			invokeHandleNotification(mediator, "Proxy2", "note2");
			invokeHandleNotification(mediator, "Proxy3", "note3");

			verifyMock(mediatorMock);			
			verifyMock(facade.mock);
			verifyMock(fabrication.mock);			
		}
		
		public function testFabricationMediatorExecutesRespondToNotificationSyntax():void {
			var mediator:FabricationMediator = new FabricationMediatorTestMock(methodName);
			var notificationCache:HashMap = new HashMap();
			var routeMapper:ComponentRouteMapper = new ComponentRouteMapper();
			
			facade.mock.method("hasInstance").withArgs(String).returns(true).atLeast(1);
			facade.mock.method("findInstance").withArgs(FabricationMediator.notificationCacheKey).returns(notificationCache).atLeast(1);
			facade.mock.method("findInstance").withArgs(FabricationMediator.routeMapperKey).returns(routeMapper).atLeast(1);
			facade.mock.method("getFabrication").withNoArgs.returns(fabrication);
			
			mediator.initializeNotifier(multitonKey);
			var mediatorMock:Mock = (mediator as IMockable).mock;
			
			mediatorMock.method("respondToNote").withArgs(
				function(note:INotification):Boolean {
					assertEquals("note", note.getName());
					return true;
				}
			).once;
			mediatorMock.method("respondToNote1").withArgs(
				function(note:INotification):Boolean {
					assertEquals("note1", note.getName());
					return true;
				}
			).once;
			mediatorMock.method("respondToNote2").withArgs(
				function(note:INotification):Boolean {
					assertEquals("note2", note.getName());
					return true;
				}
			).once;
						
			invokeHandleNotification(mediator, null, "note");
			invokeHandleNotification(mediator, null, "note1");
			invokeHandleNotification(mediator, null, "note2");

			verifyMock(mediatorMock);			
			verifyMock(facade.mock);
			verifyMock(fabrication.mock);			
		}
		
		public function testFabricationProxyCachesNotificationInterests():void {
			var notificationCache:HashMap = new HashMap();
			var routeMapper:ComponentRouteMapper = new ComponentRouteMapper();
			var sampleSize:int = 25;
			
			facade.mock.method("hasInstance").withArgs(String).returns(true).atLeast(1);
			facade.mock.method("findInstance").withArgs(FabricationMediator.notificationCacheKey).returns(notificationCache).atLeast(1);
			facade.mock.method("findInstance").withArgs(FabricationMediator.routeMapperKey).returns(routeMapper).atLeast(1);
			facade.mock.method("getFabrication").withNoArgs.returns(fabrication);
			fabrication.mock.method("getClassByName").withArgs(String).returns(FabricationMediatorTestMock).atLeast(1);
			
			mediator.initializeNotifier(multitonKey);
			
			var actualInterests:Array = mediator.listNotificationInterests();
			
			for (var i:int = 0; i < sampleSize; i++) {
				assertTrue(actualInterests === mediator.listNotificationInterests());
			}
			
			verifyMock(facade.mock);
			verifyMock(fabrication.mock);			
		}
		
		public function invokeHandleNotification(mediator:FabricationMediator, proxyName:String, noteName:String, noteBody:Object = null, noteType:String = null):void {
			if (proxyName != null) {
				noteName = proxyName + "/" + noteName;
			}
			
			var payload:Notification = new Notification(noteName, noteBody, noteType);
		
			if (proxyName == null) {	
				mediator.handleNotification(payload);
			} else {
				var systemNotification:Notification = new Notification(FabricationProxy.NOTIFICATION_FROM_PROXY, payload, proxyName);
				mediator.handleNotification(systemNotification);
			}
		}
		
	}
}
