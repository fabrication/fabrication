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
    import org.puremvc.as3.multicore.core.View;
    import org.puremvc.as3.multicore.interfaces.INotification;
    import org.puremvc.as3.multicore.patterns.observer.Notification;
    import org.puremvc.as3.multicore.utilities.fabrication.addons.BaseTestCase;
    import org.puremvc.as3.multicore.utilities.fabrication.core.*;
    import org.puremvc.as3.multicore.utilities.fabrication.core.mock.FabricationControllerMock;
    import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.mock.FabricationMediatorMock;

    /**
     * @author Darshan Sawardekar
     */
    public class FabricationViewTest extends BaseTestCase {

        private var fabricationView:FabricationView;


        [Before]
        public function setUp():void
        {
            fabricationView = FabricationView.getInstance(instanceName + "_setup");
        }

        [After]
        public function tearDown():void
        {
            fabricationView.dispose();
            fabricationView = null;
        }

        public function testFabricationViewHasValidType():void
        {
            assertType(FabricationView, fabricationView);
            assertType(View, fabricationView);
            assertType(IDisposable, fabricationView);
        }

        public function testFabricationViewIsCachedByItsMultitonKey():void
        {
            var sampleSize:int = 25;
            var view:FabricationView;
            var i:int = 0;
            var j:int = 0;
            var key:String;

            for (i = 0; i < sampleSize; i++) {
                key = instanceName + "_view" + i;
                view = FabricationView.getInstance(key);
                for (j = 0; j < sampleSize; j++) {
                    assertEquals(view, FabricationView.getInstance(key));
                }
            }
        }

        public function testFabricationViewRemovesMultitonOnItsDisposal():void
        {
            var key:String = instanceName;
            var fabricationView:FabricationView = FabricationView.getInstance(key);
            assertEquals(fabricationView, FabricationView.getInstance(key));

            fabricationView.dispose();

            assertNoMatch(fabricationView, FabricationView.getInstance(key));
        }

        public function testFabricationViewDisposesMediatorsOnItsDisposal():void
        {
            var fabricationView:FabricationView = new FabricationView(instanceName);
            var mediator:FabricationMediatorMock;
            var sampleSize:int = 25;
            var mediatorList:Array = new Array();
            var i:int;
            var mediatorName:String;

            for (i = 0; i < sampleSize; i++) {
                mediatorName = instanceName + "_mediator" + i;
                mediator = new FabricationMediatorMock(mediatorName);
                mediator.mock.ignoreMissing = true;
                mediator.mock.method("dispose").withNoArgs.once;
                mediator.mock.method("getMediatorName").withNoArgs.returns(mediatorName);
                mediator.mock.method("listNotificationInterests").withNoArgs.returns([]);

                fabricationView.registerMediator(mediator);
                mediatorList.push(mediator);
            }

            fabricationView.dispose();

            for (i = 0; i < sampleSize; i++) {
                mediator = mediatorList[i];
                verifyMock(mediator.mock);
            }
        }

        public function testFabricationViewNotifiesObserversIfControllerReferenceIsNotPresent():void
        {
            var mediator:FabricationMediatorMock = new FabricationMediatorMock(instanceName);
            var notification:Notification = new Notification(instanceName + "Note");
            mediator.mock.method("listNotificationInterests").returns([instanceName + "Note"]).once;
            mediator.mock.method("handleNotification").withArgs(notification).once;

            fabricationView.registerMediator(mediator);
            fabricationView.notifyObservers(notification);

            verifyMock(mediator.mock);
        }

        public function testFabricationViewNotifiesObserversAfterInterception():void
        {
            var mediator:FabricationMediatorMock;
            var mediatorList:Array = new Array();
            var notification:Notification = new Notification(instanceName + "Note");
            var sampleSize:int = 20;
            var i:int;

            for (i = 0; i < sampleSize; i++) {
                mediator = new FabricationMediatorMock(instanceName + i);
                mediator.mock.method("listNotificationInterests").returns([notification.getName()]).once;
                mediator.mock.method("handleNotification").withArgs(notification).once;

                fabricationView.registerMediator(mediator);
                mediatorList.push(mediator);
            }

            fabricationView.notifyObservers(notification);

            for (i = 0; i < sampleSize; i++) {
                mediator = mediatorList[i];
                verifyMock(mediator.mock);
            }
        }

        public function testFabricationViewNotifiesObserversIfNoInterceptorWasNotPresent():void
        {
            var mediator:FabricationMediatorMock = new FabricationMediatorMock(instanceName);
            var notification:INotification = new Notification(instanceName + "Note");
            var controller:FabricationControllerMock = new FabricationControllerMock(instanceName);
            controller.mock.method("intercept").withArgs(notification).returns(false).atLeast(1);

            mediator.mock.method("listNotificationInterests").returns([notification.getName()]).once;
            mediator.mock.method("handleNotification").withArgs(notification).once;

            fabricationView.controller = controller;
            fabricationView.registerMediator(mediator);
            fabricationView.notifyObservers(notification);

            verifyMock(controller.mock);
            verifyMock(mediator.mock);
        }

        public function testFabricationViewDoesNotNotifyObserversIfInterceptorsArePresent():void
        {
            var mediator:FabricationMediatorMock = new FabricationMediatorMock(instanceName);
            var notification:INotification = new Notification(instanceName + "Note");
            var controller:FabricationControllerMock = new FabricationControllerMock(instanceName);
            controller.mock.method("intercept").withArgs(notification).returns(true).atLeast(1);

            mediator.mock.method("listNotificationInterests").returns([notification.getName()]).once;
            mediator.mock.method("handleNotification").withArgs(notification).never;

            fabricationView.controller = controller;
            fabricationView.registerMediator(mediator);
            fabricationView.notifyObservers(notification);

            verifyMock(controller.mock);
            verifyMock(mediator.mock);
        }

        [Test(expects="Error")]
        public function fabricationViewResetsAfterDisposal():void
        {
            var fabricationView:FabricationView = FabricationView.getInstance(instanceName);
            fabricationView.dispose();

            assertNull(fabricationView.controller);
            fabricationView.registerMediator(new FabricationMediatorMock("x"));
        }
    }
}
