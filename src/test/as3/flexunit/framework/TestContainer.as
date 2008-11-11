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
 
package flexunit.framework {
	import mx.containers.VBox;
	import mx.core.Application;	

	/**
	 * @author Darshan Sawardekar
	 */
	public class TestContainer extends VBox {

		static public var instance:TestContainer = null;

		static public function getInstance():TestContainer {
			if (instance == null) {
				instance = new TestContainer();
				
				var application:Application = Application.application as Application;
				application.addChild(instance);
			}
			
			return instance;
		}

		public function TestContainer() {
			super();
			
			includeInLayout = false;
			visible = false;
		}
	}
}
