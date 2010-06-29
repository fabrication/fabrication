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

package org.puremvc.as3.multicore.utilities.fabrication.components.fabricator.test {
    import com.anywebcam.mock.Mock;

    import flash.events.Event;

    import org.puremvc.as3.multicore.utilities.fabrication.addons.BaseTestCase;
    import org.puremvc.as3.multicore.utilities.fabrication.addons.IMockable;
    import org.puremvc.as3.multicore.utilities.fabrication.components.fabricator.*;
    import org.puremvc.as3.multicore.utilities.fabrication.components.mock.ApplicationFabricatorMock;
    import org.puremvc.as3.multicore.utilities.fabrication.components.mock.FabricationMock;
    import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;
    import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IFabrication;
    import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IModuleAddress;
    import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IRouter;
    import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IRouterAwareModule;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.mock.SimpleFabricationCommandMock;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.mock.SimpleFabricationCommandMock1;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.facade.mock.FacadeMock;
    import org.puremvc.as3.multicore.utilities.fabrication.routing.Router;
    import org.puremvc.as3.multicore.utilities.fabrication.vo.ModuleAddress;

    /**
     * @author Darshan Sawardekar
     */
    public class ApplicationFabricatorTest extends BaseTestCase {

        public var fabricator:ApplicationFabricator;
        public var fabrication:IFabrication;
        public var fabricatorMock:Mock;
        public var fabricationMock:Mock;
        public var facadeMock:Mock;


        [Before]
        public function setUp():void
        {
            initializeFabrication();
            initializeFabricationMock();

            initializeFabricator();
            initializeFabricatorMock();
        }

        public function initializeFabrication():void
        {
            fabrication = new FabricationMock();
            fabricationMock = fabrication["mock"] as Mock;
        }

        public function initializeFabricationMock():void
        {
            fabricationMock.method("getStartupCommand").withNoArgs.returns(SimpleFabricationCommandMock);
            fabricationMock.method("addEventListener").withArgs("mockReady", Function);
            fabricationMock.method("removeEventListener").withArgs("mockReady", Function);
            fabricationMock.method("notifyFabricationCreated").withNoArgs.once;
            fabricationMock.method("notifyFabricationRemoved").withNoArgs.once;
            fabricationMock.method("dispatchEvent").withArgs(Event);
        }

        public function initializeFabricator():void
        {
            fabricator = new ApplicationFabricatorMock(fabrication, {readyEventName:"mockReady"});
            if (fabricator is IMockable) {
                fabricatorMock = (fabricator as IMockable).mock;
            }
        }

        public function initializeFabricatorMock():void
        {
            facadeMock = (fabricator.facade as FacadeMock).mock;
        }

        public function usingMockFabrication():Boolean
        {
            return fabrication is IMockable;
        }

        public function usingMockFabricator():Boolean
        {
            return fabricator is IMockable;
        }

        public function addInitSequenceMocks():void
        {
            fabricatorMock.method("initializeModuleAddress").withNoArgs.once.ordered();
            fabricatorMock.method("initializeFacade").withNoArgs.once.ordered();
            fabricatorMock.method("initializeEnvironment").withNoArgs.once.ordered();
            fabricatorMock.method("startApplication").withNoArgs.once.ordered();
            fabricatorMock.method("notifyFabricationCreated").withNoArgs.once.ordered();

            facadeMock.method("startup").withArgs(fabrication.getStartupCommand(), fabrication);
        }

        [After]
        public function tearDown():void
        {
            fabricationMock.ignoreMissing = true;
            fabricatorMock = null;
            fabricator = null;
            fabrication = null;
        }

        [Test]
        public function testApplicationFabricatorHasValidType():void
        {
            assertType(ApplicationFabricator, fabricator);
            assertType(IRouterAwareModule, fabricator);
            assertType(IDisposable, fabricator);
        }

        [Test]
        public function testApplicationFabricatorInitializesInCorrectSequence():void
        {
            addInitSequenceMocks();

            fabrication.dispatchEvent(new Event("mockReady"));

            verifyMock(fabricatorMock);
        }

        [Test]
        public function testApplicationFabricatorForwardsCreatedEventWhenApplicationIsReady():void
        {
            addInitSequenceMocks();

            fabricationMock.method("notifyFabricationCreated").withNoArgs.once;
            fabrication.dispatchEvent(new Event("mockReady"));

            verifyMock(fabricatorMock);
            verifyMock(facadeMock);
        }

        [Test]
        public function testApplicationFabricatorForwardsRemovedEventWhenApplicationIsDisposed():void
        {
            var fabrication:FabricationMock = new FabricationMock();
            var fabricationMock:Mock = fabrication.mock;
            fabricationMock.ignoreMissing = true;

            var fabricator:ApplicationFabricatorMock = new ApplicationFabricatorMock(fabrication, {readyEventName:"mockReady"});
            var fabricatorMock:Mock = fabricator.mock;
            fabricatorMock.ignoreMissing = true;
            fabricatorMock.method("notifyFabricationRemoved").withNoArgs.once;

            var facadeMock:Mock = (fabricator.facade as FacadeMock).mock;
            facadeMock.ignoreMissing = true;

            fabrication.dispatchEvent(new Event("mockReady"));
            fabricator.dispose();

            verifyMock(fabricatorMock);
        }


        [Test]
        public function testApplicationFabricatorGetsStartupCommandFromItsFabrication():void
        {
            var fabrication:FabricationMock = new FabricationMock();
            var fabricationMock:Mock = fabrication.mock;
            fabricationMock.ignoreMissing = true;
            fabricationMock.method("getStartupCommand").withNoArgs.returns(SimpleFabricationCommandMock);

            var fabricator:ApplicationFabricatorMock = new ApplicationFabricatorMock(fabrication, {readyEventName:"mockReady"});
            var fabricatorMock:Mock = fabricator.mock;
            fabricatorMock.ignoreMissing = true;

            var facadeMock:Mock = (fabricator.facade as FacadeMock).mock;
            facadeMock.ignoreMissing = true;

            assertNotNull(fabricator.startupCommand);
            assertEquals(SimpleFabricationCommandMock, fabricator.startupCommand);
            assertEquals(fabrication.getStartupCommand(), fabricator.startupCommand);
        }

        [Test]
        public function testApplicationFabricatorStoresCorrectFabrication():void
        {
            var fabrication:FabricationMock = new FabricationMock();
            var fabricationMock:Mock = fabrication.mock;
            fabricationMock.ignoreMissing = true;

            var fabricator:ApplicationFabricatorMock = new ApplicationFabricatorMock(fabrication, {readyEventName:"mockReady"});
            var fabricatorMock:Mock = fabricator.mock;
            fabricatorMock.ignoreMissing = true;

            var facadeMock:Mock = (fabricator.facade as FacadeMock).mock;
            facadeMock.ignoreMissing = true;

            assertNotNull(fabricator.fabrication);
            assertEquals(fabrication, fabricator.fabrication);
        }

        [Test]
        public function testApplicationFabricatorStoresModuleAddress():void
        {
            assertProperty(fabricator, "moduleAddress", IModuleAddress, null, new ModuleAddress("A", "A0"));
        }

        [Test]
        public function testApplicationFabricatorGetsIdFromItsFabrication():void
        {
            fabricationMock.property("id").returns(instanceName);
            assertNotNull(fabricator.id);
            assertEquals(instanceName, fabrication.id);
        }

        [Test]
        public function testApplicationFabricatorStoresDefaultRoute():void
        {
            assertProperty(fabricator, "defaultRoute", String, null, "*");
        }

        [Test]
        public function testApplicationFabricatorHasValidClassNameAndInstanceName():void
        {
            var fabrication:FabricationMock = new FabricationMock();
            var fabricationMock:Mock = fabrication.mock;
            fabricationMock.ignoreMissing = true;
            fabricationMock.method("getStartupCommand").withNoArgs.returns(SimpleFabricationCommandMock1);

            var fabricator:ApplicationFabricatorMock = new ApplicationFabricatorMock(fabrication, {readyEventName:"mockReady"});
            var fabricatorMock:Mock = fabricator.mock;
            fabricatorMock.ignoreMissing = true;

            var facadeMock:Mock = (fabricator.facade as FacadeMock).mock;
            facadeMock.ignoreMissing = true;

            assertEquals(SimpleFabricationCommandMock1, fabricator.startupCommand);
            assertNotNull(fabricator.applicationClassName);
            assertEquals("SimpleFabricationMock1", fabricator.applicationClassName);

            assertContained("SimpleFabricationMock1", fabricator.applicationInstanceName);
            assertMatch(new RegExp("SimpleFabricationMock1[0-9]+", ""), fabricator.applicationInstanceName);
        }

        [Test]
        public function testApplicationFabricatorStoresRouter():void
        {
            assertProperty(fabricator, "router", IRouter, null, new Router());
        }

        [Test]
        public function testApplicationFabricatorResetsAfterDisposal():void
        {
            var fabrication:FabricationMock = new FabricationMock();
            var fabricationMock:Mock = fabrication.mock;
            fabricationMock.ignoreMissing = true;

            var fabricator:ApplicationFabricatorMock = new ApplicationFabricatorMock(fabrication, {readyEventName:"mockReady"});
            var fabricatorMock:Mock = fabricator.mock;
            fabricatorMock.ignoreMissing = true;

            var facadeMock:Mock = (fabricator.facade as FacadeMock).mock;
            facadeMock.ignoreMissing = true;

            fabricator.dispose();

            assertNull(fabricator.facade);
            assertNull(fabricator.router);
        }

        [Test]
        public function testApplicationFabricatorAllowsManualInstanceNames():void
        {
            addInitSequenceMocks();
            fabricator.applicationInstanceName = instanceName + "Instance";

            fabrication.dispatchEvent(new Event("mockReady"));

            assertEquals(instanceName + "Instance", fabricator.applicationInstanceName);
            verifyMock(fabricatorMock);
        }


    }
}
