/*
 * Copyright (C) 2010 Rafał Szemraj, ( http://szemraj.eu )
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
    import flash.events.SecurityErrorEvent;
    import flash.events.StatusEvent;
    import flash.net.LocalConnection;
    import flash.net.registerClassAlias;
    import flash.utils.getQualifiedClassName;

    import mx.core.UIComponent;

    import org.as3commons.reflect.Accessor;
    import org.as3commons.reflect.Field;
    import org.as3commons.reflect.IMember;
    import org.as3commons.reflect.Type;
    import org.puremvc.as3.multicore.interfaces.IMediator;
    import org.puremvc.as3.multicore.interfaces.INotification;
    import org.puremvc.as3.multicore.interfaces.IProxy;
    import org.puremvc.as3.multicore.utilities.fabrication.components.FlexModule;
    import org.puremvc.as3.multicore.utilities.fabrication.components.FlexModuleLoader;
    import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IFabrication;
    import org.puremvc.as3.multicore.utilities.fabrication.logging.action.Action;
    import org.puremvc.as3.multicore.utilities.fabrication.logging.action.ActionType;

    /**
     * @author Rafał Szemraj
     * @version 0.9
     */
    public class FabricationLogger {

        private static var INSTANCE:FabricationLogger;


        public static function getInstance():FabricationLogger
        {

            return INSTANCE ? INSTANCE : INSTANCE = new FabricationLogger(new SingletonEnforcer());

        }

        private static const LOGGER_ID:String = "_org.puremvc.as3.multicore.utilities.fabrication";

        private var _lc:LocalConnection;

        private var _flowActionsCounter:int = 0;

        private var _logHandlers:Array = [];
        /* of Function */


        public function FabricationLogger(se:SingletonEnforcer)
        {
            if (se == null)
                throw new Error("Private constructor invocation error");
            registerClassAlias( "org.puremvc.as3.multicore.utilities.fabrication.logging.action.Action", Action );
            _lc = new LocalConnection();
            _lc.addEventListener(SecurityErrorEvent.SECURITY_ERROR, _lc_securityErrorHandler, false, 0, true);
            _lc.addEventListener(StatusEvent.STATUS, _lc_securityStatusHandler, false, 0, true);

        }

        public function addLogHandler(func:Function):void
        {

            _logHandlers.push(func);
        }

        public function logFabricatorStart(fabrication:IFabrication, fabricationName:String):void
        {
            var fabricationIsModule:Boolean = fabrication is FlexModule || fabrication is FlexModuleLoader;
            var action:Action = new Action();
            action.actorName = fabricationName;
            action.message = " [ " + fabricationName + " ] " + ( fabricationIsModule ? "module has started" : "application has started" );
            action.type = ActionType.FABRICATION_START;
            var infoObject:Object = {};
            infoObject.fabrication = fabricationName;
            infoObject.id = fabrication.id;
            infoObject.config = fabrication.config;
            action.infoObject = infoObject;
            logAction(action);
        }

        public function logMediatorRegistration(mediator:IMediator):void
        {
            var action:Action = new Action();
            var mediatorName:String = mediator.getMediatorName();
            action.actorName = mediatorName;
            action.message = "[ " + action.actorName + " ] mediator has been registered";
            action.type = ActionType.MEDIATOR_REGISTERED;
            var infoObject:Object = {};
            infoObject.mediatorName = mediatorName;
            var mediatorComponent:UIComponent = mediator.getViewComponent() as UIComponent;
            if (mediatorComponent) {
                infoObject.viewComponentClass = getQualifiedClassName(mediatorComponent);
                infoObject.notificationInterests = mediator.listNotificationInterests();
            }
            action.infoObject = infoObject;
            logAction(action);
        }

        public function logProxyRegistration(proxy:IProxy):void
        {
            var action:Action = new Action();
            var proxyName:String = proxy.getProxyName();
            action.actorName = proxyName;
            action.message = "[ " + action.actorName + " ] proxy has been registered";
            action.type = ActionType.PROXY_REGISTERD;
            var infoObject:Object = {};
            infoObject.proxyName = proxyName;
            infoObject.data = proxy.getData();
            infoObject = retreieveProps(proxy, infoObject);
            action.infoObject = infoObject;
            logAction(action);
        }

        public function logCommandRegistration(commandClass:Class, notificationName:String):void
        {
            if (!isFrameworkClassFlow(commandClass)) {
                var action:Action = new Action();
                action.actorName = getClassName(commandClass);
                action.message = "[ " + action.actorName + " ] command has been registered for notification [ " + notificationName + " ]";
                action.type = ActionType.COMMAND_REGISTERED;
                logAction(action);
            }
        }

        public function logInterceptorRegistration(interceptorClass:Class, notificationName:String, parameters:Object = null):void
        {
            if (!isFrameworkClassFlow(interceptorClass)) {
                var action:Action = new Action();
                var interceptorClassName:String = getClassName(interceptorClass);
                action.actorName = interceptorClassName;
                action.message = "[ " + action.actorName + " ] interceptor has been registered";
                action.message += " for notification [ " + notificationName + " ]";
                action.type = ActionType.INTERCEPTOR_REGISTERED;
                if (parameters) {
                    action.infoObject = { interceptorClass:interceptorClassName, parameters:parameters };
                }
                logAction(action);
            }
        }

        public function logRouteNotificationAction(sender:Object, notification:INotification, to:Object):void
        {
            var senderIsProxy:Boolean = sender is IProxy;
            var senderIsMediator:Boolean = sender is IMediator;
            var senderName:String = ( senderIsProxy ? ( sender as IProxy).getProxyName() : senderIsMediator ? ( sender as IMediator ).getMediatorName() : "command" );
            var action:Action = new Action();
            var notificationName:String = notification.getName() + " routed by " + senderName;
            action.actorName = notificationName;
            action.message = ( senderIsProxy ? " proxy" : " mediator" ) + " [ ";
            action.message += senderName + " ]";
            action.message += " route notification [ " + notificationName + " ]";
            if (to)
                action.message += " to [ " + to + " ]";
            action.type = ActionType.NOTIFICATION_ROUTE;
            var notificationObject:Object = {};
            notificationObject.name = notificationName;
            notificationObject.body = notification.getBody();
            notificationObject.type = notification.getType();
            notificationObject = retreieveProps(notificationObject, notificationObject);
            var flowInfoObject:Object = {};
            var senderObject:Object = {};
            if (senderIsProxy) {
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
            }
            flowInfoObject.notification = notificationObject;
            action.infoObject = flowInfoObject;
            logAction(action);
        }

        public function logSendNotificationAction(sender:Object, notification:INotification):void
        {
            var senderIsProxy:Boolean = sender is IProxy;
            var senderIsMediator:Boolean = sender is IMediator;
            var senderName:String = ( senderIsProxy ? ( sender as IProxy).getProxyName() : senderIsMediator ? ( sender as IMediator ).getMediatorName() : "command" );
            var action:Action = new Action();
            var notificationName:String = notification.getName();
            action.actorName = notificationName + " sent by " + senderName;
            action.message = ( senderIsProxy ? " proxy" : " mediator" ) + " [ ";
            action.message += senderName + " ]";
            action.message += " sent notification [ " + notificationName + " ]";
            action.type = ActionType.NOTIFICATION_SENT;
            var notificationObject:Object = {};
            notificationObject.name = notificationName;
            notificationObject.body = notification.getBody();
            notificationObject.type = notification.getType();
            notificationObject = retreieveProps(notificationObject, notificationObject);
            var flowInfoObject:Object = {};
            var senderObject:Object = {};
            if (senderIsProxy) {
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
            }
            flowInfoObject.notification = notificationObject;
            action.infoObject = flowInfoObject;
            logAction(action);
        }

        public function logServiceCall(proxy:IProxy, message:Object, eventArgs:Array = null):void
        {
            var action:Action = new Action();
            action.actorName = proxy.getProxyName();
            action.message = " service call by [ " + proxy.getProxyName() + " ]";
            action.type = ActionType.SERVICE_CALL;
            var callObject:Object = {};
            var proxyObject:Object = {};
            proxyObject.proxyName = proxy.getProxyName();
            proxyObject.data = proxy.getData();
            proxyObject = retreieveProps(proxy, proxy);
            callObject.proxy = proxy;
            callObject.callMessage = message;
            if (eventArgs)
                callObject.eventArgs = eventArgs;
            action.infoObject = callObject;
            logAction(action);
        }

        public function logServiceResponse(proxy:IProxy, result:Object):void
        {
            var action:Action = new Action();
            action.actorName = proxy.getProxyName();
            action.message = " response for call by [ " + proxy.getProxyName() + " ]";
            action.type = ActionType.SERVICE_CALL;
            var callObject:Object = {};
            var proxyObject:Object = {};
            proxyObject.proxyName = proxy.getProxyName();
            proxyObject.data = proxy.getData();
            proxyObject = retreieveProps(proxy, proxy);
            callObject.proxy = proxy;
            callObject.result = result;
            action.infoObject = callObject;
            logAction(action);
        }

        public function logServiceFault(proxy:IProxy, fault:Object):void
        {
            var action:Action = new Action();
            action.actorName = proxy.getProxyName();
            action.message = " fault for call by [ " + proxy.getProxyName() + " ]";
            action.type = ActionType.SERVICE_CALL;
            var callObject:Object = {};
            var proxyObject:Object = {};
            proxyObject.proxyName = proxy.getProxyName();
            proxyObject.data = proxy.getData();
            proxyObject = retreieveProps(proxy, proxy);
            callObject.proxy = proxy;
            callObject.fault = fault;
            action.infoObject = callObject;
            logAction(action);
            error("fault on call for [ " + fault.toString() + " ]");
        }

        public function logAction(action:Action):void
        {


            action.index = ++_flowActionsCounter;
            try {
                _lc.send(LOGGER_ID, "logAction", action);
            }
            catch(e:Error) {

                //                error(e.message);
                --_flowActionsCounter;
            }

        }

        public function logFrameworkMessage(message:String, logLevelName:String):void
        {
            _lc.send(LOGGER_ID, "logFrameworkMessage", message, logLevelName);
        }

        private function retreieveProps(object:Object, infoObject:Object, deepLevel:int = 0):Object
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
        }

        public function error(message:String):void
        {
            logFrameworkMessage(message, LogLevel.ERROR.getName());

        }

        public function warn(message:String):void
        {
            logFrameworkMessage(message, LogLevel.WARN.getName());
        }

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
            }

            return false;
        }


    }
}
class SingletonEnforcer {
}