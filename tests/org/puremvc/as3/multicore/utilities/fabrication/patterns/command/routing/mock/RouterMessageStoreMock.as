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

package org.puremvc.as3.multicore.utilities.fabrication.patterns.command.routing.mock {
    import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IRouterMessage;
    import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IRouterMessageStore;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.observer.mock.NotificationMock;

    /**
     * @author Darshan Sawardekar
     */
    public class RouterMessageStoreMock extends NotificationMock implements IRouterMessageStore {

        public function RouterMessageStoreMock(name:String, body:Object = null, type:String = null)
        {
            super(name, body, type);
        }

        public function getMessage():IRouterMessage
        {
            return mock.getMessage();
        }

        public function setMessage(message:IRouterMessage):void
        {
            mock.setMessage(message);
        }

    }
}
