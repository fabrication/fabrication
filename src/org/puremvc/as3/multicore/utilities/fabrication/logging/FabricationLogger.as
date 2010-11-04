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

package org.puremvc.as3.multicore.utilities.fabrication.logging {
    import flash.display.DisplayObject;
    import flash.events.SecurityErrorEvent;
    import flash.events.StatusEvent;
    import flash.net.LocalConnection;
    import flash.net.registerClassAlias;
    import flash.utils.ByteArray;
    import flash.utils.getQualifiedClassName;

    import flash.utils.getTimer;

    import org.as3commons.reflect.Type;
    import org.puremvc.as3.multicore.interfaces.IMediator;
    import org.puremvc.as3.multicore.interfaces.INotification;
    import org.puremvc.as3.multicore.interfaces.IProxy;
    import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IFabrication;
    import org.puremvc.as3.multicore.utilities.fabrication.logging.action.Action;
    import org.puremvc.as3.multicore.utilities.fabrication.logging.action.ActionType;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.observer.TransportNotification;

    /**
     * @author Rafał Szemraj
     */
    public class FabricationLogger {

        private static var INSTANCE:FabricationLogger;


        public static function getInstance():FabricationLogger
        {

            return INSTANCE ? INSTANCE : INSTANCE = new FabricationLogger(new SingletonEnforcer());

        }

        public static const LOGGER_ID:String = "_org.puremvc.as3.multicore.utilities.fabrication";

        private var _lc:LocalConnection;

        private var _flowActionsCounter:int = 0;


        public function FabricationLogger(se:SingletonEnforcer)
        {
            if (se == null)
                throw new Error("Private constructor invocation error");
            registerClassAlias("org.puremvc.as3.multicore.utilities.fabrication.logging.action.Action", Action);
            _lc = new LocalConnection();
            _lc.addEventListener(SecurityErrorEvent.SECURITY_ERROR, _lc_securityErrorHandler, false, 0, true);
            _lc.addEventListener(StatusEvent.STATUS, _lc_securityStatusHandler, false, 0, true);

        }

        /**
         * Logs fabricator start action
         * @param fabrication fabricator instance
         * @param fabricationName fabrication name
         */
        public function logFabricatorStart(fabrication:IFabrication, fabricationName:String):void
        {
            var action:Action = new Action();
            action.actorName = "Fabrication: " + fabricationName;
            action.message = " [ " + fabricationName + " ] " + "fabrication has started";
            action.type = ActionType.FABRICATION_START;
            var infoObject:Object = {};
            infoObject.fabrication = fabricationName;
            infoObject.id = fabrication.id;
            infoObject.config = parseObject(fabrication.config);
            action.infoObject = infoObject;
            logAction(action);
        }

        /**
         * Logs mediator registration action
         * @param mediator IMediator instance
         */
        public function logMediatorRegistration(mediator:IMediator):void
        {
            var action:Action = new Action();
            var mediatorName:String = mediator.getMediatorName();
            action.actorName = "Mediator: " + mediatorName;
            action.message = " [ " + mediatorName + " ] mediator has been registered";
            action.type = ActionType.MEDIATOR_REGISTERED;
            var infoObject:Object = {};
            infoObject.mediatorName = mediatorName;
            var mediatorComponent:DisplayObject = mediator.getViewComponent() as DisplayObject;
            if (mediatorComponent) {
                infoObject.viewComponentClass = getQualifiedClassName(mediatorComponent);
                infoObject.notificationInterests = mediator.listNotificationInterests();
            }
            action.infoObject = infoObject;
            logAction(action);
        }

        /**
         * Logs proxy registration action
         * @param proxy IProxy instance
         */
        public function logProxyRegistration(proxy:IProxy):void
        {
            if (!isFrameworkInstanceFlow(proxy)) {
                var action:Action = new Action();
                var proxyName:String = proxy.getProxyName();
                action.actorName = "Proxy: " + proxyName;
                action.message = " [ " + proxyName + " ] proxy has been registered";
                action.type = ActionType.PROXY_REGISTERED;
                var infoObject:Object = {};
                infoObject.proxyName = proxyName;
                infoObject.data = parseObject(proxy.getData());
                action.infoObject = infoObject;
                logAction(action);
            }
        }

        /**
         * Logs command registration action
         * @param commandClass command Class
         * @param notificationName notification name on wich command is registered
         */
        public function logCommandRegistration(commandClass:Class, notificationName:String):void
        {
            if (!isFrameworkClassFlow(commandClass)) {

                var commandClassName:String = getClassName(commandClass);
                var action:Action = new Action();
                action.actorName = "Command: " + commandClassName;
                action.message = " [ " + commandClassName + " ] command has been registered for notification [ " + notificationName + " ]";
                action.type = ActionType.COMMAND_REGISTERED;
                logAction(action);
            }
        }

        /**
         * Logs interceptor registration action
         * @param interceptorClass interceoptor Class
         * @param notificationName notification name on wich interceptor is registered
         * @param parameters [ optional ] interceptor optional parameters
         */
        public function logInterceptorRegistration(interceptorClass:Class, notificationName:String, parameters:Object = null):void
        {
            if (!isFrameworkClassFlow(interceptorClass)) {

                var interceptorClassName:String = getClassName(interceptorClass);
                var action:Action = new Action();
                action.actorName = "Interceptor: " + interceptorClassName;
                action.message = " [ " + interceptorClassName + " ] interceptor has been registered";
                action.message += " for notification [ " + notificationName + " ]";
                action.type = ActionType.INTERCEPTOR_REGISTERED;
                if (parameters) {
                    action.infoObject = { interceptorClass:interceptorClassName, parameters:parseObject(parameters) };
                }
                logAction(action);
            }
        }

        /**
         * Logs notification route action
         * @param sender object that sends notification
         * @param notification INotification instance
         * @param to notification reciever
         */
        public function logRouteNotificationAction(notification:TransportNotification):void
        {
            var action:Action = new Action();
            var notificationName:String = notification.getName();
            action.actorName = "Notification: " + notificationName;
            action.message = " Notification [ " + notificationName + " ] has been routed";
            if (notification.getTo())
                action.message += " to [ " + notification.getTo() + " ]";
            action.type = ActionType.NOTIFICATION_ROUTE;
            var notificationObject:Object = {};
            notificationObject.name = notificationName;
            notificationObject.body = parseObject(notification.getBody());
            notificationObject.type = notification.getType();
            var flowInfoObject:Object = {};
            flowInfoObject = notificationObject;
            action.infoObject = flowInfoObject;
            logAction(action);
        }

        /**
         * Logs send notification action
         * @param sender object that sends notification
         * @param notification INotification instance
         */
        public function logSendNotificationAction(notification:INotification):void
        {
            var action:Action = new Action();
            var notificationName:String = notification.getName();
            action.actorName = "Notification: " + notificationName;
            action.message = " Notification [ " + notificationName + " ] has been sent";
            action.type = ActionType.NOTIFICATION_SENT;
            var notificationObject:Object = {};
            notificationObject.name = notificationName;
            notificationObject.body = parseObject(notification.getBody());
            notificationObject.type = notification.getType();
            var flowInfoObject:Object = {};
            flowInfoObject = notificationObject;
            action.infoObject = flowInfoObject;
            logAction(action);
        }



        /**
         * Logs fabrication framework error
         * @param message error message to log
         */
        public function error(message:String):void
        {
            logFrameworkMessage(message, LogLevel.ERROR.getName());

        }

        /**
         * Logs fabrication framework warning
         * @param message warning message to log
         */
        public function warn(message:String):void
        {
            logFrameworkMessage(message, LogLevel.WARN.getName());
        }

        private function logFrameworkMessage(message:String, logLevelName:String):void
        {
            _lc.send(LOGGER_ID, "logFrameworkMessage", message, logLevelName);
        }

        private function logAction(action:Action):void
        {
            action.index = ++_flowActionsCounter;
            action.timestamp = new Date().time;
            _lc.send(LOGGER_ID, "logAction", action);

        }


        private function getClassName(clazz:Class):String
        {
            return getQualifiedClassName(clazz).replace(/^[\w\.]*::/, "");
        }

        private function isFrameworkClassFlow(clazz:Class):Boolean
        {

            return getQualifiedClassName(clazz).indexOf("org.puremvc.as3.multicore.utilities.fabrication") != -1;
        }

        private function isFrameworkInstanceFlow(instance:*):Boolean
        {

            return getQualifiedClassName(instance).indexOf("org.puremvc.as3.multicore.utilities.fabrication") != -1;
        }

        private function _lc_securityStatusHandler(event:StatusEvent):void
        {
        }


        private function _lc_securityErrorHandler(event:SecurityErrorEvent):void
        {
            error(event.toString());
        }

        private function parseObject(input:*):Object
        {
            if (null == input) return null;

            var ob:Object;
            var output:Object = [];
            if (input is Array) {

                var inputArray:Array = input as Array;
                var l:uint = inputArray.length;
                for (var i:int = 0; i < l; ++i) {

                    inputArray[ i ] = parseObject(inputArray[ i ]);

                }
                output = inputArray;

            }

            else if (input is DisplayObject) {

                ob = {};
                var inputDisplayObject:DisplayObject = input as DisplayObject;
                ob["name"] = "" + inputDisplayObject.name;
                ob["class"] = Type.forInstance(inputDisplayObject).name;
                output = ob;

            }

            else {

                for (var elementName:String in input) {

                    ob = input[elementName];
                    if (ob == input)
                        continue;
                    for (var elementName2:String in ob) {

                        if (ob[elementName2] == input)
                            continue;
                    }
                    output[elementName] = parseObject(input[elementName])

                }
                output = input;
            }

            var ba:ByteArray = new ByteArray();
            ba.writeObject(output);
            return ba.length > 40000 ? "object size exceeds 40K" : output;


        }

    }
}
class SingletonEnforcer {
}