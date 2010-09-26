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

package org.puremvc.as3.multicore.utilities.fabrication.logging.channel {


    import flash.events.SecurityErrorEvent;
    import flash.events.StatusEvent;
    import flash.net.LocalConnection;

    import flash.utils.ByteArray;

    import org.puremvc.as3.multicore.utilities.fabrication.logging.FabricationLogger;
    import org.puremvc.as3.multicore.utilities.fabrication.logging.LogLevel;

    public class FabricationLoggerChannel implements ILogChannel {

        private static var _instance:FabricationLoggerChannel;
        private var lc:LocalConnection;

        public static function getInstance():FabricationLoggerChannel
        {

            return _instance ? _instance : _instance = new FabricationLoggerChannel(new SingletonEnforcer());
        }

        public function FabricationLoggerChannel(se:SingletonEnforcer)
        {
            if (null == se) {
                throw new Error("Private constructor invocation error");
            }
            lc = new LocalConnection();
            lc.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError, false, 0, true);
            lc.addEventListener(StatusEvent.STATUS, onStatusEvent, false, 0, true);
        }

        /**
		 * @inheritDoc
		 */
        public function log(message:*, logLevel:LogLevel, loggingObject:String):void
        {

            lc.send( FabricationLogger.LOGGER_ID, "logMessage", "" + loggingObject + " : " + message, logLevel.getName());
        }

        /**
		 * @inheritDoc
		 */
        public function inspectObject(object:*, objectName:String = "object"):void
        {

            var ba:ByteArray = new ByteArray();
            ba.writeObject( object );
            ba.compress();
            lc.send(FabricationLogger.LOGGER_ID, "inspectObject", ba, objectName );
        }

        /**
         * Clears channel's output.
         */
        public function clearOutput():void
        {
        }

        private function onSecurityError(event:SecurityErrorEvent):void
        {
        }

        private function onStatusEvent(event:StatusEvent):void
        {
        }
    }
}

class SingletonEnforcer {
}
