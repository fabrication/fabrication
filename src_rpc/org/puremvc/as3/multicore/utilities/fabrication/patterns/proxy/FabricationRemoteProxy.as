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

package org.puremvc.as3.multicore.utilities.fabrication.patterns.proxy {
    import mx.rpc.AsyncToken;

    import org.puremvc.as3.multicore.utilities.fabrication.injection.ServiceInjector;

    /**
	 * FabricationRemoteProxy proxy empowered with service injections
     * and handy methods to perform service calls.
	 *
	 * @author Rafał Szemraj
	 */
    public class FabricationRemoteProxy extends FabricationProxy {

        /**
         * default fault handler for all service calls
         */
        public var defaultFaultHandler:Function = null;

        public function FabricationRemoteProxy(name:String = null, data:Object = null)
        {
            super(name);
        }

        /**
         * executes call to remote service
         * @param call service method ( AsyncToken )
         * @param resultHandler result handler for call
         * @param faultHandler fault handler [ optional ]. If not provided defaultFaultHandler
         * will be used ( if defined )
         */
        public function executeServiceCall(call:AsyncToken, resultHandler:Function, faultHandler:Function = null):void
        {
            call.addResponder(new CallResponder( resultHandler, faultHandler || defaultFaultHandler ));
        }

        /**
         * @inheritDoc
         */
        override protected function performInjections():void
        {
            super.performInjections();
            injectionFieldsNames = injectionFieldsNames.concat(( new ServiceInjector(fabFacade, this) ).inject());
        }
    }
}

import mx.rpc.IResponder;


class CallResponder implements IResponder {


    private var resultHandler:Function;
    private var faultHandler:Function;


    public function CallResponder( resultHandler:Function, faultHandler:Function = null)
    {
        this.faultHandler = faultHandler;
        this.resultHandler = resultHandler;
    }

    public function result(data:Object):void
    {
        if (resultHandler != null)
            resultHandler.apply(null, [data]);
    }

    public function fault(info:Object):void
    {
        if (faultHandler != null)
            faultHandler.apply(null, [info]);
    }
}