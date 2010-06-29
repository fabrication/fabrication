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
 
package org.puremvc.as3.multicore.utilities.fabrication.routing.mock {
    import com.anywebcam.mock.Mock;

    import org.puremvc.as3.multicore.utilities.fabrication.addons.IMockable;
    import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IRouterMessage;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.facade.FabricationFacade;
    import org.puremvc.as3.multicore.utilities.fabrication.routing.*;

    /**
	 * @author Darshan Sawardekar
	 */
	public class RouterCableListenerMock extends RouterCableListener implements IMockable {
		
		private var _mock:Mock;
		
		public function RouterCableListenerMock(facade:FabricationFacade) {
			super(facade);
		}
		
		public function get mock():Mock {
			if (_mock == null) {
				_mock = new Mock(this, true);
			}
			
			return _mock;
		}
		
		override public function dispose():void {
			mock.dispose();
		}
		
		override protected function handleMessage(message:IRouterMessage):void {
			mock.handleMessage(message);
		}
		
	}
}
