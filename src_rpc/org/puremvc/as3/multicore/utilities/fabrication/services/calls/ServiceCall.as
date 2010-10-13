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

package org.puremvc.as3.multicore.utilities.fabrication.services.calls {
    import mx.managers.CursorManager;
    import mx.rpc.AsyncToken;
    import mx.rpc.events.ResultEvent;

    import org.puremvc.as3.multicore.utilities.fabrication.process.Process;

    /**
     * ServiceCall is class for crating separate calls in call stack.
     * @see ServiceCallStack
     */
    public class ServiceCall extends Process implements IServiceCall {


        public var callFunction:Function;
        public var resultHandler:Function;
        public var faultHandler:Function;
        public var params:Array;
        public var showBusyCursor:Boolean = true;

        public function ServiceCall(callFunction:Function = null, params:Array = null, resultHandler:Function = null, faultHandler:Function = null):void
        {
            this.callFunction = callFunction;
            this.params = params ? params.concat() : [];
            this.resultHandler = resultHandler;
            this.faultHandler = faultHandler;

        }

        /**
         * @inheritDoc
         */
        override public function start():void
        {
            var token:AsyncToken = callFunction.apply(null, params);
            token.addResponder(new CallResponder(resultHandler, faultHandler));
            token.addResponder(new CallResponder(onCallComplete, faultHandler));
            if( showBusyCursor )
                CursorManager.setBusyCursor();
            super.start();

        }

        /**
         * @inheritDoc
         */
        override public function dispose():void
        {
            callFunction = null;
            params = null
            resultHandler = null;
            faultHandler = null;
            super.dispose();
        }

        private function onCallComplete(event:ResultEvent):void
        {
            onComplete();
            if( showBusyCursor )
                CursorManager.removeBusyCursor();
        }
    }
}

import mx.rpc.IResponder;

class CallResponder implements IResponder {


        private var resultHandler:Function;
        private var faultHandler:Function;


        public function CallResponder(resultHandler:Function, faultHandler:Function = null)
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