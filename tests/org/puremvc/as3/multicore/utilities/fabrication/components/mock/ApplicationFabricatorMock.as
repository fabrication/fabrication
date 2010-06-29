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

package org.puremvc.as3.multicore.utilities.fabrication.components.mock {
    import com.anywebcam.mock.Mock;

    import org.puremvc.as3.multicore.utilities.fabrication.addons.IMockable;
    import org.puremvc.as3.multicore.utilities.fabrication.components.fabricator.*;
    import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IFabrication;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.facade.mock.FacadeMock;

    /**
     * @author Darshan Sawardekar
     */
    public class ApplicationFabricatorMock extends ApplicationFabricator implements IMockable {

        private var _mock:Mock = null;

        public function ApplicationFabricatorMock(_fabrication:IFabrication, mockOptions:Object)
        {
            super(initializeMock(_fabrication, mockOptions));
        }

        public function initializeMock(_fabrication:IFabrication, mockOptions:Object):IFabrication
        {

            _mock = new Mock(this);
            _mock.property("readyEventName").returns(mockOptions.readyEventName);

            // the mock facade is created earlier to allow mocks to be setup on it
            // before hand. These will actually get executed in the init sequence.
            _facade = new FacadeMock(multitonKey);


            return _fabrication;
        }

        public function get mock():Mock
        {

            return _mock;

        }

        override public function dispose():void
        {
            super.dispose();
        }

        override protected function get readyEventName():String
        {
            return _mock.readyEventName;
        }

        override protected function initializeModuleAddress():void
        {
            _mock.initializeModuleAddress();
        }

        override protected function initializeFacade():void
        {
            _mock.initializeFacade();
        }

        override protected function initializeEnvironment():void
        {
            _mock.initializeEnvironment();
        }

        override protected function startApplication():void
        {
            _mock.startApplication();
            super.startApplication();
        }

        override protected function notifyFabricationCreated():void
        {
            _mock.notifyFabricationCreated();
            super.notifyFabricationCreated();
        }

        override protected function notifyFabricationRemoved():void
        {
            _mock.notifyFabricationRemoved();
            super.notifyFabricationRemoved();
        }

    }
}
