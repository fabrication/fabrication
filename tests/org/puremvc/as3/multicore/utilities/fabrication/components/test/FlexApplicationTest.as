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

package org.puremvc.as3.multicore.utilities.fabrication.components.test {
    import flash.events.Event;

    import mx.core.Application;
    import mx.events.FlexEvent;

    import org.puremvc.as3.multicore.utilities.fabrication.components.sut.TestFlexApplication;
    import org.puremvc.as3.multicore.utilities.fabrication.components.sut.TestFlexHaloApplication;

    /**
     * @author Darshan Sawardekar
     */
    [RunWith("org.flexunit.runners.Parameterized")]
    public class FlexApplicationTest extends AbstractApplicationTest {

        private var applicationClass:Class;

        public function FlexApplicationTest( testAppClass:Class )
        {
            applicationClass = testAppClass;
        }

        [Parameters]
        public static function getApplication():Array {

            return [[ TestFlexHaloApplication ],[ TestFlexApplication ]]


        }

        override protected function initializeFabrication():void
        {
            fabrication = new applicationClass();
        }


        override protected function getReadyEvent():Event
        {
            return new FlexEvent(FlexEvent.CREATION_COMPLETE);
        }

    }

}
