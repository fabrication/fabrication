/**
 * Copyright (C) 2010 Rafał Szemraj.
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

package org.puremvc.as3.multicore.utilities.fabrication.logging.action {

    /**
     * @author Rafał Szemraj
     */
    public class ActionType {

        public static const COMMAND_REGISTERED:String = "Command registered";
        public static const INTERCEPTOR_REGISTERED:String = "Interceptor registered";
        public static const PROXY_REGISTERED:String = "Proxy registered";
        public static const MEDIATOR_REGISTERED:String = "Mediator registered";
        public static const NOTIFICATION_SENT:String = "Notification sent";
        public static const NOTIFICATION_ROUTE:String = "Notification routed";
        public static const FABRICATION_START:String = "Fabrication start";
        public static const SERVICE_CALL:String = "Service call";
    }
}