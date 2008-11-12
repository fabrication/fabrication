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
 
package org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator {
	import com.anywebcam.mock.Mock;
	
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IMockable;	

	/**
	 * @author Darshan Sawardekar
	 */
	public class FabricationMediatorTestMockWithoutAnyInterests extends FabricationMediator implements IMockable {
		
		static public const NAME:String = "FabricationMediatorTestMockWithoutAnyInterests";
		
		private var _mock:Mock;
		
		public function FabricationMediatorTestMockWithoutAnyInterests(name:String = null, viewComponent:Object = null):void {
			super(name != null ? name : NAME, viewComponent);
		}
		
		public function get mock():Mock {
			if (_mock == null) {
				_mock = new Mock(this, true);
			}
			
			return _mock;
		}
		
		override public function qualifyNotificationInterests():Object {
			return mock.qualifyNotificationInterests();
		}
		
		
	}
}
