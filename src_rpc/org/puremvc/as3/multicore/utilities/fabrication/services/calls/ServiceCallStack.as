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
    import org.puremvc.as3.multicore.utilities.fabrication.process.IProcess;
    import org.puremvc.as3.multicore.utilities.fabrication.process.ProcessGroup;

    /**
     * ServiceCallStack is utility for chaining service calls.
     * You can specify how many calls should be executed at one time
     * by setting maximumParallelCalls in class constructor
     * @author Rafał Szemraj
     */
    [DefaultProperty("calls")]
    public class ServiceCallStack extends ProcessGroup implements IServiceCall {

        private var _resultHandler:Function;

        public function ServiceCallStack(resultHandler:Function = null, maximumParallelCalls:uint = 1)
        {
            super(maximumParallelCalls);
            _resultHandler = resultHandler;

        }

        /**
         * Adds service call to call stack
         * @param serviceCall instance of ServiceCall to add
         */
        public function addServiceCall(serviceCall:IServiceCall):void
        {
            super.addProcess(serviceCall);
        }

        override public function addProcess(process:IProcess):void
        {
            throw new Error("For ServiceCallStack please use addServiceCall method.")
        }

        public function get calls():Array {

            return processes;

        }

        [ArrayElementType("org.puremvc.as3.multicore.utilities.fabrication.services.calls.IServiceCall")]
        public function set calls( value:Array ):void {

            for each( var call:IServiceCall in value ) {

                addServiceCall( call );
            }

        }

        /**
         * @inheritDoc
         */
        override protected function onComplete():void
        {
            super.onComplete();
            if ( null != _resultHandler)
                _resultHandler();
        }

        /**
         * @inheritDoc
         */
        override public function dispose():void
        {
            _resultHandler = null;
            super.dispose();
        }
    }
}