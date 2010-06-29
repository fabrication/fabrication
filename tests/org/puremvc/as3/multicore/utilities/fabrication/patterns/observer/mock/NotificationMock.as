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

package org.puremvc.as3.multicore.utilities.fabrication.patterns.observer.mock {
    import com.anywebcam.mock.Mock;

    import org.puremvc.as3.multicore.patterns.observer.Notification;
    import org.puremvc.as3.multicore.utilities.fabrication.addons.IMockable;

    /**
     * @author Darshan Sawardekar
     */
    public class NotificationMock extends Notification implements IMockable {

        private var _mock:Mock;

        public function NotificationMock(name:String, body:Object = null, type:String = null)
        {
            super(name, body, type);
        }

        public function get mock():Mock
        {
            if (_mock == null) {
                _mock = new Mock(this, true);
            }

            return _mock;
        }

        override public function getName():String
        {
            return mock.getName();
        }

        override public function setBody(body:Object):void
        {
            mock.setBody(body);
        }

        override public function setType(type:String):void
        {
            mock.setType(type);
        }

        override public function getType():String
        {
            return mock.getType();
        }

    }
}
