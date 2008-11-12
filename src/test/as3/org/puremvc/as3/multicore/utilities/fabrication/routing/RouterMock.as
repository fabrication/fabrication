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
 
package org.puremvc.as3.multicore.utilities.fabrication.routing {
	import com.anywebcam.mock.Mock;
	
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IMockable;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IRouterCable;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IRouterFirewall;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IRouterMessage;	

	/**
	 * @author Darshan Sawardekar
	 */
	public class RouterMock extends Router implements IMockable {
		
		private var _mock:Mock;
		
		public function RouterMock() {
			super();
		}
		
		public function get mock():Mock {
			if (_mock == null) {
				_mock = new Mock(this, true);
			};
			
			return _mock;
		}
		
		override public function dispose():void {
			mock.dispose();
		}
		
		override public function connect(cable:IRouterCable):void {
			mock.connect(cable);
		}
		
		override public function disconnect(cable:IRouterCable):void {
			mock.disconnect(cable);
		}
		
		override public function install(firewall:IRouterFirewall):void {
			mock.install(firewall);
		}
		
		override public function lockFirewall():void {
			mock.lockFirewall();
		}
		
		override public function route(message:IRouterMessage):void {
			mock.route(message);
		}
		
		/* *
		override protected function handlePipeMessage(message:IPipeMessage):void {
			mock.handlePipeMessage(message);
		}
		/* */
		
	}
}
