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

package org.puremvc.as3.multicore.utilities.fabrication.patterns.facade.mock {
    import mx.core.Application;
    import mx.core.FlexGlobals;

    import org.puremvc.as3.multicore.interfaces.INotification;
    import org.puremvc.as3.multicore.patterns.facade.Facade;
    import org.puremvc.as3.multicore.patterns.observer.Notification;
    import org.puremvc.as3.multicore.utilities.fabrication.addons.BaseTestCase;
    import org.puremvc.as3.multicore.utilities.fabrication.addons.mock.DisposableMock;
    import org.puremvc.as3.multicore.utilities.fabrication.components.mock.FlexApplicationMock;
    import org.puremvc.as3.multicore.utilities.fabrication.core.FabricationController;
    import org.puremvc.as3.multicore.utilities.fabrication.core.FabricationModel;
    import org.puremvc.as3.multicore.utilities.fabrication.core.FabricationView;
    import org.puremvc.as3.multicore.utilities.fabrication.core.mock.FabricationControllerMock;
    import org.puremvc.as3.multicore.utilities.fabrication.core.mock.FabricationModelMock;
    import org.puremvc.as3.multicore.utilities.fabrication.core.mock.FabricationViewMock;
    import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.SimpleFabricationCommand;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.mock.SimpleFabricationCommandMock;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.mock.SimpleFabricationCommandMock1;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.facade.*;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.mock.FabricationMediatorMock;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.observer.FabricationNotification;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.observer.RouterNotification;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.observer.TransportNotification;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.proxy.mock.FabricationProxyMock;

    /**
     * @author Darshan Sawardekar
     */
    public class FacadeTest extends BaseTestCase {


        private var facade:FabricationFacade;
        private var application:Application;


        [Before]
        public function setUp():void
        {
            facade = FabricationFacade.getInstance(instanceName + "_setup");
            application = FlexGlobals.topLevelApplication as Application;
        }

        [After]
        public function tearDown():void
        {
            facade.dispose();
            facade = null;
            application = null;
        }

        [Test]
        public function fabricationFacadeHasValidType():void
        {
            assertType(FabricationFacade, facade);
            assertType(Facade, facade);
            assertType(IDisposable, facade);
        }

        [Test]
        public function fabricationFacadeCachesInstancesOnItsMultitonKey():void
        {
            var key:String = instanceName;
            var sampleSize:int = 25;
            var facade:FabricationFacade;
            var i:int;
            var j:int;

            for (i = 0; i < sampleSize; i++) {
                facade = FabricationFacade.getInstance(key + i);
                for (j = 0; j < sampleSize; j++) {
                    assertEquals(facade, FabricationFacade.getInstance(key + i));
                }
            }
        }

        [Test(expects="Error")]
        public function fabricationFacadeCalculatesValidApplicationNameFromStartupCommand():void
        {
            assertEquals("SimpleFabricationMock", FabricationFacade.calcApplicationName(SimpleFabricationCommandMock));
            assertEquals("SimpleFabricationMock1", FabricationFacade.calcApplicationName(SimpleFabricationCommandMock1));

            assertEquals("SimpleFabrication", FabricationFacade.calcApplicationName(SimpleFabricationCommand));
            //            assertEquals("EmptyFlexModule", FabricationFacade.calcApplicationName(EmptyFlexModuleStartupCommand));

            FabricationFacade.calcApplicationName(StartupCommand);
        }

        [Test]
        public function fabricationFacadeUsesFabricationModel():void
        {
            var key:String = instanceName;
            var fabricationModel:FabricationModel = FabricationModel.getInstance(key);
            var facade:FabricationFacade = FabricationFacade.getInstance(key);
            var proxy:FabricationProxyMock = new FabricationProxyMock("A0");
            proxy.mock.ignoreMissing = true;
            proxy.mock.method("getProxyName").returns("A0");

            facade.registerProxy(proxy);

            assertEquals(proxy, facade.retrieveProxy(proxy.getProxyName()));
        }

        [Test]
        public function fabricationFacadeUsesFabricationView():void
        {
            var key:String = instanceName;
            var fabricationView:FabricationView = FabricationView.getInstance(key);
            var facade:FabricationFacade = FabricationFacade.getInstance(key);
            var mediator:FabricationMediatorMock = new FabricationMediatorMock("B0");
            mediator.mock.ignoreMissing = true;
            mediator.mock.method("getMediatorName").withNoArgs.returns("B0");
            mediator.mock.method("listNotificationInterests").withNoArgs.returns([]);

            facade.registerMediator(mediator);

            assertEquals(mediator, facade.retrieveMediator(mediator.getMediatorName()));
        }

        [Test]
        public function fabricationFacadeUsesFabricationController():void
        {
            var key:String = instanceName;
            var fabricationController:FabricationController = FabricationController.getInstance(key);
            var facade:FabricationFacade = FabricationFacade.getInstance(key);

            facade.registerCommand("x0", SimpleFabricationCommandMock);

            assertTrue(facade.hasCommand("x0"));
        }

        [Test]
        public function fabricationFacadeSavesValidApplicationReferenceOnStartup():void
        {
            facade.startup(SimpleFabricationCommandMock, application);
            assertEquals(application, facade.getApplication());
        }

        [Test]
        public function fabricationFacadeSavesValidApplicationNameOnStartup():void
        {
            facade.startup(SimpleFabricationCommandMock, application);
            assertEquals("SimpleFabricationMock", facade.getApplicationName());
        }

        [Test]
        public function fabricationFacadeRegistersSpecifiedStartupCommandOnStartup():void
        {
            assertFalse(facade.hasCommand(FabricationNotification.STARTUP));
            facade.startup(SimpleFabricationCommandMock, application);
            assertTrue(facade.hasCommand(FabricationNotification.STARTUP));
        }

        [Test]
        public function fabricationFacadeSendsStartupNotificationOnStartup():void
        {
            var mediator:FabricationMediatorMock = new FabricationMediatorMock("X0");
            mediator.mock.ignoreMissing = true;
            mediator.mock.method("getMediatorName").withNoArgs.returns("X0");
            mediator.mock.method("listNotificationInterests").returns([FabricationNotification.STARTUP]);
            mediator.mock.method("handleNotification").withArgs(
                    function(note:INotification):void
                    {
                        assertEquals(FabricationNotification.STARTUP, note.getName());
                        assertEquals(application, note.getBody());
                    }
                    );

            facade.registerMediator(mediator);
            facade.startup(SimpleFabricationCommandMock, application);

            verifyMock(mediator.mock);
        }

        [Test]
        public function fabricationFacadeSendsBootstrapNotificationOnStartup():void
        {
            var mediator:FabricationMediatorMock = new FabricationMediatorMock("X0");
            mediator.mock.ignoreMissing = true;
            mediator.mock.method("getMediatorName").withNoArgs.returns("X0");
            mediator.mock.method("listNotificationInterests").returns([FabricationNotification.BOOTSTRAP]);
            mediator.mock.method("handleNotification").withArgs(
                    function(note:INotification):void
                    {
                        assertEquals(FabricationNotification.BOOTSTRAP, note.getName());
                        assertEquals(application, note.getBody());
                    }
                    );

            facade.registerMediator(mediator);
            facade.startup(SimpleFabricationCommandMock, application);

            verifyMock(mediator.mock);
        }

        [Test]
        public function fabricationFacadeInvokesUndoAndRedoOnFabricationController():void
        {
            var key:String = instanceName;
            var stepSize:int = 5;
            var controller:FabricationControllerMock = FabricationControllerMock.getInstance(key);
            var facade:FabricationFacade = FabricationFacade.getInstance(key);
            controller.mock.ignoreMissing = true;
            controller.mock.method("undo").withArgs(stepSize).once;
            controller.mock.method("redo").withArgs(stepSize).once;

            facade.undo(stepSize);
            facade.redo(stepSize);

            verifyMock(controller.mock);
        }

        [Test]
        public function fabricationFacadeHasReferenceToItsFabrication():void
        {
            var fabrication:FlexApplicationMock = new FlexApplicationMock();
            facade.startup(SimpleFabricationCommandMock, fabrication);

            assertEquals(fabrication, facade.getFabrication());
        }

        [Test]
        public function fabricationFacadeHasValidMultitonKey():void
        {
            assertEquals(instanceName + "_setup", facade.getMultitonKey());
        }

        [Test]
        public function fabricationFacadeSendsValidSystemNotificationToRouteNotifications():void
        {
            var mediator:FabricationMediatorMock = new FabricationMediatorMock("X0");
            mediator.mock.ignoreMissing = true;
            mediator.mock.method("getMediatorName").withNoArgs.returns("X0");
            mediator.mock.method("listNotificationInterests").returns([RouterNotification.SEND_MESSAGE_VIA_ROUTER]);
            mediator.mock.method("handleNotification").withArgs(
                    function(note:INotification):Boolean
                    {
                        assertEquals(RouterNotification.SEND_MESSAGE_VIA_ROUTER, note.getName());

                        var transport:TransportNotification = note.getBody() as TransportNotification;

                        assertType(TransportNotification, transport);
                        assertEquals("r0", transport.getName());
                        assertEquals("r1", transport.getBody());
                        assertEquals("r2", transport.getType());
                        assertEquals("r3", transport.getTo());
                        return true;
                    }
                    ).once;

            facade.registerMediator(mediator);
            facade.startup(SimpleFabricationCommandMock, application);
            facade.routeNotification("r0", "r1", "r2", "r3");

            verifyMock(mediator.mock);
        }

        [Test]
        public function fabricationFacadeCanSaveSingletonInstanceWithoutDuplication():void
        {
            var key:String = instanceName;
            var sampleSize:int = 25;
            var instance:Object;
            var i:int;

            for (i = 0; i < sampleSize; i++) {
                instance = new Object();
                assertEquals(instance, facade.saveInstance(key + i, instance));
                assertTrue(facade.hasInstance(key + i));
                assertEquals(instance, facade.findInstance(key + i));

                assertEquals(instance, facade.removeInstance(key + i));
                assertFalse(facade.hasInstance(key + i));
                assertNull(facade.findInstance(key + i));
            }
        }

        [Test]
        public function fabricationFacadeDisposesModelViewAndControllerOnItsDisposal():void
        {
            var key:String = instanceName;
            var model:FabricationModelMock = FabricationModelMock.getInstance(key);
            model.mock.ignoreMissing = true;
            model.mock.method("dispose").withNoArgs.once;

            var view:FabricationViewMock = FabricationViewMock.getInstance(key);
            view.mock.ignoreMissing = true;
            view.mock.method("dispose").withNoArgs.once;

            var controller:FabricationControllerMock = FabricationControllerMock.getInstance(key);
            controller.mock.ignoreMissing = true;
            controller.mock.method("dispose").withNoArgs.once;

            var facade:FabricationFacade = FabricationFacade.getInstance(key);

            facade.dispose();

            verifyMock(model.mock);
            verifyMock(view.mock);
            verifyMock(controller.mock);
        }

        [Test]
        public function fabricationFacadeDisposesSingletonsOnItsDisposal():void
        {
            var facade:FabricationFacade = FabricationFacade.getInstance(instanceName);

            var sampleSize:int = 25;
            var i:int = 0;
            var disposableMock:DisposableMock;
            var mockList:Array = new Array();

            for (i = 0; i < sampleSize; i++) {
                disposableMock = new DisposableMock();
                disposableMock.mock.method("dispose").withNoArgs.once;

                facade.saveInstance("_dispmock" + i, disposableMock);
                mockList.push(disposableMock);
            }

            facade.dispose();

            for (i = 0; i < sampleSize; i++) {
                disposableMock = mockList[i];
                verifyMock(disposableMock.mock);
            }
        }

        [Test]
        public function fabricationRemovesCoreAfterItsDisposal():void
        {
            var key:String = instanceName;
            var facade:FabricationFacade = FabricationFacade.getInstance(key);
            assertTrue(Facade.hasCore(key));

            facade.dispose();

            assertFalse(Facade.hasCore(key));
        }

        [Test]
        public function fabricationFacadeCanDirectlyExecuteCommandsUsingTheFabricationController():void
        {
            var key:String = instanceName;
            var controller:FabricationControllerMock = FabricationControllerMock.getInstance(key);
            var facade:FabricationFacade = FabricationFacade.getInstance(key);
            var body:Object = new Object();
            var note:INotification = new Notification("x", "y", "z");

            assertEquals(controller, facade.fabricationController);

            controller.mock.method("executeCommandClass").withArgs(SimpleFabricationCommandMock, body, note).returns(new SimpleFabricationCommandMock()).once;
            facade.executeCommandClass(SimpleFabricationCommandMock, body, note);

            verifyMock(controller.mock);
        }

        [Test]
        public function fabricationFacadeRegistersDefaultUndoCommands():void
        {
            assertTrue(facade.hasCommand(FabricationNotification.UNDO));
            assertTrue(facade.hasCommand(FabricationNotification.REDO));
            assertTrue(facade.hasCommand(FabricationNotification.CHANGE_UNDO_GROUP));
        }

    }
}
