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

package org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.test {
    import com.anywebcam.mock.Mock;

    import flash.events.Event;
    import flash.events.IEventDispatcher;

    import mx.core.UIComponent;

    import org.puremvc.as3.multicore.interfaces.INotification;
    import org.puremvc.as3.multicore.patterns.mediator.Mediator;
    import org.puremvc.as3.multicore.patterns.observer.Notification;
    import org.puremvc.as3.multicore.patterns.proxy.Proxy;
    import org.puremvc.as3.multicore.utilities.fabrication.addons.BaseTestCase;
    import org.puremvc.as3.multicore.utilities.fabrication.addons.IMockable;
    import org.puremvc.as3.multicore.utilities.fabrication.components.mock.FabricationMock;
    import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.facade.mock.FacadeMock;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.*;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.mock.FabricationMediatorMock;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.mock.FabricationMediatorTestMock;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.mock.FabricationMediatorTestMockWithOnlyProxyInterests;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.mock.FabricationMediatorTestMockWithQualifiedProxyInterests;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.mock.FabricationMediatorTestMockWithReactions;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.mock.FabricationMediatorTestMockWithoutAnyInterests;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.mock.FabricationMediatorTestMockWithoutProxyInterests;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.resolver.ComponentRouteMapper;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.proxy.FabricationProxy;
    import org.puremvc.as3.multicore.utilities.fabrication.routing.mock.RouterMock;
    import org.puremvc.as3.multicore.utilities.fabrication.utils.HashMap;

    /**
     * @author Darshan Sawardekar
     */
    public class FabricationMediatorTest extends BaseTestCase {

        static public var count:int = 0;

        public var multitonKey:String;
        public var mediator:FabricationMediator;
        public var facade:FacadeMock;
        public var fabrication:FabricationMock;

        [Before]
        public function setUp():void
        {
            multitonKey = instanceName + "_setup" + (count++);
            fabrication = new FabricationMock();
            facade = FacadeMock.getInstance(multitonKey);
            mediator = createMediator();
        }

        [After]
        public function tearDown():void
        {
            mediator = null;
        }

        public function createMediator():FabricationMediator
        {
            return new FabricationMediatorTestMock();
        }

        [Test]
        public function fabricationMediatorHasValidType():void
        {
            assertType(FabricationMediator, mediator);
            assertType(Mediator, mediator);
            assertType(IDisposable, mediator);
        }

        [Test]
        public function simpleFabricationMediatorAliasMethodsAreValid():void
        {
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

        [Test]
        public function fabricationMediatorHasDefaultNotificationHandlerPrefix():void
        {
            assertNotNull(FabricationMediator.DEFAULT_NOTIFICATION_HANDLER_PREFIX);
            assertType(String, FabricationMediator.DEFAULT_NOTIFICATION_HANDLER_PREFIX);
        }

        [Test]
        public function fabricationMediatorFirstCharacterRegularExpressionIsValid():void
        {
            var re:RegExp = FabricationMediator.firstCharRegExp;
            assertMatch(re, "xyz");
            assertEquals("a", re.exec("abcd")[1]);
            assertEquals("0", re.exec("012345")[1]);
        }

        [Test]
        public function fabricationMediatorNotePartRegularExpressionIsValid():void
        {
            var re:RegExp = FabricationMediator.notePartRegExp;
            assertMatch(re, "a/b");
            assertNoMatch(re, "abc");
            assertMatch(re, "Proxy/Note");
            assertNoMatch(re, "Note");
        }

        [Test]
        public function fabricationMediatorProxyNameRegularExpressionIsValid():void
        {
            var re:RegExp = FabricationMediator.proxyNameRegExp;
            assertMatch(re, "respondToMyProxy");
            assertNoMatch(re, "respondToMyNote");
            assertMatch(re, "respondToProxy1");
            assertMatch(re, "respondToProxyValue");
        }

        [Test]
        public function fabricationMediatorHasNotificationCacheKey():void
        {
            assertNotNull(FabricationMediator.notificationCacheKey);
            assertType(String, FabricationMediator.notificationCacheKey);
        }

        [Test]
        public function fabricationMediatorNotificationReflectionIsValidWithRespondToNoteAndRespondToProxySyntax():void
        {
            var notificationCache:HashMap = new HashMap();

            facade.mock.method("hasInstance").withArgs(String).returns(true).atLeast(1);
            facade.mock.method("findInstance").withArgs(FabricationMediator.notificationCacheKey).returns(notificationCache).atLeast(1);
            facade.mock.method("getFabrication").withNoArgs.returns(fabrication);
            fabrication.mock.method("getClassByName").withArgs(String).returns(FabricationMediatorTestMock).atLeast(1);

            var expectedInterests:Array = ["note",
                                           "note1",
                                           "note2",
                                           "MY_NOTE1",
                                           "MY_NOTE2",
                                           "MY_NOTE3",
                                           FabricationProxy.NOTIFICATION_FROM_PROXY];

            mediator.initializeNotifier(multitonKey);
            var actualInterests:Array = mediator.listNotificationInterests();

            expectedInterests.sort();
            actualInterests.sort();

            assertArrayEquals(expectedInterests, actualInterests);

            verifyMock(facade.mock);
            verifyMock(fabrication.mock);
        }

        [Test]
        public function fabricationMediatorNotificationReflectionIsValidWithOnlyRespondToNoteSyntax():void
        {
            var mediator:FabricationMediator = new FabricationMediatorTestMockWithoutProxyInterests(instanceName);
            var notificationCache:HashMap = new HashMap();

            facade.mock.method("hasInstance").withArgs(String).returns(true).atLeast(1);
            facade.mock.method("findInstance").withArgs(FabricationMediator.notificationCacheKey).returns(notificationCache).atLeast(1);
            facade.mock.method("getFabrication").withNoArgs.returns(fabrication);
            fabrication.mock.method("getClassByName").withArgs(String).returns(FabricationMediatorTestMock).atLeast(1);

            var expectedInterests:Array = ["note",
                                           "note1",
                                           "note2",];

            mediator.initializeNotifier(multitonKey);
            var actualInterests:Array = mediator.listNotificationInterests();

            expectedInterests.sort();
            actualInterests.sort();

            assertArrayEquals(expectedInterests, actualInterests);

            verifyMock(facade.mock);
            verifyMock(fabrication.mock);
        }

        [Test]
        public function fabricationMediatorNotificationReflectionIsValidWithOnlyRespondToProxySyntax():void
        {
            var mediator:FabricationMediator = new FabricationMediatorTestMockWithOnlyProxyInterests(instanceName);
            var notificationCache:HashMap = new HashMap();

            facade.mock.method("hasInstance").withArgs(String).returns(true).atLeast(1);
            facade.mock.method("findInstance").withArgs(FabricationMediator.notificationCacheKey).returns(notificationCache).atLeast(1);
            facade.mock.method("getFabrication").withNoArgs.returns(fabrication);
            fabrication.mock.method("getClassByName").withArgs(String).returns(FabricationMediatorTestMock).atLeast(1);

            var expectedInterests:Array = [FabricationProxy.NOTIFICATION_FROM_PROXY];

            mediator.initializeNotifier(multitonKey);
            var actualInterests:Array = mediator.listNotificationInterests();

            assertArrayEquals(expectedInterests, actualInterests);

            verifyMock(facade.mock);
            verifyMock(fabrication.mock);
        }

        [Test]
        public function fabricationMediatorNotificationReflectionIsValidWithoutAnyNotificationInterests():void
        {
            var mediator:FabricationMediator = new FabricationMediatorTestMockWithoutAnyInterests(instanceName);
            var notificationCache:HashMap = new HashMap();
            var routeMapper:ComponentRouteMapper = new ComponentRouteMapper();

            facade.mock.method("hasInstance").withArgs(String).returns(true).atLeast(1);
            facade.mock.method("findInstance").withArgs(FabricationMediator.notificationCacheKey).returns(notificationCache).atLeast(1);
            facade.mock.method("getFabrication").withNoArgs.returns(fabrication);
            fabrication.mock.method("getClassByName").withArgs(String).returns(FabricationMediatorTestMock).atLeast(1);

            mediator.initializeNotifier(multitonKey);
            var actualInterests:Array = mediator.listNotificationInterests();

            assertTrue(actualInterests.length == 0);

            verifyMock(facade.mock);
            verifyMock(fabrication.mock);
        }

        [Test]
        public function fabricationMediatorNotificationReflectionIsValidWithQualifiedProxyNotifications():void
        {
            var mediator:FabricationMediator = new FabricationMediatorTestMockWithQualifiedProxyInterests(instanceName);
            var notificationCache:HashMap = new HashMap();

            facade.mock.method("hasInstance").withArgs(String).returns(true).atLeast(1);
            facade.mock.method("findInstance").withArgs(FabricationMediator.notificationCacheKey).returns(notificationCache).atLeast(1);
            facade.mock.method("getFabrication").withNoArgs.returns(fabrication);
            fabrication.mock.method("getClassByName").withArgs(String).returns(FabricationMediatorTestMock).atLeast(1);

            var expectedInterests:Array = [FabricationProxy.NOTIFICATION_FROM_PROXY];

            var qualifications:Object = {
                note1:"Proxy1", note2:"Proxy2", note3:"Proxy3"
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

        [Test]
        public function fabricationMediatorExecutesRespondToProxySyntax():void
        {
            var mediator:FabricationMediator = new FabricationMediatorTestMockWithQualifiedProxyInterests(instanceName);
            var notificationCache:HashMap = new HashMap();

            facade.mock.method("hasInstance").withArgs(String).returns(true).atLeast(1);
            facade.mock.method("findInstance").withArgs(FabricationMediator.notificationCacheKey).returns(notificationCache).atLeast(1);
            facade.mock.method("getFabrication").withNoArgs.returns(fabrication);

            var qualifications:Object = {
                note1:"Proxy1", note2:"Proxy2", note3:"Proxy3"
            };

            mediator.initializeNotifier(multitonKey);
            var mediatorMock:Mock = (mediator as IMockable).mock;

            mediatorMock.method("qualifyNotificationInterests").withNoArgs.returns(qualifications);
            mediatorMock.method("respondToProxy1").withArgs(function(note:INotification):Boolean
            {
                assertEquals("Proxy1/note1", note.getName());
                return true;
            }).once;
            mediatorMock.method("respondToProxy2").withArgs(function(note:INotification):Boolean
            {
                assertEquals("Proxy2/note2", note.getName());
                return true;
            }).once;
            mediatorMock.method("respondToProxy3").withArgs(function(note:INotification):Boolean
            {
                assertEquals("Proxy3/note3", note.getName());
                return true;
            }).once;

            invokeHandleNotification(mediator, "Proxy1", "note1");
            invokeHandleNotification(mediator, "Proxy2", "note2");
            invokeHandleNotification(mediator, "Proxy3", "note3");

            verifyMock(mediatorMock);
            verifyMock(facade.mock);
            verifyMock(fabrication.mock);
        }

        [Test]
        public function fabricationMediatorExecutesRespondToNotificationSyntax():void
        {
            var mediator:FabricationMediator = new FabricationMediatorTestMock(instanceName);
            var notificationCache:HashMap = new HashMap();

            facade.mock.method("hasInstance").withArgs(String).returns(true).atLeast(1);
            facade.mock.method("findInstance").withArgs(FabricationMediator.notificationCacheKey).returns(notificationCache).atLeast(1);
            facade.mock.method("getFabrication").withNoArgs.returns(fabrication);

            mediator.initializeNotifier(multitonKey);
            var mediatorMock:Mock = (mediator as IMockable).mock;

            mediatorMock.method("respondToNote").withArgs(function(note:INotification):Boolean
            {
                assertEquals("note", note.getName());
                return true;
            }).once;
            mediatorMock.method("respondToNote1").withArgs(function(note:INotification):Boolean
            {
                assertEquals("note1", note.getName());
                return true;
            }).once;
            mediatorMock.method("respondToNote2").withArgs(function(note:INotification):Boolean
            {
                assertEquals("note2", note.getName());
                return true;
            }).once;

            invokeHandleNotification(mediator, null, "note");
            invokeHandleNotification(mediator, null, "note1");
            invokeHandleNotification(mediator, null, "note2");

            verifyMock(mediatorMock);
            verifyMock(facade.mock);
            verifyMock(fabrication.mock);
        }

        [Test]
        public function fabricationMediatorConstantFormatRegExpIsValid():void
        {
            var re:RegExp = FabricationMediator.constantRegExp;
            assertMatch(re, "MY_CONSTANT");
            assertNoMatch(re, "myConstant");
            assertMatch(re, "DATA_CHANGE");
            assertNoMatch(re, "dataChange");
        }


        [Test]
        public function fabricationMediatorExecutesRespondToCONSTANT_FORMSyntax():void
        {
            var mediator:FabricationMediator = new FabricationMediatorTestMock(instanceName);
            var notificationCache:HashMap = new HashMap();

            facade.mock.method("hasInstance").withArgs(String).returns(true).atLeast(1);
            facade.mock.method("findInstance").withArgs(FabricationMediator.notificationCacheKey).returns(notificationCache).atLeast(1);
            facade.mock.method("getFabrication").withNoArgs.returns(fabrication);

            mediator.initializeNotifier(multitonKey);
            var mediatorMock:Mock = (mediator as IMockable).mock;

            mediatorMock.method("respondToMY_NOTE1").withArgs(function(note:INotification):Boolean
            {
                assertEquals("MY_NOTE1", note.getName());
                return true;
            }).once;
            mediatorMock.method("respondToMY_NOTE2").withArgs(function(note:INotification):Boolean
            {
                assertEquals("MY_NOTE2", note.getName());
                return true;
            }).once;
            mediatorMock.method("respondToMY_NOTE3").withArgs(function(note:INotification):Boolean
            {
                assertEquals("MY_NOTE3", note.getName());
                return true;
            }).once;

            invokeHandleNotification(mediator, null, "MY_NOTE1");
            invokeHandleNotification(mediator, null, "MY_NOTE2");
            invokeHandleNotification(mediator, null, "MY_NOTE3");

            verifyMock(mediatorMock);
            verifyMock(facade.mock);
            verifyMock(fabrication.mock);
        }

        [Test]
        public function fabricationMediatorDoesNotHaveRouterKey():void
        {
            assertFalse((FabricationMediator as Class).hasOwnProperty("routerKey"));
        }

        [Test]
        public function fabricationProxyCachesNotificationInterests():void
        {
            var notificationCache:HashMap = new HashMap();
            var sampleSize:int = 25;

            facade.mock.method("hasInstance").withArgs(String).returns(true).atLeast(1);
            facade.mock.method("findInstance").withArgs(FabricationMediator.notificationCacheKey).returns(notificationCache).atLeast(1);
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

        public function invokeHandleNotification(mediator:FabricationMediator, proxyName:String, noteName:String, noteBody:Object = null, noteType:String = null):void
        {
            if (proxyName != null) {
                noteName = proxyName + "/" + noteName;
            }

            var payload:Notification = new Notification(noteName, noteBody, noteType);

            if (proxyName == null) {
                mediator.handleNotification(payload);
            }
            else {
                var systemNotification:Notification = new Notification(FabricationProxy.NOTIFICATION_FROM_PROXY, payload, proxyName);
                mediator.handleNotification(systemNotification);
            }
        }

        [Test]
        public function fabricationMediatorHasDefaultReactionPrefix():void
        {
            assertType(String, FabricationMediator.DEFAULT_REACTION_PREFIX);
            assertEquals("reactTo", FabricationMediator.DEFAULT_REACTION_PREFIX);
        }

        [Test]
        public function fabricationMediatorHasDefaultCapturePrefix():void
        {
            assertType(String, FabricationMediator.DEFAULT_CAPTURE_PREFIX);
            assertEquals("trap", FabricationMediator.DEFAULT_CAPTURE_PREFIX);
        }

        [Test]
        public function fabricationMediatorHasLocalDefaultReactionPrefix():void
        {
            assertEquals(FabricationMediator.DEFAULT_REACTION_PREFIX, new FabricationMediatorTestMockWithReactions().getReactionHandlerPrefix());
        }

        [Test]
        public function fabricationMediatorHasLocalDefaultCapturePrefix():void
        {
            assertEquals(FabricationMediator.DEFAULT_CAPTURE_PREFIX, new FabricationMediatorTestMockWithReactions().getCaptureHandlerPrefix());
        }

        [Test]
        public function fabricationMediatorHasValidReactionsDuringBubblingAndTargetPhase():void
        {
            facade.mock.method("getFabrication").withNoArgs.returns(fabrication).atLeast(1);

            var myButton:UIComponent = new UIComponent();
            var viewComponent:Object = {myButton:myButton};
            var mediator:FabricationMediatorTestMockWithReactions = new FabricationMediatorTestMockWithReactions("ReactionMediator", viewComponent);
            var mock:Mock = mediator.mock;

            mediator.initializeNotifier(multitonKey);
            mediator.onRegister();

            confirmReaction(mock, myButton, "reactToMyButtonClick", "click");
            confirmReaction(mock, myButton, "reactToMyButtonMouseDown", "mouseDown");
            confirmReaction(mock, myButton, "reactToMyButtonMouseUp", "mouseUp");
            confirmReaction(mock, myButton, "reactToMyButtonCustomEvent", "customEvent");
            confirmReaction(mock, myButton, "reactToMyButton$CustomEvent", "customEvent");
            confirmReaction(mock, myButton, "reactToMyButton$MouseUp", "mouseUp");

            // reactions in CONSTANT_FORMAT
            confirmReaction(mock, myButton, "reactToMyButtonCLICK", "click");
            confirmReaction(mock, myButton, "reactToMyButtonMOUSE_DOWN", "mouseDown");
            confirmReaction(mock, myButton, "reactToMyButtonMOUSE_UP", "mouseUp");
            confirmReaction(mock, myButton, "reactToMyButtonCUSTOM_EVENT", "customEvent");
            confirmReaction(mock, myButton, "reactToMyButton$CUSTOM_EVENT", "customEvent");
            confirmReaction(mock, myButton, "reactToMyButton$MOUSE_UP", "mouseUp");

            verifyMock(mock);
            verifyMock(facade.mock);
        }

        [Test]
        public function fabricationMediatorCanHaltReactions():void
        {
            facade.mock.method("getFabrication").withNoArgs.returns(fabrication).atLeast(1);

            var myButton:UIComponent = new UIComponent();
            var viewComponent:Object = {myButton:myButton};
            var mediator:FabricationMediatorTestMockWithReactions = new FabricationMediatorTestMockWithReactions("ReactionMediator", viewComponent);
            var mock:Mock = mediator.mock;

            mediator.initializeNotifier(multitonKey);
            mediator.onRegister();

            var event:Event = new Event("click");
            mock.method("reactToMyButtonClick").withArgs(event).never;

            mediator.haltReaction("reactToMyButtonClick");
            myButton.dispatchEvent(event);

            event = new Event("mouseDown");
            mock.method("reactToMyButtonMouseDown").withArgs(event).never;
            mediator.haltReaction(mediator.reactToMyButtonMouseDown);
            myButton.dispatchEvent(event);

            verifyMock(mock);
            verifyMock(facade.mock);
        }

        [Test]
        public function fabricationMediatorCanResultHaltedReactions():void
        {
            facade.mock.method("getFabrication").withNoArgs.returns(fabrication).atLeast(1);

            var myButton:UIComponent = new UIComponent();
            var viewComponent:Object = {myButton:myButton};
            var mediator:FabricationMediatorTestMockWithReactions = new FabricationMediatorTestMockWithReactions("ReactionMediator", viewComponent);
            var mock:Mock = mediator.mock;

            mediator.initializeNotifier(multitonKey);
            mediator.onRegister();

            var event:Event = new Event("mouseOver");
            mock.method("reactToMyButtonMouseOver").withArgs( event ).once;

            mediator.haltReaction("reactToMyButtonMouseOver");
            myButton.dispatchEvent(event);

            mediator.resumeReaction("reactToMyButtonMouseOver");
            myButton.dispatchEvent(event);

            verifyMock(mock);
            verifyMock(facade.mock);
        }

        [Test]
        public function fabricationMediatorCanRemoveReactions():void
        {
            facade.mock.method("getFabrication").withNoArgs.returns(fabrication).atLeast(1);

            var myButton:UIComponent = new UIComponent();
            var viewComponent:Object = {myButton:myButton};
            var mediator:FabricationMediatorTestMockWithReactions = new FabricationMediatorTestMockWithReactions("ReactionMediator", viewComponent);
            var mock:Mock = mediator.mock;

            mediator.initializeNotifier(multitonKey);
            mediator.onRegister();

            var event:Event = new Event("click");
            mock.method("reactToMyButtonClick").withArgs(event).never;

            mediator.removeReaction("reactToMyButtonClick");
            myButton.dispatchEvent(event);

            verifyMock(mock);
            verifyMock(facade.mock);
        }

        [Test]
        public function fabricationMediatorRemovesReactionsOnDisposal():void
        {
            facade.mock.method("getFabrication").withNoArgs.returns(fabrication).atLeast(1);

            var myButton:UIComponent = new UIComponent();
            var viewComponent:Object = {myButton:myButton};
            var mediator:FabricationMediatorTestMockWithReactions = new FabricationMediatorTestMockWithReactions("ReactionMediator", viewComponent);
            var mock:Mock = mediator.mock;

            mediator.initializeNotifier(multitonKey);
            mediator.onRegister();

            verifyMock(mock);
            verifyMock(facade.mock);

            mediator.dispose();
            assertNull(mediator.getReactions());
        }

        [Test]
        public function fabricationMediatorFormatEventType():void {

            var fabricationMediator:FabricationMediatorMock = new FabricationMediatorMock();
            assertEquals( "click", fabricationMediator.formatEventTypeMethod( "CLICK" ) );
            assertEquals( "click", fabricationMediator.formatEventTypeMethod( "Click" ) );
            assertEquals( "click", fabricationMediator.formatEventTypeMethod( "click" ) );

            assertEquals( "mouseDown", fabricationMediator.formatEventTypeMethod( "mouseDown" ) );
            assertEquals( "mouseDown", fabricationMediator.formatEventTypeMethod( "MOUSE_DOWN" ) );
            assertEquals( "mouseDown", fabricationMediator.formatEventTypeMethod( "MouseDown" ) );
        }

        public function confirmReaction(mock:Mock, source:IEventDispatcher, method:String, type:String, dispatcher:IEventDispatcher = null, times:int = 1):void
        {
            var event:Event = new Event(type, dispatcher != null, dispatcher != null);
            if (times == 0) {
                mock.method(method).withArgs(event).never;
            }
            else {
                mock.method(method).withArgs(event).times(times);
            }

            if (dispatcher == null) {
                source.dispatchEvent(event);
            }
            else {
                dispatcher.dispatchEvent(event);
            }
        }

        // TODO : figure out how to do capture phase testing
        /* *
         public function testFabricationMediatorHasValidReactionsDuringCapturePhase():void {
         facade.mock.method("getFabrication").withNoArgs.returns(fabrication).atLeast(1);

         var container:UIComponent = new HBox();
         container.id = methodName;
         var myButton:Button = new Button();
         TestContainer.getInstance().addChild(container);

         var viewComponent:Object = {myButton:container};
         var mediator:FabricationMediatorTestMockWithReactions = new FabricationMediatorTestMockWithReactions("ReactionMediator", viewComponent);
         var mock:Mock = mediator.mock;

         mediator.initializeNotifier(multitonKey);
         mediator.onRegister();
         mediator.initializeReactions();

         confirmReaction(mock, container, "trapMyButtonChildAdd", "childAdd", myButton);

         verifyMock(mock);
         verifyMock(facade.mock);
         }
         /* */

    }
}
