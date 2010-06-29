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
 
package org.puremvc.as3.multicore.utilities.fabrication.plumbing.mock {
    import com.anywebcam.mock.Mock;

    import org.puremvc.as3.multicore.utilities.fabrication.routing.RouterMessage;
    import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeFitting;
    import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeMessage;
    import org.puremvc.as3.multicore.utilities.pipes.plumbing.Pipe;

    /**
	 * @author Darshan Sawardekar
	 */
	public class PipeMock extends Pipe {
		
		public var mock:Mock;
		public var message:IPipeMessage;
		
		public function PipeMock(output:IPipeFitting = null) {
			super(output);
			
			mock = new Mock(this);
		}
		
		override public function connect(output:IPipeFitting):Boolean {
			return mock.connect(output);
		}
		
		override public function disconnect():IPipeFitting {
			return mock.disconnect();
		}
		
		override public function write(message:IPipeMessage):Boolean {
			var msg:RouterMessage = message as RouterMessage;
			this.message = message;
			return mock.write(message);
		}
		
	}
}
