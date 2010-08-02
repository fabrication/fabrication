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
    import flash.utils.getQualifiedClassName;

    import org.as3commons.reflect.Accessor;
    import org.as3commons.reflect.Field;
    import org.as3commons.reflect.IMember;
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
            infoObject.config = fabrication.config;
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
            var action:Action = new Action();
            var proxyName:String = proxy.getProxyName();
            action.actorName = "Proxy: " + proxyName;
            action.message = " [ " + proxyName + " ] proxy has been registered";
            action.type = ActionType.PROXY_REGISTERD;
            var infoObject:Object = {};
            infoObject.proxyName = proxyName;
            infoObject.data = proxy.getData();
//            infoObject = retreieveProps(proxy, infoObject);
            action.infoObject = infoObject;
            logAction(action);
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
                action.actorName =  "Interceptor: " + interceptorClassName; ;
                action.message = " [ " + interceptorClassName + " ] interceptor has been registered";
                action.message += " for notification [ " + notificationName + " ]";
                action.type = ActionType.INTERCEPTOR_REGISTERED;
                if (parameters) {
                    action.infoObject = { interceptorClass:interceptorClassName, parameters:parameters };
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
        public function logRouteNotificationAction( notification:TransportNotification ):void
        {
//            var senderIsProxy:Boolean = sender is IProxy;
//            var senderIsMediator:Boolean = sender is IMediator;
//            var senderName:String = ( senderIsProxy ? ( sender as IProxy).getProxyName() : senderIsMediator ? ( sender as IMediator ).getMediatorName() : "command" );
            var action:Action = new Action();
            var notificationName:String = notification.getName();
            action.actorName = "Notification: " + notificationName;
//            action.message = ( senderIsProxy ? " proxy" : " mediator" ) + " [ ";
//            action.message += senderName + " ]";
            action.message = " Notification [ " + notificationName + " ] has been routed";
            if (notification.getTo())
                action.message += " to [ " + notification.getTo() + " ]";
            action.type = ActionType.NOTIFICATION_ROUTE;
            var notificationObject:Object = {};
            notificationObject.name = notificationName;
            notificationObject.body = notification.getBody();
            notificationObject.type = notification.getType();
//            notificationObject = retreieveProps(notificationObject, notificationObject);
            var flowInfoObject:Object = {};
//            var senderObject:Object = {};
            /*if (senderIsProxy) {
                var proxy:IProxy = sender as IProxy;
                senderObject.proxyName = proxy.getProxyName();
                senderObject.data = proxy.getData();
                senderObject = retreieveProps(proxy, senderObject);
                flowInfoObject.proxy = senderObject;
            }
            else if (senderIsMediator) {
                var mediator:IMediator = sender as IMediator;
                senderObject.mediatorName = mediator.getMediatorName();
                senderObject.viewComponent = mediator.getViewComponent();
                flowInfoObject.mediator = senderObject;
            }*/
            flowInfoObject = notificationObject;
            action.infoObject = flowInfoObject;
            logAction(action);
        }

        /**
         * Logs send notification action
         * @param sender object that sends notification
         * @param notification INotification instance
         */
        public function logSendNotificationAction( notification:INotification):void
        {
//            var senderIsProxy:Boolean = sender is IProxy;
//            var senderIsMediator:Boolean = sender is IMediator;
//            var senderName:String = ( senderIsProxy ? ( sender as IProxy).getProxyName() : senderIsMediator ? ( sender as IMediator ).getMediatorName() : "command" );
            var action:Action = new Action();
            var notificationName:String = notification.getName();
            action.actorName = "Notification: " + notificationName;
//            action.message = " " + ( senderIsProxy ? " proxy" : " mediator" ) + " [ ";
//            action.message += senderName + " ]";
            action.message = " Notification [ " + notificationName + " ] has been sent";
            action.type = ActionType.NOTIFICATION_SENT;
            var notificationObject:Object = {};
            notificationObject.name = notificationName;
            notificationObject.body = notification.getBody();
            notificationObject.type = notification.getType();
//            notificationObject = retreieveProps(notificationObject, notificationObject);
            var flowInfoObject:Object = {};
//            var senderObject:Object = {};
//            if (senderIsProxy) {
//                var proxy:IProxy = sender as IProxy;
//                senderObject.proxyName = proxy.getProxyName();
//                senderObject.data = proxy.getData();
//                senderObject = retreieveProps(proxy, senderObject);
//                flowInfoObject.proxy = senderObject;
//            }
//            else if (senderIsMediator) {
//                var mediator:IMediator = sender as IMediator;
//                senderObject.mediatorName = mediator.getMediatorName();
//                senderObject.viewComponent = mediator.getViewComponent();
//                flowInfoObject.mediator = senderObject;
//            }
            flowInfoObject = notificationObject;
            action.infoObject = flowInfoObject;
            logAction(action);
        }

        //        public function logServiceCall(proxy:IProxy, message:Object, eventArgs:Array = null):void
        //        {
        //            var action:Action = new Action();
        //            action.actorName = proxy.getProxyName();
        //            action.message = " service call by [ " + proxy.getProxyName() + " ]";
        //            action.type = ActionType.SERVICE_CALL;
        //            var callObject:Object = {};
        //            var proxyObject:Object = {};
        //            proxyObject.proxyName = proxy.getProxyName();
        //            proxyObject.data = proxy.getData();
        //            proxyObject = retreieveProps(proxy, proxy);
        //            callObject.proxy = proxy;
        //            callObject.callMessage = message;
        //            if (eventArgs)
        //                callObject.eventArgs = eventArgs;
        //            action.infoObject = callObject;
        //            logAction(action);
        //        }

        //        public function logServiceResponse(proxy:IProxy, result:Object):void
        //        {
        //            var action:Action = new Action();
        //            action.actorName = proxy.getProxyName();
        //            action.message = " response for call by [ " + proxy.getProxyName() + " ]";
        //            action.type = ActionType.SERVICE_CALL;
        //            var callObject:Object = {};
        //            var proxyObject:Object = {};
        //            proxyObject.proxyName = proxy.getProxyName();
        //            proxyObject.data = proxy.getData();
        //            proxyObject = retreieveProps(proxy, proxy);
        //            callObject.proxy = proxy;
        //            callObject.result = result;
        //            action.infoObject = callObject;
        //            logAction(action);
        //        }

        //        public function logServiceFault(proxy:IProxy, fault:Object):void
        //        {
        //            var action:Action = new Action();
        //            action.actorName = proxy.getProxyName();
        //            action.message = " fault for call by [ " + proxy.getProxyName() + " ]";
        //            action.type = ActionType.SERVICE_CALL;
        //            var callObject:Object = {};
        //            var proxyObject:Object = {};
        //            proxyObject.proxyName = proxy.getProxyName();
        //            proxyObject.data = proxy.getData();
        //            proxyObject = retreieveProps(proxy, proxy);
        //            callObject.proxy = proxy;
        //            callObject.fault = fault;
        //            action.infoObject = callObject;
        //            logAction(action);
        //            frameworkError("fault on call for [ " + fault.toString() + " ]");
        //        }


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
            _lc.send(LOGGER_ID, "logAction", action);

        }


        /*private function retreieveProps(object:Object, infoObject:Object, deepLevel:int = 0):Object
        {


            var type:Type = Type.forInstance(object);
            var innerObject:Object;
            var ob:Object;
            // accesors
            var accesors:Array = type.accessors;
            var accesorssElement:Accessor;
            for (var i:int = 0; i < accesors.length; ++i) {

                accesorssElement = Accessor(accesors[ i ]);
                if (accesorssElement.name == "prototype" || accesorssElement.isStatic || accesorssElement.isWriteable()) continue;
                innerObject = {};
                ob = object[ accesorssElement.name ];
                if (deepLevel < 2 && ob != null && !isSimple(ob)) {

                    innerObject = retreieveProps(ob, innerObject, deepLevel + 1);
                    infoObject[ accesorssElement.name ] = innerObject;
                }
                else
                    infoObject[ accesorssElement.name ] = ob;

            }

            var fields:Array = type.fields.filter(filterArrayForProxyProps);
            var fieldElement:Field;
            for (i = 0; i < fields.length; ++i) {

                fieldElement = Field(fields[ i ]);
                if (fieldElement.isStatic) continue;
                innerObject = {};
                ob = object[ fieldElement.name ];
                if (deepLevel < 2 && ob != null && !isSimple(ob)) {

                    innerObject = retreieveProps(ob, innerObject, deepLevel + 1);
                    infoObject[ fieldElement.name ] = innerObject;
                }
                else
                    infoObject[ fieldElement.name ] = ob;

            }


            return infoObject;
        }*/


        private function getClassName(clazz:Class):String
        {
            return getQualifiedClassName(clazz).replace(/^[\w\.]*::/, "");
        }

        private function isFrameworkClassFlow(clazz:Class):Boolean
        {

            return getQualifiedClassName(clazz).indexOf("org.puremvc.as3.multicore.utilities.fabrication") != -1;
        }

        private function _lc_securityStatusHandler(event:StatusEvent):void
        {
        }


        private function _lc_securityErrorHandler(event:SecurityErrorEvent):void
        {
            error(event.toString());
        }


        private function filterArrayForProxyProps(item:IMember, index:int, array:Array):Boolean
        {

            var memberName:String = item.name;
            return memberName != "expansion";


        }

        private function isSimple(value:Object):Boolean
        {
            var type:String = typeof(value);
            switch (type) {
                case "number":
                case "string":
                case "boolean":
                {
                    return true;
                }

                case "object":
                {
                    return (value is Date) || (value is Array);
                }
                default: return false;
            }

            return false;
        }

    }
}
class SingletonEnforcer {
}