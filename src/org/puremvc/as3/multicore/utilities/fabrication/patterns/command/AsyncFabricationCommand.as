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

package org.puremvc.as3.multicore.utilities.fabrication.patterns.command {
    import org.puremvc.as3.multicore.interfaces.IAsyncCommand;
    import org.puremvc.as3.multicore.interfaces.INotification;

    public class AsyncFabricationCommand extends SimpleFabricationCommand implements IAsyncCommand {

        private var onComplete:Function;

        public function AsyncFabricationCommand()
        {
            super();
        }

        public function setOnComplete(value:Function):void
        {
            onComplete = value;
        }

        protected function commandComplete():void {

            onComplete();

        }

    }
}